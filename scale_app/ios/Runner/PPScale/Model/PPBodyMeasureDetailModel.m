//
//  PPBodyMeasureDetailModel.m
//  PPBlueToothDemo
//
//  Created by 彭思远 on 2020/7/31.
//  Copyright © 2020 彭思远. All rights reserved.
//

#import "PPBodyMeasureDetailModel.h"

@interface PPBodyMeasureDetailModel()

@property (nonatomic,copy,readwrite) NSString *indexName;      //身体指标名
@property (nonatomic,copy,readwrite) NSString *standStr;      //标准评价(正常、偏高、偏低)
@property (nonatomic,copy,readwrite) NSString *introduction;    //介绍当前指标的含义
@property (nonatomic,copy,readwrite) NSString *suggestion;      //针对当前状况的建议
@property (nonatomic,copy,readwrite) NSString *evaluation;      //当前情况的评价
@property (nonatomic,strong,readwrite) NSArray *standardTitleArray;   //标准文字数组(正常、偏高、偏低)

@property (nonatomic,strong,readwrite) NSArray *standardArray;        //标准分隔点数组
@property (nonatomic,assign,readwrite) NSInteger currentStandard;     //当前属于哪个标准 从0开始
@property (nonatomic,assign,readwrite) BOOL isHappyFace;              //笑脸还是哭脸
@end

@implementation PPBodyMeasureDetailModel

- (instancetype)initWithBodyParam:(PPBodyParam)bodyParam bodyData:(PPBodyFatModel *)bodyData{
    self = [super init];
    if (self) {
        
        [PPBodyMeasureDetailModel setProgressValueWithBodyParam:bodyParam bodyData:bodyData calculateFinishHandle:^(NSArray *standardArray, NSInteger currentStandard,BOOL isHappyFace) {
            self.standardArray = standardArray;
            self.currentStandard = currentStandard;
        }];
        
        [PPBodyMeasureDetailModel getBodyTextInfoWithBodyParam:bodyParam currentStandard:self.currentStandard handle:^(NSString *indexName, NSString *suggestion, NSString *introduction, NSString *standStr, NSArray *stands, NSString *evaluation,UIColor *standColor,NSArray *colors) {
            //身体指标名称，BMI、内脏脂肪……
            self.indexName = indexName;
            //当前指标的评价(偏低、标准、偏高)
            self.standStr = standStr;
            //根据当前阶段获取建议
            self.suggestion = suggestion;
            //根据指标名获取简介、介绍
            self.introduction = introduction;
            //当前情况的评价
            self.evaluation = evaluation;
            //每一个分段layer下显示的title数组
            self.standardTitleArray = stands;
        }];
    }
    return self;
}

+ (void)setProgressValueWithBodyParam:(PPBodyParam)bodyParam bodyData:(PPBodyFatModel *)bodyData calculateFinishHandle:(void(^)(NSArray *standardArray,NSInteger currentStandard,BOOL isHappyFace))handle{
    
    NSInteger section;
    
    switch (bodyParam) {
#pragma mark -- BMI
        case PPBodyParam_BMI:
        {
            double value = bodyData.ppBMI;
            
            if (value<18.5) {
                section=1;
            }
            else if (value>=18.5 && value<24) {
                section=2;
            }
            else if(value>=24 && value<30){
                section=3;
            }
            else{
                section=4;
            }
            // standardArray第一个插入0.0，最后一个插入 前两个的差值加上前一个的值再乘以2，便于之后计算笑脸的位置
            NSArray *standardArray = @[@"0.0",@"18.5",@"24",@"30",@"42"];
            NSInteger currentStandard = section-1;
            BOOL isHappyFace = NO;
            if (section==2){
                isHappyFace = YES;
            }
            if (handle) {
                handle(standardArray,currentStandard,isHappyFace);
            }
        }
            break;
#pragma mark -- Weight 体重
        case PPBodyParam_Weight:
        {
            CGFloat standValue;
            if (bodyData.ppSex==PPUserGenderMale) {//男性
                standValue = (bodyData.ppHeightCm-80)*0.7; // 身高单位为cm
            }
            else{//女性
                standValue = (bodyData.ppHeightCm-70)*0.6;
            }
            CGFloat point1 = standValue*0.9f;
            CGFloat point2 = standValue*1.1f;
            
            if (bodyData.ppWeightKg<point1) { // 重量单位为kg
                section=1;
            }
            else if(bodyData.ppWeightKg<point2){
                section = 2;
            }
            else{
                section = 3;
            }
            
            // standardArray第一个插入0.0，最后一个插入 前两个的差值加上前一个的值再乘以2，便于之后计算笑脸的位置
            NSArray *standardArray = @[@"0.0",[PPBodyMeasureDetailModel weightStrWithKg:point1],[PPBodyMeasureDetailModel weightStrWithKg:point2],[NSString stringWithFormat:@"%.1f",point2 + (point2-point1)*2]];
            NSInteger currentStandard = section-1;
            BOOL isHappyFace = NO; // 显示笑脸还是哭脸
            if (section==2){
                isHappyFace = YES;
            }
            if (handle) {
                handle(standardArray,currentStandard,isHappyFace);
            }
        }
            break;
#pragma mark -- BodyFat 脂肪
        case PPBodyParam_BodyFat:
        {
            float fat = bodyData.ppBodyfatPercentage/100.0;
            float labelValue[4];
            if (bodyData.ppSex==PPUserGenderMale) {
                if (bodyData.ppAge>18 && bodyData.ppAge<39) {
                    labelValue[0]=0.1;
                    labelValue[1]=0.21;
                    labelValue[2]=0.26;
//                    labelValue[3]=0.45;
                }
                else if (bodyData.ppAge>=40 && bodyData.ppAge<59){
                    labelValue[0]=0.11;
                    labelValue[1]=0.22;
                    labelValue[2]=0.27;
//                    labelValue[3]=0.45;
                }
                else{
                    labelValue[0]=0.13;
                    labelValue[1]=0.24;
                    labelValue[2]=0.29;
//                    labelValue[3]=0.45;
                }
            }
            else{
                if (bodyData.ppAge>18 && bodyData.ppAge<39) {
                    labelValue[0]=0.2;
                    labelValue[1]=0.34;
                    labelValue[2]=0.39;
//                    labelValue[3]=0.45;
                }
                else if (bodyData.ppAge>=40 && bodyData.ppAge<59){
                    labelValue[0]=0.21;
                    labelValue[1]=0.35;
                    labelValue[2]=0.40;
//                    labelValue[3]=0.45;
                }
                else{
                    labelValue[0]=0.22;
                    labelValue[1]=0.36;
                    labelValue[2]=0.41;
//                    labelValue[3]=0.45;
                }
            }
            
            if (fat<labelValue[0]) {
                section=1;
            }
            else if (fat<labelValue[1]){
                section=2;
            }
            else if (fat<labelValue[2]){
                section=3;
            }
            else{
                section=4;
            }
            // standardArray第一个插入0.0，最后一个插入 前两个的差值加上前一个的值再乘以2，便于之后计算笑脸的位置
            NSArray *standardArray = @[@"0.0",[NSString stringWithFormat:@"%.1f%%",labelValue[0]*100],[NSString stringWithFormat:@"%.1f%%",labelValue[1]*100],[NSString stringWithFormat:@"%.1f%%",labelValue[2]*100],[NSString stringWithFormat:@"%.1f%%",(labelValue[2] + 2.5*(labelValue[2] - labelValue[1]))*100]];
            NSInteger currentStandard = section-1;
            BOOL isHappyFace = NO;
            if (section==2){
                isHappyFace = YES;
            }
            if (handle) {
                handle(standardArray,currentStandard,isHappyFace);
            }
        }
            break;
#pragma mark -- Bone 骨量
        case PPBodyParam_Bone:
        {
            CGFloat standValue;
            double weight = bodyData.ppWeightKg;
            double bone = bodyData.ppBoneKg;
            bone=((int)(bone*100)/100.0);
            NSInteger section;
            if (bodyData.ppSex==PPUserGenderMale) {
                if (weight<60.0) {
                    standValue = 2.5;
                }
                else if (weight>75.0){
                    standValue = 3.2;
                }
                else{
                    standValue = 2.9;
                }
            }
            else{
                if (weight<45.0) {
                    standValue = 1.8;
                }
                else if (weight>60.0){
                    standValue = 2.5;
                }
                else{
                    standValue = 2.2;
                }
            }
            
            if (bone<(standValue-0.1)) {
                section=1;
            }
            else if(bone>(standValue+0.1)){
                section=3;
            }
            else{
                section=2;
            }
            // standardArray第一个插入0.0，最后一个插入 前两个的差值加上前一个的值再乘以2，便于之后计算笑脸的位置
            NSArray *standardArray = @[@"0.0",[PPBodyMeasureDetailModel weightStrWithKg:(standValue-0.1)],[PPBodyMeasureDetailModel weightStrWithKg:(standValue+0.1)],[PPBodyMeasureDetailModel weightStrWithKg:(standValue+0.1+0.4)]];
            NSInteger currentStandard = section-1;
            BOOL isHappyFace = NO;
            if (section==2||section==3){
                isHappyFace = YES;
            }
            if (handle) {
                handle(standardArray,currentStandard,isHappyFace);
            }
        }
            break;
#pragma mark -- VisFat 内脏脂肪
        case PPBodyParam_VisFat:
        {
            double fat = bodyData.ppVFAL;
            if (fat<=9) {
                section=1;
            }
            else if(fat>14){
                section=3;
            }
            else{
                section=2;
            }
            // standardArray第一个插入0.0，最后一个插入 前两个的差值加上前一个的值再乘以2，便于之后计算笑脸的位置
            NSArray *standardArray = @[@"0.0",@"9",@"14",@"24"];
            NSInteger currentStandard = section-1;
            BOOL isHappyFace = NO;
            if (section==1){
                isHappyFace = YES;
            }
            if (handle) {
                handle(standardArray,currentStandard,isHappyFace);
            }
            
        }
            break;
#pragma mark -- BMR
        case PPBodyParam_BMR:
        {
            CGFloat standValue =0;
            double weight = bodyData.ppWeightKg;
            double metabolize = bodyData.ppBMR;
            
            if (bodyData.ppSex==PPUserGenderMale) {
                if (bodyData.ppAge<29) {
                    standValue = weight*24;
                }
                else if (bodyData.ppAge<49){
                    standValue = weight*22.3;
                }
                else if (bodyData.ppAge<69){
                    standValue = weight*21.5;
                }
                else{
                    standValue = weight*21.5;
                }
            }
            else {
                if (bodyData.ppAge<29) {
                    standValue = weight*23.6;
                }
                else if (bodyData.ppAge<49){
                    standValue = weight*21.7;
                }
                else if (bodyData.ppAge<69){
                    standValue = weight*20.7;
                }
                else{
                    standValue = weight*20.7;
                }
            }
            
            if (metabolize<standValue||metabolize<0.01) {
                section=1;
            }
            else{
                section=2;
            }
            // standardArray第一个插入0.0，最后一个插入 前两个的差值加上前一个的值再乘以2，便于之后计算笑脸的位置
            NSArray *standardArray = @[@"0.0",[NSString stringWithFormat:@"%.1fKcal",standValue],[NSString stringWithFormat:@"%.1fKcal",2*standValue]];
            NSInteger currentStandard = section-1;
            BOOL isHappyFace = NO;
            if (section==2){
                isHappyFace = YES;
            }
            if (handle) {
                handle(standardArray,currentStandard,isHappyFace);
            }
        }
            break;
#pragma mark -- Water 水分
        case PPBodyParam_Water:
        {
            float water = bodyData.ppWaterPercentage/100.0;
            
            if (water<((bodyData.ppSex==PPUserGenderMale)?0.55:0.45)) {
                section=1;
            }
            else if(water>((bodyData.ppSex==PPUserGenderMale)?0.65:0.60)){
                section=3;
            }
            else{
                section=2;
            }
            // standardArray第一个插入0.0，最后一个插入 前两个的差值加上前一个的值再乘以2，便于之后计算笑脸的位置
            NSArray *standardArray = @[@"0.0",[NSString stringWithFormat:@"%@%%",@((bodyData.ppSex==PPUserGenderMale)?55:45)],[NSString stringWithFormat:@"%@%%",@((bodyData.ppSex==PPUserGenderMale)?65:60)],[NSString stringWithFormat:@"%@%%",@((bodyData.ppSex==PPUserGenderMale)?85:90)]];
            NSInteger currentStandard = section-1;
            BOOL isHappyFace = NO;
            if (section==2 || section == 3){
                isHappyFace = YES;
            }
            if (handle) {
                handle(standardArray,currentStandard,isHappyFace);
            }
        }
            break;
#pragma mark -- Muscle 肌肉
        case PPBodyParam_Mus:
        {
            CGFloat standValue;
            double muscle = bodyData.ppMuscleKg;
            CGFloat difference;
            
            if (bodyData.ppSex==PPUserGenderMale) {
                if (bodyData.ppHeightCm<160) {
                    standValue = 42.5;
                    difference = 4.0;
                }
                else if (bodyData.ppHeightCm>170){
                    standValue = 54.4;
                    difference = 5.0;
                }
                else{
                    standValue = 48.2;
                    difference = 4.2;
                }
            }
            else{
                if (bodyData.ppHeightCm<150) {
                    standValue = 31.9;
                    difference = 2.8;
                }
                else if (bodyData.ppHeightCm>160){
                    standValue = 39.5;
                    difference = 3.0;
                }
                else{
                    standValue = 35.2;
                    difference = 2.3;
                }
            }
            
            if (muscle<standValue-difference) {
                section=1;
            }
            else if(muscle>standValue+difference){
                section=3;
            }
            else{
                section=2;
            }
            // standardArray第一个插入0.0，最后一个插入 前两个的差值加上前一个的值再乘以2，便于之后计算笑脸的位置
            NSArray *standardArray = @[@"0.0",[PPBodyMeasureDetailModel weightStrWithKg:(standValue-difference)],[PPBodyMeasureDetailModel weightStrWithKg:(standValue+difference)],[PPBodyMeasureDetailModel weightStrWithKg:(standValue+difference+4*difference)]];
            NSInteger currentStandard = section-1;
            BOOL isHappyFace = NO;
            if (section==2||section==3){
                isHappyFace = YES;
            }
            if (handle) {
                handle(standardArray,currentStandard,isHappyFace);
            }
        }
            break;
#pragma mark -- ProteinPercentage 蛋白质
        case PPBodyParam_proteinPercentage:
        {
            double value = bodyData.ppproteinPercentage;
            if (value<16) {
                section=1;
            }
            else if (value<=20) {
                section=2;
            }
            else{
                section=3;
            }
            // standardArray第一个插入0.0，最后一个插入 前两个的差值加上前一个的值再乘以2，便于之后计算笑脸的位置
            NSArray *standardArray = @[@"0.0",@"16%",@"20%",@"28%"];
            NSInteger currentStandard = section - 1;
            BOOL isHappyFace = NO;
            if (section==2){
                isHappyFace = YES;
            }

            if (handle) {
                handle(standardArray,currentStandard,isHappyFace);
            }
        }
            break;
#pragma mark -- FatGrade 肥胖等级
        case PPBodyParam_FatGrade:
        {
            double bmi = bodyData.ppBMI ;
            float labelValue[5];
            labelValue[0] = 18.5;
            labelValue[1] = 24.9;
            labelValue[2] = 29.9;
            labelValue[3] = 35.0;
            labelValue[4] = 40.0;
            
            if (bmi<labelValue[0]) {
                section=1;
            }
            else if (bmi<labelValue[1]){
                section=2;
            }
            else if (bmi<labelValue[2]){
                section=3;
            }
            else if (bmi<labelValue[3]){
                section=4;
            }
            else if (bmi<labelValue[4])
            {
                section=5;
            }
            else{
                section=6;
            }
            // standardArray第一个插入0.0，最后一个插入 前两个的差值加上前一个的值再乘以2，便于之后计算笑脸的位置
            NSArray *standardArray = @[@"0.0",[NSString stringWithFormat:@"%.1f",labelValue[0]],[NSString stringWithFormat:@"%.1f",labelValue[1]],[NSString stringWithFormat:@"%.1f",labelValue[2]],[NSString stringWithFormat:@"%.1f",labelValue[3]],[NSString stringWithFormat:@"%.1f",labelValue[4]],[NSString stringWithFormat:@"%.1f",(labelValue[4] + 2*(labelValue[4] - labelValue[3]))]];
            NSInteger currentStandard = section-1;
            BOOL isHappyFace = NO;
            if (section==2){
                isHappyFace = YES;
            }
            
            if (handle) {
                handle(standardArray,currentStandard,isHappyFace);
            }
        }
            break;
#pragma mark -- BodySubcutaneousFat 皮下脂肪
        case PPBodyParam_BodySubcutaneousFat:
        {
            double subFat = bodyData.ppBodySubcutaneousFat;
            float labelValue[3];
            NSArray *standardArray;
            if (bodyData.ppSex==PPUserGenderMale) {
                if (subFat < 8.6) {
                    section = 1;
                }else if (subFat < 16.7)
                {
                    section = 2;
                }else if (subFat < 20.7)
                {
                    section = 3;
                }else
                {
                    section = 4;
                }
                // standardArray第一个插入0.0，最后一个插入 前两个的差值加上前一个的值再乘以2，便于之后计算笑脸的位置
                standardArray = @[@"0.0",@"8.6%",@"16.7%",@"20.7%",@"28.7%"];
                labelValue[0] = 8.6;
                labelValue[1] = 16.7;
                labelValue[2] = 20.7;
            }else{
                if (subFat < 18.5) {
                    section = 1;
                }else if (subFat < 26.7)
                {
                    section = 2;
                }else if (subFat < 30.8)
                {
                    section = 3;
                }else
                {
                    section = 4;
                }
                // standardArray第一个插入0.0，最后一个插入 前两个的差值加上前一个的值再乘以2，便于之后计算笑脸的位置
                standardArray = @[@"0.0",@"18.5%",@"26.7%",@"30.8%",@"39.0%"];
                labelValue[0] = 18.5;
                labelValue[1] = 26.7;
                labelValue[2] = 30.8;
            }
            
            NSInteger currentStandard = section-1;
            BOOL isHappyFace = NO;
            if (section==2){
                isHappyFace = YES;
            }
            if (handle) {
                handle(standardArray,currentStandard,isHappyFace);
            }
            
        }
            break;
#pragma mark -- BodyScore 身体得分
        case PPBodyParam_BodyScore:
        {
            int bodyScore = bodyData.ppBodyScore;
            int labelValue[3];
            labelValue[0] = 70;
            labelValue[1] = 80;
            labelValue[2] = 90;
            
            if (bodyScore<labelValue[0]) {
                section=1;
            }
            else if (bodyScore<labelValue[1]){
                section=2;
            }
            else if (bodyScore<labelValue[2]){
                section=3;
            }
            else{
                section=4;
            }
            NSArray *standardArray = @[@"0",[NSString stringWithFormat:@"%d",labelValue[0]],[NSString stringWithFormat:@"%d",labelValue[1]],[NSString stringWithFormat:@"%d",labelValue[2]],@"100"];
            NSInteger currentStandard = section-1;
            BOOL isHappyFace = NO;
            if (section==3 || section==4){
                isHappyFace = YES;
            }
            if (handle) {
                handle(standardArray,currentStandard,isHappyFace);
            }
        }
            break;
#pragma mark -- physicalAgeValue 身体年龄
        case PPBodyParam_physicalAgeValue:
        {
            int bodyAge = bodyData.ppBodyAge;
            int realyAge = bodyData.ppAge;
            if (realyAge > bodyAge) {
                section = 1;
            }else{
                section = 2;
            }
            NSArray *standardArray = @[[NSString stringWithFormat:@"%d",realyAge - 10],[NSString stringWithFormat:@"%d%@",realyAge,NSLocalizedString(@"years old", nil)],[NSString stringWithFormat:@"%d",realyAge + 10]];
            NSInteger currentStandard = section-1;
            BOOL isHappyFace = NO;
            if (section==1){
                isHappyFace = YES;
            }
            if (handle) {
                handle(standardArray,currentStandard,isHappyFace);
            }
            
        }
            break;
#pragma mark -- BodyType 身体类型
        case PPBodyParam_BodyType:
        {
            int bodyType = bodyData.ppBodyType;
            section = bodyType;
            NSArray *standardArray = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8"];
            NSInteger currentStandard = section;
            BOOL isHappyFace = NO;
            if (handle) {
                handle(standardArray,currentStandard,isHappyFace);
            }
            
        }
            break;
#pragma mark -- BodyLBW 去脂体重
        case PPBodyParam_BodyLBW:
        {
        
            double nofatWeight = bodyData.ppBodyLBW;
            double weight = bodyData.ppWeightKg;
            double labelValue[2];
            labelValue[0] = weight - 10.0;
            labelValue[1] = weight + 10.0;

            if (nofatWeight<labelValue[0]) {
                section=1;
            }
            else if (nofatWeight<labelValue[1]){
                section=2;
            }
            else{
                section=3;
            }
            NSArray *standardArray = @[@"0.0",[NSString stringWithFormat:@"%.1f",labelValue[0]],[NSString stringWithFormat:@"%.1f",labelValue[1]],[NSString stringWithFormat:@"%.1f",labelValue[1] + 2*(labelValue[1] - labelValue[0])]];
            NSInteger currentStandard = section-1;
            BOOL isHappyFace = NO;
            if (section==2){
                isHappyFace = YES;
            }
            if (handle) {
                handle(standardArray,currentStandard,isHappyFace);
            }
            
        }
            break;
#pragma mark -- Bmdj 闭目单脚
        case PPBodyParam_Bmdj:
        {
            float bmdjTime = bodyData.ppStandTime / 10.0;
            NSArray *standardArray ;
            
            if (bodyData.ppSex==PPUserGenderMale) {//男
                
                if (bodyData.ppAge <= 24) { // 0-24
                    if (bmdjTime <= 5.0) {
                        section = 1;
                    }else if (bmdjTime <= 17.0){
                        section = 2;
                    }else if (bmdjTime <= 41.0){
                        section = 3;
                    }else if(bmdjTime <= 98.0){
                        section = 4;
                    }else{
                        section = 5;
                    }
                    
                    standardArray = @[@"0",@"5",@"17",@"41",@"98",@"212"];
                    
                }else if (bodyData.ppAge <= 29){ // 25-29
                    if (bmdjTime <= 5.0) {
                        section = 1;
                    }else if (bmdjTime <= 14.0){
                        section = 2;
                    }else if (bmdjTime <= 35.0){
                        section = 3;
                    }else if(bmdjTime <= 85.0){
                        section = 4;
                    }else{
                        section = 5;
                    }
                    
                    standardArray = @[@"0",@"5",@"14",@"35",@"85",@"185"];
                    
                }else if (bodyData.ppAge <= 34){ // 30-34
                    if (bmdjTime <= 4.0) {
                        section = 1;
                    }else if (bmdjTime <= 12.0){
                        section = 2;
                    }else if (bmdjTime <= 39.0){
                        section = 3;
                    }else if(bmdjTime <= 74.0){
                        section = 4;
                    }else{
                        section = 5;
                    }
                    
                    standardArray = @[@"0",@"4",@"12",@"39",@"74",@"144"];
                    
                }else if (bodyData.ppAge <= 39){ // 35-39
                    if (bmdjTime <= 3.0) {
                        section = 1;
                    }else if (bmdjTime <= 11.0){
                        section = 2;
                    }else if (bmdjTime <= 27.0){
                        section = 3;
                    }else if(bmdjTime <= 69.0){
                        section = 4;
                    }else{
                        section = 5;
                    }
                    
                    standardArray = @[@"0",@"3",@"11",@"27",@"69",@"153"];
                    
                }else if (bodyData.ppAge <= 44){ // 40-44
                    if (bmdjTime <= 3.0) {
                        section = 1;
                    }else if (bmdjTime <= 9.0){
                        section = 2;
                    }else if (bmdjTime <= 21.0){
                        section = 3;
                    }else if(bmdjTime <= 54.0){
                        section = 4;
                    }else{
                        section = 5;
                    }
                    
                    standardArray = @[@"0",@"3",@"9",@"21",@"54",@"120"];
                    
                }else if (bodyData.ppAge <= 49){ // 45-49
                    if (bmdjTime <= 3.0) {
                        section = 1;
                    }else if (bmdjTime <= 8.0){
                        section = 2;
                    }else if (bmdjTime <= 19.0){
                        section = 3;
                    }else if(bmdjTime <= 48.0){
                        section = 4;
                    }else{
                        section = 5;
                    }
                    
                    standardArray = @[@"0",@"3",@"8",@"19",@"48",@"106"];
                    
                }else if (bodyData.ppAge <= 54){ // 50-54
                    if (bmdjTime <= 4.0) {
                        section = 1;
                    }else if (bmdjTime <= 7.0){
                        section = 2;
                    }else if (bmdjTime <= 16.0){
                        section = 3;
                    }else if(bmdjTime <= 39.0){
                        section = 4;
                    }else{
                        section = 5;
                    }
                    
                    standardArray = @[@"0",@"4",@"7",@"16",@"39",@"85"];
                    
                }else { // >= 55
                    if (bmdjTime <= 2.0) {
                        section = 1;
                    }else if (bmdjTime <= 6.0){
                        section = 2;
                    }else if (bmdjTime <= 13.0){
                        section = 3;
                    }else if(bmdjTime <= 33.0){
                        section = 4;
                    }else{
                        section = 5;
                    }
                    
                    standardArray = @[@"0",@"2",@"6",@"13",@"33",@"73"];
                }
                
            }else{ //女
                
                if (bodyData.ppAge <= 24) { // 0-24
                    if (bmdjTime <= 5.0) {
                        section = 1;
                    }else if (bmdjTime <= 15.0){
                        section = 2;
                    }else if (bmdjTime <= 36.0){
                        section = 3;
                    }else if(bmdjTime <= 90.0){
                        section = 4;
                    }else{
                        section = 5;
                    }
                    
                    standardArray = @[@"0",@"5",@"15",@"36",@"90",@"206"];
                    
                }else if (bodyData.ppAge <= 29){ // 25-29
                    if (bmdjTime <= 5.0) {
                        section = 1;
                    }else if (bmdjTime <= 14.0){
                        section = 2;
                    }else if (bmdjTime <= 32.0){
                        section = 3;
                    }else if(bmdjTime <= 84.0){
                        section = 4;
                    }else{
                        section = 5;
                    }
                    
                    standardArray = @[@"0",@"5",@"14",@"32",@"84",@"188"];
                    
                }else if (bodyData.ppAge <= 34){ // 30-34
                    if (bmdjTime <= 4.0) {
                        section = 1;
                    }else if (bmdjTime <= 12.0){
                        section = 2;
                    }else if (bmdjTime <= 26.0){
                        section = 3;
                    }else if(bmdjTime <= 72.0){
                        section = 4;
                    }else{
                        section = 5;
                    }
                    
                    standardArray = @[@"0",@"4",@"12",@"26",@"72",@"164"];
                    
                }else if (bodyData.ppAge <= 39){ // 35-39
                    if (bmdjTime <= 3.0) {
                        section = 1;
                    }else if (bmdjTime <= 9.0){
                        section = 2;
                    }else if (bmdjTime <= 23.0){
                        section = 3;
                    }else if(bmdjTime <= 62.0){
                        section = 4;
                    }else{
                        section = 5;
                    }
                    
                    standardArray = @[@"0",@"3",@"9",@"23",@"62",@"140"];
                    
                }else if (bodyData.ppAge <= 44){ // 40-44
                    if (bmdjTime <= 3.0) {
                        section = 1;
                    }else if (bmdjTime <= 7.0){
                        section = 2;
                    }else if (bmdjTime <= 18.0){
                        section = 3;
                    }else if(bmdjTime <= 45.0){
                        section = 4;
                    }else{
                        section = 5;
                    }
                    
                    standardArray = @[@"0",@"3",@"7",@"18",@"45",@"99"];
                    
                }else if (bodyData.ppAge <= 49){ // 45-49
                    if (bmdjTime <= 2.0) {
                        section = 1;
                    }else if (bmdjTime <= 6.0){
                        section = 2;
                    }else if (bmdjTime <= 15.0){
                        section = 3;
                    }else if(bmdjTime <= 39.0){
                        section = 4;
                    }else{
                        section = 5;
                    }
                    
                    standardArray = @[@"0",@"2",@"6",@"15",@"39",@"87"];
                    
                }else if (bodyData.ppAge <= 54){ // 50-54
                    if (bmdjTime <= 2.0) {
                        section = 1;
                    }else if (bmdjTime <= 6.0){
                        section = 2;
                    }else if (bmdjTime <= 13.0){
                        section = 3;
                    }else if(bmdjTime <= 33.0){
                        section = 4;
                    }else{
                        section = 5;
                    }
                    
                    standardArray = @[@"0",@"2",@"6",@"13",@"33",@"73"];
                    
                }else { // >= 55
                    if (bmdjTime <= 2.0) {
                        section = 1;
                    }else if (bmdjTime <= 5.0){
                        section = 2;
                    }else if (bmdjTime <= 10.0){
                        section = 3;
                    }else if(bmdjTime <= 26.0){
                        section = 4;
                    }else{
                        section = 5;
                    }
                    
                    standardArray = @[@"0",@"2",@"5",@"10",@"26",@"58"];
                }
    
            }
         
            NSInteger currentStandard = section-1;
            BOOL isHappyFace = NO;
            if (section==4 || section==5){
                isHappyFace = YES;
            }
            if (handle) {
                handle(standardArray,currentStandard,isHappyFace);
            }
            
        }
            break;
#pragma mark -- heartRate
        case PPBodyParam_heart:
        {
            int value = bodyData.ppHeartRate;
            
            if (value<40) {
                section=1;
            }
            else if (value>=40 && value<60) {
                section=2;
            }
            else if(value>=60 && value<100){
                section=3;
            }
            else if(value>=100 && value<160){
                section=4;
            }
            else{
                section=5;
            }
            NSArray *standardArray = @[@"0.0",@"40",@"60",@"100",@"160",@"180"];
            NSInteger currentStandard = section-1;
            BOOL isHappyFace = NO;
            if (section == 3){
                isHappyFace = YES;
            }
            if (handle) {
                handle(standardArray,currentStandard,isHappyFace);
            }
        }
            break;
        default:
            break;
    }
}


+(void)getBodyTextInfoWithBodyParam:(PPBodyParam)bodyParam currentStandard:(NSInteger)currentStandard handle:(void(^)(NSString *indexName,NSString *suggestion,NSString *introduction, NSString *standStr,NSArray *stands,NSString *evaluation,UIColor *standColor,NSArray *colors))handle{
    //建议数组
    NSArray *suggestionArray;
    //评价数组
    NSArray *evaluationArray;
    //标准段名称
    NSArray *standardArray;
    //简介、介绍
    NSString *introductionString;
    //参数名称，BMI、内脏脂肪……
    NSString *bodyParamNameString;
    //评价标准的指示颜色数组
    NSArray *colorArray;
    switch (bodyParam) {
#pragma mark -- heart
        case PPBodyParam_heart:
        {
            suggestionArray = @[@"heart_leve1_suggestion",@"heart_leve2_suggestion",@"heart_leve3_suggestion",@"heart_leve4_suggestion",@"heart_leve5_suggestion"];
            evaluationArray = @[@"heart_leve1_evaluation",@"heart_leve2_evaluation",@"heart_leve3_evaluation",@"heart_leve4_evaluation",@"heart_leve5_evaluation"];
            standardArray = @[@"heart_leve1_name",@"heart_leve4_name",@"heart_leve3_name",@"heart_leve5_name",@"heart_leve2_name"];
            introductionString = @"heart_introduction";
            bodyParamNameString = @"heart_name";
            colorArray = @[KpureRedColor,KblueColor,KlightGreenColor,KyellowColor,KlightRedColor];
        }
            break;
#pragma mark -- BMI
        case PPBodyParam_BMI:
        {
            suggestionArray = @[@"BMI_leve1_suggestion",@"BMI_leve2_suggestion",@"BMI_leve3_suggestion",@"BMI_leve4_suggestion"];
            evaluationArray = @[@"BMI_leve1_evaluation",@"BMI_leve2_evaluation",@"BMI_leve3_evaluation",@"BMI_leve4_evaluation"];
            standardArray = @[@"BMI_leve1_name",@"BMI_leve2_name",@"BMI_leve3_name",@"BMI_leve4_name"];
            introductionString = @"BMI_introduction";
            bodyParamNameString = @"BMI_name";
            colorArray = @[KblueColor,KlightGreenColor,KyellowColor,KlightRedColor];
        }
            break;
#pragma mark -- Weight 体重
        case PPBodyParam_Weight:
        {
            suggestionArray = @[@"Weight_leve1_suggestion",@"Weight_leve2_suggestion",@"Weight_leve3_suggestion"];
            evaluationArray = @[@"Weight_leve1_evaluation",@"Weight_leve2_evaluation",@"Weight_leve3_evaluation"];
            standardArray = @[@"Weight_leve1_name",@"Weight_leve2_name",@"Weight_leve3_name"];
            introductionString = @"Weight_introduction";
            bodyParamNameString = @"Weight_name";
            colorArray = @[KblueColor,KlightGreenColor,KyellowColor];
        }
            break;
#pragma mark -- BodyFat 脂肪
        case PPBodyParam_BodyFat:
        {
            suggestionArray = @[@"Bodyfat_leve1_suggestion",@"Bodyfat_leve2_suggestion",@"Bodyfat_leve3_suggestion",@"Bodyfat_leve4_suggestion"];
            evaluationArray = @[@"Bodyfat_leve1_evaluation",@"Bodyfat_leve2_evaluation",@"Bodyfat_leve3_evaluation",@"Bodyfat_leve4_evaluation"];
            standardArray = @[@"Bodyfat_leve1_name",@"Bodyfat_leve2_name",@"Bodyfat_leve3_name",@"Bodyfat_leve4_name"];
            introductionString = @"Bodyfat_introduction";
            bodyParamNameString = @"Bodyfat_name";
            colorArray = @[KblueColor,KlightGreenColor,KyellowColor,KlightRedColor];
        }
            break;
#pragma mark -- Bone 骨量
        case PPBodyParam_Bone:
        {
            suggestionArray = @[@"bone_leve1_suggestion",@"bone_leve2_suggestion",@"bone_leve3_suggestion"];
            evaluationArray = @[@"bone_leve1_evaluation",@"bone_leve2_evaluation",@"bone_leve3_evaluation"];
            standardArray = @[@"bone_leve1_name",@"bone_leve2_name",@"bone_leve3_name"];
            introductionString = @"bone_introduction";
            bodyParamNameString = @"bone_name";
            colorArray = @[KblueColor,KlightGreenColor,KdeepGreenColor];
        }
            break;
#pragma mark -- VisFat 内脏脂肪
        case PPBodyParam_VisFat:
        {
            suggestionArray = @[@"visfat_leve1_suggestion",@"visfat_leve2_suggestion",@"visfat_leve3_suggestion"];
            evaluationArray = @[@"visfat_leve1_evaluation",@"visfat_leve2_evaluation",@"visfat_leve3_evaluation"];
            standardArray = @[@"visfat_leve1_name",@"visfat_leve2_name",@"visfat_leve3_name"];
            introductionString = @"visfat_introduction";
            bodyParamNameString = @"visfat_name";
            colorArray = @[KlightGreenColor,KyellowColor,KlightRedColor];
        }
            break;
#pragma mark -- BMR
        case PPBodyParam_BMR:
        {
            suggestionArray = @[@"BMR_leve1_suggestion",@"BMR_leve2_suggestion"];
            evaluationArray = @[@"BMR_leve1_evaluation",@"BMR_leve2_evaluation"];
            standardArray = @[@"BMR_leve1_name",@"BMR_leve2_name"];
            introductionString = @"BMR_introduction";
            bodyParamNameString = @"BMR_name";
            colorArray = @[KblueColor,KdeepGreenColor];
        }
            break;
#pragma mark -- Water 水分
        case PPBodyParam_Water:
        {
            suggestionArray = @[@"water_leve1_suggestion",@"water_leve2_suggestion",@"water_leve2_suggestion"];
            evaluationArray = @[@"water_leve1_evaluation",@"water_leve2_evaluation",@"water_leve2_evaluation"];
            standardArray = @[@"water_leve1_name",@"water_leve2_name",@"water_leve3_name"];
            introductionString = @"water_introduction";
            bodyParamNameString = @"water_name";
            colorArray = @[KblueColor,KlightGreenColor,KdeepGreenColor];
        }
            break;
#pragma mark -- Muscle 肌肉
        case PPBodyParam_Mus:
        {
            suggestionArray = @[@"mus_leve1_suggestion",@"mus_leve2_suggestion",@"mus_leve3_suggestion"];
            evaluationArray = @[@"mus_leve1_evaluation",@"mus_leve2_evaluation",@"mus_leve3_evaluation"];
            standardArray = @[@"mus_leve1_name",@"mus_leve2_name",@"mus_leve3_name"];
            introductionString = @"mus_introduction";
            bodyParamNameString = @"mus_name";
            colorArray = @[KblueColor,KlightGreenColor,KdeepGreenColor];
        }
            break;
#pragma mark -- ProteinPercentage 蛋白质
        case PPBodyParam_proteinPercentage:
        {
            suggestionArray = @[@"proteinPercentage_leve1_suggestion",@"proteinPercentage_leve2_suggestion",@"proteinPercentage_leve3_suggestion"];
            evaluationArray = @[@"proteinPercentage_leve1_evaluation",@"proteinPercentage_leve2_evaluation",@"proteinPercentage_leve3_evaluation"];
            standardArray = @[@"proteinPercentage_leve1_name",@"proteinPercentage_leve2_name",@"proteinPercentage_leve3_name"];
            introductionString = @"proteinPercentage_introduction";
            bodyParamNameString = @"proteinPercentage_name";
            colorArray = @[KblueColor,KlightGreenColor,KyellowColor];
        }
            break;
#pragma mark -- FatGrade 肥胖等级
        case PPBodyParam_FatGrade:
        {
            suggestionArray = @[@"FatGrade_leve1_suggestion",@"FatGrade_leve2_suggestion",@"FatGrade_leve3_suggestion",@"FatGrade_leve4_suggestion",@"FatGrade_leve5_suggestion",@"FatGrade_leve6_suggestion"];
            evaluationArray = @[@"FatGrade_leve1_evaluation",@"FatGrade_leve2_evaluation",@"FatGrade_leve3_evaluation",@"FatGrade_leve4_evaluation",@"FatGrade_leve5_evaluation",@"FatGrade_leve6_evaluation"];
            standardArray = @[@"FatGrade_leve1_name",@"FatGrade_leve2_name",@"FatGrade_leve3_name",@"FatGrade_leve4_name",@"FatGrade_leve5_name",@"FatGrade_leve6_name"];
            introductionString = @"FatGrade_introduction";
            bodyParamNameString = @"FatGrade_name";
            colorArray = @[KblueColor,KlightGreenColor,KyellowColor,KlightRedColor,KmiddleRedColor,KpureRedColor];
        }
            break;
#pragma mark -- BodySubcutaneousFat 皮下脂肪
        case PPBodyParam_BodySubcutaneousFat:
        {
            suggestionArray = @[@"BodySubcutaneousFat_leve1_suggestion",@"BodySubcutaneousFat_leve2_suggestion",@"BodySubcutaneousFat_leve3_suggestion",@"BodySubcutaneousFat_leve4_suggestion"];
            evaluationArray = @[@"BodySubcutaneousFat_leve1_evaluation",@"BodySubcutaneousFat_leve2_evaluation",@"BodySubcutaneousFat_leve3_evaluation",@"BodySubcutaneousFat_leve4_evaluation"];
            standardArray = @[@"BodySubcutaneousFat_leve1_name",@"BodySubcutaneousFat_leve2_name",@"BodySubcutaneousFat_leve3_name",@"BodySubcutaneousFat_leve4_name"];
            introductionString = @"BodySubcutaneousFat_introduction";
            bodyParamNameString = @"BodySubcutaneousFat_name";
            colorArray = @[KblueColor,KlightGreenColor,KyellowColor,KlightRedColor];
        }
            break;
#pragma mark -- BodyLBW 去脂体重
        case PPBodyParam_BodyLBW:
        {
            suggestionArray = @[@"BodyLBW_leve1_suggestion",@"BodyLBW_leve2_suggestion",@"BodyLBW_leve3_suggestion"];
            evaluationArray = @[@"BodyLBW_leve1_evaluation",@"BodyLBW_leve2_evaluation",@"BodyLBW_leve3_evaluation"];
            standardArray = @[@"BodyLBW_leve1_name",@"BodyLBW_leve2_name",@"BodyLBW_leve3_name"];
            introductionString = @"BodyLBW_introduction";
            bodyParamNameString = @"BodyLBW_name";
        }
            break;
#pragma mark -- BodyScore 身体得分
        case PPBodyParam_BodyScore:
        {
            suggestionArray = @[@"BodyScore_leve1_suggestion",@"BodyScore_leve2_suggestion",@"BodyScore_leve3_suggestion",@"BodyScore_leve4_suggestion"];
            evaluationArray = @[@"BodyScore_leve1_evaluation",@"BodyScore_leve2_evaluation",@"BodyScore_leve3_evaluation",@"BodyScore_leve4_evaluation"];
            standardArray = @[@"BodyScore_leve1_name",@"BodyScore_leve2_name",@"BodyScore_leve3_name",@"BodyScore_leve4_name"];
            introductionString = @"BodyScore_introduction";
            bodyParamNameString = @"BodyScore_name";
            colorArray = @[KlightRedColor,KyellowColor,KlightGreenColor,KdeepGreenColor];
        }
            break;
#pragma mark -- physicalAgeValue 身体年龄
        case PPBodyParam_physicalAgeValue:
        {
            suggestionArray = @[@"physicalAgeValue_leve1_suggestion",@"physicalAgeValue_leve2_suggestion"];
            evaluationArray = @[@"physicalAgeValue_leve1_evaluation",@"physicalAgeValue_leve2_evaluation"];
            standardArray = @[@"physicalAgeValue_leve1_name",@"physicalAgeValue_leve2_name"];
            introductionString = @"physicalAgeValue_introduction";
            bodyParamNameString = @"physicalAgeValue_name";
            colorArray = @[KlightGreenColor,KyellowColor];
        }
            break;
#pragma mark -- BodyType 身体类型
        case PPBodyParam_BodyType:
        {
            suggestionArray = @[@"BodyType_leve1_suggestion",@"BodyType_leve2_suggestion",@"BodyType_leve3_suggestion",@"BodyType_leve4_suggestion",@"BodyType_leve5_suggestion",@"BodyType_leve6_suggestion",@"BodyType_leve7_suggestion",@"BodyType_leve8_suggestion",@"BodyType_leve9_suggestion"];
            evaluationArray = @[@"BodyType_leve1_evaluation",@"BodyType_leve2_evaluation",@"BodyType_leve3_evaluation",@"BodyType_leve4_evaluation",@"BodyType_leve5_evaluation",@"BodyType_leve6_evaluation",@"BodyType_leve7_evaluation",@"BodyType_leve8_evaluation",@"BodyType_leve9_evaluation"];
            standardArray = @[@"BodyType_leve1_name",@"BodyType_leve2_name",@"BodyType_leve3_name",@"BodyType_leve4_name",@"BodyType_leve5_name",@"BodyType_leve6_name",@"BodyType_leve7_name",@"BodyType_leve8_name",@"BodyType_leve9_name"];
            introductionString = @"BodyType_introduction";
            bodyParamNameString = @"BodyType_name";
        }
            break;
#pragma mark -- Bodystandard 标准体重
        case PPBodyParam_Bodystandard:
        {
            suggestionArray = @[@"Bodystandard_leve1_suggestion",@"Bodystandard_leve2_suggestion",@"Bodystandard_leve3_suggestion"];
            evaluationArray = @[@"Bodystandard_leve1_evaluation",@"Bodystandard_leve2_suggestion",@"Bodystandard_leve3_suggestion"];
            standardArray = @[@"Bodystandard_leve1_name",@"Bodystandard_leve2_name",@"Bodystandard_leve3_name"];
            introductionString = @"Bodystandard_introduction";
            bodyParamNameString = @"Bodystandard_name";
        }
            break;
#pragma mark -- Bmdj 闭目单脚
        case PPBodyParam_Bmdj:
        {
            suggestionArray = @[@"Bmdj_leve1_suggestion",@"Bmdj_leve2_suggestion",@"Bmdj_leve3_suggestion",@"Bmdj_leve4_suggestion",@"Bmdj_leve5_suggestion"];
            evaluationArray = @[@"Bmdj_leve1_evaluation",@"Bmdj_leve2_evaluation",@"Bmdj_leve3_evaluation",@"Bmdj_leve4_evaluation",@"Bmdj_leve5_evaluation"];
            standardArray = @[@"verybad",@"bad",@"soso",@"good",@"verygood"];
            introductionString = @"Bmdj_introduction";
            bodyParamNameString = @"Bmdj_name";
            colorArray = @[KBmdjRedColor,KBmdjOrangeColor,KBmdjYellowColor,KBmdjGreenColor,KBmdjDeepGreenColor];
        }
            break;
        default:
            break;
    }
    
    NSString *suggestionStr;
    if (suggestionArray == nil) {
        suggestionStr = @"";
    }else if (currentStandard < suggestionArray.count ) {
        suggestionStr = NSLocalizedString(suggestionArray[currentStandard], nil) ;
    }
    
    NSString *evaluationStr;
    if (evaluationArray == nil) {
        evaluationStr = @"";
    }else if (currentStandard < evaluationArray.count) {
        evaluationStr = NSLocalizedString(evaluationArray[currentStandard], nil) ;
    }
    
    NSString *standardStr;
    if (standardArray == nil) {
        standardStr = @"";
    }else if (currentStandard < standardArray.count) {
        
        standardStr = NSLocalizedString(standardArray[currentStandard],nil);
        
    }
    
    if (introductionString&&introductionString.length>0) {
        introductionString = NSLocalizedString(introductionString,nil);
    }else{
        introductionString = @"";
    }
    
    if (bodyParamNameString&&bodyParamNameString.length>0) {
        bodyParamNameString = NSLocalizedString(bodyParamNameString,nil);
    }else{
        bodyParamNameString = @"";
    }
    
    UIColor *standardColor;
    if (colorArray == nil) {
        standardColor = [UIColor whiteColor];
    }else if(currentStandard < colorArray.count){
        standardColor = [PPBodyMeasureDetailModel colorWithHexString:colorArray[currentStandard]];
    }
    
    NSMutableArray *realStandards = [[NSMutableArray alloc] init];
    if (standardArray) {
        for (NSString *standard in standardArray) {
            [realStandards addObject:NSLocalizedString(standard,nil)];
        }
    }else{
        realStandards = nil;
    }
    
    if (handle) {
        handle(bodyParamNameString,suggestionStr,introductionString,standardStr,realStandards,evaluationStr,standardColor,colorArray);
    }
    
    
}

+ (NSString *)weightStrWithKg:(CGFloat)weightKG{
    return [NSString stringWithFormat:@"%.1f",weightKG];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor whiteColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor whiteColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
@end
