//
//  PPScaleManager.m
//  PPBlueToothDemo
//
//  Created by 彭思远 on 2020/7/31.
//  Copyright © 2020 彭思远. All rights reserved.
//

#import "PPScaleManager.h"
#import <objc/runtime.h>
#import "PPDataAnalysisHandler.h"
#import "PPScaleInstructionProvider.h"
#import "PPScaleFilter.h"

static NSInteger BLEDeviceModelKey;

#define kBLEAdvDataManufacturerData @"kCBAdvDataManufacturerData"
#define kBLEAdvDataLocalName @"kCBAdvDataLocalName"
#define kBLEAdvDataIsConnectable @"kCBAdvDataIsConnectable"

@interface PPScaleManager ()<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic, strong) CBCentralManager *centralManager;

@property (nonatomic, strong) CBPeripheral *currentPeripheral;

@property (nonatomic, strong) CBCharacteristic *writeCharacteristic;

@property (nonatomic, strong) CBCharacteristic *bmdjWriteCharacteristic;

@property (nonatomic, strong) NSArray<NSString *> *filterMacAddressList;

@property (nonatomic, strong) NSArray<NSString *> *filterDeviceNameArr;

@property (nonatomic, strong) PPScaleInstructionProvider *instructionProvider;

@property (nonatomic, strong) NSData *lastData;

@property (nonatomic, assign) PPUserModel *userModel;

@property (nonatomic, copy) void(^myBMDJStartHandler)(BOOL isSuccess);

@property (nonatomic, copy) void(^myBMDJExitHandler)(BOOL isSuccess);

@property (nonatomic, copy) void(^myBMDJTimeIntervalHandler)(BOOL isEnd, NSInteger timeInterval, BOOL isFailed);

@property (nonatomic, copy) void(^myBleConfigHandler)(BOOL isSuccess, NSString *sn);

@property (nonatomic, copy) void(^myBleDeveloperCommandHandler)(NSData *reviceData);

@end

@implementation PPScaleManager
#pragma mark - Public Func

- (instancetype)initWithMacAddressList:(NSArray <NSString *>*)addressList filterDeviceNameArr:(NSArray<NSString *> *)filterDeviceNameArr andUserModel:(PPUserModel *)userModel{
    self = [super init];
    if (self) {
        self.filterMacAddressList = addressList;
        self.userModel = userModel;
        self.filterDeviceNameArr = filterDeviceNameArr;
    }
    return self;
}

- (void)startSearching{
    self.lastData = nil;
    [self reStartSearching];
}

- (void)reStartSearching{
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

- (void)disconnect{
    if (self.currentPeripheral) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.centralManager cancelPeripheralConnection:self.currentPeripheral];
        });
    }
    [self.centralManager stopScan];
    self.dataInterface = nil;

    self.centralManager.delegate = nil;
    self.stateInterface = nil;
}

- (PPDeviceModel *)currentDevice{
    PPDeviceModel *deviceModel = [self getDeviceModelFromPeripheral:self.currentPeripheral];
    return deviceModel;
}

- (void)disconnectBMScale{
    [self.currentPeripheral writeValue:[PPScaleInstructionProvider exitBMDJInstruction] forCharacteristic:self.bmdjWriteCharacteristic type:CBCharacteristicWriteWithResponse];
    self.myBMDJStartHandler = nil;
    self.myBMDJExitHandler = nil;
    self.myBMDJTimeIntervalHandler = nil;
    [self disconnect];
}

- (void)BMScaleStartTiming:(void(^)(BOOL isSuccess))start{
    self.myBMDJStartHandler = start;
    [self.currentPeripheral writeValue:[PPScaleInstructionProvider intoBMDJInstruction] forCharacteristic:self.bmdjWriteCharacteristic type:CBCharacteristicWriteWithResponse];
}

- (void)BMScaleExitTiming:(void(^)(BOOL isSuccess))exit{
    self.myBMDJExitHandler = exit;
}

- (void)BMScaleTimeInterval:(void(^)(BOOL isEnd, NSInteger timeInterval, BOOL isFailed))timeInterval{
    self.myBMDJTimeIntervalHandler = timeInterval;
}

- (void)configNetWorkWithSSID:(NSString *)ssid password:(NSString *)password andSuccessHandler:(void(^)(BOOL isSuccess, NSString *sn))handler{
    self.myBleConfigHandler = handler;
    NSArray *codes = [PPScaleInstructionProvider codesBySSID:ssid andPassword:password];
    for (NSData *code in codes) {
        [self.currentPeripheral writeValue:code forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

- (void)writeDeveloperCommands:(NSArray *)codes withReciveDataHandler:(void(^)(NSData *reviceData))handler{
    self.myBleDeveloperCommandHandler = handler;
    for (NSData *code in codes) {
        [self.currentPeripheral writeValue:code forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

- (void)changeKitchenScaleUnit:(PPUserUnit)unit{
    if (self.currentPeripheral && self.writeCharacteristic) {
        [self.currentPeripheral writeValue:[PPScaleInstructionProvider changeKitchenScaleUnit:unit] forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

- (void)toZeroKitchenScale{
    if (self.currentPeripheral && self.writeCharacteristic) {
        [self.currentPeripheral writeValue:[PPScaleInstructionProvider toZeroForKitchenScale] forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
    }
}

#pragma mark - Life Cycle

- (void)dealloc{
    NSLog(@"PPScaleManager dealloc");
}

#pragma mark - Private Func
        
- (void)scan{
    
    [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    if (self.stateInterface && [self.stateInterface respondsToSelector:@selector(monitorBluetoothWorkState:)]) {
        [self.stateInterface monitorBluetoothWorkState:PPBleWorkStateSearching];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral handleReciveData:(NSData *)reciveData{
    
    NSLog(@"handleReciveData - %@", reciveData);
    
    if ([self.lastData isEqual:reciveData]){
        return;
    }else{
        self.lastData = reciveData;
    }
    
    if (self.myBMDJStartHandler) {
        [PPDataAnalysisHandler isBMDJTimingStart:reciveData status:self.myBMDJStartHandler];
    }
    
    if (self.myBMDJTimeIntervalHandler){
        [PPDataAnalysisHandler BMDJTimeInterval:reciveData withHandler:self.myBMDJTimeIntervalHandler];
    }
    
    if (self.myBMDJExitHandler) {
        [PPDataAnalysisHandler isBMDJTimingExit:reciveData status:self.myBMDJExitHandler];
    }
    
    if (self.myBleConfigHandler) {
        [PPDataAnalysisHandler isConnect2Wifi:reciveData status:self.myBleConfigHandler];
    }
    
    if (self.myBleDeveloperCommandHandler) {
        self.myBleDeveloperCommandHandler(reciveData);
    }
    
    PPDeviceModel *deviceModel = [self getDeviceModelFromPeripheral:peripheral];
    [PPDataAnalysisHandler receiveDate:reciveData analysis2BodyBaseModelWithHandler:^(id  _Nonnull model) {
        
        if ([model class] == [[PPBodyBaseModel new] class]) {
            PPBodyBaseModel *bodyBaseModle = (PPBodyBaseModel *)model;

            if (bodyBaseModle.haveImpedance) {
                deviceModel.deviceType = deviceModel.deviceType | PPDeviceTypeBodyFat;
            }
            if (bodyBaseModle.isEnd) {
                
                if (self.dataInterface && [self.dataInterface respondsToSelector:@selector(scaleManager:monitorLockData:)]) {
                    
                    PPUserModel *userModel = [[PPUserModel alloc] initWithUserHeight:self.userModel.userHeight gender:self.userModel.userGender age:self.userModel.userAge andUnit:self.userModel.userUnit];
                    PPBodyFatModel *bodyFatModel = [[PPBodyFatModel alloc] initWithUserModel:userModel weight:bodyBaseModle.weight/100.0 heartRate:bodyBaseModle.heartRate isHeartRateEnd:bodyBaseModle.isHeartRatingEnd andImpedance:bodyBaseModle.impedance];
                    [self.dataInterface scaleManager:self monitorLockData:bodyFatModel];
                }
            }else{
                
                if (self.dataInterface && [self.dataInterface respondsToSelector:@selector(scaleManager:monitorProcessData:)]) {
                    
                    [self.dataInterface scaleManager:self monitorProcessData:model];
                }
            }
        }
        
        if ([model class] == [[PPBodyHistoryBaseModel new] class]) {
            deviceModel.deviceType = deviceModel.deviceType | PPDeviceTypeHistory;
            PPBodyHistoryBaseModel *historyModel = (PPBodyHistoryBaseModel *)model;
            if (historyModel.isEnd && self.dataInterface && [self.dataInterface respondsToSelector:@selector(scaleManager:monitorHistorData:)]) {
                
                [self.currentPeripheral writeValue:[PPScaleInstructionProvider delHistoryDataInstruction] forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
            }
            
            if (self.dataInterface && [self.dataInterface respondsToSelector:@selector(scaleManager:monitorHistorData:)]) {
                
                [self.dataInterface scaleManager:self monitorHistorData:model];
            }
        }
        
        if ([model class] == [[PPBodyFatModel new] class]) {
            
            if (self.dataInterface && [self.dataInterface respondsToSelector:@selector(scaleManager:monitorLockData:)]) {
                
                [self.dataInterface scaleManager:self monitorLockData:model];
            }
        }

    }];
}

#pragma mark - Delegate

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{

    if (central.state == CBCentralManagerStatePoweredOn) {
        [self scan];
    }
    
    if (self.stateInterface && [self.stateInterface respondsToSelector:@selector(monitorBluetoothSwitchState:)]) {
        if (@available(iOS 10.0, *)) {
            [self.stateInterface monitorBluetoothSwitchState:self.centralManager.state];
        }
    }
    
    if (self.stateInterface && [self.stateInterface respondsToSelector:@selector(monitorBluetoothAuthorState:)]) {
        if (@available(iOS 13.0, *)) {
            [self.stateInterface monitorBluetoothAuthorState:self.centralManager.authorization];
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    NSLog(@"advertisementData: %@",advertisementData);
    NSData *advData = [advertisementData objectForKey:kBLEAdvDataManufacturerData];
    
    if (!advData) {
        return;
    }
    
    NSString *localName = [advertisementData objectForKey:kBLEAdvDataLocalName] ;
    if (![self.filterDeviceNameArr containsObject:localName]) {
        return;
    }
    
    if (advData.length != 19 && advData.length != 17 && advData.length != 8 && advData.length != 25 && advData.length != 20) {
        return;
    }
 
    if (![self.ignoreAdvDeviceNameArr containsObject:localName]) {
        if (![PPDataAnalysisHandler isCorrectADVData:advData]) {
            return;
        }
    }
    
    NSInteger connectable =  [[advertisementData objectForKey:kBLEAdvDataIsConnectable] integerValue];
    if (connectable == 0 && advData.length != 17 && advData.length != 19) {
        return;
    }
    
    NSString *macAddress = [PPScaleFilter macAddressByCBAdvDataManufacturerData:advData];
    
    if (self.filterMacAddressList && ![self.filterMacAddressList containsObject:macAddress]) {
        return;
    }

    PPDeviceModel *device = [self getDeviceModelFromPeripheral:peripheral];
    if (!device) {
        device = [[PPDeviceModel alloc] init];
        device.deviceMac = macAddress;
        device.deviceName = localName;
        if (advData.length == 8) {
            device.deviceType = PPDeviceTypeCalcuteInScale | PPDeviceTypeWeight | PPDeviceTypeBodyFat;
        }else{
            device.deviceType = PPDeviceTypeWeight;
        }
        [self saveDeviceModel:device toPeripheral:peripheral];
    }
    
    self.currentPeripheral = peripheral;

    if (connectable == 0 && advData.length == 17) {
        
        NSData *subData = [advData subdataWithRange:NSMakeRange(6, 11)];
        [self peripheral:peripheral handleReciveData:subData];

    }else if(connectable == 0 && advData.length == 19){
        
        NSData *subData = [advData subdataWithRange:NSMakeRange(8, 11)];
        [self peripheral:peripheral handleReciveData:subData];

    }else{
        [central stopScan];
        
        if (self.stateInterface && [self.stateInterface respondsToSelector:@selector(monitorBluetoothWorkState:)]) {
            [self.stateInterface monitorBluetoothWorkState:PPBleWorkStateSearchStop];
        }
        
        peripheral.delegate = self;
        [self.centralManager connectPeripheral:peripheral options:nil];
        
        if (self.stateInterface && [self.stateInterface respondsToSelector:@selector(monitorBluetoothWorkState:)]) {
            [self.stateInterface monitorBluetoothWorkState:PPBleWorkStateConnecting];
        }

    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    
    NSArray *services = [PPScaleFilter filterServicesByUUID];
    [peripheral discoverServices:services];
}

#pragma mark - CBPeripheralDelegate


- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"已经发现特性%@",characteristic);

        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF4"]]) {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF1"]]) {
            self.writeCharacteristic = characteristic;
        }
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF5"]]) {
            self.bmdjWriteCharacteristic = characteristic;
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
    if (self.stateInterface && [self.stateInterface respondsToSelector:@selector(monitorBluetoothWorkState:)]) {
        [self.stateInterface monitorBluetoothWorkState:PPBleWorkStateConnected];
    }
    self.lastData = nil;
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF4"]]) {
        PPDeviceModel *deviceModel = [self getDeviceModelFromPeripheral:peripheral];
        BOOL needHistory = [self.dataInterface respondsToSelector:@selector(scaleManager:monitorHistorData:)];
        NSArray <NSData *>*dataArray = [self.instructionProvider send2ScaleInstructionByType:deviceModel.deviceType andHistoryState:needHistory];
        
        for (NSData *data in dataArray) {
            [peripheral writeValue:data forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error{
    NSData *data = characteristic.value;
    if (!data) {
        return;
    }
    NSLog(@"didUpdateValueForCharacteristic: %@",data);

    [self peripheral:peripheral handleReciveData:data];

}

/** 写入数据回调 */
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(nonnull CBCharacteristic *)characteristic error:(nullable NSError *)error {
    NSLog(@"写入数据回调characteristic = %@",characteristic);
    if (error) {
        NSLog(@"写入数据回调error = %@",error);
    }else{
        NSLog(@"写入成功");
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (self.stateInterface && [self.stateInterface respondsToSelector:@selector(monitorBluetoothWorkState:)]) {
        [self.stateInterface monitorBluetoothWorkState:PPBleWorkStateDisconnected];
    }
}

#pragma mark - Setter

- (void)setUserModel:(PPUserModel *)userModel{
    _userModel = userModel;
    self.instructionProvider = [[PPScaleInstructionProvider alloc] initWithUserModel:userModel];
}

#pragma mark - Getter
- (NSArray <NSString *>*)filterDeviceNameArr{
    if (_filterDeviceNameArr) {
        return _filterDeviceNameArr;
    }else{
        return @[
                    kBLEDeviceEnergyScale,
                    kBLEDeviceHealthScale,
                    kBLEDeviceHealthScale3,
                    kBLEDeviceADore,
                    kBLEDeviceADore1,
                    kBLEDeviceLFScale,
                    kBLEDeviceBFScale,
                    kBLEDeviceElectronicScale,
                    kBLEDeviceBMScale,
                    kBLEDeviceBodyFatScale,
                    KBLEDeviceHumanScale,
                    kBLEDeviceSHINILITOSCALE,
                    kBLEDeviceHeartRateScale,
                    KBLEDeviceWeightScale,
                    KBLEDeviceBodyFatScale1,
                    KBLEDeviceLFSC,
                    KBLEDeviceKitchenScale
                ];
    }

}

- (NSArray <NSString *>*)ignoreAdvDeviceNameArr{

    return @[
                kBLEDeviceBMScale,
                KBLEDeviceKitchenScale,
                kBLEDeviceHealthScale5,
                kBLEDeviceHealthScale6
            ];

}


#pragma mark - Add Property

- (void)saveDeviceModel:(PPDeviceModel *)model toPeripheral:(CBPeripheral *)peripheral{
    objc_setAssociatedObject(peripheral, &BLEDeviceModelKey, model, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (PPDeviceModel *)getDeviceModelFromPeripheral:(CBPeripheral *)peripheral{
    PPDeviceModel *model = objc_getAssociatedObject(peripheral, &BLEDeviceModelKey);
    return model;
}



@end
