//
//  FMBudgetManager.m
//  design
//
//  Created by PeyetZhao on 2022/3/22.
//

#import "FMBudgetManager.h"
#import "FMCollectionView.h"
#import "FMBudgetKeyboard.h"

@interface FMBudgetManager ()

@property (nonatomic, strong) UISegmentedControl *naviSegment;
@property (nonatomic, strong) FMBudgetKeyboard *keyboard;
@property (nonatomic, strong) FMCollectionView *categoryView;

@property (nonatomic, strong) FMBudget *budget;
@property (nonatomic, strong) FMCategory *budgetCategory;

@property (nonatomic, strong) FMDatabaseManager *databaseManager;

@end

@implementation FMBudgetManager

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setUpViewNaviBar];
    [self setUpCategoryView];
    [self setUpKeyboard];
    self.view.backgroundColor = UIColor.whiteColor;
}


#pragma mark - Life Cycle
- (void)setUpViewNaviBar {
    self.naviSegment = [[UISegmentedControl alloc] initWithItems:@[@"  支出  ", @"  收入  "]];
    [self.naviSegment addTarget:self action:@selector(clickSegment) forControlEvents:UIControlEventValueChanged];
    self.naviSegment.frame = CGRectMake(0, 0, 80, 30);
    self.naviSegment.selectedSegmentIndex = 0;
    [self.navigationItem setTitleView:self.naviSegment];
}

- (void)setUpCategoryView {
    self.categoryView = [FMCollectionView initWithFrame:CGRectMake(0, SCREEN_StatusBar_Height + SCREEN_NavigationBar_Height, SCREEN_WIDTH, SCREEN_HEIGHT - (SCREEN_WIDTH / 5 * 4 + SafeAreaBottomHeight) - SCREEN_StatusBar_Height - SCREEN_NavigationBar_Height)];
    [self.view addSubview:self.categoryView];
    
    // 设置默认类别的数据模型
//    [self.categoryView setModel:[self.databaseManager queryAllCategories]];
    [self.categoryView setUpViewWithCategories:[NSArray arrayWithRLMResults:[self.databaseManager queryCategoriesWithPaymentType:self.naviSegment.selectedSegmentIndex]]];
    
    // 点击类别 block
    __weak typeof(self) weakSelf = self;
    [self.categoryView monitoringSelectedCategory:^(FMCategory * _Nonnull selectedCategory) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.budgetCategory = selectedCategory;
    }];
    
    // 设置默认选中值
    if (self.budget) {
        [self.categoryView setUpSelectedCategoryWithCategory:self.budgetCategory];
    }
}

- (void)setUpKeyboard {
    self.keyboard = [FMBudgetKeyboard init];
    [self.view addSubview:_keyboard];
    [self.keyboard show];
    
    // 更新Budget block
    __weak typeof(self) weakSelf = self;
//    [self.keyboard monitoringCreateBudget:^(NSString * _Nonnull amount, NSDate * _Nonnull date, NSString * _Nullable budgetID) {
//        __strong typeof(weakSelf) strongSelf = weakSelf;
//        FMBudget *newBudget = [[FMBudget alloc] init];
//        if (budgetID) {
//            newBudget.budgetID = budgetID;
//        }
//        newBudget.amount = [NSNumber numberWithFloat:[amount floatValue]];
//        newBudget.category = strongSelf.budgetCategory;
//        newBudget.date = date;
//        [strongSelf.databaseManager insertWithBudget:newBudget];
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
    
    [self.keyboard monitoringCreateBudget:^(NSString * _Nonnull amount, NSDate * _Nonnull date, NSString * _Nullable budgetID) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            FMBudget *newBudget = [[FMBudget alloc] init];
            if (budgetID) {
                newBudget.budgetID = budgetID;
            }
            newBudget.amount = [NSNumber numberWithFloat:[amount floatValue]];
            newBudget.category = strongSelf.budgetCategory;
            newBudget.date = date;
            [strongSelf.databaseManager insertWithBudget:newBudget];
            [self.navigationController popViewControllerAnimated:YES];
    }];
    
    // 设置默认选中值
    if (self.budget) {
        [self.keyboard setUpKeyBoardWithBudget:self.budget];
    }
}

- (void)clickSegment {
    [self.categoryView setUpViewWithCategories:[NSArray arrayWithRLMResults:[self.databaseManager queryCategoriesWithPaymentType:self.naviSegment.selectedSegmentIndex]]];
}


- (void)modifyBudgetWithFMBudget:(FMBudget *)budget {
    self.budget = budget;
    self.budgetCategory = budget.category;
}


#pragma mark - 懒加载
- (FMDatabaseManager *)databaseManager {
    if (!_databaseManager) {
        _databaseManager = [FMDatabaseManager defaultManager];
    }
    return _databaseManager;
}



@end
