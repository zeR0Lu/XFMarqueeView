//
//  XFMarqueeView.m
//  跑马灯
//
//  Created by zeroLu on 16/11/17.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import "XFMarqueeView.h"
#import "XFMarqueeViewCell.h"

@interface XFMarqueeView ()
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, weak) NSTimer *timer;

@end

@implementation XFMarqueeView

+ (instancetype)makeViewWithFrame:(CGRect)frame titles:(NSArray *)titles {
    XFMarqueeView *view = [[XFMarqueeView alloc] initWithFrame:frame];
    view.titles = titles;
    
    [view setupUI];
    return view;
}

- (void)setupUI {
    
    for (int i = 0; i < 100; i++) {
        for (int j = 0; j < self.titles.count; j++) {
            [self.dataArray addObject:@(j)];
        }
    }
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = self.frame.size;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.alwaysBounceHorizontal = YES;
    self.collectionView.alwaysBounceVertical = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"XFMarqueeViewCell'" bundle:nil] forCellWithReuseIdentifier:@"XFMarqueeViewCell"];       // 注册 cell 重用
    [self addSubview:self.collectionView];
}

#pragma mark - UICollectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"XFMarqueeViewCell";
    
    XFMarqueeViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSInteger index = [self.dataArray[indexPath.item] integerValue];
    
    cell.titleLabel.text = self.titles[index];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - 
#pragma mark -
- (void)setupTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)automaticScroll
{
    NSArray *array = [self.collectionView indexPathsForVisibleItems];
    if (array.count == 0) return ;
    
    NSIndexPath *indexPath = array[0];
    NSInteger item = indexPath.item;
    
    if (item % self.dataArray.count == 0) {
        item = 50 * self.dataArray.count;         // 重新定位
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:item + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

- (NSInteger)currentIndex {
    
    NSInteger index = (self.collectionView.contentOffset.y + CGRectGetHeight(self.frame) * 0.5) / CGRectGetHeight(self.frame);
    return MAX(0, index);
}

#pragma mark - lazy
- (NSMutableArray *)dataArray {
    if ( !_dataArray ) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
