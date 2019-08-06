//
//  XYColorBackView.m
//  fula
//
//  Created by xiyedev on 2017/9/16.
//  Copyright © 2017年 ixiye company. All rights reserved.
//

#import "XYColorBackView.h"

@implementation XYColorBackView

- (UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width,kTopHeight)];
        _topView.backgroundColor = [UIColor clearColor];
    }
    return _topView;
}

- (UIView *)backColorView
{
    if (!_backColorView) {
        _backColorView = [[UIView alloc]initWithFrame:CGRectMake(0,kTopHeight, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height - kTopHeight)];
    }
    return _backColorView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.topView];
        [self addSubview:self.backColorView];
    }
    return self;
}
@end
