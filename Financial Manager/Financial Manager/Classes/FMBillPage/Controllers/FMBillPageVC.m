//
//  FMBillPageVC.m
//  design
//
//  Created by PeyetZhao on 2022/3/15.
//

#import "FMBillPageVC.h"
#import "AAChartKit.h"
#import "BillingManager.h"
#import "FMBillPageCell.h"


@interface FMBillPageVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) RLMResults *models;
@property (nonatomic, strong) RLMNotificationToken *notificationToken;

@property (nonatomic, strong) FMDatabaseManager *databaseManager;
@property (nonatomic, strong) RLMRealm *realm;

@end

@implementation FMBillPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    [self addRealmNotification];

}


#pragma mark - Life Cycle
/// 初始化tableView
- (void)setupTableView {
    self.tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.frame = self.view.frame;
    [self.view addSubview:self.tableView];
}

/// 查看收入或支出
/// @param paymentType 收支类型
- (void)reloadViewWithPaymentType:(PaymentType)paymentType {
    self.models = [self.databaseManager queryBillsWithPaymentType:paymentType];
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FMBillPageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normalBillCell"];
    if (!cell) {
        cell =[[NSBundle mainBundle] loadNibNamed:@"FMBillPageCell" owner:self options:nil].firstObject;
    }
    [cell updateCellWithFMBill:self.models[indexPath.row]];
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
    [self.databaseManager deleteWithBill:self.models[indexPath.row]];
}

- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
      return YES;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BillingManager *billingManager = [[BillingManager alloc] init];
    [billingManager modifyBillWithFMBill:self.models[indexPath.row]];
    [self.tabBarController.navigationController pushViewController:billingManager animated:YES];
}



#pragma mark - RealmNotification
- (void)addRealmNotification {
    __weak typeof(self) weakSelf = self;
    self.notificationToken = [[FMBill allObjects] addNotificationBlock:^(RLMResults * _Nullable results, RLMCollectionChange * _Nullable change, NSError * _Nullable error) {
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
        _models = [self.databaseManager queryBillsWithPaymentType:expend];
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
