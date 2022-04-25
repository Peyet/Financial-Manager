//
//  FMKeyboard.h
//  design
//
//  Created by PeyetZhao on 2022/3/23.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMKeyboard : BaseView

- (void)createBtn;
- (void)show;
- (void)hide;

- (void)mathBtnClick:(UIButton *)btn;
- (void)pointBtnClick:(UIButton *)btn;
- (void)plusBtnClick:(UIButton *)btn;

- (void)lessBtnClick:(UIButton *)btn;
- (void)dateBtnClick:(UIButton *)btn;
- (void)deleteBtnClick:(UIButton *)btn;

- (void)calculationMath;
- (void)reloadCompleteButton;

@end

NS_ASSUME_NONNULL_END
