//
//  XYCalendarPickerView.m
//  fula
//
//  Created by 叶炯 on 2018/1/8.
//  Copyright © 2018年 ixiye company. All rights reserved.
//

#import "XYCalendarPickerView.h"
#import "XYCalendarCollectionViewCell.h"

static NSString *const XYCalendarCollectionViewCellIdentifier = @"XYCalendarCollectionViewCellIdentifier";

@interface XYCalendarPickerView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray  *dataSource;
@property (nonatomic, copy) XYCalendarResultBlock resultBlock;
// 选中的项
@property (nonatomic, strong) NSNumber *selectedItem;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation XYCalendarPickerView

+ (void)showCalendarPickerWithTitle:(NSString *)title
                         dataSource:(NSArray *)dataSource
                    defaultSelValue:(NSNumber *)defaultSelValue
                        resultBlock:(XYCalendarResultBlock)resultBlock {
    
    if (dataSource == nil || dataSource.count == 0) {
        return;
    }
    XYCalendarPickerView *calendarPickerView = [[XYCalendarPickerView alloc] initWithTitle:title dataSource:dataSource defaultSelValue:defaultSelValue resultBlock:resultBlock];
    
    [calendarPickerView showWithAnimation:YES];
    
}

#pragma mark - 初始化自定义字符串选择器
- (instancetype)initWithTitle:(NSString *)title
                   dataSource:(NSArray *)dataSource
              defaultSelValue:(NSNumber *)defaultSelValue
                  resultBlock:(XYCalendarResultBlock)resultBlock {
    if (self = [super init]) {
        self.title = title;
        self.dataSource = dataSource;
        self.resultBlock = resultBlock;
        self.selectedItem = defaultSelValue;
        
        [self initUI];
        
    }
    return self;
}

#pragma mark - 初始化子视图
- (void)initUI {
    [super initUI];
    self.titleLabel.text = self.title;
    // 添加字符串选择器
    [self.alertView addSubview:self.collectionView];
    [self.collectionView reloadData];
}

#pragma mark - 背景视图的点击事件
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender {
    [self dismissWithAnimation:NO];
}

#pragma mark - 弹出视图方法
- (void)showWithAnimation:(BOOL)animation {
    //1. 获取当前应用的主窗口
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:self];
    if (animation) {
        // 动画前初始位置
        CGRect rect = self.alertView.frame;
        rect.origin.y = SCREEN_HEIGHT;
        self.alertView.frame = rect;
        
        // 浮现动画
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.alertView.frame;
            if (isIPhoneNotchScreen()) {
                rect.origin.y -= kDatePicHeight + kTopViewHeight + kTabBarBottomHeight;
            }else {
                rect.origin.y -= kDatePicHeight + kTopViewHeight;
            }
            self.alertView.frame = rect;
        }];
    }
}

#pragma mark - 关闭视图方法
- (void)dismissWithAnimation:(BOOL)animation {
    // 关闭动画
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.alertView.frame;
        if (isIPhoneNotchScreen()) {
            rect.origin.y += kDatePicHeight + kTopViewHeight + kTabBarBottomHeight;
        }else {
            rect.origin.y += kDatePicHeight + kTopViewHeight;
        }
        self.alertView.frame = rect;
        
        self.backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.leftBtn removeFromSuperview];
        [self.rightBtn removeFromSuperview];
        [self.titleLabel removeFromSuperview];
        [self.lineView removeFromSuperview];
        [self.topView removeFromSuperview];
        [self.collectionView removeFromSuperview];
        [self.alertView removeFromSuperview];
        [self.backgroundView removeFromSuperview];
        [self removeFromSuperview];
        
        self.leftBtn = nil;
        self.rightBtn = nil;
        self.titleLabel = nil;
        self.lineView = nil;
        self.topView = nil;
        self.collectionView = nil;
        self.alertView = nil;
        self.backgroundView = nil;
    }];
}

#pragma mark - 取消按钮的点击事件
- (void)clickLeftBtn {
    [self dismissWithAnimation:YES];
}

#pragma mark - CollectionDataSource -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XYCalendarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XYCalendarCollectionViewCellIdentifier forIndexPath:indexPath];
    
    NSString *numberString = self.dataSource[indexPath.item];
    
    [cell.contentBtn setTitle:numberString forState:UIControlStateNormal];
    
    cell.tapContentBtnBlock = ^(UIButton *sender) {
        
        self.resultBlock(numberString);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissWithAnimation:YES];
        });

    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    for (NSInteger i = 0; i < self.dataSource.count; i++) {
        if (self.selectedItem.integerValue == indexPath.row) {
            
        }
    }
    
}
#pragma mark - lazy -

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat width = kScreenWidth  / 7.0;
        flowLayout.itemSize = CGSizeMake(width, 44.0f);
        flowLayout.minimumLineSpacing = 0.0f;
        flowLayout.minimumInteritemSpacing = 0.0f;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kTopViewHeight + 0.5, SCREEN_WIDTH, kDatePicHeight) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"XYCalendarCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:XYCalendarCollectionViewCellIdentifier];
    }
    return _collectionView;
}

@end
