//
//  ViewController.m
//  跑马灯
//
//  Created by zeroLu on 16/11/17.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import "ViewController.h"
#import "XFMarqueeViewCell.h"

#define itemHeight 44.0

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *cellData;

@property (nonatomic, assign) NSInteger totalItemsCount;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = @[@"1、库里43分，勇士吊打骑士",@"2、伦纳德死亡缠绕詹姆斯，马刺大胜骑士",@"3、乐福致命失误，骑士惨遭5连败",@"4、五小阵容发威，雄鹿吊打骑士", @"5、天猫的双十一，然而并没卵用"];
    
    self.cellData = [[NSMutableArray alloc] init];
    for (int i=0; i<100; i++) {
        for (int j=0; j<self.dataArray.count; j++) {
            [self.cellData addObject:@(j)];
        }
    }
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"XFMarqueeViewCell" bundle:nil] forCellWithReuseIdentifier:@"XFMarqueeViewCell"];
    
    [self setupTimer];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cellData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"XFMarqueeViewCell";
    
    XFMarqueeViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    NSInteger index = [self.cellData[indexPath.item] integerValue];

    cell.titleLabel.text = self.dataArray[index];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(collectionView.frame), itemHeight);
}

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
    
    NSInteger index = (self.collectionView.contentOffset.y + itemHeight * 0.5) / itemHeight;
    return MAX(0, index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
