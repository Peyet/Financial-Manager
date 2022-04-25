//
//  FMKeyboard.m
//  design
//
//  Created by PeyetZhao on 2022/3/23.
//

#import "FMKeyboard.h"
#import "FMDatePicker.h"


#define DATE_TAG 13         // 日期
#define PLUS_TAG 17         // 加
#define LESS_TAG 21         // 减
#define POINT_TAG 22        // 点
#define DELETE_TAG 24       // 删除
#define FINISH_TAG 25       // 完成
#define IS_MATH(tag) (tag >= 10 && tag <= 12) || (tag >= 14 && tag <= 16) || (tag >= 18 && tag <= 20) || tag == 23   // 是否是数字


@interface FMKeyboard()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UIView *textContent;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textConstraintH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyConstraintB;

@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, assign) BOOL isLess;          // 减
@property (nonatomic, assign) BOOL animation;       // 动画中

//@property (nonatomic, copy  ) budgetMonitorBlock budgetMonitor;
@property (nonatomic, strong) FMBudget *model;
@property (nonatomic, strong) NSMutableString *money;

@end


@implementation FMKeyboard

- (void)createBtn {
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[UIButton class]] && [obj tag] >= 10) {
            UIButton *btn = obj;
            [btn.titleLabel setFont:[UIFont systemFontOfSize:AdjustFont(14)]];
            // 背景色
            if (btn.tag == FINISH_TAG) {
                [btn setBackgroundImage:[UIColor createImageWithColor:kColor_Main_Color] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIColor createImageWithColor:kColor_Main_Dark_Color] forState:UIControlStateHighlighted];
            }
            else {
                [btn setBackgroundImage:[UIColor createImageWithColor:kColor_White] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIColor createImageWithColor:kColor_BG] forState:UIControlStateHighlighted];
            }
            
            // 数字
            if (IS_MATH(btn.tag)) {
                NSInteger math = [self getMath:btn.tag];
                [btn setTitle:[@(math) description] forState:UIControlStateNormal];
                [btn setTitle:[@(math) description] forState:UIControlStateHighlighted];
            }
            else if (btn.tag == POINT_TAG) {
                [btn setTitle:@"." forState:UIControlStateNormal];
                [btn setTitle:@"." forState:UIControlStateHighlighted];
            }
            else if (btn.tag == DATE_TAG) {
                [btn setTitle:@"今天" forState:UIControlStateNormal];
                [btn setTitle:@"今天" forState:UIControlStateHighlighted];
            }
            else if (btn.tag == PLUS_TAG) {
                [btn setTitle:@"+" forState:UIControlStateNormal];
                [btn setTitle:@"+" forState:UIControlStateHighlighted];
            }
            else if (btn.tag == LESS_TAG) {
                [btn setTitle:@"-" forState:UIControlStateNormal];
                [btn setTitle:@"-" forState:UIControlStateHighlighted];
            }
            else if (btn.tag == FINISH_TAG) {
                [btn setTitle:@"完成" forState:UIControlStateNormal];
                [btn setTitle:@"完成" forState:UIControlStateHighlighted];
            } if (btn.tag == DELETE_TAG) {
                [btn setTitle:@"删除" forState:UIControlStateNormal];
                [btn setTitle:@"删除" forState:UIControlStateHighlighted];
            }
            
            [btn setTitleColor:kColor_Text_Black forState:UIControlStateNormal];
            [btn setTitleColor:kColor_Text_Black forState:UIControlStateHighlighted];
            
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

#pragma mark - 动画
- (void)show {
    if (_animation == YES) {
        return;
    }
    _animation = YES;
    
    
    [self setHidden:NO];
    [UIView animateWithDuration:.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setTop:SCREEN_HEIGHT - self.height];
    } completion:^(BOOL finished) {
        [self setAnimation:NO];
    }];
}
- (void)hide {
    if (_animation == YES) {
        return;
    }
    _animation = YES;
    
    [self setHidden:NO];
    [UIView animateWithDuration:.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setTop:SCREEN_HEIGHT];
    } completion:^(BOOL finished) {
        [self setAnimation:NO];
    }];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 点击
// 刷新完成按钮
- (void)reloadCompleteButton {
    if (_money.length == 0) {
        UIButton *btn = [self viewWithTag:FINISH_TAG];
        [btn setTitle:@"完成" forState:UIControlStateNormal];
        [btn setTitle:@"完成" forState:UIControlStateHighlighted];
    } else {
        NSString *subMoney = [_money substringFromIndex:1];
        BOOL condition1 = ([subMoney containsString:@"+"] || [subMoney containsString:@"-"]) && ![_money hasSuffix:@"+"] && ![_money hasSuffix:@"-"];
        if (condition1) {
            UIButton *btn = [self viewWithTag:FINISH_TAG];
            [btn setTitle:@"=" forState:UIControlStateNormal];
            [btn setTitle:@"=" forState:UIControlStateHighlighted];
        } else {
            UIButton *btn = [self viewWithTag:FINISH_TAG];
            [btn setTitle:@"完成" forState:UIControlStateNormal];
            [btn setTitle:@"完成" forState:UIControlStateHighlighted];
        }
    }
}
// 数字
- (void)mathBtnClick:(UIButton *)btn {
    // 数字
    if (IS_MATH(btn.tag)) {
        
        NSInteger math = [self getMath:btn.tag];
        NSString *str = ({
            NSString *str;
            if ([_money componentsSeparatedByString:@"+"].count == 2) {
                str = [_money componentsSeparatedByString:@"+"][1];
            } else {
                str = _money;
            }
            str;
        });
        
        
        
        // 是否可以输入
        if ([self isAllowMath:str]) {
            if (_money.length == 0 || [_money isEqualToString:@"0"]) {
                _money = [NSMutableString stringWithString:[@(math) description]];
            } else {
                [_money appendString:[@(math) description]];
            }
            [self setMoney:_money];
        }
        
    }
}
// 点
- (void)pointBtnClick:(UIButton *)btn {
    // 点
    if (btn.tag == POINT_TAG) {
        // 是否可以输入
        if ([self isAllowPoint:_money]) {
            if (_money.length == 0) {
                [_money appendString:@"0"];
            }
            [_money appendString:@"."];
            [self setMoney:_money];
        }
    }
}
// 加
- (void)plusBtnClick:(UIButton *)btn {
    // 加
    if (btn.tag == PLUS_TAG) {
        if (_money.length == 0) {
            _money = [NSMutableString stringWithString:@"0"];
        }
        
        if ([self isAllowPlusOrLess:_money]) {
            [_money appendString:@"+"];
            [self setMoney:_money];
        }
    }
}
// 减
- (void)lessBtnClick:(UIButton *)btn {
    // 减
    if (btn.tag == LESS_TAG) {
        if (_money.length == 0) {
            _money = [NSMutableString stringWithString:@"0"];
        }
        
        if ([self isAllowPlusOrLess:_money]) {
            [_money appendString:@"-"];
            [self setMoney:_money];
        }
    }
}
// 时间
- (void)dateBtnClick:(UIButton *)btn {
    // 时间
    if (btn.tag == DATE_TAG) {
//        @weakify(self)
        __weak typeof(self) weakSelf = self;
        
        FMDatePicker *datePicker = [[FMDatePicker alloc] init];
        [self addSubview:datePicker];
        
        [datePicker showSelectDate:^(NSDate * _Nonnull date) {
            __strong typeof(weakSelf) strongSelf = weakSelf;

            [strongSelf setCurrentDate:date];

            NSString *selectValue = [date formatYMD];
            selectValue = [strongSelf.currentDate isToday] ? @"今天" : selectValue;
            [btn setTitle:selectValue forState:UIControlStateNormal];
            [btn setTitle:selectValue forState:UIControlStateHighlighted];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:AdjustFont(12)]];
        }];
        
    }
}
// 删除
- (void)deleteBtnClick:(UIButton *)btn {
    if (btn.tag == DELETE_TAG) {
        if (_money.length > 1) {
            [_money deleteCharactersInRange:NSMakeRange(_money.length - 1, 1)];
            [self setMoney:_money];
        } else {
            _money = [NSMutableString string];
            _moneyLab.text = @"0";
        }
    }
}
// 计算
- (void)calculationMath {
    if (_money.length == 0) {
        return;
    }
    
    
    BOOL condition1 = [_money hasSuffix:@"="];
    BOOL condition2 = [_money componentsSeparatedByString:@"+"].count == 3;
    BOOL condition3 = ([_money hasPrefix:@"-"] && [NSString getDuplicateSubStrCountInCompleteStr:_money withSubStr:@"-"] == 3) ||
                      (![_money hasPrefix:@"-"] && [NSString getDuplicateSubStrCountInCompleteStr:_money withSubStr:@"-"] == 2);
    BOOL condition4 = [_money containsString:@"+"] &&
                      (([_money hasPrefix:@"-"] && [NSString getDuplicateSubStrCountInCompleteStr:_money withSubStr:@"-"] == 2) ||
                       (![_money hasPrefix:@"-"] && [NSString getDuplicateSubStrCountInCompleteStr:_money withSubStr:@"-"] == 1));
    if (condition1 == true || condition2 == true || condition3 == true || condition4 == true) {
        NSMutableString *strm = [NSMutableString stringWithString:[NSString calcComplexFormulaString:_money]];
        // 没小数
        if (![self hasDecimal:strm]) {
            strm = [NSMutableString stringWithString:[strm componentsSeparatedByString:@"."][0]];
        }
        // 加
        if ([_money hasSuffix:@"+"]) {
            [strm appendString:@"+"];
        }
        // 减
        if ([_money hasSuffix:@"-"]) {
            [strm appendString:@"-"];
        }
//        // 没加减
//        if (![_money hasSuffix:@"+"] && ![_money hasSuffix:@"-"]) {
//            [self reloadCompleteButton];
//        }
        
        [self setMoney:strm];
    }
}


// 两数加减
- (NSString *)calculation:(NSString *)str1 math:(NSString *)str2 isPlus:(BOOL)isPlus {
    CGFloat number1 = [str1 floatValue];
    CGFloat number2 = [str2 floatValue];
    NSString *newNumber = [NSString stringWithFormat:@"%.2f", (isPlus ? number1 + number2 : number1 - number2)];
    if (![self hasDecimal:newNumber]) {
        newNumber = [newNumber substringWithRange:NSMakeRange(0, newNumber.length - 3)];
    }
    return newNumber;
}
// 是否有小数
- (BOOL)hasDecimal:(NSString *)number {
    NSArray<NSString *> *arr = [number componentsSeparatedByString:@"."];
    NSString *decimal = arr[1];
    if ([decimal integerValue] == 0) {
        return false;
    }
    return true;
}
// 获取字符串中的数字
- (NSArray<NSString *> *)getNumberWithString:(NSString *)string {
    // 第一个数是负数
    BOOL isNegative = [[string substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"-"];
    if (isNegative == true) {
        string = [string substringFromIndex:1];
    }
    
    NSString *lastStr = [string substringWithRange:NSMakeRange(string.length - 1, 1)];
    if ([lastStr isEqualToString:@"+"] || [lastStr isEqualToString:@"-"]) {
        string = [string substringToIndex:string.length - 1];
    }
    
    
    NSMutableArray *arrm;
    // 加法
    if ([string containsString:@"+"]) {
        arrm = [NSMutableArray arrayWithArray:[string componentsSeparatedByString:@"+"]];
    }
    // 减法
    else if ([string containsString:@"-"]) {
        arrm = [NSMutableArray arrayWithArray:[string componentsSeparatedByString:@"-"]];
    }
    // 第一个数是负数
    if (isNegative == true) {
        NSString *str = [NSString stringWithFormat:@"-%@", arrm[0]];
        [arrm replaceObjectAtIndex:0 withObject:str];
    }
    NSLog(@"%@", arrm);
    NSLog(@"123");
    return @[];
    
}

// 是否可以输入数字
- (BOOL)isAllowMath:(NSString *)str {
    // 超过10位
    if (_money.length >= 15) {
        return false;
    }
    
    
    if (!str || str.length == 0) {
        return true;
    }
    
    NSString *lastStr = [str substringFromIndex:str.length - 1];
    // 最后输入的是数字
    if ([lastStr isEqualToString:@"+"] || [lastStr isEqualToString:@"-"] || [lastStr isEqualToString:@"="]) {
        return true;
    }
    // 最后输入的是数字/点
    else {
        if ([str containsString:@"+"]) {
            str = [str componentsSeparatedByString:@"+"][1];
        } else if ([str containsString:@"-"]) {
            str = [str componentsSeparatedByString:@"-"][1];
        }
        NSArray<NSString *> *arr = [str componentsSeparatedByString:@"."];
        if (arr.count != 2 || (arr.count == 2 && arr[1].length < 2)) {
            return true;
        }
        return false;
    }
}
// 是否可以输入点
- (BOOL)isAllowPoint:(NSString *)str {
    // 超过10位
    if (_money.length >= 15) {
        return false;
    }
    
    
    // 是否可以输入
    for (int i=0; i<3; i++) {
        str = [str containsString:@"+"] ? [str componentsSeparatedByString:@"+"][1] : str;
        str = [str containsString:@"-"] ? [str componentsSeparatedByString:@"-"][1] : str;
    }
    if (![str containsString:@"."]) {
        return true;
    }
    return false;
}
// 是否可以输入加号减号
- (BOOL)isAllowPlusOrLess:(NSString *)str {
    NSString *lastStr = [str substringWithRange:NSMakeRange(_money.length - 1, 1)];
    if ([lastStr isEqualToString:@"+"] || [lastStr isEqualToString:@"-"]) {
        return false;
    }
    return true;
}
// 根据btn.tag 返回数字
- (CGFloat)getMath:(NSInteger)tag {
    if (tag >= 10 && tag <= 12) {
        return tag - 3;
    }
    else if (tag >= 14 && tag <= 16) {
        return tag - 10;
    }
    else if (tag >= 18 && tag <= 20) {
        return tag - 17;
    }
    else if (tag == 23) {
        return 0;
    }
    return 0;
}

@end
