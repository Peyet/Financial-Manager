//
//  BaseCollectionCell.m
//  design
//
//  Created by PeyetZhao on 2022/3/18.
//

#import "BaseCollectionCell.h"

@implementation BaseCollectionCell

// 创建cell
+ (instancetype)loadItem:(UICollectionView *)collection index:(NSIndexPath *)index {
    NSString *name = NSStringFromClass(self);
    BaseCollectionCell *cell = [collection dequeueReusableCellWithReuseIdentifier:name forIndexPath:index];
    [cell initUI];
    return cell;
}

// 初始化UI
- (void)initUI {
    
}


@end
