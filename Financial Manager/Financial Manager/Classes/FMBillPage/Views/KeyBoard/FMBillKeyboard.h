/**
 * 键盘
 * @author 郑业强 2018-12-18 创建文件
 */

#import "BaseView.h"
#import "FMBill.h"

NS_ASSUME_NONNULL_BEGIN


#pragma mark - typedef
typedef void(^billMonitorBlock)(NSString *amount, NSString *remark, NSDate *date, NSString  * _Nullable billID);

@interface FMBillKeyboard : BaseView

//@property (nonatomic, copy  ) budgetMonitorBlock complete;

+ (instancetype)init;

- (void)show;
- (void)hide;

/// 监听完成按钮（账单更新）
- (void)monitoringCreateBill:(billMonitorBlock)billMonitor;

- (void)setUpKeyBoardWithBill:(FMBill *)bill;

@end

NS_ASSUME_NONNULL_END
