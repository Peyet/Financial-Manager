//
//  FMBudget.h
//  design
//
//  Created by PeyetZhao on 2022/3/14.
//

#import "RLMObject.h"
#import <Realm/Realm.h>
@class FMCategory;

static NSString *const kBudgetPrimaryKey    = @"budgetID";
static NSString *const kBudgetCategory      = @"category";
static NSString *const kBudgetAmount        = @"amount";
static NSString *const kBudgetMonth         = @"month";


@interface FMBudget : RLMObject

/// 主键
@property (nonatomic) NSString *budgetID;
/// 消费类别
@property FMCategory *category;
/// 预算金额
@property NSNumber<RLMDouble> *amount;
/// 预算月份
@property NSDate *date;


/// 修改类别
- (void)updateBudgetCategory:(FMCategory *)title;
/// 修改预算金额
- (void)updateBudgetAmount:(NSNumber<RLMDouble> *)amount;
/// 修改预算月份
- (void)updateBudgetDate:(NSDate *)month;


@end
