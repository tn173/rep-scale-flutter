//
//  PPUserModel.m
//  PPBlueToothDemo
//
//  Created by 彭思远 on 2020/7/31.
//  Copyright © 2020 彭思远. All rights reserved.
//

#import "PPUserModel.h"

@implementation PPUserModel

- (instancetype)initWithUserHeight:(NSInteger)userHeight gender:(PPUserGender)userGender age:(NSInteger)userAge andUnit:(PPUserUnit)userUnit{
    self = [super init];
    if (self) {
        self.userHeight = userHeight;
        self.userGender = userGender;
        self.userAge = userAge;
        self.userUnit = userUnit;
    }
    return self;
}
@end
