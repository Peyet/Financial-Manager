//
//  FMBudget.m
//  design
//
//  Created by PeyetZhao on 2022/3/14.
//

#import "FMBudget.h"

@implementation FMBudget

#pragma mark - Budget数据模型的默认设置
+ (NSString *)primaryKey {
    return kBudgetPrimaryKey;
}

+ (NSArray<NSString *> *)requiredProperties {
    return @[kBudgetAmount, kBudgetMonth];
}

#pragma mark - public method

/// 修改预算类别
/// @param category 预算类别
- (void)updateBudgetCategory:(FMCategory *)category {
    @autoreleasepool {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            self.category = category;
        }];
    }
}
/// 修改预算金额
/// @param amount 预算金额
- (void)updateBudgetAmount:(NSNumber<RLMDouble> *)amount {
    @autoreleasepool {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            self.amount = amount;
        }];
    }
}
/// 修改预算月份
/// @param month 预算月份
- (void)updateBudgetDate:(NSDate *)month {
    @autoreleasepool {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            self.date = month;
        }];
    }
}


#pragma mark - private method
/// 生成64位随机字符串作为主键
-(NSString *)ret64bitString {
    char data[64];
    for (int x=0; x <64; data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:64 encoding:NSUTF8StringEncoding];
}

- (NSString *)budgetID {
    if (!_budgetID) {
        _budgetID = [self ret64bitString];
    }
    return _budgetID;
}

@end
