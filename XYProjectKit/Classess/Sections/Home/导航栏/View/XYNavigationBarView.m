//
//  XYNavigationBarView.m
//  XYProjectKit
//
//  Created by xiaoye on 2020/4/5.
//  Copyright © 2020 JiongYe. All rights reserved.
//

#import "XYNavigationBarView.h"

@implementation XYNavigationBarView

- (instancetype)initWithFrame:(CGRect)frame {

    if ([super initWithFrame:frame]) {
        
        [self initialization];
    }
    
    return self;
}

- (void)initialization {
    
    self.backgroundColor = kRandColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
