//
//  XYCalendarCollectionViewCell.m
//  fula
//
//  Created by 叶炯 on 2018/1/8.
//  Copyright © 2018年 ixiye company. All rights reserved.
//

#import "XYCalendarCollectionViewCell.h"

@implementation XYCalendarCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.contentBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.contentBtn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
}

- (IBAction)contentBtnClick:(UIButton *)sender {
    
    if (self.tapContentBtnBlock) {
        self.tapContentBtnBlock(sender);
    }
}

@end
