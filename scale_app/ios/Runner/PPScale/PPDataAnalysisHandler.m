//
//  PPDataAnalysisHandler.m
//  PPBlueToothDemo
//
//  Created by 彭思远 on 2020/7/31.
//  Copyright © 2020 彭思远. All rights reserved.
//

#import "PPDataAnalysisHandler.h"
#import <UIKit/UIKit.h>
#import "PPBodyBaseModel.h"
#import "PPBodyHistoryBaseModel.h"
#import "PPBodyFatModel.h"
#import "PPScaleFormatTool.h"

@implementation PPDataAnalysisHandler

+ (void)receiveDate:(NSData *)receiveData analysis2BodyBaseModelWithHandler:(reciveData2BodyBaseModelHandler)handler{
    if (receiveData.length == 11) {
        
        [self analysis11LengthData:receiveData withResultHandler:handler];
    }else if (receiveData.length == 17){
        
        [self analysis17LengthData:receiveData withResultHandler:handler];
    }else if (receiveData.length == 16){
        
        [self analysis16LengthData:receiveData withResultHandler:handler];
    }else if (receiveData.length == 18){
        
        [self analysis18LengthData:receiveData withResultHandler:handler];
    }else if (receiveData.length == 2){
        
        [self analysis2LengthData:receiveData withResultHandler:handler];
    }else if (receiveData.length == 20) {
        
        NSData *subData = [receiveData subdataWithRange:NSMakeRange(0, 11)];
        if ([self checkData:subData]) {
            [self analysis11LengthData:subData withResultHandler:handler];
        }
    }
}

+ (BOOL)isCorrectADVData:(NSData *)receiveData{

    if (receiveData.length == 19) {
        
        NSData *subData = [receiveData subdataWithRange:NSMakeRange(8, 11)];
        return [self checkData:subData];
    }else if (receiveData.length == 17){
        
        NSData *subData = [receiveData subdataWithRange:NSMakeRange(6, 11)];
        return [self checkData:subData];
    }else if (receiveData.length == 8){
        NSString *str = [PPScaleFormatTool data2String:receiveData];
        if ([str hasPrefix:@"0000"]) {
            return YES;
        }
        return NO;
    }else if (receiveData.length == 25){
        
        return YES;
    }else if (receiveData.length == 20){
        NSData *subData = [receiveData subdataWithRange:NSMakeRange(6, 11)];
        return [self checkData:subData];
    }
    return NO;
}

+ (BOOL)checkData:(NSData *)receiveData{
    UInt8 bytes[11];
    memcpy(bytes, receiveData.bytes, 11);

    Byte crc=bytes[0];
    if (crc != 0xcf && crc != 0xce) {
        return NO;
    }
    for (int i=1; i<10; i++) {
        crc = crc^bytes[i];
    }
    if (crc == bytes[10]) {
        return YES;
    }else{
        return NO;
    }
}

+ (void)analysis11LengthData:(NSData *)receiveDate withResultHandler:(reciveData2BodyBaseModelHandler)handler{
    UInt8 bytes[11];
    memcpy(bytes, receiveDate.bytes, 11);
    int unlockImpedance = (int)(bytes[2]*256+bytes[1]);
    if (unlockImpedance > 12000) {
        [self analysis11HeartRateLengthData:receiveDate withResultHandler:handler];
    }else{
        [self analysis11NormalLengthData:receiveDate withResultHandler:handler];
    }

}

+ (void)analysis11NormalLengthData:(NSData *)receiveDate withResultHandler:(reciveData2BodyBaseModelHandler)handler{
    PPBodyBaseModel *model = [[PPBodyBaseModel alloc] init];
    UInt8 bytes[11];
    memcpy(bytes, receiveDate.bytes, 11);
    if (bytes[0]==0xcf || bytes[0] == 0xce || bytes[0] == 0xca) {
        if (bytes[9]==0x01) {
            int weightInt = (int)(bytes[4]*256+bytes[3]);
            model.weight = weightInt;
            model.impedance = 0;
            model.isEnd = NO;
            model.isHeartRatingEnd = YES;
            model.heartRate = 0;
        }
        else if(bytes[9]==0x00){
          //体脂类声明
            int weightInt = (int)(bytes[4]*256+bytes[3]);
            NSInteger impedance = (bytes[7]*256*256+bytes[6]*256+bytes[5]);
            model.weight = weightInt;
            model.impedance = impedance;
            model.isEnd = YES;
            model.isHeartRatingEnd = YES;
            model.heartRate = 0;
        }
        model.haveImpedance = bytes[0] == 0xcf ? YES:NO;
        if (handler) {
            handler(model);
        }
    }
}

+ (void)analysis11HeartRateLengthData:(NSData *)receiveDate withResultHandler:(reciveData2BodyBaseModelHandler)handler{
    PPBodyBaseModel *model = [[PPBodyBaseModel alloc] init];
    UInt8 bytes[11];
     memcpy(bytes, receiveDate.bytes, 11);
     if (bytes[0]==0xcf) {
         if (bytes[9]==0x01) {
             int weightInt = (int)(bytes[4]*256+bytes[3]);
             model.weight = weightInt;
             model.impedance = 0;
             model.isEnd = NO;
             model.isHeartRatingEnd = YES;
             model.heartRate = 0;
         }
         else if(bytes[9]==0x00){
             //体脂类声明
             int weightInt = (int)(bytes[4]*256+bytes[3]);
             if (weightInt > 0) {
                 [[NSUserDefaults standardUserDefaults] setInteger:weightInt forKey:@"heartRateScaleWeight"];
             }
             NSInteger impedance = (bytes[7]*256*256+bytes[6]*256+bytes[5]);
             if (impedance > 0) {
                 [[NSUserDefaults standardUserDefaults] setInteger:impedance forKey:@"heartRateScaleImpedance"];
             }
             NSString *str = [NSString stringWithFormat:@"%02X",bytes[2]];
             NSString *bStr = [PPScaleFormatTool getBinaryStrByHexStr:str];
             if ([bStr hasPrefix:@"10"]) {
                 model.weight = weightInt;
                 model.impedance = impedance;
                 model.isEnd = YES;
                 model.isHeartRatingEnd = NO;
                 model.heartRate = 0;
             }else if ([bStr hasPrefix:@"11"]){
                 NSString *heartStr = [NSString stringWithFormat:@"%02X",bytes[1]];
                 int heartRate = (int)strtoul([heartStr UTF8String],0,16);  //16进制字符串转换成int
                 NSInteger myWeight = [[NSUserDefaults standardUserDefaults] integerForKey:@"heartRateScaleWeight"];
                 NSInteger myImpendance = [[NSUserDefaults standardUserDefaults] integerForKey:@"heartRateScaleImpedance"];
                 model.weight = myWeight;
                 model.impedance = myImpendance;
                 model.isEnd = YES;
                 model.isHeartRatingEnd = YES;
                 model.heartRate = heartRate;
                 [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"heartRateScaleWeight"];
                 [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"heartRateScaleImpedance"];
             }else{
                 model.weight = weightInt;
                 model.impedance = impedance;
                 model.isEnd = YES;
                 model.isHeartRatingEnd = YES;
                 model.heartRate = 0;
             }
         }
         model.haveImpedance = YES;
         if (handler) {
             handler(model);
         }
     }
}


+ (void)analysis16LengthData:(NSData *)receiveDate withResultHandler:(reciveData2BodyBaseModelHandler)handler{
    UInt8 bytes[16];
    memcpy(bytes, receiveDate.bytes, 16);
    if (bytes[0] == 0xcf) {
        //身高
        int heightInt = (int)bytes[3];
        //体重
        int weightInt = (int)(bytes[4]*256+bytes[5]);
        CGFloat weight = (CGFloat)weightInt / 10.0;
        //BMI
        CGFloat BMI = weight/((heightInt/100.0) * (heightInt/100.0));
        //脂肪
        int fatInt = (int)(bytes[6]*256+bytes[7]);
        CGFloat fat = (CGFloat)fatInt / 10.0;
        // 骨骼
        int boneInt = (int)bytes[8];
        CGFloat bone = boneInt / 10.0;
        // 肌肉含量
        int muscleInt = (int)(bytes[9]*256+bytes[10]);
        CGFloat muscle = muscleInt / 10;
        // 内脏脂肪等级
        int VFAInt = (int)bytes[11];
        NSInteger VFA = (NSInteger)VFAInt;
        // 水分含量
        int waterInt = (int)(bytes[12]*256+bytes[13]);
        CGFloat water = waterInt / 10.0;
        // BMR
        int BMRInt = (int)(bytes[14]*256+bytes[15]);
        NSInteger BMR = (NSInteger)BMRInt;

        PPBodyFatModel *model = [[PPBodyFatModel alloc] init];
        model.ppWeightKg = weight;
        model.ppBMI = BMI;
        model.ppBodyfatPercentage = fat;
        model.ppBoneKg = bone;
        model.ppMuscleKg = muscle;
        model.ppVFAL = VFA;
        model.ppWaterPercentage = water;
        model.ppBMR =  BMR;
        model.ppIsHeartRateEnd = YES;
        if (handler) {
            handler(model);
        }
    }
}


+ (void)analysis17LengthData:(NSData *)receiveDate withResultHandler:(reciveData2BodyBaseModelHandler)handler{
    UInt8 bytes[17];
    memcpy(bytes, receiveDate.bytes, 17);
    if (bytes[0] == 0xcf) {
        //身高
        int heightInt = (int)bytes[3];
        //体重
        int weightInt = (int)(bytes[4]*256+bytes[5]);
        CGFloat weight = (CGFloat)weightInt / 10.0;
        //BMI
        CGFloat BMI = weight/((heightInt/100.0) * (heightInt/100.0));
        //脂肪
        int fatInt = (int)(bytes[6]*256+bytes[7]);
        CGFloat fat = (CGFloat)fatInt / 10.0;
        // 骨骼
        int boneInt = (int)bytes[8];
        CGFloat bone = boneInt / 10.0;
        // 肌肉含量
        int muscleInt = (int)(bytes[9]*256+bytes[10]);
        CGFloat muscle = muscleInt / 10;
        // 内脏脂肪等级
        int VFAInt = (int)bytes[11];
        NSInteger VFA = (NSInteger)VFAInt;
        // 水分含量
        int waterInt = (int)(bytes[12]*256+bytes[13]);
        CGFloat water = waterInt / 10.0;
        // BMR
        int BMRInt = (int)(bytes[14]*256+bytes[15]);
        NSInteger BMR = (NSInteger)BMRInt;
        // 是否锁定
        NSString *lockSign = [NSString stringWithFormat:@"%02x",bytes[16]];
        if ([[lockSign uppercaseString] isEqualToString:@"F0"]) {
            PPBodyFatModel *model = [[PPBodyFatModel alloc] init];
            model.ppWeightKg = weight;
            model.ppBMI = BMI;
            model.ppBodyfatPercentage = fat;
            model.ppBoneKg = bone;
            model.ppMuscleKg = muscle;
            model.ppVFAL = VFA;
            model.ppWaterPercentage = water;
            model.ppBMR =  BMR;
            if (handler) {
                handler(model);
            }
        }else if([[lockSign uppercaseString] isEqualToString:@"F1"]){
            if (handler) {
                PPBodyBaseModel *model = [[PPBodyBaseModel alloc] init];
                model.weight = (NSInteger)(weight * 100);
                model.impedance = 0;
                model.isEnd = NO;
                model.isHeartRatingEnd = YES;
                model.heartRate = 0;
                handler(model);
            }
        }else{
            PPBodyFatModel *model = [[PPBodyFatModel alloc] init];
            model.ppWeightKg = weight;
            model.ppBMI = BMI;
            model.ppBodyfatPercentage = fat;
            model.ppBoneKg = bone;
            model.ppMuscleKg = muscle;
            model.ppVFAL = VFA;
            model.ppWaterPercentage = water;
            model.ppBMR =  BMR;
            //身体年龄
            int bodyAgeInt = (int)bytes[16];
            NSInteger bodyAge = (NSInteger)bodyAgeInt;
            model.ppBodyAge = bodyAge;
            model.ppIsHeartRateEnd = YES;
            if (handler) {
                handler(model);
            }
        }
    }
}

+ (void)analysis18LengthData:(NSData *)receiveDate withResultHandler:(reciveData2BodyBaseModelHandler)handler{

    PPBodyHistoryBaseModel *model = [[PPBodyHistoryBaseModel alloc] init];
    UInt8 bytes[18];
    memcpy(bytes, receiveDate.bytes, 18);

    if (bytes[0]==0xcf || bytes[0] == 0xce) {
        int year = (int)(bytes[11] *256 + bytes[12]);
        int mounth = (int)(bytes[13]);
        int day = (int)(bytes[14]);
        int hour = (int)(bytes[15]);
        int minite = (int)(bytes[16]);
        int secound = (int)(bytes[17]);
        NSString *dateStr = [NSString stringWithFormat:@"%02d-%02d-%02d %02d:%02d:%02d",year,mounth,day,hour,minite,secound];
        model.dateStr = dateStr;
        if (bytes[9]==0x01) {
           int weightInt = (int)(bytes[4]*256+bytes[3]);
           model.weight = weightInt;
        }
        else if(bytes[9]==0x00){
           //体脂类声明
           int weightInt = (int)(bytes[4]*256+bytes[3]);
           NSInteger impedance = (bytes[7]*256*256+bytes[6]*256+bytes[5]);
           model.weight = weightInt;
           model.impedance = impedance;
           if (bytes[2] == 0xc0) {
               NSInteger heartRate = (int)(bytes[1]);
               model.heartRate = heartRate;
           }
        }
        model.isEnd = NO;
        model.haveImpedance = bytes[0] == 0xcf ? YES:NO;
        if (handler) {
           handler(model);
        }
    }
}

+ (void)analysis2LengthData:(NSData *)receiveDate withResultHandler:(reciveData2BodyBaseModelHandler)handler{
    UInt8 bytes[2];
    memcpy(bytes, receiveDate.bytes, 2);
    if (bytes[0] == 0xf2 && bytes[1] == 0x00 && handler) {
        PPBodyHistoryBaseModel *model = [[PPBodyHistoryBaseModel alloc] init];
        model.isEnd = YES;
        handler(model);
    }
}


+ (void)BMDJTimeInterval:(NSData *)reciveData withHandler:(void(^)(BOOL isEnd, NSInteger timeInterval, BOOL isFailed))handler{
    BOOL isEnd = [PPDataAnalysisHandler isBMDJTimingEnd:reciveData];
    NSInteger timeInterval = [PPDataAnalysisHandler BMDJTimeInterval:reciveData];
    BOOL isFailed = [PPDataAnalysisHandler isBMDJTimingFailed:reciveData];
    handler(isEnd, timeInterval, isFailed);
}


+ (void)isBMDJTimingStart:(NSData *)reciveData status:(void(^)(BOOL isSuccess))handler{
    NSString *str = [PPScaleFormatTool data2String:reciveData];
    if ([str isEqualToString:@"10060f0001"]) {
        handler(YES) ;
    }
    if ([str isEqualToString:@"10060f0003"]) {
        handler(NO) ;
    }
}

+ (BOOL)isBMDJTimingEnd:(NSData *)reciveData{
    NSString *str = [PPScaleFormatTool data2String:reciveData];
    if ([str hasPrefix:@"10060f02"]) {
        return YES;
    }
    return NO;
}


+ (BOOL)isBMDJTimingFailed:(NSData *)reciveData{
    NSString *str = [PPScaleFormatTool data2String:reciveData];
    if ([str isEqualToString:@"10060f0003"]) {
        return YES;
    }
    return NO;
}

+ (NSInteger)BMDJTimeInterval:(NSData *)reciveData{
    NSString *str = [PPScaleFormatTool data2String:reciveData];
    if ([str hasPrefix:@"10060f"]) {
        Byte *testByte = (Byte *)[reciveData bytes];
        NSString *strHigh = [NSString stringWithFormat:@"%02X",testByte[4]];
        NSString *strLow = [NSString stringWithFormat:@"%02X",testByte[5]];
        NSString *timeHexStr = [NSString stringWithFormat:@"%@%@", strLow, strHigh];
        NSInteger time = [PPScaleFormatTool numberHexString:timeHexStr];
        return time;
    }
    return 0;
}

+ (void)isBMDJTimingExit:(NSData *)reciveData status:(void(^)(BOOL isSuccess))handler{
    NSString *str = [PPScaleFormatTool data2String:reciveData];
    if ([str isEqualToString:@"1006110001"]) {
        handler(YES) ;
    }
    if ([str isEqualToString:@"1006110003"]) {
        handler(NO) ;
    }
}

+ (void)isConnect2Wifi:(NSData *)reciveData status:(void(^)(BOOL isSuccess, NSString *sn))handler{
    NSString *str = [PPScaleFormatTool data2String:reciveData];
    if ([str hasPrefix:@"06"]) {
        NSData *d = [reciveData subdataWithRange:NSMakeRange(1, reciveData.length -1)];
        NSString *s  =[[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
        handler(YES, s);
    }
}



@end
