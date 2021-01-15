//
//  PPScaleFilter.h
//  powercloudneutral
//
//  Created by 彭思远 on 2020/8/5.
//  Copyright © 2020 Peng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPScaleFilter : NSObject

+ (NSArray<CBUUID *> *)filterServicesByUUID;

+ (NSString *)macAddressByCBAdvDataManufacturerData:(NSData *)advData;
@end

NS_ASSUME_NONNULL_END
