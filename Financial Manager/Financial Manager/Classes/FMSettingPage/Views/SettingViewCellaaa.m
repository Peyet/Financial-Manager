//
//  SettingViewCellaaa.m
//  design
//
//  Created by PeyetZhao on 2022/3/22.
//

#import "SettingViewCellaaa.h"

@implementation SettingViewCellaaa

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame {
    frame.origin.x = 20;

    frame.size.width -= 40;

    [super setFrame:frame];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.backgroundColor = UIColor.clearColor;
    }
    return self;
}

@end
