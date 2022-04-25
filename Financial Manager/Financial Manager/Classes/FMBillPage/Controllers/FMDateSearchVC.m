//
//  FMDateSearchVC.m
//  design
//
//  Created by PeyetZhao on 2022/4/14.
//

#import "FMDateSearchVC.h"
#import "FMBillPageCell.h"
#import "FMDatePicker.h"

@interface FMDateSearchVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISegmentedControl *naviSegment;

@property (nonatomic, strong) RLMResults *models;
@property (nonatomic, strong) RLMNotificationToken *notificationToken;
@property (nonatomic, strong) NSDate *selectedDate;

@property (nonatomic, strong) FMDatabaseManager *databaseManager;
@property (nonatomic, strong) RLMRealm *realm;

@end

@implementation FMDateSearchVC

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
    [self setUpSegment];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择日期" style:UIBarButtonItemStylePlain target:self action:@selector(clickSearchPageRightButton)];
}

- (void)setUpSegment {
    self.naviSegment = [[UISegmentedControl alloc] initWithItems:@[@"  支出  ", @"  收入  "]];
    [self.naviSegment addTarget:self action:@selector(clickBillPageSegment) forControlEvents:UIControlEventValueChanged];
    self.naviSegment.frame = CGRectMake(0, 0, 80, 30);
    self.naviSegment.selectedSegmentIndex = 0;
    [self.navigationItem setTitleView:self.naviSegment];
}

- (void)clickSearchPageRightButton {
    FMDatePicker *datePicker = [[FMDatePicker alloc] init];
    [self.view addSubview:datePicker];
    __weak typeof(self) weakSelf = self;
    [datePicker showSelectDate:^(NSDate * _Nonnull date) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.models = [self.databaseManager queryBillsWithDay:date andPaymentType:(self.naviSegment.selectedSegmentIndex == 0 ? expend : income)];
        [self.tableView reloadData];
        self.selectedDate = date;
    }];

}

- (void)clickBillPageSegment {
    if (self.selectedDate) {
        self.models = [self.databaseManager queryBillsWithDay:self.selectedDate andPaymentType:(self.naviSegment.selectedSegmentIndex == 0 ? expend : income)];
        [self.tableView reloadData];
    }
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
