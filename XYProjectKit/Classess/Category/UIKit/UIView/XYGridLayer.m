//
//  XYGridLayer.m
//  fula
//
//  Created by cby on 2017/4/12.
//  Copyright © 2017年 ixiye company. All rights reserved.
//

#import "XYGridLayer.h"

@interface XYGridLayer ()

@property (assign, nonatomic, readwrite) XYGridType type;

@end

@implementation XYGridLayer

- (instancetype)initWithType:(XYGridType)type color:(UIColor *)color
{
    self = [super init];
    if(self)
    {
        self.type = type;
        self.backgroundColor = color.CGColor;
        switch (type) {
            case XYGridTypeBottom:
            case XYGridTypeTop:
                self.offset = @(0);
                break;
            case XYGridTypeRight:
            case XYGridTypeLeft:
                self.offset = @(5);
                break;
            default:
                self.offset = @(0);
                break;
        }
    }
    return self;
}

- (void)layoutWithSuperViewFrame:(CGRect)frame
{
    CGFloat defaultLineWidth = 1.0f;
    CGFloat defaultLineWidthOffset = 1.0f;
    if(self.lineWidth) {
        defaultLineWidth = self.lineWidth.floatValue;
        if(defaultLineWidth == SINGLE_LINE_WIDTH)
            defaultLineWidthOffset = SINGLE_LINE_ADJUST_OFFSET;
        else
            defaultLineWidthOffset = self.lineWidth.floatValue;
    }
    switch (self.type) {
        case XYGridTypeTop: {
            self.frame = CGRectMake(_offset.floatValue, 0, frame.size.width - _offset.floatValue * 2, defaultLineWidth);
        }
            break;
        case XYGridTypeLeft: {
            self.frame = CGRectMake(0, _offset.floatValue, defaultLineWidth, frame.size.height - _offset.floatValue * 2);
        }
            break;
        case XYGridTypeRight: {
            self.frame = CGRectMake(frame.size.width - defaultLineWidthOffset, _offset.floatValue, defaultLineWidth, frame.size.height - 2 * _offset.floatValue);
        }
            break;
        case XYGridTypeBottom: {
            self.frame = CGRectMake(_offset.floatValue, frame.size.height - defaultLineWidthOffset, frame.size.width - _offset.floatValue * 2, defaultLineWidth);
        }
            break;
        case XYGridTypeBottomOffsetLefit: {
            self.frame = CGRectMake(_offset.floatValue, frame.size.height - defaultLineWidthOffset, frame.size.width - _offset.floatValue, defaultLineWidth);
        }
            break;
        case XYGridTypeBottomOffsetRight: {
            self.frame = CGRectMake(0, frame.size.height - defaultLineWidthOffset, frame.size.width - _offset.floatValue, defaultLineWidth);
        }
            break;
        case XYGridTypeBottomFrame: {
            
            self.frame = CGRectMake(_leftOffset.floatValue, frame.size.height - defaultLineWidthOffset - _offset.floatValue, frame.size.width - _leftOffset.floatValue - _rightOffset.floatValue, defaultLineWidth);
        }
            break;
        default:
            break;
    }
}
@end
