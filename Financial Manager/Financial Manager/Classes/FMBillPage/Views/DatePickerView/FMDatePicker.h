//
//  FMDatePicker.h
//  design
//
//  Created by PeyetZhao on 2022/3/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^renewDateBlock)(NSDate *date);

@interface FMDatePicker : UIDatePicker

- (void)showSelectDate:(renewDateBlock)renewDate;
@end

NS_ASSUME_NONNULL_END
