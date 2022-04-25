//
//  FMSearchVC.m
//  design
//
//  Created by PeyetZhao on 2022/3/21.
//

#import "FMSearchVC.h"
#import "FMBillPageCell.h"
#import "FMDateSearchVC.h"

@interface FMSearchVC ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) RLMResults *models;
@property (nonatomic, strong) RLMNotificationToken *notificationToken;

@property (nonatomic, strong) FMDatabaseManager *databaseManager;
@property (nonatomic, strong) RLMRealm *realm;

@end

@implementation FMSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [self setUpNavigation];
    [self addRealmNotification];
}

- (void)setUpTableView {
    self.tableView = [[UITableView alloc] init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.frame = self.view.frame;
    [self.view addSubview:self.tableView];
}

- (void)setUpNavigation {
    [self setUpSearchBar];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"按日期搜索" style:UIBarButtonItemStylePlain target:self action:@selector(clickSearchPageRightButton)];
    self.title = @"搜索";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"按日期搜索" style:UIBarButtonItemStylePlain target:self action:@selector(clickSearchPageRightButton)];
}

- (void)setUpSearchBar {
    UITextField *searchBar = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH- 10*4 - 10*20, SCREEN_NavigationBar_Height - 10)];
    searchBar.backgroundColor = [UIColor lightGrayColor];
    searchBar.layer.cornerRadius = 17;
    searchBar.layer.masksToBounds = YES;
    searchBar.delegate = self;
    searchBar.clearButtonMode = UITextFieldViewModeAlways;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSAttributedString *attri = [[NSAttributedString alloc] initWithString:@"点击进行搜索" attributes:@{NSParagraphStyleAttributeName:style}];
    searchBar.attributedPlaceholder = attri;

    [self.navigationItem setTitleView:searchBar];
}

- (void)clickSearchPageRightButton {
    [self.navigationController pushViewController:[[FMDateSearchVC alloc] init] animated:YES];
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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  
    self.models = [self.databaseManager queryBillsWithRemark:textField.text];
    [self.tableView reloadData];
    [textField resignFirstResponder];
    return YES;
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
