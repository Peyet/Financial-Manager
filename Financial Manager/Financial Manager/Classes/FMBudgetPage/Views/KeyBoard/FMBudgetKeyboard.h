/**
 * 键盘
 * @author 郑业强 2018-12-18 创建文件
 */

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - typedef
typedef void(^budgetMonitorBlock)(NSString *amount, NSDate *date, NSString  * _Nullable budgetID);

@interface FMBudgetKeyboard : BaseView

+ (instancetype)init;

- (void)show;
- (void)hide;

/// 监听完成按钮（账单更新）
- (void)monitoringCreateBudget:(budgetMonitorBlock)budgetMonitor;

- (void)setUpKeyBoardWithBudget:(FMBudget *)budget;


@end

NS_ASSUME_NONNULL_END
