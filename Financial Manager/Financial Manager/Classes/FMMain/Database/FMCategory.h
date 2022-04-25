//
//  FMCategory.h
//  design
//
//  Created by PeyetZhao on 2022/3/14.
//

#import "RLMObject.h"
#import "FMBill.h"
#import "FMBudget.h"

static NSString *const kCATPrimaryKey    = @"categoryID";
static NSString *const kCATTitle         = @"categoryTitle";
static NSString *const kCATImage         = @"categoryImage";
static NSString *const kCATIncome        = @"isIncome";
static NSString *const kCATBill          = @"bills";
static NSString *const kCATBudget        = @"budget";

typedef enum : NSUInteger {
    expend,
    income,
} PaymentType;

@interface FMCategory : RLMObject

/// 类别ID 主键
@property NSString *categoryID;
/// 类别标题
@property NSString *categoryTitle;
/// 类别图片
@property NSString *categoryImage;
/// 收入or支出类别
@property NSNumber<RLMBool> *isIncome;
///// 类别下的账单
//@property (readonly) RLMLinkingObjects *bills;
///// 类别下的预算
//@property (readonly) RLMLinkingObjects *budget;


///// 分配categoryID
//- (void)assignAnIdentifier;

/// 初始化类别
/// @param dictionary 字典信息
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
/// 修改类别名称
- (void)updateTitle:(NSString *)title;
/// 修改类别图标
- (void)updateImage:(NSString *)image;
/// 修改类别收支
- (void)updateIncome:(NSNumber<RLMBool> *)isIncome;

///// 类别plist表
//+ (NSArray *)categoryList;
///// 修改类别标题
///// @param categoryTitle 要修改为的标题
//- (void)modifyCategoryTitle:(NSString *)categoryTitle;


@end


/*
 支出

 饮食
 cc_catering_chicken_l
 cc_catering_chicken_s

 娱乐
 cc_entertainmente_game_l
 cc_entertainmente_game_s

 cc_family_pet_home_l

 健身
 cc_fitness_bodybuilding_l
 cc_fitness_bodybuilding_s

 运动
 e_sport_l
 e_sport_s

 家庭
 cc_life_candlelight_l
 cc_life_candlelight_s

 医药
 e_medical_l
 e_medical_s

 通信
 cc_personal_phone_l
 cc_personal_phone_s

 送礼
 cc_shopping_flower_l
 cc_shopping_flower_s

 购物
 cc_shopping_shopping_trolley_l
 cc_shopping_shopping_trolley_s

 服饰
 cc_shopping_skirt_l
 cc_shopping_skirt_s

 宠物
 e_pet_l
 e_pet_s

 教育
 e_study_l
 e_study_s

 房租
 cc_study_school_l
 cc_study_school_s

 出行
 cc_traffic_car_l
 cc_traffic_car_s


 收入

 工资
 i_wage_l
 i_wage_s

 兼职
 i_parttimework_l
 i_parttimework_s

 股票
 i_finance_l
 i_finance_s

 其他
 i_other_l
 i_other_s


 红包
 cc_income_9_l
 cc_income_9_s

 */
