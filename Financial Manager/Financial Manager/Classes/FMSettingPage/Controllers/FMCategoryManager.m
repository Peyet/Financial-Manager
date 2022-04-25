//
//  FMCategoryManager.m
//  design
//
//  Created by PeyetZhao on 2022/4/13.
//

#import "FMCategoryManager.h"

@interface FMCategoryManager ()

//@property (nonatomic, strong) UIImageView *categoryImage;
@property (nonatomic, strong) UITextField *categoryTextField;
@property (nonatomic, strong) UISegmentedControl *paymentTypeSegment;

@property (nonatomic, strong) FMCategory *category;

@end

@implementation FMCategoryManager

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.category) {
        self.categoryTextField.text = self.category.categoryTitle;
        self.paymentTypeSegment.selectedSegmentIndex = self.category.isIncome.boolValue;
    }
}

- (void)setUpView {
    UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, 100, 50)];
    categoryLabel.text = @"名称";
    [self.view addSubview:categoryLabel];
    
    self.categoryTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 200, 300, 50)];
    self.categoryTextField.placeholder = @"类别名称";
    [self.view addSubview:self.categoryTextField];
    
    UILabel *paymentTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 300, 100, 50)];
    paymentTypeLabel.text = @"类别";
    [self.view addSubview:paymentTypeLabel];
    
    
    self.paymentTypeSegment = [[UISegmentedControl alloc] initWithItems:@[@"  支出  ", @"  收入  "]];
    self.paymentTypeSegment.frame = CGRectMake(10, 350, 160, 40);
    self.paymentTypeSegment.selectedSegmentIndex = 0;
    [self.view addSubview:self.paymentTypeSegment];

    UIButton *addNewCategoryBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    addNewCategoryBtn.frame = CGRectMake(10, 400, 80, 40);
    [addNewCategoryBtn setTitle:@"确认" forState:UIControlStateNormal];
    [addNewCategoryBtn addTarget:self action:@selector(addNewCategory) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addNewCategoryBtn];
    
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)modifyCategoryWithFMCategory:(FMCategory *)category {
    self.category = category;
}

- (void)addNewCategory {
    FMCategory *newCategory = [[FMCategory alloc] init];
    if (self.category) {
        newCategory.categoryID = self.category.categoryID;
    }
    newCategory.categoryTitle = self.categoryTextField.text;
    newCategory.isIncome = (self.paymentTypeSegment.selectedSegmentIndex == 0) ? [NSNumber numberWithBool:expend] : [NSNumber numberWithBool:income];
    newCategory.categoryImage = [NSString stringWithFormat:@"random_%d_", arc4random() % 7];
    [[FMDatabaseManager defaultManager] insertWithCategory:newCategory];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
