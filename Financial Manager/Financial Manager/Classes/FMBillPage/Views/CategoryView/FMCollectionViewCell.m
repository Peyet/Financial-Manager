//
//  FMCollectionViewCell.m
//  design
//
//  Created by PeyetZhao on 2022/3/18.
//

#import "FMCollectionViewCell.h"
#pragma mark - 声明
@interface FMCollectionViewCell()

@property (nonatomic, strong) FMCategory *model;
@property (nonatomic, assign, getter=isSelected) BOOL isSelected;

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *lab;

@end


#pragma mark - 实现
@implementation FMCollectionViewCell

/// 初始化
- (void)initUI {
    self.lab.font = [UIFont systemFontOfSize:AdjustFont(12) weight:UIFontWeightLight];
    self.lab.textColor = kColor_Text_Gary;
    self.lab.backgroundColor = UIColor.whiteColor;
}

/// 设置类别图片和名称
/// @param category 类别图片和名称
- (void)setUpCellWithFMCategory:(FMCategory *)category {
    self.model = category;
    [self.lab setText:self.model.categoryTitle];
    [self.icon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@l", self.model.categoryImage]]];
}

/// 更新选中状态
/// @param isSelected 是否选中
- (void)updateCellWithChoose:(BOOL)isSelected {
    self.isSelected = isSelected;
    if (isSelected) {
        [self.icon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@s", self.model.categoryImage]]];
    } else {
        [self.icon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@l", self.model.categoryImage]]];
    }
}

@end
