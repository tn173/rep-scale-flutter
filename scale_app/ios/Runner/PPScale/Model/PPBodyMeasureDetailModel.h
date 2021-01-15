//
//  PPBodyMeasureDetailModel.h
//  PPBlueToothDemo
//
//  Created by 彭思远 on 2020/7/31.
//  Copyright © 2020 彭思远. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PPBodyFatModel.h"

typedef NS_ENUM(NSUInteger, PPBodyParam) {
    PPBodyParam_BMI       = 1,
    PPBodyParam_Weight    = 2,
    PPBodyParam_BodyFat   = 3,
    PPBodyParam_Bone      = 4,
    PPBodyParam_VisFat    = 5,
    PPBodyParam_BMR       = 6,
    PPBodyParam_Water     = 7,
    PPBodyParam_Mus       = 8,
    PPBodyParam_BodyAge   = 9,
    PPBodyParam_proteinPercentage = 10,
    PPBodyParam_FatGrade = 11,
    PPBodyParam_BodySubcutaneousFat = 12,
    PPBodyParam_BodyLBW = 13,
    PPBodyParam_BodyScore = 14,
    PPBodyParam_physicalAgeValue = 15,
    PPBodyParam_BodyType = 16,
    PPBodyParam_Bodystandard = 17,
    PPBodyParam_Bmdj = 18,
    PPBodyParam_heart = 19,
};
// 身体数据不同状态的颜色值
// 蓝色
#define KblueColor @"#4592f8"
// 浅绿
#define KlightGreenColor @"#48da7f"
// 深绿
#define KdeepGreenColor @"#1aa646"
// 黄色
#define KyellowColor @"#fece2f"
// 浅红
#define KlightRedColor @"#f55453"
// 中级红
#define KmiddleRedColor @"#ec3b30"
// 纯红
#define KpureRedColor @"#ff0000"


#define KBmdjRedColor @"#FF6170"
#define KBmdjOrangeColor @"#FF9F39"
#define KBmdjYellowColor @"#FFD200"
#define KBmdjGreenColor @"#7BDEA7"
#define KBmdjDeepGreenColor @"#48CA82"

NS_ASSUME_NONNULL_BEGIN

@interface PPBodyMeasureDetailModel : NSObject

@property (nonatomic,copy,readonly) NSString *indexName;      //身体指标名
@property (nonatomic,copy,readonly) NSString *standStr;      //标准评价(正常、偏高、偏低)
@property (nonatomic,copy,readonly) NSString *introduction;    //介绍当前指标的含义
@property (nonatomic,copy,readonly) NSString *suggestion;      //针对当前状况的建议
@property (nonatomic,copy,readonly) NSString *evaluation;      //当前情况的评价
@property (nonatomic,strong,readonly) NSArray *standardTitleArray;   //标准文字数组(正常、偏高、偏低)

@property (nonatomic,strong,readonly) NSArray *standardArray;        //标准分隔点数组
@property (nonatomic,assign,readonly) NSInteger currentStandard;     //当前属于哪个标准 从0开始
@property (nonatomic,assign,readonly) BOOL isHappyFace;              //笑脸还是哭脸

- (instancetype)initWithBodyParam:(PPBodyParam)bodyParam bodyData:(PPBodyFatModel *)bodyData;
@end

NS_ASSUME_NONNULL_END
