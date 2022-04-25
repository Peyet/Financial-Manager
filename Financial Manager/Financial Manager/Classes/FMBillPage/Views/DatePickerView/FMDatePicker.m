//
//  FMDatePicker.m
//  design
//
//  Created by PeyetZhao on 2022/3/19.
//

#import "FMDatePicker.h"

@interface FMDatePicker()
@property (nonatomic, strong) renewDateBlock renewDateValue;
@end

@implementation FMDatePicker

- (instancetype)init {
    if(self = [super init]) {
//        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 65);
        self.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        self.datePickerMode = UIDatePickerModeDate;
        self.frame = CGRectMake(SCREEN_WIDTH - 100, 70, 100, 65);

        self.maximumDate = [NSDate date];
        [self addTarget:self action:@selector(dateChange) forControlEvents:UIControlEventValueChanged];
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

- (void)showSelectDate:(renewDateBlock)renewDate {
    self.renewDateValue = renewDate;
}

- (void)dateChange {
    [self removeFromSuperview];
    self.renewDateValue(self.date);
//    [self setDate:self.date animated:YES];
    self.date = self.date;
}


@end
