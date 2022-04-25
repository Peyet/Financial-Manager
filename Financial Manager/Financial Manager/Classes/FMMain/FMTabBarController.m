//
//  FMTabBarController.m
//  design
//
//  Created by PeyetZhao on 2022/3/14.
//

#import "FMTabBarController.h"
#import "FMBillPageVC.h"
#import "FMHomePageVC.h"
#import "FMSettingPageVC.h"
#import "FMSearchVC.h"
#import "FMBudgetPageVC.h"

#import "BillingManager.h"
#import "FMBudgetManager.h"
#import "FMCategoryManager.h"

@interface FMTabBarController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) FMHomePageVC *homePageVC;
@property (nonatomic, strong) FMBillPageVC *billPageVC;
@property (nonatomic, strong) FMBudgetPageVC *budgetPageVC;
@property (nonatomic, strong) FMSettingPageVC *settingPageVC;

@property (nonatomic, strong) UISegmentedControl *naviSegment;

@end

@implementation FMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpChildrenViewController];
}

/// 初始化tabBar的子控制器
- (void)setUpChildrenViewController {
    self.homePageVC = (FMHomePageVC *)[self _createChildViewControllerWithClass:([FMHomePageVC class]) imageName:@"home.png" selectedImageName:@"home.png" title:@"首页"];
    
    self.billPageVC = (FMBillPageVC *)[self _createChildViewControllerWithClass:([FMBillPageVC class]) imageName:@"bill.png" selectedImageName:@"bill.png" title:@"明细"];
    
    self.budgetPageVC = (FMBudgetPageVC *)[self _createChildViewControllerWithClass:([FMBudgetPageVC class]) imageName:@"budget.png" selectedImageName:@"budget.png" title:@"预算"];
    
    self.settingPageVC = (FMSettingPageVC *)[self _createChildViewControllerWithClass:([FMSettingPageVC class]) imageName:@"budget.png" selectedImageName:@"budget.png" title:@"设置"];
        
    self.viewControllers = @[self.homePageVC, self.billPageVC, self.budgetPageVC, self.settingPageVC];
    
    // 设置tabBar的颜色
    self.tabBar.backgroundColor = kZPJ_COLOR_TABBAR;
    self.delegate = self;
}

/// 创建子控制器
/// @param class 子控制器的类型
/// @param imageName tabbar未选中时显示的图片
/// @param selectedImageName tabbar选中时显示的图片
/// @param title tabbar的标题
- (UIViewController *)_createChildViewControllerWithClass:(Class)class
                              imageName:(NSString *)imageName
                      selectedImageName:(NSString *)selectedImageName
                                  title:(NSString *)title {
    UIViewController *vc = [[class alloc] init];
    vc.tabBarItem.image = [UIImage imageNamed:imageName];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    vc.tabBarItem.title = title;
    return vc;
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[self.billPageVC class]]) {
        // 设置流水界面导航栏
        [self setUpBillPageNaviBar];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    } else if ([viewController isKindOfClass:[self.budgetPageVC class]]) {
        [self setUpBudgetPageNaviBar];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    } else if([viewController isKindOfClass:[self.settingPageVC class]]) {
        [self setUpSettingPageNaviBar];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    } else {
        // 其他界面无导航栏
        [self.navigationController setNavigationBarHidden:YES animated:NO];

    }
}

/// 设置流水界面导航栏
- (void)setUpBillPageNaviBar {
    self.naviSegment = [[UISegmentedControl alloc] initWithItems:@[@"  支出  ", @"  收入  "]];
    [self.naviSegment addTarget:self action:@selector(clickBillPageSegment) forControlEvents:UIControlEventValueChanged];
    self.naviSegment.frame = CGRectMake(0, 0, 80, 30);
    self.naviSegment.selectedSegmentIndex = 0;
    [self.navigationItem setTitleView:self.naviSegment];
    
    self.navigationItem.title = @"明细";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(clickBillPageRightButton)];
}

/// 设置预算界面导航栏
- (void)setUpBudgetPageNaviBar {
    [self.navigationItem setTitleView:nil];
    self.navigationItem.title = @" ";
    
    self.navigationItem.title = @"预算";
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(clickBudgetPageRightButton)];
}

- (void)setUpSettingPageNaviBar {
    self.naviSegment = [[UISegmentedControl alloc] initWithItems:@[@"  支出  ", @"  收入  "]];
    [self.naviSegment addTarget:self action:@selector(clickSettingPageSegment) forControlEvents:UIControlEventValueChanged];
    self.naviSegment.frame = CGRectMake(0, 0, 80, 30);
    self.naviSegment.selectedSegmentIndex = 0;
    [self.navigationItem setTitleView:self.naviSegment];
    
    self.navigationItem.title = @"设置";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(clickSettingPageRightButton)];
}

#pragma mark -导航栏点击事件
// 导航栏左侧按钮
- (void)clickLeftButton {
    [self.navigationController pushViewController:[[FMSearchVC alloc] init] animated:YES];
}

// 导航栏右侧按钮
- (void)clickBillPageRightButton {
    [self.navigationController pushViewController:[[BillingManager alloc] init] animated:YES];
}

- (void)clickBudgetPageRightButton {
    [self.navigationController pushViewController:[[FMBudgetManager alloc] init] animated:YES];
}

- (void)clickSettingPageRightButton {
    [self.navigationController pushViewController:[[FMCategoryManager alloc] init] animated:YES];
}

// 导航栏segment
- (void)clickBillPageSegment {
    if (self.naviSegment.selectedSegmentIndex) {
        [self.billPageVC reloadViewWithPaymentType:income];
    } else {
        [self.billPageVC reloadViewWithPaymentType:expend];
    }
}

- (void)clickSettingPageSegment {
    if (self.naviSegment.selectedSegmentIndex) {
        [self.settingPageVC reloadViewWithPaymentType:income];
    } else {
        [self.settingPageVC reloadViewWithPaymentType:expend];
    }
}

@end
