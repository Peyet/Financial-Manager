//
//  FMDatabaseManager.m
//  design
//
//  Created by PeyetZhao on 2022/3/17.
//


//6.RLMResults与线程问题，在主线程查出来的数据，如果在其他线程被访问是不允许的，运行时会报错。


#import "FMDatabaseManager.h"

@interface FMDatabaseManager()

@property (nonatomic, strong) RLMRealm *realm;

@end

@implementation FMDatabaseManager

/// 单例
+ (instancetype)defaultManager {
    static FMDatabaseManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FMDatabaseManager alloc] init];
        [manager readCategoryFromPlistSaveToDB];
//        [manager readCategoryFromPlistSaveToDB];
//        [manager readAddCategoryFromPlistSaveToDB];
//        [manager setupDefaultBooks];
    });
    return manager;
}

#pragma mark - Bill

- (BOOL)insertWithBill:(FMBill *)bill {
    if (!(bill.amount.doubleValue >= 0.0) || !bill.date || !bill.category) return NO;
    
    __weak typeof(self) weakSelf = self;
    @autoreleasepool {
        [self.realm transactionWithBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.realm addOrUpdateObject:bill];
        }];
    }
    return YES;
}

- (BOOL)deleteWithBill:(FMBill *)bill {
    if (bill.billID.length<=0) return NO;
    
    __weak typeof(self) weakSelf = self;
    @autoreleasepool {
        [self.realm transactionWithBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.realm deleteObject:bill];
        }];
    }
    return YES;
}

- (RLMResults *)queryAllBills {
    return [FMBill allObjects];
}

- (RLMResults *)queryBillsWithPaymentType:(PaymentType)paymentType {
    return [[FMBill objectsWhere:@"category.isIncome = %li" ,paymentType] sortedResultsUsingKeyPath:@"date" ascending:NO];
}

- (RLMResults *)queryBillsWithRemark:(NSString *)remark {
    return [FMBill objectsWhere:@"remarks CONTAINS %@" ,remark];
}

- (RLMResults *)queryBillsWithDay:(NSDate *)day {
    NSDate *nextDay = [[NSDate alloc] initWithTimeInterval:24*60*60 sinceDate:day];
//    NSLog(@"day:%@, nextDay:%@, results:%@", day, nextDay, [FMBill objectsWhere:@"date > %@ AND date < %@", day, nextDay]);
    return [FMBill objectsWhere:@"date > %@ AND date < %@", day, nextDay];
    
}

- (RLMResults *)queryBillsWithDay:(NSDate *)day andPaymentType:(PaymentType)paymentType{
    NSDate *nextDay = [[NSDate alloc] initWithTimeInterval:24*60*60 sinceDate:day];
//    NSLog(@"day:%@, nextDay:%@, results:%@", day, nextDay, [FMBill objectsWhere:@"date > %@ AND date < %@", day, nextDay]);
    RLMResults *results = [self queryBillsWithPaymentType:paymentType];
    return [results objectsWhere:@"date > %@ AND date < %@", day, nextDay];
}


- (RLMResults *)queryBillsWithMonth:(NSDate *)month {
    NSDate *beginDay = [month begindayOfMonth];
    NSDate *lastDay = [month lastdayOfMonth];
    return [FMBill objectsWhere:@"date > %@ AND date < %@", beginDay, lastDay];
}

- (RLMResults *)queryBillsWithCategoryTitle:(NSString *)categoryTitle inMonth:(NSDate *)month {
    return [[self queryBillsWithMonth:month] objectsWhere:@"category.categoryTitle = %@", categoryTitle];
}

#pragma mark - Budget
- (BOOL)insertWithBudget:(FMBudget *)budget {
    if (!budget.category || !(budget.amount.doubleValue >= 0.0) || !budget.date) return NO;
    __weak typeof(self) weakSelf = self;
    @autoreleasepool {
        [self.realm transactionWithBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.realm addOrUpdateObject:budget];
        }];
    }
    return YES;
}

- (BOOL)deleteWithBudget:(FMBudget *)budget {
    __weak typeof(self) weakSelf = self;
    @autoreleasepool {
        [self.realm transactionWithBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.realm deleteObject:budget];
        }];
    }
    return YES;
}

- (RLMResults *)queryAllBudgets {
    return [[FMBudget allObjects] sortedResultsUsingKeyPath:@"date" ascending:NO];
}

- (RLMResults *)queryBudgetsForMonth:(NSDate *)month {
    NSDate *beginDay = [month begindayOfMonth] ;
    NSDate *lastDay = [month lastdayOfMonth] ;
//    RLMResults *results = [FMCategory allObjects];
//    FMCategory *cate = [FMCategory new];cate.
    return [FMBudget objectsWhere:@"date > %@ AND date < %@", beginDay, lastDay];
//    [[FMCategory new] objectsWhere:@"budget.date > %@ AND budget.date < %@", beginDay, lastDay];
//    return [FMCategory objectsWhere:@"budget.date > %@ AND budget.date < %@", beginDay, lastDay];
}

- (RLMResults *)queryBudgetsWithPaymentType:(PaymentType)paymentType {
    return [FMBudget objectsWhere:@"isIncome = %i",paymentType];
}

- (BOOL)queryWhetherBudgetExistWithBudget:(FMBudget *)budget {
    if ([FMBudget objectsWhere:@"category.categoryID = %@", budget.category.categoryID]) {
        return YES;
    }
    return NO;
}


#pragma mark - Category
- (BOOL)insertWithCategory:(FMCategory *)category {
    if (!(category.categoryTitle.length > 0) || !(category.isIncome.stringValue.length > 0)) return NO;
    __weak typeof(self) weakSelf = self;
    @autoreleasepool {
        [self.realm transactionWithBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.realm addOrUpdateObject:category];
        }];
    }
    return YES;
}

- (BOOL)deleteWithCategory:(FMCategory *)category {
    __weak typeof(self) weakSelf = self;
    @autoreleasepool {
        [self.realm transactionWithBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.realm deleteObject:category];
        }];
    }
    return YES;
}

- (NSArray<FMCategory *> *)queryCategoryWithCategoryTitle:(NSString *)categoryTitle {
    return [self convertToArrayWithRLMResults:[FMCategory objectsWhere:@"categoryTitle = %@", categoryTitle]];
}

- (NSArray<FMCategory *> *)queryAllCategories {
    return [self convertToArrayWithRLMResults:[FMCategory allObjects]];
}


// used
- (RLMResults<FMCategory *> *)queryCategoriesWithPaymentType:(PaymentType)paymentType {
    return [FMCategory objectsWhere:@"isIncome = %i",paymentType];
}

- (float)queryTotleAmountWithCategory:(FMCategory *)category inMonth:(NSDate *)month{
    NSDate *beginDay = [month begindayOfMonth] ;
    NSDate *lastDay = [month lastdayOfMonth] ;
    float totalAmount = 0;
    for (FMBill *bill in [FMBill objectsWhere:@"category.categoryID = %@ AND date > %@ AND date < %@", category.categoryID, beginDay, lastDay]) {
        totalAmount += bill.amount.floatValue;
    }
    return totalAmount;
}


#pragma mark - private method
/// 生成64位随机字符串作为主键
- (NSString *)ret64bitString {
    char data[64];
    for (int x=0; x <64; data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:64 encoding:NSUTF8StringEncoding];
}

- (NSArray *)convertToArrayWithRLMResults:(RLMResults *)results{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:10];
    for (id object in results) {
        [mutableArray addObject:object];
    }
    return [mutableArray copy];
}

/** 当数据库类别为0时,从plist读取数据,保存到数据库 */
- (void)readCategoryFromPlistSaveToDB {
    if ([self queryAllCategories].count)return;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"defaultCategory" ofType:@"plist"];
    NSArray *dictArray = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *dict in dictArray) {
        FMCategory *category = [[FMCategory alloc] initWithDictionary:dict];
        [self insertWithCategory:category];
    }
}


#pragma mark - 懒加载
- (RLMRealm *)realm {
    if (!_realm) {
        _realm = [RLMRealm defaultRealm];
    }
    return _realm;
}

@end
