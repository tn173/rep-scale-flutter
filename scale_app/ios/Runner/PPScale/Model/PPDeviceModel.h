//
//  PPDeviceModel.h
//  PPBlueToothDemo
//
//  Created by 彭思远 on 2020/7/31.
//  Copyright © 2020 彭思远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPScaleDefine.h"
NS_ASSUME_NONNULL_BEGIN

@interface PPDeviceModel : NSObject

@property (nonatomic, copy) NSString *deviceMac;
@property (nonatomic, copy) NSString *deviceName;
@property (nonatomic, assign) PPDeviceType deviceType;
@end

NS_ASSUME_NONNULL_END
