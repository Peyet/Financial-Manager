//
//  FMDatabaseManager.h
//  design
//
//  Created by PeyetZhao on 2022/3/17.
//

#import <Foundation/Foundation.h>
#import "FMBill.h"
#import "FMBudget.h"
#import "FMCategory.h"

@interface FMDatabaseManager : NSObject

/// 单例
+ (instancetype)defaultManager;

#pragma mark - Bill
/// 新增一笔账单
/// @param bill 账单
- (BOOL)insertWithBill:(FMBill *)bill;

/// 删除一笔账单
/// @param bill 账单
- (BOOL)deleteWithBill:(FMBill *)bill;

/// 查询所有账单
- (RLMResults *)queryAllBills;

/// 查询账本的支出or收入
/// @param type 收支类别
- (RLMResults *)queryBillsWithPaymentType:(PaymentType)type;

- (RLMResults *)queryBillsWithRemark:(NSString *)remark;

- (RLMResults *)queryBillsWithDay:(NSDate *)day;

- (RLMResults *)queryBillsWithDay:(NSDate *)day andPaymentType:(PaymentType)paymentType;


- (RLMResults *)queryBillsWithMonth:(NSDate *)month;

- (RLMResults *)queryBillsWithCategoryTitle:(NSString *)categoryTitle inMonth:(NSDate *)month;

///// 查询账本某个类别的某年/某月所有数据
///// @param dateStr 时间 eg.@"2016-05-18"/@"ALL"
///// @param categotyTitle 类别标题
//- (RLMResults *)queryBillWithBeginSwithContains:(NSString *)dateStr andCategoryTitle:(NSString *)categotyTitle;

///// 查询账本某年/某月支出 or 收入 or 总 数据
///// @param dateStr 时间 eg.@"2016-05-18"/@"ALL"
///// @param categotyTitle income | expend | allPayment
//- (RLMResults *)queryBillWithBeginSwithContains:(NSString *)dateStr andCategoryTitle:(NSString *)categotyTitle;
#pragma mark - Budget
/// 新增一笔预算
/// @param budget 预算
- (BOOL)insertWithBudget:(FMBudget *)budget;

/// 删除一笔预算
/// @param budget 预算
- (BOOL)deleteWithBudget:(FMBudget *)budget;

/// 查询所有预算
- (RLMResults *)queryAllBudgets;

- (RLMResults *)queryBudgetsForMonth:(NSDate *)month;

- (BOOL)queryWhetherBudgetExistWithBudget:(FMBudget *)budget;




#pragma mark - Category
/// 新增一个类别
/// @param category 要新增的类别
- (BOOL)insertWithCategory:(FMCategory *)category;

/// 删除一个类别
/// @param category 要删除的类别
- (BOOL)deleteWithCategory:(FMCategory *)category;

/// 查询选中类别
/// @param categoryTitle 选中类别的标题
- (NSArray<FMCategory *> *)queryCategoryWithCategoryTitle:(NSString *)categoryTitle;


//- (NSArray<FMCategory *> *)queryCategoryWithCategoryTitle:(NSString *)categoryTitle;



/// 查询所有类别
- (RLMResults<FMCategory *> *)queryAllCategories;

/// 查询类别的收支
/// @param paymentType 收入或支出
- (RLMResults<FMCategory *> *)queryCategoriesWithPaymentType:(PaymentType)paymentType;

- (float)queryTotleAmountWithCategory:(FMCategory *)category inMonth:(NSDate *)month;


@end
