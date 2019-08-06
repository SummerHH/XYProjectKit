//
//  XYNewFeatureCollectionViewCell.h
//  fula
//
//  Created by xiyedev on 2017/8/7.
//  Copyright © 2017年 ixiye company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYNewFeatureViewController.h"

@interface XYNewFeatureCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;

// 判断是否是最后一页
- (void)setIndexPath:(NSIndexPath *)indexPath count:(NSInteger)count;

@end
