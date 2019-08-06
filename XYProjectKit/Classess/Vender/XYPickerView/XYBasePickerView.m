//
//  XYBasePickerView.m
//  fula
//
//  Created by xiyedev on 2017/9/15.
//  Copyright © 2017年 ixiye company. All rights reserved.
//

#import "XYBasePickerView.h"

@interface XYBasePickerView () {
    UIView *_selectBackView;
}
@end

@implementation XYBasePickerView

-(void)layoutSubviews {
    [super layoutSubviews];
    if(self.subviews.count){
        [self updateSelectView];
    }
}

-(void)updateSelectView {

    //修改线条颜色
    UIView *line1 = self.subviews[1];
    line1.backgroundColor = [UIColor colorFromHexString:@"#c3e1f6"];;
    UIView *line2 = self.subviews[2];
    line2.backgroundColor = [UIColor colorFromHexString:@"#c3e1f6"];;
   
    //修改选中行的背景色
    for (UIView *subView in self.subviews) {
        if(subView.subviews.count){
            UIView *contentView = subView.subviews[0];
            for (UIView *contentSubView in contentView.subviews) {
                if(contentSubView.center.y == contentView.center.y){
                    if(_selectBackView != contentSubView){
                        _selectBackView.backgroundColor = [UIColor clearColor];
                        _selectBackView = contentSubView;
                        _selectBackView.backgroundColor = [UIColor colorFromHexString:@"#f3faff"];
                    }
                    break;
                }
            }
            break;
        }
    }
}

@end
