//
//  XYWordItem.m
//  XYProjectKit
//
//  Created by xiaoye on 2020/4/4.
//  Copyright © 2020 JiongYe. All rights reserved.
//

#import "XYWordItem.h"

@implementation XYWordItem

+ (instancetype)itemWithTitle:(NSString *)title subTitle:(NSString *)subTitle {
    XYWordItem *item = [[self alloc] init];
    item.subTitle = subTitle;
    item.title = title;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title subTitle:(NSString *)subTitle itemOperation:(void(^)(NSIndexPath *indexPath))itemOperation {
    XYWordItem *item = [self itemWithTitle:title subTitle:subTitle];
    item.itemOperation = itemOperation;
    return item;
}

- (instancetype)init {
    if (self = [super init]) {
        _titleColor = [UIColor blackColor];
        _subTitleColor = [UIColor blackColor];
//        _cellHeight = AdaptedWidth(50);
        _titleFont = AdaptedFontSize(16);
        _subTitleFont = AdaptedFontSize(16);
        _subTitleNumberOfLines = 2;
    }
    
    return self;
}

- (CGFloat)cellHeight {
    if (!_cellHeight) {
        _cellHeight += 20;
        NSString *totalString = [NSString stringWithFormat:@"%@%@", self.title, self.subTitle];
        _cellHeight += [totalString boundingRectWithSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT) options:0 attributes:@{NSFontAttributeName : self.subTitleFont} context:nil].size.height;
        _cellHeight = MAX(_cellHeight, 50);
        _cellHeight = AdaptedWidth(_cellHeight);
    }
    return _cellHeight;
}

@end
