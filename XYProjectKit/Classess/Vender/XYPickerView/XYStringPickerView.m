//
//  XYStringPickerView.m
//  XYPIckerView
//
//  Created by xiyedev on 2017/9/14.
//  Copyright © 2017年 YeJiong. All rights reserved.
//

#import "XYStringPickerView.h"
#import "XYBasePickerView.h"

@interface XYStringPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
// 字符串选择器(默认大小: 320px × 216px)
@property (nonatomic, strong) XYBasePickerView *pickerView;
// 是否是单列
@property (nonatomic, assign) BOOL isSingleColumn;
// 数据源是否合法（数组的元素类型只能是字符串或数组类型）
@property (nonatomic, assign) BOOL isDataSourceValid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray  *dataSource;
// 是否开启自动选择
@property (nonatomic, assign) BOOL isAutoSelect;
@property (nonatomic, copy) XYStringResultBlock resultBlock;
// 单列选中的项
@property (nonatomic, copy) NSString *selectedItem;
// 多列选中的项
@property (nonatomic, strong) NSMutableArray *selectedItems;
// 选中的行
//@property (nonatomic, assign) NSInteger selectRow;

@end

@implementation XYStringPickerView

#pragma mark - 显示自定义字符串选择器
+ (void)showStringPickerWithTitle:(NSString *)title
                       dataSource:(NSArray *)dataSource
                  defaultSelValue:(id)defaultSelValue
                     isAutoSelect:(BOOL)isAutoSelect
                      resultBlock:(XYStringResultBlock)resultBlock {
    if (dataSource == nil || dataSource.count == 0) {
        return;
    }
    XYStringPickerView *strPickerView = [[XYStringPickerView alloc]initWithTitle:title dataSource:dataSource defaultSelValue:defaultSelValue isAutoSelect:isAutoSelect resultBlock:resultBlock];
    [strPickerView showWithAnimation:YES];
}

#pragma mark - 显示自定义字符串选择器
+ (void)showStringPickerWithTitle:(NSString *)title
                        plistName:(NSString *)plistName
                  defaultSelValue:(id)defaultSelValue
                     isAutoSelect:(BOOL)isAutoSelect
                      resultBlock:(XYStringResultBlock)resultBlock {
    if (plistName == nil || plistName.length == 0) {
        return;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    NSArray *dataSource =[[NSArray alloc] initWithContentsOfFile:path];
    XYStringPickerView *strPickerView = [[XYStringPickerView alloc]initWithTitle:title dataSource:dataSource defaultSelValue:defaultSelValue isAutoSelect:isAutoSelect resultBlock:resultBlock];
    [strPickerView showWithAnimation:YES];
}


#pragma mark - 初始化自定义字符串选择器
- (instancetype)initWithTitle:(NSString *)title
                   dataSource:(NSArray *)dataSource
              defaultSelValue:(id)defaultSelValue
                 isAutoSelect:(BOOL)isAutoSelect
                  resultBlock:(XYStringResultBlock)resultBlock {
    if (self = [super init]) {
        self.title = title;
        self.dataSource = dataSource;
        self.isAutoSelect = isAutoSelect;
        self.resultBlock = resultBlock;
        
        if (defaultSelValue) {
            if ([defaultSelValue isKindOfClass:[NSString class]]) {
                self.selectedItem = defaultSelValue;
            } else if ([defaultSelValue isKindOfClass:[NSArray class]]){
                self.selectedItems = [defaultSelValue mutableCopy];
            }
        }
        
        [self loadData];
        [self initUI];
    }
    return self;
}

#pragma mark - 初始化子视图
- (void)initUI {
    [super initUI];
    self.titleLabel.text = self.title;
    // 添加字符串选择器
    [self.alertView addSubview:self.pickerView];
}

#pragma mark - 加载自定义字符串数据
- (void)loadData {
    if (self.dataSource == nil || self.dataSource.count == 0) {
        self.isDataSourceValid = NO;
        return;
    } else {
        self.isDataSourceValid = YES;
    }
    
    __weak typeof(self) weakSelf = self;
    // 遍历数组元素 (遍历多维数组一般用这个方法)
    [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        static Class itemType;
        if (idx == 0) {
            itemType = [obj class];
            // 判断数据源数组的第一个元素是什么类型
            if ([obj isKindOfClass:[NSArray class]]) {
                weakSelf.isSingleColumn = NO; // 非单列
            } else if ([obj isKindOfClass:[NSString class]]) {
                weakSelf.isSingleColumn = YES; // 单列
            } else {
                weakSelf.isDataSourceValid = NO; // 数组不合法
                return;
            }
        } else {
            // 判断数组的元素类型是否相同
            if (itemType != [obj class]) {
                weakSelf.isDataSourceValid = NO; // 数组不合法
                *stop = YES;
                return;
            }
            
            if ([obj isKindOfClass:[NSArray class]]) {
                if (((NSArray *)obj).count == 0) {
                    weakSelf.isDataSourceValid = NO;
                    *stop = YES;
                    return;
                } else {
                    for (id subObj in obj) {
                        if (![subObj isKindOfClass:[NSString class]]) {
                            weakSelf.isDataSourceValid = NO;
                            *stop = YES;
                            return;
                        }
                    }
                }
            }
        }
    }];
    
    if (self.isSingleColumn) {
        if (self.selectedItem == nil) {
            // 如果是单列，默认选中数组第一个元素
            self.selectedItem = _dataSource.firstObject;
        }
    } else {
        BOOL isSelectedItemsValid = YES;
        for (id obj in self.selectedItems) {
            if (![obj isKindOfClass:[NSString class]]) {
                isSelectedItemsValid = NO;
                break;
            }
        }
        
        if (self.selectedItems == nil || self.selectedItems.count != self.dataSource.count || !isSelectedItemsValid) {
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (NSArray* componentItem in _dataSource) {
                [mutableArray addObject:componentItem.firstObject];
            }
            self.selectedItems = [NSMutableArray arrayWithArray:mutableArray];
        }
    }
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
        [self.pickerView removeFromSuperview];
        [self.alertView removeFromSuperview];
        [self.backgroundView removeFromSuperview];
        [self removeFromSuperview];
        
        self.leftBtn = nil;
        self.rightBtn = nil;
        self.titleLabel = nil;
        self.lineView = nil;
        self.topView = nil;
        self.pickerView = nil;
        self.alertView = nil;
        self.backgroundView = nil;
    }];
}

#pragma mark - 取消按钮的点击事件
- (void)clickLeftBtn {
    [self dismissWithAnimation:YES];
}

#pragma mark - 确定按钮的点击事件
- (void)clickRightBtn {
    NSLog(@"点击确定按钮后，执行block回调");
    [self dismissWithAnimation:YES];
    if(_resultBlock) {
        if (self.isSingleColumn) {
            _resultBlock([self.selectedItem copy]);
        } else {
            _resultBlock([self.selectedItems copy]);
        }
    }
}

#pragma mark - 字符串选择器
- (XYBasePickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[XYBasePickerView alloc]initWithFrame:CGRectMake(0, kTopViewHeight + 0.5, SCREEN_WIDTH, kDatePicHeight)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        
        __weak typeof(self) weakSelf = self;
        if (self.isSingleColumn) {
            [_dataSource enumerateObjectsUsingBlock:^(NSString *rowItem, NSUInteger rowIdx, BOOL *stop) {
                if ([weakSelf.selectedItem isEqualToString:rowItem]) {
                    [weakSelf.pickerView selectRow:rowIdx inComponent:0 animated:NO];
                    *stop = YES;
                }
            }];
        } else {
            [self.selectedItems enumerateObjectsUsingBlock:^(NSString *selectedItem, NSUInteger component, BOOL *stop) {
                [self->_dataSource[component] enumerateObjectsUsingBlock:^(id rowItem, NSUInteger rowIdx, BOOL *stop) {
                    if ([selectedItem isEqualToString:rowItem]) {
                        [weakSelf.pickerView selectRow:rowIdx inComponent:component animated:NO];
                        *stop = YES;
                    }
                }];
            }];
        }
    }
    return _pickerView;
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.isSingleColumn) {
        return 1;
    } else {
        return _dataSource.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {

    return 40.0f;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (self.isSingleColumn) {
        return _dataSource.count;
    } else {
        return ((NSArray*)_dataSource[component]).count;
    }
}

#pragma mark - UIPickerViewDelegate
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.isSingleColumn) {
        return _dataSource[row];
    } else {
        return ((NSArray*)_dataSource[component])[row];
    }
}

//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
//
//    NSString *titleString;
//    
//    if (self.isSingleColumn) {
//        titleString = _dataSource[row];
//    } else {
//        titleString = ((NSArray*)_dataSource[component])[row];
//    }
//    
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:titleString];
//    NSRange range = [titleString rangeOfString:titleString];
//    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"38acff"] range:range];
//    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0f] range:range];
//
//    return attributedString;
//}

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    //设置分割线的颜色
//    for(UIView *singleLine in pickerView.subviews) {
//        if (singleLine.frame.size.height < 1) {
//            
//            singleLine.backgroundColor = [UIColor colorFromHexString:@"c3e1f6"];
//        }
//    }
//    //设置文字的属性
//    UILabel* genderLabel = (UILabel*)view;
//    if (!genderLabel){
//        genderLabel = [[UILabel alloc] init];
//        genderLabel.textAlignment = NSTextAlignmentCenter;
//        [genderLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
//
//    }
//    if (row == self.selectRow) {
//        genderLabel.attributedText = [self pickerView:pickerView attributedTitleForRow:row forComponent:component];
//        genderLabel.backgroundColor = [UIColor colorFromHexString:@"f3faff"];
//    }else {
//        genderLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
//        genderLabel.textColor = [UIColor blackColor];
//        genderLabel.backgroundColor = [UIColor clearColor];
//    }
//    
//    return genderLabel;
//    
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
//    self.selectRow = row;
//    [self.pickerView reloadAllComponents];
//    UIView *view = [pickerView viewForRow:row forComponent:component];
//    view.backgroundColor = [UIColor colorFromHexString:@"f3faff"];
//    [self.pickerView reloadAllComponents];
    
    if (self.isSingleColumn) {
        self.selectedItem = _dataSource[row];
    } else {
        self.selectedItems[component] = ((NSArray *)_dataSource[component])[row];
    }
    // 设置是否自动回调
    if (self.isAutoSelect) {
        if(_resultBlock) {
            if (self.isSingleColumn) {
                _resultBlock([self.selectedItem copy]);
            } else {
                _resultBlock([self.selectedItems copy]);
            }
        }
    }
}

@end

