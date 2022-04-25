//
//  FMHomeHeaderView.m
//  design
//
//  Created by PeyetZhao on 2022/3/24.
//

#import "FMHomeHeaderView.h"

@interface FMHomeHeaderView()

@property (nonatomic, strong) UILabel *consumptionLabel;
@property (nonatomic, strong) UILabel *budgetLabel;

@property (nonatomic, assign) NSInteger consumption;
@property (nonatomic, assign) NSInteger budget;

@end

@implementation FMHomeHeaderView

+ (instancetype)homeHeader {
    FMHomeHeaderView *homeHeader = [[self alloc] init];
    [homeHeader calculateBudget];

    homeHeader.backgroundColor = UIColor.clearColor;
    
    homeHeader.consumptionLabel = [UILabel new];
    [homeHeader addSubview:homeHeader.consumptionLabel];
    homeHeader.consumptionLabel.textAlignment = NSTextAlignmentCenter;
    homeHeader.consumptionLabel.adjustsFontSizeToFitWidth = YES;
    homeHeader.consumptionLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:45];
    homeHeader.consumptionLabel.textColor = [UIColor colorWithHexString:@"04c1a7"];
    [homeHeader.consumptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(85);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(100);
    }];
    
    homeHeader.budgetLabel = [UILabel new];
    [homeHeader addSubview:homeHeader.budgetLabel];
    homeHeader.budgetLabel.textAlignment = NSTextAlignmentCenter;
    homeHeader.budgetLabel.adjustsFontSizeToFitWidth = YES;
    homeHeader.budgetLabel.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:45];
    homeHeader.budgetLabel.textColor = [UIColor colorWithHexString:@"1c4ca4"];
    [homeHeader.budgetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(120);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(100);
    }];
    return homeHeader;
}

- (void)calculateBudget {
    FMDatabaseManager *databaseManager = [FMDatabaseManager defaultManager];
    float totalBudget = 0.f;
    float cost = 0.f;
    for (FMBudget *budget in [databaseManager queryBudgetsForMonth:[NSDate date]]) {
        totalBudget += budget.amount.floatValue;
        for (FMBill *bill in [databaseManager queryBillsWithCategoryTitle:budget.category.categoryTitle inMonth:[NSDate date]]) {
            cost += bill.amount.floatValue;
        };
    }
    self.budget = (NSInteger)totalBudget;
    self.consumption = (NSInteger)cost;

}

- (void)reloadData {
    [self calculateBudget];
    self.consumptionLabel.text = [NSString stringWithFormat:@"%ld", self.consumption];
    self.budgetLabel.text = [NSString stringWithFormat:@"%ld", self.budget];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    CAShapeLayer* lineLayer = [CAShapeLayer layer];
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    lineLayer.strokeColor = [UIColor colorWithHexString:@"ebfaf7"].CGColor;
    lineLayer.lineWidth = 15.0f;
    [self.layer addSublayer:lineLayer];

    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineWidth =  15.0f;
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinRound;
    layer.strokeColor = [UIColor colorWithHexString:@"#04c1a7"].CGColor;
    [self.layer addSublayer:layer];
    
    // 创建路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(SCREEN_WIDTH/2, 150) radius:80 startAngle:- M_PI_2 endAngle:(- M_PI_2 + M_PI * 2  *(self.consumption * 1.0 / self.budget)) clockwise:YES];
    UIBezierPath* path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(SCREEN_WIDTH/2, 150) radius:80 startAngle:- M_PI_2 endAngle:M_PI_2 *3 clockwise:YES];

    // 关联layer和路径
    layer.path = path.CGPath;
    lineLayer.path = path2.CGPath;

    // 创建Animation
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0.0);
    animation.toValue = @(1.0);
    layer.autoreverses = NO;
    animation.duration = 1.5f;
    
    // 设置layer的animation
    [layer addAnimation:animation forKey:nil];
}


@end
