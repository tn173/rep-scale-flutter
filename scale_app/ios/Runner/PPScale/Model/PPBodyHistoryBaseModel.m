//
//  PPBodyHistoryBaseModel.m
//  PPBlueToothDemo
//
//  Created by 彭思远 on 2020/7/31.
//  Copyright © 2020 彭思远. All rights reserved.
//

#import "PPBodyHistoryBaseModel.h"

@implementation PPBodyHistoryBaseModel

- (NSString *)description{
    
   return [NSString stringWithFormat:@"\n>>>>>>>>>>>>>>>>>>>\n dateStr: %@ \n weight: %ld \n impedance: %ld \n isEnd: %@ \n heartRate: %ld \n isHeartRatingEnd:%@\n>>>>>>>>>>>>>>>>>>>\n",self.dateStr, self.weight, self.impedance, @(self.isEnd), self.heartRate, @(self.isHeartRatingEnd)];
}
@end
