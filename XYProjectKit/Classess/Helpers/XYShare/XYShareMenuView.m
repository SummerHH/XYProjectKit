//
//  XYShareMenuView.m
//  LeRongRong
//
//  Created by xiaoye on 2018/10/25.
//  Copyright © 2018 Rong Zheng De. All rights reserved.
//

#import "XYShareMenuView.h"
#import "XYShareMenuBtnView.h"

#define BTN_WIDTH           60//按钮宽度
#define BTN_FRAME_X         10.0//按钮x开始坐标(距父视图左边距)
#define BTN_MINI_SPACE      5.0//按钮之间最小间距

static CGFloat const menuHeight = 300.0f;

@interface XYShareMenuView ()<XYShareMenuBtnViewDelegate>

@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) NSArray <NSDictionary *>*titleAndImages;
@property (nonatomic, assign, readwrite) NSInteger columnNum;/**< 按钮列数 */
@property (nonatomic, assign, readwrite) CGFloat animateTime;
@property (nonatomic, assign) CGSize btnViewSize;/**< 按钮视图大小 */
@property (nonatomic, assign) CGFloat btnFrameX;//按钮起始X坐标（以此为准）
@property (nonatomic, assign) CGFloat btnFrameY;//按钮起始Y坐标
@property (nonatomic, assign) CGFloat btnItemSpace;//按钮间距（与btnFrameX相同）
@property (nonatomic, assign) NSInteger btnRowNum;//按钮行数

@property (nonatomic, copy) shareMenuViewCallback completionBlock;

@property (nonatomic, strong) NSMutableArray <XYShareMenuBtnView *>*btnViewArray;
@end

@implementation XYShareMenuView

+ (instancetype)alertShareMenuButtonTitleAndImages:(NSArray<NSDictionary *> *)titleAndImages columnNums:(NSInteger)columnNum completion:(shareMenuViewCallback)completion {

    XYShareMenuView *menuView = [[XYShareMenuView alloc] initWithButtonTitleAndImages:titleAndImages columnNums:columnNum completion:completion];
    
    return menuView;
}

- (instancetype)initWithButtonTitleAndImages:(NSArray<NSDictionary *> *)titleAndImages columnNums:(NSInteger)columnNum completion:(shareMenuViewCallback)completion {

    if (self = [super init]) {
        
        NSInteger columnMaxNum = ((kScreenWidth - BTN_FRAME_X * 2.0 - BTN_MINI_SPACE * 2.0) / BTN_WIDTH);
        self.columnNum = (columnNum >= 3) ? columnNum : 3;
        self.columnNum = (columnNum <= columnMaxNum) ? columnNum : columnMaxNum;
        self.titleAndImages = titleAndImages;
        self.completionBlock = completion;
        self.alpha = 0.0f;
        self.animateTime = 0.6f;
        
        [self initialize];
    }
    
    return self;
}

- (void)initialize {
    
    self.frame = [UIScreen mainScreen].bounds;
    [self addSubview:self.menuView];
    
    _btnViewSize = CGSizeMake(BTN_WIDTH, BTN_WIDTH + 40.0);
    _btnRowNum = (self.titleAndImages.count + self.columnNum - 1) / self.columnNum;
    _btnFrameX = (self.menuView.width - BTN_WIDTH * self.columnNum) / (self.columnNum + 1);
    _btnFrameY = self.menuView.height / 2.0 - _btnViewSize.height * _btnRowNum / 2.0;
    _btnItemSpace = _btnFrameX;
    for (int i = 0; i < self.titleAndImages.count; i++) {
        NSString *titleStr = [[self.titleAndImages objectAtIndex:i] objectForKey:@"title"];
        NSString *imageStr = [[self.titleAndImages objectAtIndex:i] objectForKey:@"image"];
        XYShareMenuBtnView *btnView = [[XYShareMenuBtnView alloc] initWithFrame:CGRectMake(_btnFrameX + (_btnViewSize.width + _btnItemSpace) * (i % self.columnNum), self.menuView.height + (i / self.columnNum) * _btnViewSize.height, _btnViewSize.width, _btnViewSize.height)];
        btnView.delegate = self;
        btnView.btnImageView.image = [UIImage imageNamed:imageStr];
        btnView.btnTitleLabel.text = titleStr;
        btnView.sendViewButton.tag = i;
        [self.menuView addSubview:btnView];
        [self.btnViewArray addObject:btnView];
    }
}

#pragma mark ******  XYShareMenuBtnViewDelegate  *******

- (void)sendViewButtonClickCallblack:(UIButton *)sender {
    
    if (self.completionBlock) {
        XYShareMenuBtnView *btnView = (XYShareMenuBtnView *)sender.superview;
        self.completionBlock(btnView.sendViewButton.tag);
    }
    
    [self hideShareMenuView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   
    if (self.completionBlock) {
        self.completionBlock(-1);
    }
    
    if (self.btnViewArray.count == 0) {
        [self removeMenuViewFromSuperview];
    } else {
        [self hideShareMenuView];
    }
}

- (void)showShareMenuView {
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    self.alpha = 1.0f;
    self.menuView.alpha = 1.0f;
    CGFloat delyTime = 0.1;
    for (int i = 0; i < self.btnViewArray.count; i++) {
        __strong XYShareMenuBtnView *btnView = [self.btnViewArray objectAtIndex:i];
        if (i == self.btnViewArray.count - 1) {
            [UIView animateWithDuration:self.animateTime delay:delyTime * i usingSpringWithDamping:0.6 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                btnView.frame = CGRectMake(self->_btnFrameX + (self->_btnViewSize.width + self->_btnItemSpace) * (i % self.columnNum), self->_btnFrameY + (i / self.columnNum) * self->_btnViewSize.height, self->_btnViewSize.width, self->_btnViewSize.height);
            } completion:^(BOOL finished) {
                
            }];
            
        }else {
            
            [UIView animateWithDuration:self.animateTime delay:delyTime * i usingSpringWithDamping:0.6 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                btnView.frame = CGRectMake(self->_btnFrameX + (self->_btnViewSize.width + self->_btnItemSpace) * (i % self.columnNum), self->_btnFrameY + (i / self.columnNum) * self->_btnViewSize.height, self->_btnViewSize.width, self->_btnViewSize.height);
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

- (void)hideShareMenuView {
    
    CGFloat delyTime = 0.1;
    for (int i = 0; i < self.btnViewArray.count; i++) {
        __strong XYShareMenuBtnView *btnView = [self.btnViewArray objectAtIndex:i];
        if (i == self.btnViewArray.count - 1) {
            [UIView animateWithDuration:self.animateTime delay:delyTime * (self.btnViewArray.count - i - 1) usingSpringWithDamping:0.7 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                btnView.frame = CGRectMake(self->_btnFrameX + (self->_btnViewSize.width + self->_btnItemSpace) * (i % self.columnNum), self.frame.size.height + (i / self.columnNum) * self->_btnViewSize.height, self->_btnViewSize.width, self->_btnViewSize.height);
                
            } completion:^(BOOL finished) {
                //最后一个动画完成移除 view
                self.alpha = 0.f;
                [self removeFromSuperview];
            }];
            
        }else {
            
            [UIView animateWithDuration:self.animateTime delay:delyTime * (self.btnViewArray.count - i - 1) usingSpringWithDamping:0.7 initialSpringVelocity:0.2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                
                btnView.frame = CGRectMake(self->_btnFrameX + (self->_btnViewSize.width + self->_btnItemSpace) * (i % self.columnNum), self.frame.size.height + (i / self.columnNum) * self->_btnViewSize.height, self->_btnViewSize.width, self->_btnViewSize.height);
                
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

- (void)removeMenuViewFromSuperview {
    //最后一个动画完成移除 view
    self.alpha = 0.f;
    [self removeFromSuperview];
}

#pragma mark ******  lazy  *******
- (NSMutableArray<XYShareMenuBtnView *> *)btnViewArray {

    if (!_btnViewArray) {
        _btnViewArray = [NSMutableArray new];
    }
    return _btnViewArray;
}

- (UIView *)menuView {
    if (!_menuView) {
        _menuView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - menuHeight, kScreenWidth, menuHeight)];
        _menuView.alpha = 1.0f;
        _menuView.backgroundColor = RGBACOLOR(0, 0, 0, 0.8f);
    }
    return _menuView;
}

@end
