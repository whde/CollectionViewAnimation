//
//  ViewController.m
//  CollectionViewAnimation
//
//  Created by whde on 2018/7/7.
//  Copyright © 2018年 whde. All rights reserved.
//

#import "ViewController.h"
#import "WhdeCollectionViewLayout.h"
@interface ViewController ()
@property (strong, nonatomic) UICollectionView *collectionView;
@property (assign, nonatomic) NSInteger currentIndex; // 当前Index
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    WhdeCollectionViewLayout *cardLayout = [WhdeCollectionViewLayout new];
    cardLayout.itemSize = CGSizeMake(300, 300);
    cardLayout.itemMarginWidth = 30;
    cardLayout.itemMarginHeight = 8;
    cardLayout.showPages = 3;
    cardLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    cardLayout.minimumLineSpacing = 30;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 300, 300) collectionViewLayout:cardLayout];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView.layer.masksToBounds = NO;
    self.collectionView.dataSource = (id)self;
    self.collectionView.delegate = (id)self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.bounces = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.view addSubview:self.collectionView];
    self.collectionView.center = self.view.center;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    UIImageView *imageV = [cell.contentView viewWithTag:100];
    if (!imageV) {
        imageV = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        imageV.layer.masksToBounds = YES;
        imageV.tag = 100;
        [cell.contentView addSubview:imageV];
        imageV.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.png", (long)indexPath.row]];
    return cell;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    UICollectionView *collectionView = (UICollectionView *)scrollView;
    CGFloat cellWidth = 300;
    CGFloat cellPadding = ((UICollectionViewFlowLayout *)collectionView.collectionViewLayout).minimumLineSpacing;
    NSInteger page = roundf(targetContentOffset->x/(cellWidth+cellPadding));
    if (self.currentIndex==page) {
        if (velocity.x > 0) {
            page++;
        } else if (velocity.x < 0){
            page--;
        }
    } else if (page>self.currentIndex) {
        page = self.currentIndex+1;
    } else {
        page = self.currentIndex-1;
    }
    page = MAX(page,0);
    page = MIN(page, 9-1);
    CGFloat newOffset = page * (cellWidth + cellPadding)-collectionView.contentInset.left;
    targetContentOffset->x = newOffset;
    self.currentIndex = page;
}
@end
