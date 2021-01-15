//
//  PPDataAnalysisHandler.h
//  PPBlueToothDemo
//
//  Created by 彭思远 on 2020/7/31.
//  Copyright © 2020 彭思远. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

typedef void(^reciveData2BodyBaseModelHandler)(id model);

@interface PPDataAnalysisHandler : NSObject

+ (BOOL)isCorrectADVData:(NSData *)receiveData;

+ (void)receiveDate:(NSData *)receiveDate analysis2BodyBaseModelWithHandler:(reciveData2BodyBaseModelHandler)handler;

+ (void)isBMDJTimingStart:(NSData *)reciveData status:(void(^)(BOOL isSuccess))handler;

+ (void)BMDJTimeInterval:(NSData *)reciveData withHandler:(void(^)(BOOL isEnd, NSInteger timeInterval, BOOL isFailed))handler;

+ (void)isBMDJTimingExit:(NSData *)reciveData status:(void(^)(BOOL isSuccess))handler;

+ (void)isConnect2Wifi:(NSData *)reciveData status:(void(^)(BOOL isSuccess, NSString *sn))handler;
@end

NS_ASSUME_NONNULL_END
