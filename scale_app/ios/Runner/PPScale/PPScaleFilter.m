//
//  PPScaleFilter.m
//  powercloudneutral
//
//  Created by 彭思远 on 2020/8/5.
//  Copyright © 2020 Peng. All rights reserved.
//

#import "PPScaleFilter.h"

@implementation PPScaleFilter


+ (NSArray<CBUUID *> *)filterServicesByUUID{
    
    NSMutableArray *services = [@[] mutableCopy];
    CBUUID *filterCB = [CBUUID UUIDWithString:@"FFF0"];
    [services addObject:filterCB];
    return services;
}

+ (NSString *)macAddressByCBAdvDataManufacturerData:(NSData *)advData{
    
    unsigned char bytestemp[advData.length];
    unsigned char bytes[advData.length];
    memcpy(bytestemp, advData.bytes, advData.length);
    NSInteger scaleNameLocation = 0;
    NSInteger macAddressLength = 0;
    if (advData.length == 19) {
        scaleNameLocation = 7;
        macAddressLength = 6;
    }else if (advData.length == 17){
        scaleNameLocation = 5;
        macAddressLength = 6;
    }else if (advData.length == 8){
        scaleNameLocation = 7;
        macAddressLength = 6;
    }else if (advData.length == 25){
        scaleNameLocation = 7;
        macAddressLength = 6;
    }else if (advData.length == 20){
        scaleNameLocation = 5;
        macAddressLength = 6;
    }
    
    for (int i = 0; i<macAddressLength; i++) {
        bytes[i] = bytestemp[scaleNameLocation -i];
    }
    NSString *mac = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",bytes[5],bytes[4],bytes[3],bytes[2],bytes[1],bytes[0]];
    return [mac uppercaseString];
}


@end
