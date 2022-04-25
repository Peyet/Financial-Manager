//
//  FMCollectionViewCell.h
//  design
//
//  Created by PeyetZhao on 2022/3/18.
//

#import <UIKit/UIKit.h>
#import "FMCategory.h"

NS_ASSUME_NONNULL_BEGIN

@interface FMCollectionViewCell : BaseCollectionCell

- (void)setUpCellWithFMCategory:(FMCategory *)category;

- (void)updateCellWithChoose:(BOOL)isSelected;

@end

NS_ASSUME_NONNULL_END
