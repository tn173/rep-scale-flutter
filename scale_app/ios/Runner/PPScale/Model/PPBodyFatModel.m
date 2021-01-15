//
//  PPBodyFatModel.m
//  PPBlueToothDemo
//
//  Created by 彭思远 on 2020/7/31.
//  Copyright © 2020 彭思远. All rights reserved.
//

#import "PPBodyFatModel.h"
#import "HTBodyfat_SDK.h"

@implementation PPBodyFatModel

- (instancetype)initWithUserModel:(PPUserModel *)userModel weight:(CGFloat)weight heartRate:(NSInteger)heartRate isHeartRateEnd:(BOOL)isEnd andImpedance:(NSInteger)impedance{
    self = [super init];
    if (self) {
        HTPeopleGeneral *peopleModel = [[HTPeopleGeneral alloc] init];
        HTSexType gender = (HTSexType)userModel.userGender;
        HTBodyfatErrorType errorType = [peopleModel getBodyfatWithweightKg:weight heightCm:userModel.userHeight sex:gender age:userModel.userAge impedance:impedance];
        self.errorType = (PPBodyfatErrorType)errorType;
        self.ppSex = userModel.userGender;
        self.ppHeightCm = userModel.userHeight;
        self.ppWeightKg = weight;
        self.ppAge = userModel.userAge;                  //!< 年龄(岁)，需在6 ~ 99岁
        self.ppBMI = peopleModel.htBMI;                  //!< Body Mass Index 人体质量指数, 分辨率0.1, 范围10.0 ~ 90.0
        if (self.ppBMI <= 10.0) {
            self.ppBMI = weight / powf((self.ppHeightCm /100.0), 2);
        }
        if (self.errorType == PPBodyfatErrorTypeNone) {
            self.ppZTwoLegs = impedance;           
            self.ppproteinPercentage = peopleModel.htproteinPercentage;   //!< 蛋白质,分辨率0.1, 范围2.0% ~ 30.0%
            self.ppBodyAge = [self calcuteBodyAge:peopleModel.htBodyAge];          //!< 身体年龄,6~99岁
            self.ppIdealWeightKg = peopleModel.htIdealWeightKg;        //!< 理想体重(kg)
            self.ppBMR = peopleModel.htBMR;                  //!< Basal Metabolic Rate基础代谢, 分辨率1, 范围500 ~ 10000
            self.ppVFAL = peopleModel.htVFAL;                 //!< Visceral fat area leverl内脏脂肪, 分辨率1, 范围1 ~ 60
            self.ppBoneKg = ((int)(peopleModel.htBoneKg*100+5))/100.0;;              //!< 骨量(kg), 分辨率0.1, 范围0.5 ~ 8.0

            CGFloat difference = 0;
            if (gender == PPUserGenderFemale) {
                if (peopleModel.htBodyfatPercentage < 14) {
                    difference = 0;
                }else if (peopleModel.htBodyfatPercentage < 21){
                    difference = 1.0;
                }else if (peopleModel.htBodyfatPercentage < 25){
                    difference = 2.0;
                }else if (peopleModel.htBodyfatPercentage < 32){
                    difference = 3.0;
                }else{
                    difference = 4.0;
                }
            }else{
                if (peopleModel.htBodyfatPercentage < 6) {
                    difference = 0;
                }else if (peopleModel.htBodyfatPercentage < 14){
                    difference = 1.0;
                }else if (peopleModel.htBodyfatPercentage < 18){
                    difference = 2.0;
                }else if (peopleModel.htBodyfatPercentage < 26){
                    difference = 3.0;
                }else{
                    difference = 4.0;
                }
            }
            
            self.ppBodyfatPercentage = peopleModel.htBodyfatPercentage - difference < 5.0 ? 5.0:peopleModel.htBodyfatPercentage - difference;    //!< 脂肪率(%), 分辨率0.1, 范围5.0% ~ 75.0%
            self.ppWaterPercentage = peopleModel.htWaterPercentage;      //!< 水分率(%), 分辨率0.1, 范围35.0% ~ 75.0%
            self.ppMuscleKg =  ((int)(peopleModel.htMuscleKg*100+5))/100.0;           //!< 肌肉量(kg), 分辨率0.1, 范围10.0 ~ 120.0
           
            self.ppBodyType = (PPBodyDetailType)peopleModel.htBodyType;              //!< 身体类型
            self.ppBodyScore = peopleModel.htBodyScore;             //!< 身体得分，50 ~ 100分
            self.ppMusclePercentage = peopleModel.htMusclePercentage;     //!< 肌肉率(%),分辨率0.1，范围5%~90%
            
            self.ppBodyfatKg = self.ppBodyfatPercentage * 0.01 * weight;            //!< 脂肪量(kg)
            
            CGFloat heightM = userModel.userHeight / 100.0;
            self.ppBodystandard = 21.75 * heightM * heightM;         //!< 标准体重(kg)
            self.ppBodyLBW = weight - self.ppBodyfatKg;               //!< 去脂体重(kg)
            self.ppBodyControl = weight - self.ppBodystandard;           //!< 控制体重(kg)
            if (peopleModel.htBodyfatKg != 0) {
                self.ppBodyControlLiang =  [self ppBodyControlLiangWithBodyfatKg:self.ppBodyfatKg sex:gender bmi:peopleModel.htBMI andAge:userModel.userAge];      //!< 脂肪控制量(kg)
                if (gender == PPUserGenderFemale)//女性
                {
                    self.ppBodySkeletal = self.ppBodyLBW * 0.54 / weight;//!< 骨骼肌率(%)
                    
                    CGFloat StandMuscle = self.ppBodystandard * 0.724;
                    self.ppBodySMuscleControl = StandMuscle - peopleModel.htMuscleKg; //!< 肌肉控制量(kg)
                    if (self.ppBodySMuscleControl < 0) {
                        self.ppBodySMuscleControl = 0;
                    }
                    
                }else
                {
                    self.ppBodySkeletal = self.ppBodyLBW * 0.56 / weight;
                    CGFloat StandMuscle = self.ppBodystandard * 0.797;
                    self.ppBodySMuscleControl = StandMuscle - peopleModel.htMuscleKg;
                    if (self.ppBodySMuscleControl < 0) {
                        self.ppBodySMuscleControl = 0;
                    }
                }
            }

            self.ppBodySubcutaneousFat = self.ppBodyfatPercentage * 2 / 3;   //!< 皮下脂肪(%)
            self.ppBodyHealth = [self HealthScore:self.ppBodyScore];       //!< 健康评估
            self.ppFatGrade = [self BodyFatGrade:self.ppBMI];              //!< 肥胖等级
            self.ppBodyHealthGrade = [self BodyGrade:self.ppBMI];      //!< 健康等级
            self.ppHeartRate = heartRate;
        }
        self.ppIsHeartRateEnd = isEnd;
    }
    return self;
}

//脂肪控制量
- (CGFloat)ppBodyControlLiangWithBodyfatKg:(CGFloat)bodyfatKg sex:(PPUserGender)sex bmi:(CGFloat)bmi andAge:(NSInteger)age
{
    CGFloat control;
    //女性
    if (sex == PPUserGenderFemale)
    {
        float B0 = 67.2037;
        float B1 = 0.6351;
        float B2 = -2.6706;
        float B3 = -18.1146;
        float B4 = -0.2374;
        if(bmi <= 21)
        {
            if(bodyfatKg < 10.5 )
                return 10.2 - bodyfatKg;
            else
                return 0;
        }
         control = B0 + B1 * age + B2 * bmi + B3 * age / bmi + B4 * bmi * bmi / age;
        
    }else
    {
        float B0 = 24.1589;
        float B1 = -0.6282;
        float B2 = -0.5865;
        float B3 = 9.8772;
        float B4 = -0.368;
        if(bmi <= 22.5)
        {
            if(bodyfatKg < 8.5 )
                return 9 - bodyfatKg;
            else
                return 0;
        }
        control = B0 + B1 * age + B2 * bmi + B3 * age / bmi + B4 * bmi * bmi / age;
    }
    
    return control;
}

//健康评估
- (PPBodyHealthAssessment) HealthScore:(NSInteger)htBodyScore
{
    if (htBodyScore <= 0) {
        htBodyScore = 10;
    }
    if (0 < htBodyScore && htBodyScore <= 60) {
        return PPBodyAssessment1;
    }else if ( 60 < htBodyScore && htBodyScore <=70)
    {
        return PPBodyAssessment2;
    }else if ( 70 < htBodyScore && htBodyScore <= 80)
    {
        return PPBodyAssessment3;
    }else if (80 < htBodyScore && htBodyScore <= 90)
    {
        return PPBodyAssessment4;
    }else
    {
        return PPBodyAssessment5;
    }
}
//肥胖等级
- (PPBodyFatGrade)BodyFatGrade :(CGFloat)bmi
{
    if (30 <= bmi && bmi < 35) {
        return PPBodyGradeFatOne;
    }else if (35 <= bmi && bmi < 40)
    {
        return PPBodyGradeLFatTwo;
    }else if (40 <= bmi && bmi < 90)
    {
        return PPBodyGradeFatThree;
    }else
    {
        return PPBodyGradeFatFour;
    }
}
//健康等级
- (PPBodyGrade)BodyGrade :(CGFloat)bmi
{
    if (0 <= bmi && bmi < 18.5) {
        return PPBodyGradeThin;
    }else if (18.6 <= bmi && bmi < 24.9)
    {
        return PPBodyGradeLThinMuscle;
    }else if (25 <= bmi && bmi < 29.9)
    {
        return PPBodyGradeMuscular;
    }else if (30 <= bmi && bmi < 90)
    {
        return PPBodyGradeLackofexercise;
    }else
    {
        return PPBodyGradeError;
    }
}

- (NSInteger)calcuteBodyAge:(NSInteger)bodyAge{
    // 不展示身体年龄
    return 0;
    
    NSInteger physicAge = 0;
    NSInteger age = bodyAge;
    CGFloat bmi = self.ppBMI;
    if (bmi < 22) {
        CGFloat temp = (age - 5) + ((22 - bmi) * (5 / (22 - 18.5f)));
            if (fabs(temp - age) >= 5) {
           physicAge = age + 5;
        } else {
           physicAge = temp;
        }
    } else if (bmi == 22) {
        physicAge = age - 5;
    } else if (bmi > 22) {
        float temp = (age - 5) + ((bmi - 22) * (5 / (24.9f - 22)));
        if (fabs(temp - age) >= 8) {
           physicAge = age + 8;
        } else {
           physicAge = temp;
        }
    }
    return physicAge;

}

@end
