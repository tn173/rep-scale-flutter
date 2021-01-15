//
//  PPScaleInstructionProvider.h
//  PPBlueToothDemo
//
//  Created by 彭思远 on 2020/8/1.
//  Copyright © 2020 彭思远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPUserModel.h"
#import "PPScaleFormatTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPScaleInstructionProvider : NSObject

- (instancetype)initWithUserModel:(PPUserModel *)model;

- (NSArray <NSData *> *)send2ScaleInstructionByType:(PPDeviceType)type andHistoryState:(BOOL)needHistory;

+ (NSData *)delHistoryDataInstruction;

+ (NSData *)exitBMDJInstruction;

+ (NSData *)intoBMDJInstruction;

+ (NSArray *)codesBySSID:(NSString *)ssid andPassword:(NSString *)password;

+ (NSData *)changeKitchenScaleUnit:(PPUserUnit)unit;

+ (NSData *)toZeroForKitchenScale;

@end

NS_ASSUME_NONNULL_END
