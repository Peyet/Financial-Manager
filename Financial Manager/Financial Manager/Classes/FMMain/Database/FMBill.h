//
//  FMBill.h
//  design
//
//  Created by PeyetZhao on 2022/3/14.
//

#import "RLMObject.h"
#import <Realm/Realm.h>
@class FMCategory;

static NSString *const kBillPrimaryKey  = @"billID";
static NSString *const kBillCategory    = @"category";
static NSString *const kBillAmount      = @"amount";
static NSString *const kBillRemarks     = @"remarks";
static NSString *const kBillRemarkImage = @"remarkImage";
static NSString *const kBillDate        = @"date";
static NSString *const kBillIncome      = @"isIncome";

@interface FMBill : RLMObject
/// 账单主键
@property NSString *billID;
/// 消费类别
@property FMCategory *category;
/// 消费金额
@property NSNumber<RLMDouble> *amount;
/// 消费备注
@property NSString *remarks;
/// 备注图片
@property NSString *remarkImage;
/// 消费日期
@property NSDate *date;

/// 修改账单类别
- (void)updateCategory:(FMCategory *)category;
/// 修改账单金额
- (void)updateAmount:(NSNumber<RLMDouble> *)amount;
/// 修改账单备注
- (void)updateRemarks:(NSString *)remakrs;
/// 修改账单图片
- (void)updateRemarkImage:(NSString *)remarkImage;
/// 修改账单时间
- (void)updateDate:(NSDate *)date;


@property NSInteger day;
@property NSInteger month;
@property NSInteger year;
@property CGFloat price;
@property NSString *mark;
@end

