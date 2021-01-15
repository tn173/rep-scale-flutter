//
//  PPBodyFatModel.h
//  PPBlueToothDemo
//
//  Created by 彭思远 on 2020/7/31.
//  Copyright © 2020 彭思远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPScaleDefine.h"
#import "PPUserModel.h"

///错误类型(针对输入的参数)
typedef NS_ENUM(NSInteger, PPBodyfatErrorType){
    PPBodyfatErrorTypeNone,         //!< 无错误(可读取所有参数)
    PPBodyfatErrorTypeImpedance,    //!< 阻抗有误,阻抗有误时, 不计算除BMI/idealWeightKg以外参数(写0)
    PPBodyfatErrorTypeAge,          //!< 年龄参数有误，需在 6   ~ 99岁(不计算除BMI/idealWeightKg以外参数)
    PPBodyfatErrorTypeWeight,       //!< 体重参数有误，需在 10  ~ 200kg(有误不计算所有参数)
    PPBodyfatErrorTypeHeight        //!< 身高参数有误，需在 90 ~ 220cm(不计算所有参数)
};

//健康等级
typedef NS_ENUM(NSInteger, PPBodyGrade) {
    
    PPBodyGradeThin,             //!< 偏瘦型
    PPBodyGradeLThinMuscle,      //!< 标准型
    PPBodyGradeMuscular,         //!< 超重型
    PPBodyGradeLackofexercise,   //!< 肥胖型
    PPBodyGradeError,            //!< 参数错误
};
//肥胖等级
typedef NS_ENUM(NSInteger, PPBodyFatGrade) {
    
    PPBodyGradeFatOne,             //!< 肥胖1级
    PPBodyGradeLFatTwo,            //!< 肥胖2级
    PPBodyGradeFatThree,           //!< 肥胖3级
    PPBodyGradeFatFour,            //!< 参数错误
};
//健康评估
typedef NS_ENUM(NSInteger, PPBodyHealthAssessment) {
    
    PPBodyAssessment1,          //!< 健康存在隐患
    PPBodyAssessment2,          //!< 亚健康
    PPBodyAssessment3,          //!< 一般
    PPBodyAssessment4,          //!< 良好
    PPBodyAssessment5,          //!< 非常好
};

NS_ASSUME_NONNULL_BEGIN

@interface PPBodyFatModel : NSObject
@property (nonatomic,assign) PPBodyfatErrorType   errorType;
@property (nonatomic,assign) PPUserGender         ppSex;                  //!< 性别
@property (nonatomic,assign) NSInteger            ppHeightCm;             //!< 身高(cm)，需在 90 ~ 220cm
@property (nonatomic,assign) CGFloat              ppWeightKg;             //!< 体重(kg)，需在 10  ~ 200kg
@property (nonatomic,assign) NSInteger            ppAge;                  //!< 年龄(岁)，需在6 ~ 99岁
@property (nonatomic,assign) CGFloat              ppZTwoLegs;             //!< 脚对脚阻抗值(Ω), 范围200.0 ~ 1200.0
@property (nonatomic,assign) CGFloat              ppproteinPercentage;    //!< 蛋白质,分辨率0.1, 范围2.0% ~ 30.0%
@property (nonatomic,assign) NSInteger            ppBodyAge;              //!< 身体年龄,6~99岁
@property (nonatomic,assign) CGFloat              ppIdealWeightKg;        //!< 理想体重(kg)
@property (nonatomic,assign) CGFloat              ppBMI;                  //!< Body Mass Index 人体质量指数, 分辨率0.1, 范围10.0 ~ 90.0
@property (nonatomic,assign) NSInteger            ppBMR;                  //!< Basal Metabolic Rate基础代谢, 分辨率1, 范围500 ~ 10000
@property (nonatomic,assign) NSInteger            ppVFAL;                 //!< Visceral fat area leverl内脏脂肪, 分辨率1, 范围1 ~ 60
@property (nonatomic,assign) CGFloat              ppBoneKg;               //!< 骨量(kg), 分辨率0.1, 范围0.5 ~ 8.0
@property (nonatomic,assign) CGFloat              ppBodyfatPercentage;    //!< 脂肪率(%), 分辨率0.1, 范围5.0% ~ 75.0%
@property (nonatomic,assign) CGFloat              ppWaterPercentage;      //!< 水分率(%), 分辨率0.1, 范围35.0% ~ 75.0%
@property (nonatomic,assign) CGFloat              ppMuscleKg;             //!< 肌肉量(kg), 分辨率0.1, 范围10.0 ~ 120.0
@property (nonatomic,assign) PPBodyDetailType     ppBodyType;              //!< 身体类型
@property (nonatomic,assign) NSInteger            ppBodyScore;             //!< 身体得分，50 ~ 100分
@property (nonatomic,assign) CGFloat              ppMusclePercentage;      //!< 肌肉率(%),分辨率0.1，范围5%~90%
@property (nonatomic,assign) CGFloat              ppBodyfatKg;             //!< 脂肪量(kg)
@property (nonatomic,assign) CGFloat              ppBodystandard;          //!< 标准体重(kg)
@property (nonatomic,assign) CGFloat              ppBodyLBW;               //!< 去脂体重(kg)
@property (nonatomic,assign) CGFloat              ppBodyControl;           //!< 控制体重(kg)
@property (nonatomic,assign) CGFloat              ppBodyControlLiang;      //!< 脂肪控制量(kg)
@property (nonatomic,assign) CGFloat              ppBodySkeletal;          //!< 骨骼肌率(%)
@property (nonatomic,assign) CGFloat              ppBodySMuscleControl;    //!< 肌肉控制量(kg)
@property (nonatomic,assign) CGFloat              ppBodySubcutaneousFat;   //!< 皮下脂肪(%)
@property (nonatomic,assign) PPBodyHealthAssessment   ppBodyHealth;       //!< 健康等级
@property (nonatomic,assign) PPBodyFatGrade      ppFatGrade;              //!< 肥胖等级
@property (nonatomic,assign) PPBodyGrade         ppBodyHealthGrade;       //!< 健康评估
@property (nonatomic,assign) NSInteger           ppHeartRate;             //!< 心律
@property (nonatomic,assign) NSInteger           ppStandTime;             //!< 闭目单脚站立时间
@property (nonatomic,assign) BOOL                ppIsHeartRateEnd;

- (instancetype)initWithUserModel:(PPUserModel *)userModel weight:(CGFloat)weight heartRate:(NSInteger)heartRate isHeartRateEnd:(BOOL)isEnd andImpedance:(NSInteger)impedance;
@end

NS_ASSUME_NONNULL_END
