//
//  FMBill.m
//  design
//
//  Created by PeyetZhao on 2022/3/14.
//

#import "FMBill.h"

@implementation FMBill

#pragma mark - Bill数据模型的默认设置
+ (NSArray<NSString *> *)ignoredProperties {
    return @[@"day", @"month", @"year", @"price", @"mark"];
}

+ (NSString *)primaryKey {
    return kBillPrimaryKey;
}

+ (NSArray<NSString *> *)requiredProperties {
    return @[kBillAmount, kBillDate];
}

+ (NSArray<NSString *> *)indexedProperties {
    return @[kBillDate];
}

#pragma mark - public method
///// 分配categoryID
//- (void)assignAnIdentifier {
//    self.billID = [self ret64bitString];
//}
/// 修改账单类别
/// @param category 账单类别
- (void)updateCategory:(FMCategory *)category {
    @autoreleasepool {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            self.category = category;
        }];
    }
}

/// 修改账单金额
/// @param amount 账单金额
- (void)updateAmount:(NSNumber<RLMDouble> *)amount {
    @autoreleasepool {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            self.amount = amount;
        }];
    }
}

/// 修改账单备注
/// @param remakrs 账单备注
- (void)updateRemarks:(NSString *)remakrs {
    @autoreleasepool {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            self.remarks = remakrs;
        }];
    }
}

/// 修改账单图片
/// @param remarkImage 账单图片
- (void)updateRemarkImage:(NSString *)remarkImage {
    @autoreleasepool {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            self.remarkImage = remarkImage;
        }];
    }
}

/// 修改账单时间
/// @param date 账单时间
- (void)updateDate:(NSDate *)date {
    @autoreleasepool {
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm transactionWithBlock:^{
            self.date = date;
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

- (NSString *)billID {
    if (!_billID) {
        _billID = [self ret64bitString];
    }
    return _billID;
}

@end
