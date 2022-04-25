//
//  FMSettingPageVC.m
//  design
//
//  Created by PeyetZhao on 2022/3/15.
//

#import "FMSettingPageVC.h"
#import "SettingViewCell.h"

#import "BillingManager.h"
#import "FMCategoryManager.h"

// 类别设置
// 预算设置
// 提醒设置
// 反馈
// 关于

@interface FMSettingPageVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) RLMResults *models;
@property (nonatomic, strong) RLMNotificationToken *notificationToken;

@property (nonatomic, strong) FMDatabaseManager *databaseManager;
@property (nonatomic, strong) RLMRealm *realm;

@end

@implementation FMSettingPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [self addRealmNotification];
}

#pragma mark - Life Cycle
/// 初始化tableView
- (void)setUpTableView {
//    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
//    [self.tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)reloadViewWithPaymentType:(PaymentType)paymentType {
    self.models = [self.databaseManager queryCategoriesWithPaymentType:paymentType];
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell"];
    if (!cell) {
        cell =[[NSBundle mainBundle] loadNibNamed:@"SettingViewCell" owner:self options:nil].firstObject;
    }
    [cell updateCellWithFMCategory:self.models[indexPath.row]];
    return cell;
}


#pragma mark 设置删除按钮
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.databaseManager deleteWithCategory:self.models[indexPath.row]];
}

- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
      return YES;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FMCategoryManager *categoryManager = [[FMCategoryManager alloc] init];
    [self.tabBarController.navigationController pushViewController:categoryManager animated:YES];
    [categoryManager modifyCategoryWithFMCategory:self.models[indexPath.row]];
    [self.tabBarController.navigationController setNavigationBarHidden:NO animated:NO];
}


#pragma mark - RealmNotification
- (void)addRealmNotification {
    __weak typeof(self) weakSelf = self;
    self.notificationToken = [[FMCategory allObjects] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (error) {
            NSLog(@"Failed to open Realm on background worker: %@", error);
            return;
        }
        [strongSelf.tableView reloadData];
    }];
}

- (void)removeRealmNotification {
    [self.notificationToken invalidate];
}


#pragma mark - 懒加载
- (RLMResults *)models {
    if (!_models) {
        _models = [self.databaseManager queryCategoriesWithPaymentType:expend];
    }
    return _models;
}

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
