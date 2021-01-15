//
//  PPBodyDetailModel.h
//  PPBlueToothDemo
//
//  Created by 彭思远 on 2020/7/31.
//  Copyright © 2020 彭思远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPBodyMeasureDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PPBodyDetailModel : NSObject
// 体重
@property(nonatomic,strong,readonly)PPBodyMeasureDetailModel *weightDetailMode;
// bmi
@property(nonatomic,strong,readonly)PPBodyMeasureDetailModel *bmiDetailModell;
// 脂肪
@property(nonatomic,strong,readonly)PPBodyMeasureDetailModel *fatDetailModel;
// 肌肉
@property(nonatomic,strong,readonly)PPBodyMeasureDetailModel *muscleDetailModel;
// 水分
@property(nonatomic,strong,readonly)PPBodyMeasureDetailModel *watercontentDetailModel;
// 内脏脂肪
@property(nonatomic,strong,readonly)PPBodyMeasureDetailModel *visceralfatDetailModel;
// 骨量
@property(nonatomic,strong,readonly)PPBodyMeasureDetailModel *boneDetailModel;
// bmr
@property(nonatomic,strong,readonly)PPBodyMeasureDetailModel *metabolizeDetailModel;
// 蛋白质
@property(nonatomic,strong,readonly)PPBodyMeasureDetailModel *proteinDetailModel;
// 皮下脂肪
@property(nonatomic,strong,readonly)PPBodyMeasureDetailModel *subFatDetailModell;
// 肥胖等级
@property(nonatomic,strong,readonly)PPBodyMeasureDetailModel *obsLevelDetailModel;
// 身体得分
@property(nonatomic,strong,readonly)PPBodyMeasureDetailModel *bodyScoreDetailModel;
// 去脂体重
@property(nonatomic,strong,readonly)PPBodyMeasureDetailModel *nofatWeightDetailModel;
// 身体年龄
@property(nonatomic,strong,readonly)PPBodyMeasureDetailModel *bodyAgeDetailModel;
// 身体类型
@property(nonatomic,strong,readonly)PPBodyMeasureDetailModel *bodyTypeDetailModel;
// 标准体重
@property(nonatomic,strong,readonly)PPBodyMeasureDetailModel *standardWeightDetailModel;
// 闭目单脚
@property(nonatomic,strong,readonly)PPBodyMeasureDetailModel *bmdjDetailModel;
// 心率
@property(nonatomic,strong,readonly)PPBodyMeasureDetailModel *heartRateModel;

@property(nonatomic,strong,readonly)PPBodyFatModel *originBody;

- (instancetype)initWithPPBodyFatModel:(PPBodyFatModel *)bodyData;

@end

NS_ASSUME_NONNULL_END
