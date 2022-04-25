//
//  BillingManager.m
//  design
//
//  Created by PeyetZhao on 2022/3/18.
//

#import "BillingManager.h"
#import "FMCollectionView.h"
#import "FMBillKeyboard.h"

@interface BillingManager ()

@property (nonatomic, strong) UISegmentedControl *naviSegment;
@property (nonatomic, strong) FMBillKeyboard *keyboard;
@property (nonatomic, strong) FMCollectionView *categoryView;

@property (nonatomic, strong) FMBill *bill;
@property (nonatomic, strong) FMCategory *billCategory;

@property (nonatomic, strong) FMDatabaseManager *databaseManager;

@end

@implementation BillingManager

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViewNaviBar];
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
        strongSelf.billCategory = selectedCategory;
    }];
    
    // 设置默认选中值
    if (self.bill) {
        [self.categoryView setUpSelectedCategoryWithCategory:self.billCategory];
    }
}

- (void)setUpKeyboard {
    self.keyboard = [FMBillKeyboard init];
    [self.view addSubview:_keyboard];
    [self.keyboard show];
    
    // 更新Bill block
    __weak typeof(self) weakSelf = self;
    [self.keyboard monitoringCreateBill:^(NSString * _Nonnull amount, NSString * _Nonnull remark, NSDate * _Nonnull date, NSString * _Nullable billID) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        FMBill *newBill = [[FMBill alloc] init];
        if (billID) {
            newBill.billID = billID;
        }
        newBill.amount = [NSNumber numberWithFloat:[amount floatValue]];
        newBill.remarks = remark;
        newBill.category = strongSelf.billCategory;
        newBill.date = date;
        [strongSelf.databaseManager insertWithBill:newBill];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    // 设置默认选中值
    if (self.bill) {
        [self.keyboard setUpKeyBoardWithBill:self.bill];
    }
}

- (void)clickSegment {
    [self.categoryView setUpViewWithCategories:[NSArray arrayWithRLMResults:[self.databaseManager queryCategoriesWithPaymentType:self.naviSegment.selectedSegmentIndex]]];
}


- (void)modifyBillWithFMBill:(FMBill *)bill {
    self.bill = bill;
    self.billCategory = bill.category;
}


#pragma mark - 懒加载
- (FMDatabaseManager *)databaseManager {
    if (!_databaseManager) {
        _databaseManager = [FMDatabaseManager defaultManager];
    }
    return _databaseManager;
}

@end
