//
//  PPScaleInstructionProvider.m
//  PPBlueToothDemo
//
//  Created by 彭思远 on 2020/8/1.
//  Copyright © 2020 彭思远. All rights reserved.
//

#import "PPScaleInstructionProvider.h"
#import "PPScaleDefine.h"


@interface PPScaleInstructionProvider()
@property (nonatomic, strong) PPUserModel *userModel;

@end

@implementation PPScaleInstructionProvider


- (instancetype)initWithUserModel:(PPUserModel *)model{
    self = [super init];
    if (self) {
        self.userModel = model;
    }
    return self;
}

- (NSArray <NSData *> *)send2ScaleInstructionByType:(PPDeviceType)type andHistoryState:(BOOL)needHistory{
    NSData *unitData = [self unitChangeInstruction];
    NSData *syncTimeData = [PPScaleInstructionProvider synchronisedTimeInstruction];
    NSData *offlineData = [self getHistoryDataInstruction];
    NSData *bodyData = [self calcuteInScaleInstruction];
    if ((type & PPDeviceTypeCalcuteInScale) == PPDeviceTypeCalcuteInScale) {
         return @[bodyData];
    }else{
        if (needHistory) {
            return @[unitData,syncTimeData,offlineData];
        }else{
            return @[unitData];
        }
    }
}


- (NSData *)calcuteInScaleInstruction{
    NSData *dataClose = nil;
    Byte bytes[8];
    bytes[0] = 0xFE;
    bytes[1] = 00;
    switch (self.userModel.userGender) {
        case PPUserGenderMale:
            bytes[2] = 0x01;
            break;
        case PPUserGenderFemale:
            bytes[2] = 0x00;
            break;
    }
    bytes[3] = 0x00;
    bytes[4] = [PPScaleFormatTool convertDecimalTo0x:self.userModel.userHeight];
    bytes[5] = [PPScaleFormatTool convertDecimalTo0x:self.userModel.userAge];
    switch (self.userModel.userUnit) {
    case PPUnitKG:
        bytes[6] = 01;
        break;
    case PPUnitLB:
        bytes[6] = 02;
        break;
    case PPUnitJin:
        bytes[6] = 01;
        break;
    }

    Byte crc=bytes[1];
    for (int i=2; i<7; i++) {
        crc = crc^bytes[i];
    }
    bytes[7] = crc;
    dataClose = [[NSData alloc] initWithBytes:bytes length:8];
    return dataClose;
}


// 更改称的显示单位的指令
- (NSData *)unitChangeInstruction{
    NSData *dataClose = nil;
    
    Byte bytes[11];
    bytes[0] = 0xFD;
    bytes[1] = 0x00;
    switch (self.userModel.userUnit) {
    case PPUnitKG:
        bytes[2] = 00;
        break;
    case PPUnitLB:
        bytes[2] = 01;
        break;
    case PPUnitST:
        bytes[2] = 02;
        break;
    case PPUnitJin:
        bytes[2] = 03;
        break;
    }
    bytes[3] = 0x0;
    bytes[4] = 0x0;
    bytes[5] = 0x0;
    bytes[6] = 0x0;
    bytes[7] = 0x0;
    bytes[8] = 0x0;
    bytes[9] = 0x0;
    Byte crc=bytes[0];
    for (int i=1; i<10; i++) {
        crc = crc^bytes[i];
    }
    bytes[10] = crc;
    dataClose = [[NSData alloc] initWithBytes:bytes length:11];
    return dataClose;
}


// 获取离线缓存数据
- (NSData *)getHistoryDataInstruction{
    NSData *dataClose = nil;
    Byte bytes[2];
    bytes[0] = 0xF2;
    bytes[1] = 0x00;
    dataClose = [[NSData alloc] initWithBytes:bytes length:2];
    return dataClose;
}

// 时间同步信息指令
+ (NSData *)synchronisedTimeInstruction{
    
    NSMutableString *timeHexStr = [[NSMutableString alloc] init];
    [timeHexStr appendString:@"F1"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy MM dd HH mm ss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString =  %@",currentTimeString);
    NSArray *array = [currentTimeString componentsSeparatedByString:@" "];
    
    for (NSString *timeComponent in array) {
        [timeHexStr appendString:[PPScaleFormatTool getHexByDecimal:[timeComponent integerValue]]];
    }
    
    NSLog(@"timeHexStr = %@",timeHexStr);
    return [PPScaleFormatTool convertHexStrToData:timeHexStr];
    
}

// 历史数据删除
+ (NSData *)delHistoryDataInstruction{
    NSData *dataClose = nil;
    Byte bytes[2];
    bytes[0] = 0xF2;
    bytes[1] = 0x01;
    dataClose = [[NSData alloc] initWithBytes:bytes length:2];
    return dataClose;
}

// 进入闭目单脚模式
+ (NSData *)intoBMDJInstruction{
    NSData *data = nil;
    Byte bytes[4];
    bytes[0] = 0x06;
    bytes[1] = 0x0F;
    bytes[2] = 0x00;
    bytes[3] = 0x00;
    data = [[NSData alloc] initWithBytes:bytes length:4];
    return data;
}

// 退出闭目单脚模式
+ (NSData *)exitBMDJInstruction{
    NSData *data = nil;
    Byte bytes[4];
    bytes[0] = 0x06;
    bytes[1] = 0x11;
    bytes[2] = 0x00;
    bytes[3] = 0x00;
    data = [[NSData alloc] initWithBytes:bytes length:4];
    return data;
}

+ (NSArray *)codesBySSID:(NSString *)ssid andPassword:(NSString *)password{
    
    NSData *syncTimeData = [PPScaleInstructionProvider synchronisedTimeInstruction];

    NSString *hexSSID = [PPScaleFormatTool hexStringFromString:ssid];
    NSString *hexSSIDPrefix = @"";
    for (NSInteger i = 0; i < 76; i ++) {
        NSString *s;
        if (i < hexSSID.length) {
            s =  [hexSSID substringWithRange:NSMakeRange(i, 1)];
        }else{
            s = @"0";
        }
        hexSSIDPrefix = [hexSSIDPrefix stringByAppendingString:s];
    }
    NSString *ssid03 = [hexSSIDPrefix substringWithRange:NSMakeRange(0, 38)];
    NSString *ssid04 = [hexSSIDPrefix substringWithRange:NSMakeRange(38, 38)];
    NSData *ssidCode03 = [PPScaleFormatTool convertHexStrToData:[NSString stringWithFormat:@"03%@", ssid03]];
    NSData *ssidCode04 = [PPScaleFormatTool convertHexStrToData:[NSString stringWithFormat:@"04%@", ssid04]];

    NSString *hexPassword = [PPScaleFormatTool hexStringFromString:password];
    NSData *passwordCode = [PPScaleFormatTool convertHexStrToData:[NSString stringWithFormat:@"05%@", hexPassword]];
    if (password && password.length > 0) {
        return @[ssidCode03, ssidCode04,[PPScaleFormatTool convertHexStrToData:@"06"],syncTimeData];
    }
    return @[ssidCode03,ssidCode04,passwordCode,[PPScaleFormatTool convertHexStrToData:@"06"],syncTimeData];
}

+ (NSData *)changeKitchenScaleUnit:(PPUserUnit)unit{
    NSData *dataClose = nil;
    
    Byte bytes[11];
    bytes[0] = 0xFD;
    bytes[1] = 0x00;
    switch (unit) {
        case PPUnitG:
            bytes[2] = 0x04;
            break;
        case PPUnitLBOZ:
            bytes[2] = 0x05;
            break;
        case PPUnitMLWater:
            bytes[2] = 0x07;
            break;
        case PPUnitMLMilk:
            bytes[2] = 0x08;
            break;
        case PPUnitOZ:
            bytes[2] = 0x06;
            break;
        default:
            bytes[2] = 0x00;
            break;;
    }
    bytes[3] = 0x0;
    bytes[4] = 0x0;
    bytes[5] = 0x0;
    bytes[6] = 0x0;
    bytes[7] = 0x0;
    bytes[8] = 0x0;
    bytes[9] = 0x0;
    Byte crc=bytes[0];
    for (int i=1; i<10; i++) {
        crc = crc^bytes[i];
    }
    bytes[10] = crc;
    
    dataClose = [[NSData alloc] initWithBytes:bytes length:11];
    
    return dataClose;
}


+ (NSData *)toZeroForKitchenScale{
    NSData *dataClose = nil;
    
    Byte bytes[11];
    bytes[0] = 0xFD;
    bytes[1] = 0x32;
    bytes[2] = 0x00;
    bytes[3] = 0x0;
    bytes[4] = 0x0;
    bytes[5] = 0x0;
    bytes[6] = 0x0;
    bytes[7] = 0x0;
    bytes[8] = 0x0;
    bytes[9] = 0x0;
    Byte crc=bytes[0];
    for (int i=1; i<10; i++) {
        crc = crc^bytes[i];
    }
    bytes[10] = crc;
    
    dataClose = [[NSData alloc] initWithBytes:bytes length:11];
    
    return dataClose;
}

@end
