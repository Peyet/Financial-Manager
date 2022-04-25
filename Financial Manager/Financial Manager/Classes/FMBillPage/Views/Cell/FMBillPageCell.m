//
//  FMBillPageCell.m
//  design
//
//  Created by PeyetZhao on 2022/3/20.
//

#import "FMBillPageCell.h"

@interface FMBillPageCell()

@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) FMBill *model;

@end

@implementation FMBillPageCell

- (void)updateCellWithFMBill:(FMBill *)bill {
    self.model = bill;

//    NSString *categoryImgPath = [[NSBundle mainBundle] pathForResource:bill.category.categoryImage ofType:nil];
//    [self.categoryImageView sd_setImageWithURL:[NSURL fileURLWithPath:categoryImgPath]];
    _categoryImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@l", bill.category.categoryImage]];
    self.categoryLabel.text = bill.category.categoryTitle;
    self.remarkLabel.text = bill.remarks;
    self.amountLabel.text = [NSString stringWithFormat:@"¥ %.2f", bill.amount.floatValue];
    self.timeLabel.text = [bill.date formatYMD];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


/// 取消cell选中高亮
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
}
/// 取消cell选中高亮
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
}

@end
