//
//  FMCollectionView.h
//  design
//
//  Created by PeyetZhao on 2022/3/18.
//

#import <UIKit/UIKit.h>
#import "FMCategory.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^categoryMonitorBlock)(FMCategory * selectedCategory);
@interface FMCollectionView : UICollectionView



// 初始化
+ (instancetype)initWithFrame:(CGRect)frame;

// 更新数据模型
- (void)setUpViewWithCategories:(NSArray *)categories;
/// 设置默认选中的类别
/// @param selectedCategory 类别模型
- (void)setUpSelectedCategoryWithCategory:(FMCategory *)selectedCategory;


/// 监听选中状态
- (void)monitoringSelectedCategory:(categoryMonitorBlock)categoryMonitor;


@end

NS_ASSUME_NONNULL_END
