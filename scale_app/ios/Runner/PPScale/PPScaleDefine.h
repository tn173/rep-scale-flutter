//
//  PPScaleDefine.h
//  PPBlueToothDemo
//
//  Created by 彭思远 on 2020/7/31.
//  Copyright © 2020 彭思远. All rights reserved.
//

#ifndef PPScaleDefine_h
#define PPScaleDefine_h

typedef NS_ENUM(NSUInteger, PPUserGender) {
    PPUserGenderFemale,
    PPUserGenderMale,
};

typedef NS_ENUM(NSUInteger, PPUserUnit) {
    PPUnitKG = 0,
    PPUnitLB = 1,
    PPUnitST = 2,
    PPUnitJin = 3,
    PPUnitG = 4,
    PPUnitLBOZ = 5,
    PPUnitMLWater = 7,
    PPUnitMLMilk = 8,
    PPUnitOZ = 6,
};

typedef NS_ENUM(NSUInteger, PPDeviceType) {
    PPDeviceTypeWeight = 1 << 0,
    PPDeviceTypeBodyFat = 1 << 1,
    PPDeviceTypeHearRate = 1 << 2,
    PPDeviceTypeHistory = 1 << 3,
    PPDeviceTypeCalcuteInScale = 1 << 4,
};

typedef NS_ENUM(NSUInteger, PPBodyDetailType) {
     PPBodyTypeThin,             //!< 偏瘦型
     PPBodyTypeLThinMuscle,      //!< 偏瘦肌肉型
     PPBodyTypeMuscular,         //!< 肌肉发达型
    
     PPBodyTypeLackofexercise,   //!< 缺乏运动型
     PPBodyTypeStandard,         //!< 标准型
     PPBodyTypeStandardMuscle,   //!< 标准肌肉型
    
     PPBodyTypeObesFat,          //!< 浮肿肥胖型
     PPBodyTypeLFatMuscle,       //!< 偏胖肌肉型
     PPBodyTypeMuscleFat,        //!< 肌肉型偏胖
};

typedef NS_ENUM(NSUInteger, PPBleSwitchState) {
    PPBleSwitchStateOn,
    PPBleSwitchStateOff,
};

typedef NS_ENUM(NSUInteger, PPBleWorkState) {
    PPBleWorkStateSearching, //扫描中
    PPBleWorkStateSearchStop, //停止扫描
    PPBleWorkStateConnecting, //设备连接中
    PPBleWorkStateConnected, //设备已连接
    PPBleWorkStateDisconnected, //设备已断开
};

#define kBLEDeviceEnergyScale @"Energy Scale"
#define kBLEDeviceHealthScale @"Health Scale"
#define kBLEDeviceHealthScale3 @"Health Scale3"
#define kBLEDeviceHealthScale6 @"Health Scale6"
#define kBLEDeviceHealthScale5 @"Health Scale5"
#define kBLEDeviceADore @"ADORE"
#define kBLEDeviceADore1 @"ADORE1"
#define kBLEDeviceLFScale @"LFScale"
#define kBLEDeviceBFScale @"BFScale"
#define kBLEDeviceElectronicScale @"Electronic Scale"
#define kBLEDeviceBMScale @"BM Scale"
#define kBLEDeviceBodyFatScale @"BodyFat Scale"
#define KBLEDeviceHumanScale @"Human Scale"
#define kBLEDeviceSHINILITOSCALE @"SHINIL ITO SCALE"
#define kBLEDeviceHeartRateScale @"HeartRate Scale"
#define KBLEDeviceWeightScale @"Weight Scale"
#define KBLEDeviceBodyFatScale1 @"BodyFat Scale1"
#define KBLEDeviceLFSC @"LF_SC"
#define KBLEDeviceKitchenScale @"Kitchen Scale"

#endif /* PPScaleDefine_h */
