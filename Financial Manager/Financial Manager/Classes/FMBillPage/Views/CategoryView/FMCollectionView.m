//
//  FMCollectionView.m
//  design
//
//  Created by PeyetZhao on 2022/3/18.
//

#import "FMCollectionView.h"
#import "FMCollectionViewCell.h"

#define PADDING countcoordinatesX(10)               // 间距
#define ROW 4                                       // 每行几个
#define CELL_W (SCREEN_WIDTH - PADDING * 2) / ROW   // cell宽度
#define CELL_H CELL_W                               // cell高度


#pragma mark - 声明
@interface FMCollectionView()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSIndexPath *selectedIndex;
@property (nonatomic, strong) FMCategory *defaulSelectedCategory;
@property (nonatomic, strong) categoryMonitorBlock categoryMonitor;

@property (nonatomic, strong) NSArray *model;


@end


@implementation FMCollectionView
#pragma mark - 初始化
+ (instancetype)initWithFrame:(CGRect)frame {
//    CGRect newFrame = CGRectMake(0, 0, frame.size.width, 0);
    FMCollectionView *collection = [[FMCollectionView alloc] initWithFrame:frame collectionViewLayout:({
        UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
        flow.itemSize = CGSizeMake(CELL_W, CELL_H);
        flow.minimumLineSpacing = 0;
        flow.minimumInteritemSpacing = 0;
        flow;
    })];
    [collection setHeight:0];
    [UIView animateWithDuration:.5f animations:^{
        [collection setHeight:frame.size.height];
    }];
    [collection setShowsVerticalScrollIndicator:NO];
    [collection setShowsHorizontalScrollIndicator:NO];
    [collection setBackgroundColor:kColor_BG];
    [collection setDelegate:collection];
    [collection setDataSource:collection];
    [collection registerNib:[UINib nibWithNibName:@"FMCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"FMCollectionViewCell"];
    return collection;
}


#pragma mark - set
- (void)setUpViewWithCategories:(NSArray *)categories {
    self.model = categories;
    [self reloadData];
}

- (void)setUpSelectedCategoryWithCategory:(FMCategory *)selectedCategory {
    self.defaulSelectedCategory = selectedCategory;
    int index = 0;
    for (FMCategory *category in self.model) {
        if ([selectedCategory.categoryTitle isEqualToString:category.categoryTitle]) {
            self.selectedIndex = [NSIndexPath indexPathForItem:index inSection:0];
            break;;
        }
        index++;
    }
}


#pragma mark - Monitor
- (void)monitoringSelectedCategory:(categoryMonitorBlock)categoryMonitor {
    self.categoryMonitor = categoryMonitor;
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FMCollectionViewCell *cell = [FMCollectionViewCell loadItem:collectionView index:indexPath];
    [cell setUpCellWithFMCategory:self.model[indexPath.row]];
    [cell updateCellWithChoose:[self.selectedIndex isEqual:indexPath]];
    return cell;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 更新图标
    FMCollectionViewCell *cell = (FMCollectionViewCell *)[self cellForItemAtIndexPath:self.selectedIndex];
    [cell updateCellWithChoose:NO];
    self.selectedIndex = indexPath;
    cell = (FMCollectionViewCell *)[self cellForItemAtIndexPath:self.selectedIndex];
    [cell updateCellWithChoose:YES];

    if (self.categoryMonitor) {
        self.categoryMonitor(self.model[indexPath.row]);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(countcoordinatesX(10), countcoordinatesX(10), countcoordinatesX(10), countcoordinatesX(10));
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y < -54) {
        if (self.viewController.navigationController.viewControllers.count != 1) {
            [self.viewController.navigationController popViewControllerAnimated:true];
        } else {
            [self.viewController.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        }
    }
}

@end
