//
//  XYAlertSheetView.m
//  XYAlertViewDemo
//
//  Created by 叶炯 on 2017/12/23.
//  Copyright © 2017年 ixiyedev. All rights reserved.
//

#import "XYAlertSheetView.h"
#import "XYAlertSheetTableViewCell.h"


#pragma make - XYAlertWindow -

@interface XYAlertWindow : UIWindow

/** Alert背景视图风格 */
@property (nonatomic, assign) XYAlertSheetViewBackgroundStyle style;

@end

@implementation XYAlertWindow

- (instancetype)initWithFrame:(CGRect)frame withStyle:(XYAlertSheetViewBackgroundStyle)style {
    if (self = [super initWithFrame:frame]) {
        
        self.style = style;
        self.opaque = NO;
        self.windowLevel = UIWindowLevelAlert;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    switch (self.style) {
        case XYAlertViewBackgroundStyleGradient: {
            size_t locationsCount = 2; // unsigned long
            CGFloat locations[2] = {0.0f, 1.0f};
            CGFloat colors[8] = {0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.75f};
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
            CGColorSpaceRelease(colorSpace);
            
            CGPoint center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5);
            CGFloat radius = MIN(kScreenWidth, kScreenHeight) ;
            CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
            CGGradientRelease(gradient);
            
        }
            break;
        case XYAlertViewBackgroundStyleSolid: {
            [[[UIColor blackColor] colorWithAlphaComponent:0.3] set];
            CGContextFillRect(context, self.bounds);
        }
            break;
    }
}

@end

#pragma make - XYAlertSheetViewController -
@interface XYAlertSheetViewController : UIViewController

@property (nonatomic, assign) BOOL allowRotation;

@end

@implementation XYAlertSheetViewController

- (instancetype)initWithAllowRotation:(BOOL)allowRotation {

    if (self = [super init]) {
        self.allowRotation = allowRotation;
    }
    return self;
}

- (BOOL)shouldAutorotate {

    return self.allowRotation;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.allowRotation) {
        return UIInterfaceOrientationMaskAll;
    }
    
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end

#pragma make - XYAlertSheetView -

/** 默认 52.0f */
static CGFloat rowHeight = 49.0f;

static NSString *XYAlertSheetTableViewCellIdentifier = @"XYAlertSheetTableViewCellIdentifier";

@interface XYAlertSheetView() <UITableViewDelegate, UITableViewDataSource>
/** 是否动画 */
@property (nonatomic, assign, getter = isAlertAnimating) BOOL alertAnimating;
/** 是否可见 */
@property (nonatomic, assign, getter = isVisible) BOOL visible;
/** ActionSheet模式最多2行 */
@property (nonatomic, copy) NSString *title;
/** 取消按钮 */
@property (nonatomic, copy) NSString *cancelButtonTitle;
/** 存放按钮 */
@property (nonatomic, strong) NSArray <NSString *> *otherButtonTitles;
/** 存放按钮图标 */
@property (nonatomic, strong) NSArray <NSString *> *otherButtonImages;
/** 展示的背景Window */
@property (nonatomic, strong) XYAlertWindow *alertWindow;
/** 背景视图 */
@property (nonatomic, strong) UIControl *cancelControl;
/** 容器视图 */
@property (nonatomic, strong) UIView *containerView;
/** 毛玻璃视图 */
@property (nonatomic, strong) UIVisualEffectView *effectView;
/** 可见视图 */
@property (nonatomic, strong) UITableView *tableView;
/** 标题视图*/
@property (nonatomic, strong) UIView *titleView;
/** 尾部视图*/
@property (nonatomic, strong) UIView *footView;
/** 标题*/
@property (nonatomic, strong) UILabel *titleLab;
/** 取消按钮*/
@property (nonatomic, strong) UIButton *cancelBtn;

@end

@implementation XYAlertSheetView

+ (XYAlertSheetView *)showAlertViewWithTitle:(NSString *)title
                       cancelButtonTitle:(NSString *)cancelButtonTitle
                       otherButtonImages:(NSArray <NSString *>*)otherButtonImages
                       otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles
                                 handler:(void (^)(XYAlertSheetView *alertView, NSInteger buttonIndex))block {

    XYAlertSheetView *alertSheetView = [XYAlertSheetView showAlertViewWithTitle:title cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles handler:block];
    alertSheetView.otherButtonImages = otherButtonImages;

    return alertSheetView;
    
}

+ (XYAlertSheetView *)showAlertViewWithTitle:(NSString *)title
                           cancelButtonTitle:(NSString *)cancelButtonTitle
                           otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles
                                     handler:(void (^)(XYAlertSheetView *alertView, NSInteger buttonIndex))block {
    
    XYAlertSheetView *alertSheetView = [[XYAlertSheetView alloc] init];
    alertSheetView.title = title;
    alertSheetView.cancelButtonTitle = cancelButtonTitle;
    alertSheetView.otherButtonTitles = otherButtonTitles;
    
    if (!XYStringIsEmpty(cancelButtonTitle)) {
        alertSheetView.cancelHandler = ^(XYAlertSheetView *alertSheetView, NSInteger buttonIndex) {
          
            if (block) {
                block(alertSheetView, buttonIndex);
            }
        };
    }
    
    if (otherButtonTitles.count != 0) {
        alertSheetView.defulHandler = ^(XYAlertSheetView *alertSheetView, NSInteger buttonIndex) {
            
            if (block) {
                block(alertSheetView, buttonIndex);
            }
        };
    }
   
    [alertSheetView show];
    
    return alertSheetView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    
        self.frame = kScreenMainBounds;
        
        [self createSubViews];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)supportRotating {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)statusBarOrientationChange:(NSNotification *)notification {
    self.frame = kScreenMainBounds;
    [self updateSubviewsFrame];
}

- (void)show {
    
    if (self.isVisible) return;
    if (self.isAlertAnimating) return;
    
    weakSelf(weakSelf)
   
    self.visible = YES;
    self.alertAnimating = YES;
    
    [self.alertWindow.rootViewController.view addSubview:self];
    [self.alertWindow makeKeyAndVisible];

    [self updateSubviewsFrame]; //布局
    
    [self transitionInCompletion:^{
    
        weakSelf.alertAnimating = NO;
    }];
    
    //支持旋转
    [self supportRotating];
    
}

- (void)removeAlertView {
    
    [self dismissAnimated:YES];
}

- (void)dismissAnimated:(BOOL)animated {
    
    [self dismissAnimated:animated cleanup:YES];
}

/**
 *  撤销弹窗提示
 *
 *  @param animated 是否动画
 *  @param cleanup  是否清除
 */
- (void)dismissAnimated:(BOOL)animated cleanup:(BOOL)cleanup {
 
    BOOL isVisible = self.isVisible;
    weakSelf(weakSelf)

    void (^dismissComplete)(void) = ^{
        weakSelf.visible = NO;
        weakSelf.alertAnimating = NO;
        [self removeView];
    };
    
    if (animated && isVisible) {
        self.alertAnimating =  YES;
        [self transitionOutCompletion:dismissComplete];
    } else {
        dismissComplete();
    }
}

- (void)removeView {
    [UIView animateWithDuration:0.25 animations:^{
        self.alertWindow.alpha = 0.01;
    } completion:^(BOOL finished) {
        [self.alertWindow removeFromSuperview];
        self.alertWindow = nil;
        [self removeAllSubviews];
        [self removeFromSuperview];
        
        [XYFirstWindow makeKeyAndVisible];
    }];
}

- (void)removeAllSubviews {
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

#pragma mark - Transitions动画
/**
 *  进入的动画
 */
- (void)transitionInCompletion:(void(^)(void))completion {
    CGFloat duration = 0.25;
    
    [UIView animateWithDuration:duration animations:^{
        self.alertWindow.alpha = 1.0;
    }];
  
    CGRect rect = self.containerView.frame;
    CGRect originalRect = rect;
    rect.origin.y = self.frame.size.height;
    self.containerView.frame = rect;
            
    [UIView animateWithDuration:duration animations:^{
        
        self.containerView.frame = originalRect;
        
    } completion:^(BOOL finished) {
        
        if (completion) {
            completion();
        }
    }];
}

/**
 *  消失的动画
 */
- (void)transitionOutCompletion:(void(^)(void))completion {
    CGFloat duration = 0.25;
    
    CGRect rect = self.containerView.frame;
    rect.origin.y = self.frame.size.height;
            
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.containerView.frame = rect;
    } completion:^(BOOL finished) {
        
        if (completion) {
            completion();
        }
    }];
}

#pragma - eventAction -
- (void)onAlertWindow {
    
    [self dismissAnimated:YES];
}

- (void)cancelBtnClick:(UIButton *)sender {
    
    if (self.defulHandler) {
        self.defulHandler(self, 0);
    }
    [self dismissAnimated:YES];
}

#pragma make - UITableViewDataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.otherButtonTitles.count == 0 ? 0 : self.otherButtonTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.otherButtonImages.count >0 ) {
        static NSString *sheetViewCell = @"sheetViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sheetViewCell];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sheetViewCell];
        }
        cell.textLabel.text = self.otherButtonTitles[indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
        if (self.otherButtonImages.count == self.otherButtonTitles.count) {
            
            cell.imageView.image = [UIImage imageNamed:self.otherButtonImages[indexPath.row]];
        }
        return cell;
    }
    else {
        XYAlertSheetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XYAlertSheetTableViewCellIdentifier forIndexPath:indexPath];
        cell.titleLab.text = self.otherButtonTitles[indexPath.row];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.alertAnimating = YES;
    if (self.defulHandler) {
        self.defulHandler(self, indexPath.row + 1);
    }
  
    [self dismissAnimated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //设置separatorInset(iOS7之后)
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    //设置layoutMargins(iOS8之后)
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - 布局

- (void)updateSubviewsFrame {
    
    /** 容器视图 */
    CGFloat containerViewH = 0.0f;
    
    CGFloat titleHeight = 0.0f;
    CGFloat footViewHeight = 0.0f;
    CGFloat rowCountHeight = 0.0f;
    
    CGFloat margin = 25.0;
    CGFloat titleLabelW = kScreenWidth - margin * 2;
    
    if (!XYStringIsEmpty(self.title)) {
        //标题文字默认15.0f;
        CGSize titleLabelSize = [self heightOfStringRect:self.title sizeWithSystemFont:[UIFont systemFontOfSize:17.0f] constrainedToSize:CGSizeMake(titleLabelW, MAXFLOAT)];
        titleHeight = titleLabelSize.height;
        
        titleHeight = titleHeight < rowHeight ? rowHeight : (titleHeight + 20);
        
        self.titleLab.frame = CGRectMake(0, 0, kScreenWidth, titleHeight - 0.5f);
        self.titleLab.text = self.title;
        [self.titleView addSubview:self.titleLab];
        
    }
    
    if (!XYStringIsEmpty(self.cancelButtonTitle)) {
        
        if (isIPhoneNotchScreen()) {
            footViewHeight = rowHeight + 10 + kTabBarBottomHeight;
        }
        else {
            footViewHeight = rowHeight + 10;
        }
        [self.cancelBtn setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
        
        self.cancelBtn.frame = CGRectMake(0, 10, kScreenWidth, rowHeight);
        [self.footView addSubview:self.cancelBtn];
    }
    
    if (self.otherButtonTitles.count != 0) {
        rowCountHeight = rowHeight * self.otherButtonTitles.count;
    }
    
    self.titleView.frame = CGRectMake(0, 0, kScreenWidth, titleHeight);
    containerViewH = titleHeight + footViewHeight + rowCountHeight;
    CGFloat containerViewX = 0;
    CGFloat containerViewY = kScreenHeight - containerViewH;
    
    //当Y < 100 时, tableView 可以滑动,否则展示全部
    if (containerViewY > 100) {
        self.containerView.frame = CGRectMake(containerViewX, containerViewY, kScreenWidth, containerViewH);
        self.tableView.scrollEnabled = NO;
        self.tableView.frame = CGRectMake(0, self.titleView.bottom, kScreenWidth, rowCountHeight);
    }
    else {
        self.containerView.frame = CGRectMake(containerViewX, 100, kScreenWidth, kScreenHeight - 100);
        self.tableView.scrollEnabled = YES;
        self.tableView.frame = CGRectMake(0, self.titleView.bottom, kScreenWidth, kScreenHeight - 100 - titleHeight - footViewHeight);
    }
    self.footView.frame = CGRectMake(0, self.tableView.bottom, kScreenWidth, footViewHeight);

    self.effectView.frame = self.containerView.bounds;
}

- (CGSize)heightOfStringRect:(NSString *)message sizeWithSystemFont:(UIFont *)font constrainedToSize:(CGSize)size {
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary *attributes = @{NSFontAttributeName : font,
                                 NSParagraphStyleAttributeName : paragraphStyle};
    CGRect rect = [message boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return CGSizeMake(ceil(rect.size.width), ceil(rect.size.height));
    
}

#pragma mark - 视图相关
- (void)createSubViews {
    
    [self addSubview:self.cancelControl];

    /** 容器视图 */
    [self addSubview:self.containerView];
    /** 毛玻璃视图 */
    [self.containerView addSubview:self.effectView];
    /** 可见视图 */
    [self.containerView addSubview:self.titleView];

    [self.containerView addSubview:self.tableView];
    
    [self.containerView addSubview:self.footView];

}

- (void)setBackgroundStyle:(XYAlertSheetViewBackgroundStyle)backgroundStyle {
    _backgroundStyle = backgroundStyle;
}

- (void)setButtonType:(XYSheetViewCancelButtonType)buttonType {
    _buttonType = buttonType;
    if (_buttonType == XYAlertViewButtonTypeDefault) {
        [self.cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else if (_buttonType == XYAlertViewButtonTypeDestructive) {
        [self.cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    else if (_buttonType == XYAlertViewButtonTypeCancel) {
        
        [self.cancelBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
}

#pragma - lazy -
- (XYAlertWindow *)alertWindow {
    
    if (!_alertWindow) {
        _alertWindow = [[XYAlertWindow alloc] initWithFrame:kScreenMainBounds withStyle:self.backgroundStyle];
        _alertWindow.rootViewController = [[XYAlertSheetViewController alloc] initWithAllowRotation:YES];
        _alertWindow.alpha = 0.01;
    }
    return _alertWindow;
}

- (UIControl *)cancelControl {
    if (!_cancelControl) {
        _cancelControl = [[UIControl alloc] initWithFrame:self.bounds];
        [_cancelControl addTarget:self action:@selector(removeAlertView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelControl;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    }
    return _effectView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [UIColor colorWithRed:236/255.0f green:236/255.0f blue:237/255.0f alpha:1.0f];
        _tableView.bounces = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollsToTop = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"XYAlertSheetTableViewCell" bundle:nil] forCellReuseIdentifier:XYAlertSheetTableViewCellIdentifier];
    }
    return _tableView;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = [UIColor colorWithRed:236/255.0f green:236/255.0f blue:237/255.0f alpha:1.0f];
    }
    return _titleView;
}

- (UIView *)footView {
    if (!_footView) {
        _footView = [[UIView alloc] init];
        _footView.backgroundColor = [UIColor colorWithRed:236/255.0f green:236/255.0f blue:237/255.0f alpha:1.0f];
    }
    return _footView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_cancelBtn setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1.0f]] forState:UIControlStateHighlighted];
    }
    return _cancelBtn;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.numberOfLines = 0;
        _titleLab.backgroundColor = [UIColor whiteColor];
        _titleLab.font = [UIFont systemFontOfSize:17.0f];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}

//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
