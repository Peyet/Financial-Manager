//
//  SettingViewCell.m
//  design
//
//  Created by PeyetZhao on 2022/4/13.
//

#import "SettingViewCell.h"

@interface SettingViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *categoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;

@property (nonatomic, strong) FMCategory *model;

@end

@implementation SettingViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)updateCellWithFMCategory:(FMCategory *)category {
    self.model = category;
    _categoryImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@l", category.categoryImage]];
    self.categoryLabel.text = category.categoryTitle;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

/// 取消cell选中高亮
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
}
/// 取消cell选中高亮
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
}

//- (void)setFrame:(CGRect)frame {
//    frame.origin.x = 20;
//
//    frame.size.width -= 40;
//
//    [super setFrame:frame];
//}


@end
