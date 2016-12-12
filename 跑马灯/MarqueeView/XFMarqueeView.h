//
//  XFMarqueeView.h
//  跑马灯
//
//  Created by zeroLu on 16/11/17.
//  Copyright © 2016年 zeroLu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XFMarqueeView : UIView <UICollectionViewDelegate,UICollectionViewDataSource>

+ (instancetype)makeViewWithFrame:(CGRect)frame titles:(NSArray *)titles;

@end
