//
//  PPDeviceModel.m
//  PPBlueToothDemo
//
//  Created by 彭思远 on 2020/7/31.
//  Copyright © 2020 彭思远. All rights reserved.
//

#import "PPDeviceModel.h"

@interface PPDeviceModel()<NSCopying>

@end

@implementation PPDeviceModel

- (NSString *)description{
    
    return [NSString stringWithFormat:@"\n>>>>>>>>>>>>>>>>>>>\n deviceMac: %@ \n deviceName:  %@ \n deviceType: %@ \n>>>>>>>>>>>>>>>>>>>\n",self.deviceMac, self.deviceName, @(self.deviceType)] ;
}

- (id)copyWithZone:(NSZone *)zone{
    
    PPDeviceModel *model = [[[self class] allocWithZone:zone] init];
    model.deviceMac = self.deviceMac;
    model.deviceName = self.deviceName;
    model.deviceType = self.deviceType;
    return model;
}
@end
