//
//  PPBodyDetailModel.m
//  PPBlueToothDemo
//
//  Created by 彭思远 on 2020/7/31.
//  Copyright © 2020 彭思远. All rights reserved.
//

#import "PPBodyDetailModel.h"
@interface PPBodyDetailModel()

@property(nonatomic,strong,readwrite)PPBodyMeasureDetailModel *fatDetailModel;
@property(nonatomic,strong,readwrite)PPBodyMeasureDetailModel *visceralfatDetailModel;
@property(nonatomic,strong,readwrite)PPBodyMeasureDetailModel *metabolizeDetailModel;
@property(nonatomic,strong,readwrite)PPBodyMeasureDetailModel *watercontentDetailModel;
@property(nonatomic,strong,readwrite)PPBodyMeasureDetailModel *boneDetailModel;
@property(nonatomic,strong,readwrite)PPBodyMeasureDetailModel *proteinDetailModel;
@property(nonatomic,strong,readwrite)PPBodyMeasureDetailModel *bmiDetailModell;
@property(nonatomic,strong,readwrite)PPBodyMeasureDetailModel *nofatWeightDetailModel;
@property(nonatomic,strong,readwrite)PPBodyMeasureDetailModel *obsLevelDetailModel;
@property(nonatomic,strong,readwrite)PPBodyMeasureDetailModel *subFatDetailModell;
@property(nonatomic,strong,readwrite)PPBodyMeasureDetailModel *bodyAgeDetailModel;
@property(nonatomic,strong,readwrite)PPBodyMeasureDetailModel *bodyTypeDetailModel;
@property(nonatomic,strong,readwrite)PPBodyMeasureDetailModel *standardWeightDetailModel;
@property(nonatomic,strong,readwrite)PPBodyMeasureDetailModel *weightDetailMode;
@property(nonatomic,strong,readwrite)PPBodyMeasureDetailModel *muscleDetailModel;
@property(nonatomic,strong,readwrite)PPBodyMeasureDetailModel *bodyScoreDetailModel;
@property(nonatomic,strong,readwrite)PPBodyMeasureDetailModel *bmdjDetailModel;
@property(nonatomic,strong,readwrite)PPBodyMeasureDetailModel *heartRateModel;
@property(nonatomic,strong,readwrite)PPBodyFatModel *originBody;
@end

@implementation PPBodyDetailModel

- (instancetype)initWithPPBodyFatModel:(PPBodyFatModel *)bodyData{
    self = [super init];
    if (self) {
        self.originBody = bodyData;
        [self setAllInfoWithBodyData:bodyData];
    }
    return self;
}

- (void)setAllInfoWithBodyData:(PPBodyFatModel *)bodyData{
    // 脂肪
    self.fatDetailModel = [[PPBodyMeasureDetailModel alloc] initWithBodyParam:PPBodyParam_BodyFat bodyData:bodyData];
    // 内脏脂肪
    self.visceralfatDetailModel = [[PPBodyMeasureDetailModel alloc] initWithBodyParam:PPBodyParam_VisFat bodyData:bodyData];
    // BMR
    self.metabolizeDetailModel = [[PPBodyMeasureDetailModel alloc] initWithBodyParam:PPBodyParam_BMR bodyData:bodyData];
    // 水分
    self.watercontentDetailModel = [[PPBodyMeasureDetailModel alloc] initWithBodyParam:PPBodyParam_Water bodyData:bodyData];
    // 骨量
    self.boneDetailModel = [[PPBodyMeasureDetailModel alloc] initWithBodyParam:PPBodyParam_Bone bodyData:bodyData];
    // 蛋白质
    self.proteinDetailModel = [[PPBodyMeasureDetailModel alloc] initWithBodyParam:PPBodyParam_proteinPercentage bodyData:bodyData];
    // bmi
    self.bmiDetailModell = [[PPBodyMeasureDetailModel alloc] initWithBodyParam:PPBodyParam_BMI bodyData:bodyData];
    // 去脂体重
    self.nofatWeightDetailModel = [[PPBodyMeasureDetailModel alloc] initWithBodyParam:PPBodyParam_BodyLBW bodyData:bodyData];
    // 肥胖等级
    self.obsLevelDetailModel = [[PPBodyMeasureDetailModel alloc] initWithBodyParam:PPBodyParam_FatGrade bodyData:bodyData];
    // 皮下脂肪
    self.subFatDetailModell = [[PPBodyMeasureDetailModel alloc] initWithBodyParam:PPBodyParam_BodySubcutaneousFat bodyData:bodyData];
    // 身体年龄
    self.bodyAgeDetailModel = [[PPBodyMeasureDetailModel alloc] initWithBodyParam:PPBodyParam_physicalAgeValue bodyData:bodyData];
    // 身体类型
    self.bodyTypeDetailModel = [[PPBodyMeasureDetailModel alloc] initWithBodyParam:PPBodyParam_BodyType bodyData:bodyData];
    // 标准体重
    self.standardWeightDetailModel = [[PPBodyMeasureDetailModel alloc] initWithBodyParam:PPBodyParam_Bodystandard bodyData:bodyData];
    // 体重
    self.weightDetailMode = [[PPBodyMeasureDetailModel alloc] initWithBodyParam:PPBodyParam_Weight bodyData:bodyData];
    // 肌肉
    self.muscleDetailModel = [[PPBodyMeasureDetailModel alloc] initWithBodyParam:PPBodyParam_Mus bodyData:bodyData];
    // 身体得分
    self.bodyScoreDetailModel = [[PPBodyMeasureDetailModel alloc] initWithBodyParam:PPBodyParam_BodyScore bodyData:bodyData];
    
    self.bmdjDetailModel = [[PPBodyMeasureDetailModel alloc] initWithBodyParam:PPBodyParam_Bmdj bodyData:bodyData];

    self.heartRateModel = [[PPBodyMeasureDetailModel alloc] initWithBodyParam:PPBodyParam_heart bodyData:bodyData];
}
@end
