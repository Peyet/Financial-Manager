//
//  BaseCollectionCell.h
//  design
//
//  Created by PeyetZhao on 2022/3/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseCollectionCell : UICollectionViewCell
/// 创建cell
+ (instancetype)loadItem:(UICollectionView *)collection index:(NSIndexPath *)index;
/// 初始化UI
- (void)initUI;

@end

NS_ASSUME_NONNULL_END
