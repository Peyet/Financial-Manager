//
//  FMBudgetPageCell.m
//  design
//
//  Created by PeyetZhao on 2022/3/23.
//

#import "FMBudgetPageCell.h"

@interface FMBudgetPageCell()
@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) FMBudget *model;

@end

@implementation FMBudgetPageCell

- (void)updateCellWithFMBudget:(FMBudget *)budget {
    self.model = budget;

//    NSString *categoryImgPath = [[NSBundle mainBundle] pathForResource:bill.category.categoryImage ofType:nil];
//    [self.categoryImageView sd_setImageWithURL:[NSURL fileURLWithPath:categoryImgPath]];
    _categoryImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@l", budget.category.categoryImage]];
    self.categoryLabel.text = budget.category.categoryTitle;
    self.amountLabel.text = [NSString stringWithFormat:@"¥ %.2f", budget.amount.floatValue];
    self.timeLabel.text = [budget.date formatYM];

}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

/// 取消cell选中高亮
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
}
/// 取消cell选中高亮
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
}



@end
