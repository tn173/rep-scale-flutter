//
//  PPBodyBaseModel.h
//  PPBlueToothDemo
//
//  Created by 彭思远 on 2020/7/31.
//  Copyright © 2020 彭思远. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPBodyBaseModel : NSObject
@property (nonatomic, assign) NSInteger weight;
@property (nonatomic, assign) NSInteger impedance;
@property (nonatomic, assign) BOOL isEnd;

@property (nonatomic, assign) NSInteger heartRate;
@property (nonatomic, assign) NSInteger isHeartRatingEnd;

@property (nonatomic, assign) BOOL haveImpedance;

@end

NS_ASSUME_NONNULL_END
