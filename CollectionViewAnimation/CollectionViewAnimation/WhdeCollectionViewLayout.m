//
//  WhdeCollectionViewLayout.m
//  WhdeCollectionViewLayout
//
//  Created by Whde on 18/7/7.
//  Copyright © 2018年 Whde. All rights reserved.
//

#import "WhdeCollectionViewLayout.h"
static CGFloat Animation_Scale = 1.f;
@interface WhdeCollectionViewLayout()
@property (nonatomic, strong) NSMutableArray *itemsY;
@property (nonatomic, strong) NSMutableArray *itemsScale;
@property (nonatomic) NSInteger numberOfCellsInSection;
@end
@implementation WhdeCollectionViewLayout
#pragma mark -- UICollectionViewLayout 重写的方法
- (void)prepareLayout {
    [super prepareLayout];
    [self initItems];
}
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    CGFloat contentOffsetX = self.collectionView.contentOffset.x;
    NSInteger currentIndex = contentOffsetX/(int)(self.itemSize.width+self.minimumLineSpacing);
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < _numberOfCellsInSection; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        NSInteger startIndex = indexPath.row - currentIndex;
        if (indexPath.row >= currentIndex) {
            CGFloat ratio = (contentOffsetX - currentIndex*(self.itemSize.width+self.minimumLineSpacing))/((self.itemSize.width+self.minimumLineSpacing)*Animation_Scale);
            if (ratio >= 1) {
                ratio = 1.f;
            }
            CGFloat centerX = self.itemSize.width/2+contentOffsetX;
            CGFloat centerY = self.itemSize.height/2-[_itemsY[startIndex] floatValue];
            
            if ((startIndex == 1 || startIndex == 2) && contentOffsetX >= 0) {
                attributes.size = CGSizeMake(self.itemSize.width, self.itemSize.height);
                CGFloat heightChange = [_itemsY[startIndex] floatValue] - [_itemsY[startIndex - 1] floatValue];
                attributes.center = CGPointMake(centerX, centerY+heightChange*ratio);
                CGFloat scaleChange = [_itemsScale[startIndex - 1] floatValue] - [_itemsScale[startIndex] floatValue];
                CGFloat scale = [_itemsScale[startIndex] floatValue] + scaleChange*ratio;
                attributes.transform = CGAffineTransformMakeScale(scale, scale);
                attributes.alpha = (((contentOffsetX-currentIndex*(int)(self.itemSize.width+self.minimumLineSpacing))/(self.itemSize.width+self.minimumLineSpacing))+1)/2;
            } else if (startIndex == 0) {
                attributes.size = CGSizeMake(self.itemSize.width, self.itemSize.height);
                attributes.center = CGPointMake(centerX+currentIndex*self.minimumLineSpacing, centerY);
                attributes.transform = CGAffineTransformMakeScale(1, 1);
                attributes.alpha = (1-(contentOffsetX-currentIndex*(int)(self.itemSize.width+self.minimumLineSpacing))/(self.itemSize.width+self.minimumLineSpacing));
            } else {
                attributes.alpha = (((contentOffsetX-currentIndex*(int)(self.itemSize.width+self.minimumLineSpacing))/(self.itemSize.width+self.minimumLineSpacing))+1)/2;
            }
            attributes.zIndex = 10000 - indexPath.row;
        }
        
        if (indexPath.row == currentIndex || contentOffsetX < 0) {
            attributes.transform = CGAffineTransformTranslate(attributes.transform, -(contentOffsetX-currentIndex*self.itemSize.width), 0);
        }
        [array addObject:attributes];
    }
    return array;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    NSInteger currentIndex = proposedContentOffset.x/self.itemSize.width;
    if (proposedContentOffset.x - currentIndex*self.itemSize.width > Animation_Scale*self.itemSize.width) {
        proposedContentOffset.x = (currentIndex + 1)*self.itemSize.width;
    }
    return proposedContentOffset;
}
- (void)initItems {
    _numberOfCellsInSection = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
    _itemsY = [[NSMutableArray alloc] initWithCapacity:_numberOfCellsInSection];
    _itemsScale = [[NSMutableArray alloc] initWithCapacity:_numberOfCellsInSection];
    for (int i = 0; i < _numberOfCellsInSection; i ++) {
        CGFloat tempScale = (i >= _showPages)?((self.itemSize.width - 2*_itemMarginWidth)/self.itemSize.width):((self.itemSize.width - i*_itemMarginWidth)/self.itemSize.width);
        [_itemsScale addObject:@(tempScale)];
        
        CGFloat scalesHeight = (1 - tempScale)/2*(self.itemSize.height);

        CGFloat tempY = (i >= _showPages)?(2*_itemMarginHeight+scalesHeight):(i*_itemMarginHeight+scalesHeight);
        [_itemsY addObject:@(tempY)];
    }
}
@end
