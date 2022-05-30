//
//  FMHomeViewCell.m
//  design
//
//  Created by PeyetZhao on 2022/3/15.
//

#import "FMHomeViewCell.h"
#import "AAChartKit.h"

@interface FMHomeViewCell ()<AAChartViewEventDelegate>

@property (nonatomic, strong) AAChartView *aaChartView;
@property (nonatomic, strong) AAChartModel *aaChartModel;

@property (nonatomic, strong) UILabel *suggestionLabel;

@property (nonatomic, strong) NSString *cellType;

@property (nonatomic, strong) RLMNotificationToken *billNotificationToken;
@property (nonatomic, strong) RLMNotificationToken *budgetNotificationToken;

@property (nonatomic, strong) FMDatabaseManager *databaseManager;

@end

@implementation FMHomeViewCell

- (instancetype)initWithCellType:(NSString *)cellType {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellType];
    if (self) {
        [self setUpCellWithType:cellType];
        [self addRealmNotification];
    }
    return self;
}



#pragma mark - Life cycle
/// 初始化cell
/// @param cellType  cell类型
- (void)setUpCellWithType:(NSString *)cellType {
    self.cellType = cellType;
    if ([cellType isEqualToString:@"消费建议"]) {
        [self setUpSuggestionView];
    } else{
        [self setUpChartView];
        if ([cellType isEqualToString:@"近期消费趋势"]) {
            [self configureRecentConsumptionModel];
        } else if ([cellType isEqualToString:@"本月消费趋势"]) {
            [self configureMonthlyConsumptionModel];
        } else if ([cellType isEqualToString:@"预算汇总"]) {
            [self configureTotalBudgetModel];
        } else if ([cellType isEqualToString:@"预算使用详情"]) {
            [self configureBudgetUsageModel];
        } else if ([cellType isEqualToString:@"消费偏好"]) {
            [self configureConsumerPreferenceModel];
        }
        [self drawChart];
//        self.backgroundColor = [UIColor colorWithHexString:@"b4c6ff"];
    }
    self.backgroundColor = UIColor.clearColor;
}

/// 刷新cell
- (void)reloadData {
    if ([self.cellType isEqualToString:@"消费建议"]) {
        [self updateSuggestionView];
    } else if ([self.cellType isEqualToString:@"近期消费趋势"]) {
        [self getRecentConsumptionModelSeries];
    } else if ([self.cellType isEqualToString:@"本月消费趋势"]) {
        [self getMonthlyConsumptionModelSeries];
    } else if ([self.cellType isEqualToString:@"预算汇总"]) {
        [self getTotalBudgetModelSeries];
    } else if ([self.cellType isEqualToString:@"预算使用详情"]) {
        [self getBudgetUsageModelSeries];
    } else if ([self.cellType isEqualToString:@"消费偏好"]) {
        [self getConsumerPreferenceModelSeries];
    }
}


#pragma mark - SuggestionView
- (void)setUpSuggestionView {
    UIView *suggestionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 40, 180)];
    suggestionView.backgroundColor = [UIColor colorWithHexString:@"8BE98C"];
    [self.contentView addSubview:suggestionView];
    suggestionView.layer.cornerRadius = 20;
    suggestionView.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    
    self.suggestionLabel = [UILabel new];
    [suggestionView addSubview:self.suggestionLabel];
    [self.suggestionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(30);
            make.center.mas_equalTo(0);
    }];
    self.suggestionLabel.textAlignment = NSTextAlignmentCenter;
    self.suggestionLabel.adjustsFontSizeToFitWidth = YES;
    
    [self updateSuggestionView];
}


#pragma mark - ChartView
///创建视图AAChartView
- (void)setUpChartView {
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH - 40, 280)];
    NSArray *colorArr = @[@"92a6fe",  @"efa2cb", @"ccccc0", @"8BE98C", @"ffafa3" ];
    ;
    backgroundView.backgroundColor = [UIColor colorWithHexString:colorArr[arc4random() % (colorArr.count - 1)]];
    backgroundView.layer.cornerRadius = 20;
    backgroundView.layer.masksToBounds = YES;
    [self.contentView addSubview:backgroundView];

    _aaChartView = [[AAChartView alloc]init];
    _aaChartView.frame = CGRectMake(0, 10, SCREEN_WIDTH - 40, 280);
    ////禁用 AAChartView 滚动效果(默认不禁用)
    self.aaChartView.scrollEnabled = NO;
    self.aaChartView.delegate = self;
    self.aaChartView.layer.cornerRadius = 20;
    self.aaChartView.layer.masksToBounds = YES;
    self.aaChartView.isClearBackgroundColor = YES;
    [backgroundView addSubview:_aaChartView];
}


- (void)configureRecentConsumptionModel {
    // 图表标题
    NSString *titleSet = @"近期消费";
    // 数据内容
    AAChartModel *aaChartModel= AAObject(AAChartModel)
    .chartTypeSet(AAChartTypeColumn)//设置图表的类型
    .titleSet(titleSet);//设置图表标题
    _aaChartModel = aaChartModel;
}


- (void)configureMonthlyConsumptionModel {
    // 图表标题
    NSString *titleSet = @"本月消费趋势";

    // 数据内容
    AAChartModel *aaChartModel= AAObject(AAChartModel)
    .markerRadiusSet(@1.0)//marker点半径为8个像素
    .chartTypeSet(AAChartTypeAreaspline)//设置图表的类型(这里以设置的为折线面积图为例)
    .titleSet(titleSet);//设置图表标题
    _aaChartModel = aaChartModel;
}


- (void)configureTotalBudgetModel {
    // 图表标题
    NSString *titleSet = @"预算汇总";
    // 数据内容
    AAChartModel *aaChartModel= AAObject(AAChartModel)
    .chartTypeSet(AAChartTypePie)//设置图表的类型(这里以设置的为折线面积图为例)
    .titleSet(titleSet);//设置图表标题
    _aaChartModel = aaChartModel;
}


- (void)configureBudgetUsageModel {
    // 图表标题
    NSString *titleSet = @"预算使用详情";
    // 数据内容
    _aaChartModel = AAChartModel.new
    .chartTypeSet(AAChartTypeColumn)
    .titleSet(titleSet)
    .yAxisGridLineStyleSet([AALineStyle styleWithWidth:@0])
    .markerRadiusSet(@0);

}


- (void)configureConsumerPreferenceModel {
    AAChartModel *aaChartModel = AAChartModel.new
    .chartTypeSet(AAChartTypeColumn)
    .borderRadiusSet(@5)
    .polarSet(true);
    _aaChartModel = aaChartModel;

}



/// 绘制图形(创建 AAChartView 实例对象后,首次绘制图形调用此方法)
- (void)drawChart {
    /*图表视图对象调用图表模型对象,绘制最终图形*/
    [_aaChartView aa_drawChartWithChartModel:_aaChartModel];
}


#pragma mark - Calculate
- (void)updateSuggestionView {
    FMDatabaseManager *databaseManager = [FMDatabaseManager defaultManager];
    float totalBudget = 0.f;
    float cost = 0.f;
    for (FMBudget *budget in [databaseManager queryBudgetsForMonth:[NSDate date]]) {
        totalBudget += budget.amount.floatValue;
        for (FMBill *bill in [databaseManager queryBillsWithCategoryTitle:budget.category.categoryTitle inMonth:[NSDate date]]) {
            cost += bill.amount.floatValue;
        };
    }
    NSString *reminder;
    if (totalBudget == 0) {
        reminder = @"您还没有设置预算哦😉";
    }
        else if (totalBudget - cost <= 0) {
        reminder = @"您设置的预算已经使用完了哦😱";
    } else if (cost / totalBudget > 0.9) {
        reminder = @"您设置的预算即将用完，坚持就是胜利✌️";
    } else {
        reminder = @"您的财务状况目前很优秀，继续保持🥳";
    }
    
    self.suggestionLabel.text = reminder;
}


- (void)getRecentConsumptionModelSeries {
    NSMutableArray *seriesSet = [NSMutableArray new];
    NSMutableArray *expenditure = [NSMutableArray new];
    NSMutableArray *income = [NSMutableArray new];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __strong typeof(self)  strongSelf = weakSelf;
        // 图表横轴的内容
        NSMutableArray *categoriesSet = [NSMutableArray new];
        [categoriesSet addObjectsFromArray:@[@"一", @"二", @"三", @"四", @"五", @"六", @"日"]];

        float expends = 0, incomes = 0;
        for (NSDate *day in [[NSDate date] currentWeekDaiesForDate]) {
            for (FMBill *bill in [self.databaseManager queryBillsWithDay:day]) {
                if (bill.category.isIncome) {
                    incomes += bill.amount.floatValue;
                } else {
                    expends += bill.amount.floatValue;
                }
            }
            [expenditure addObject:[NSNumber numberWithFloat:expends]];
            [income addObject:[NSNumber numberWithFloat:incomes]];
            expends = 0;
            incomes = 0;
        }
        [seriesSet addObject:(AAObject(AASeriesElement)
                              .borderRadiusTopLeftSet((id)@"20%")
                              .borderRadiusTopRightSet((id)@"20%")
                                .nameSet(@"支出")
                                .dataSet(expenditure))];
        [seriesSet addObject:(AAObject(AASeriesElement)
                              .borderRadiusTopLeftSet((id)@"20%")
                              .borderRadiusTopRightSet((id)@"20%")
                              .nameSet(@"收入")
                              .dataSet(income))];
        dispatch_async(dispatch_get_main_queue(), ^{
//            [strongSelf.aaChartView aa_onlyRefreshTheChartDataWithChartModelSeries:seriesSet];
            strongSelf.aaChartModel.categoriesSet(categoriesSet)
                .seriesSet(seriesSet);
            [strongSelf.aaChartView aa_refreshChartWithChartModel:strongSelf.aaChartModel];
        });
    });
}

- (void)getMonthlyConsumptionModelSeries {
    NSMutableArray *seriesSet = [NSMutableArray new];
    NSMutableArray *categoriesSet = [NSMutableArray new];
    NSDictionary *gradientColorDic1 =
    [AAGradientColor gradientColorWithDirection:AALinearGradientDirectionToBottom
                               startColorString:AARgbaColor(255, 20, 147, 1.0)//热情的粉红, alpha 透明度 1
                                 endColorString:AARgbaColor(255, 20, 147, 0.3)];//热情的粉红, alpha 透明度 0.3

    NSMutableArray *seriesArray = [NSMutableArray new];
    NSDate __block *beginDay = [[[NSDate date] getZeroToday] begindayOfMonth];
    NSDate *lastDay = [[[[NSDate date] getZeroToday] lastdayOfMonth] dateAfterDay:1];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __strong typeof(self)  strongSelf = weakSelf;
        float billAmount = 0.f;
        for (int day = 1; ![beginDay isSameDay:lastDay] ; beginDay = [beginDay dateAfterDay:1], day++) {
            for (FMBill *bill in [self.databaseManager queryBillsWithDay:beginDay andPaymentType:expend]) {
                billAmount += bill.amount.floatValue;
            }
            [seriesArray addObject:[NSNumber numberWithFloat:billAmount]];
            billAmount = 0.f;
            [categoriesSet addObject:[NSString stringWithFormat:@"%d", day]];
        }
        [seriesSet addObject:AASeriesElement.new.nameSet(@"当日消费")
                                 .lineWidthSet(@3.0)
                                 .colorSet(AARgbaColor(220, 20, 60, 1.0))//猩红色, alpha 透明度 1
                                 .fillColorSet((id)gradientColorDic1)
                               .allowPointSelectSet(false)//是否允许在点击数据点标记(扇形图点击选中的块发生位移)
                               .dataSet(seriesArray)];
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.aaChartModel.categoriesSet(categoriesSet)
                .seriesSet(seriesSet);
            [strongSelf.aaChartView aa_refreshChartWithChartModel:strongSelf.aaChartModel];
        });
    });
}

- (void)getTotalBudgetModelSeries {
    NSMutableArray *seriesSet = [NSMutableArray new];
    NSMutableArray *seriesArray = [NSMutableArray new];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __strong typeof(self)  strongSelf = weakSelf;
        for (FMBudget *budget in [self.databaseManager queryBudgetsForMonth:[NSDate date]]) {
            [seriesArray addObject:@[budget.category.categoryTitle.copy, budget.amount]];
        }
        [seriesSet addObject:AASeriesElement.new.nameSet(@"预算")
                                 .innerSizeSet(@"40%")//内部圆环半径大小占比
                                 .borderWidthSet(@0)//描边的宽度
                                 .allowPointSelectSet(false)//是否允许在点击数据点标记(扇形图点击选中的块发生位移)
             .dataSet(seriesArray)];

        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.aaChartModel.seriesSet(seriesSet);
            [strongSelf.aaChartView aa_refreshChartWithChartModel:strongSelf.aaChartModel];
        });

    });
}

- (void)getBudgetUsageModelSeries {
    NSMutableArray *categories = [NSMutableArray new];
    NSMutableArray *seriesArray = [NSMutableArray new];
    
//    return @[column1, column2];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __strong typeof(self)  strongSelf = weakSelf;
        for (FMBudget *budget in [self.databaseManager queryBudgetsForMonth:[NSDate date]]) {
            [categories addObject:budget.category.categoryTitle];
            [seriesArray addObject:budget.amount];
        }
        AAColumn *column1 = AAColumn.new
                            .nameSet(@"预算")
                            .colorSet(@"#D8D8D8")
                            .dataSet(seriesArray.copy)
                            .groupingSet(false);

        //
        [seriesArray removeAllObjects];
        for (NSString *categoryTitle in categories) {
            float cost = 0.f;
            for (FMBill *bill in [self.databaseManager queryBillsWithCategoryTitle:categoryTitle inMonth:[NSDate date]]) {
                cost += bill.amount.floatValue;
            };
            [seriesArray addObject:[NSNumber numberWithFloat:cost]];
            cost = 0.f;
        }
        AAColumn *column2 = AAColumn.new
                            .nameSet(@"已使用")
                            // .colorSet(@"#D8D8D8")
                            .dataSet(seriesArray.copy);

        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.aaChartModel.categoriesSet(categories)
                .seriesSet(@[column1, column2]);
            [strongSelf.aaChartView aa_refreshChartWithChartModel:strongSelf.aaChartModel];
        });
    });
}

- (void)getConsumerPreferenceModelSeries {
    NSMutableArray *categoriesSet = [NSMutableArray new];
    NSMutableArray *seriesArray = [NSMutableArray new];
    NSMutableArray *mutableArray = [NSMutableArray new];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __strong typeof(self)  strongSelf = weakSelf;
        for (FMCategory *category in [self.databaseManager queryCategoriesWithPaymentType:expend]) {
            float totalAmount = [self.databaseManager queryTotleAmountWithCategory:category inMonth:[NSDate date]];
            if (totalAmount) {
                [mutableArray addObject: @{@"category" : category, @"totalAmount" : [NSNumber numberWithFloat:totalAmount]}];
            }
        }
        NSInteger maxAmount = 0, index = 0;
        for (; mutableArray.count > 0; ) {
            for (NSInteger i = 0; i < mutableArray.count; i++) {
                NSNumber *currentValue =  mutableArray[i][@"totalAmount"];
                if (maxAmount < currentValue.floatValue) {
                    maxAmount = currentValue.floatValue;
                    index = i;
                }
            }
            FMCategory *cate =  mutableArray[index][@"category"];
            [categoriesSet addObject:cate.categoryTitle];
            [seriesArray addObject:[NSNumber numberWithFloat:maxAmount]];
            [mutableArray removeObjectAtIndex:index];
            index = 0;
            maxAmount = 0;
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.aaChartModel.categoriesSet(categoriesSet)
                .seriesSet(@[
                AASeriesElement.new
                .nameSet(@"消费偏好")
                .dataSet(seriesArray),
                       ]);
            [strongSelf.aaChartView aa_refreshChartWithChartModel:strongSelf.aaChartModel];
        });

    });
}



#pragma mark - override

- (void)setFrame:(CGRect)frame {
    frame.origin.x = 20;

    frame.size.width -= 40;

    [super setFrame:frame];
}

/// 取消cell选中高亮
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
}

/// 取消cell选中高亮
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
}


#pragma mark - RealmNotification
- (void)addRealmNotification {
    __weak typeof(self) weakSelf = self;
    self.billNotificationToken = [[FMBill allObjects] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf reloadData];
    }];
    
    self.budgetNotificationToken =  [[FMBudget allObjects] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf reloadData];
    }];
}

- (void)removeRealmNotification {
    [self.billNotificationToken invalidate];
    [self.budgetNotificationToken invalidate];
}



#pragma mark - 懒加载
- (FMDatabaseManager *)databaseManager {
    if (!_databaseManager) {
        _databaseManager = [FMDatabaseManager defaultManager];
    }
    return _databaseManager;
}


- (void)dealloc {
    [self removeRealmNotification];
}

@end
