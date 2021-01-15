//
//  PPScaleManager.h
//  PPBlueToothDemo
//
//  Created by 彭思远 on 2020/7/31.
//  Copyright © 2020 彭思远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPScaleDefine.h"
#import "PPDeviceModel.h"
#import "PPBodyBaseModel.h"
#import "PPBodyHistoryBaseModel.h"
#import "PPBodyFatModel.h"
#import "PPUserModel.h"
#import "PPScaleFormatTool.h"
#import <CoreBluetooth/CoreBluetooth.h>

@class PPScaleManager;
@protocol PPBleStateInterface <NSObject>

@optional
- (void)monitorBluetoothWorkState:(PPBleWorkState)state;

- (void)monitorBluetoothSwitchState:(CBManagerState)state API_AVAILABLE(ios(10.0));

- (void)monitorBluetoothAuthorState:(CBManagerAuthorization)state API_AVAILABLE(ios(13.0));

@end

@protocol PPDataInterface <NSObject>

- (void)scaleManager:(PPScaleManager *)manager monitorLockData:(PPBodyFatModel *)model;

@optional

- (void)scaleManager:(PPScaleManager *)manager monitorProcessData:(PPBodyBaseModel *)model;

- (void)scaleManager:(PPScaleManager *)manager monitorHistorData:(PPBodyHistoryBaseModel *)model;
@end

@interface PPScaleManager : NSObject

@property (nonatomic, weak) id<PPBleStateInterface> stateInterface;

@property (nonatomic, weak) id<PPDataInterface> dataInterface;


- (instancetype)initWithMacAddressList:(NSArray <NSString *>*)addressList filterDeviceNameArr:(NSArray<NSString *> *)filterDeviceNameArr andUserModel:(PPUserModel *)userModel;

- (void)startSearching;

- (void)reStartSearching;

- (void)disconnect;

- (PPDeviceModel *)currentDevice;

- (void)disconnectBMScale;

- (void)BMScaleStartTiming:(void(^)(BOOL isSuccess))start;

- (void)BMScaleExitTiming:(void(^)(BOOL isSuccess))exit;

- (void)BMScaleTimeInterval:(void(^)(BOOL isEnd, NSInteger timeInterval, BOOL isFailed))timeInterval;

- (void)configNetWorkWithSSID:(NSString *)ssid password:(NSString *)password andSuccessHandler:(void(^)(BOOL isSuccess, NSString *sn))handler;

- (void)writeDeveloperCommands:(NSArray *)codes withReciveDataHandler:(void(^)(NSData *reviceData))handler;

- (void)changeKitchenScaleUnit:(PPUserUnit)unit;

- (void)toZeroKitchenScale;

@end

