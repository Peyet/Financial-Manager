//
//  FMHomePageVC.m
//  design
//
//  Created by PeyetZhao on 2022/3/15.
//

#import "FMHomePageVC.h"
#import "Masonry.h"
#import "FMHomeViewCell.h"
#import "AAChartKit.h"

#import "FMBill.h"
#import "FMCategory.h"
#import <Realm/Realm.h>

#import "FMDatabaseManager.h"
#import "FMHomeHeaderView.h"

@interface FMHomePageVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FMHomeHeaderView *homeHeaderView;
//@property (nonatomic, strong) NSArray *cellsType;

@property (nonatomic, strong) NSArray *sectionTypeArr;
@property (nonatomic, strong) NSArray *cellTypeNameArr;
@end

@implementation FMHomePageVC


#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    

}

- (void)viewWillAppear:(BOOL)animated {
    [self.homeHeaderView reloadData];
    [self.tableView reloadData];
}

/// 初始化首页界面
- (void)setUpTableView {
    self.view.backgroundColor = UIColor.greenColor;
    [self.view addSubview:self.tableView];
        
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(0);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(0);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(0);
    }];
    [self.tableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.homeHeaderView = [FMHomeHeaderView homeHeader];
    self.tableView.tableHeaderView = self.homeHeaderView;
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 300);
}

- (UIView*)getTableHeaderViewWithTitle:(NSString *)title{
    UIView* vc=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    UILabel* label=[[UILabel alloc]initWithFrame:CGRectMake(25, 0, SCREEN_WIDTH, 40)];
    label.font=[UIFont boldSystemFontOfSize:26];
    label.adjustsFontSizeToFitWidth = YES;
    label.text= title;
    label.textColor=[UIColor blackColor];
    [vc addSubview:label];
    return vc;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTypeArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.cellTypeNameArr[(NSUInteger) section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = self.cellTypeNameArr[indexPath.section];
    
    FMHomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:arr[indexPath.row]];
    if (!cell) {
        cell = [[FMHomeViewCell alloc] initWithCellType:arr[indexPath.row]];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self getTableHeaderViewWithTitle:self.sectionTypeArr[section]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        return 180;
    }
    return 320;
}



#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (NSArray *)sectionTypeArr {
    if (!_sectionTypeArr) {
        _sectionTypeArr = @[
            @"建议👀",// 🤩🥳😫
            @"趋势🚀",
            @"预算📝",
            @"偏好分析🥰",
        ];
    }
    return _sectionTypeArr;
}

- (NSArray *)cellTypeNameArr {
    if (!_cellTypeNameArr) {
        _cellTypeNameArr = @[
            @[
                @"消费建议"
            ],
            @[
                @"近期消费趋势",
                @"本月消费趋势"
            ],
            @[
                @"预算汇总",
                @"预算使用详情"
            ],
            @[
                @"消费偏好"
            ],
        ];
    }
    return _cellTypeNameArr;
}

@end
