//
//  PPUserModel.h
//  PPBlueToothDemo
//
//  Created by 彭思远 on 2020/7/31.
//  Copyright © 2020 彭思远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPScaleDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPUserModel : NSObject

@property (nonatomic, assign) NSInteger userHeight;
@property (nonatomic, assign) PPUserGender userGender;
@property (nonatomic, assign) NSInteger userAge;
@property (nonatomic, assign) PPUserUnit userUnit;


- (instancetype)initWithUserHeight:(NSInteger)userHeight gender:(PPUserGender)userGender age:(NSInteger)userAge andUnit:(PPUserUnit)userUnit;
@end

NS_ASSUME_NONNULL_END
