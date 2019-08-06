//
//  XYAddressPickerView.m
//  XYPIckerView
//
//  Created by xiyedev on 2017/9/14.
//  Copyright © 2017年 YeJiong. All rights reserved.
//

#import "XYAddressPickerView.h"
#import "XYAddressModel.h"
#import "XYBasePickerView.h"

@interface XYAddressPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>  {
    NSInteger rowOfProvince; // 保存省份对应的下标
    NSInteger rowOfCity;     // 保存市对应的下标
    NSInteger rowOfTown;     // 保存区对应的下标
}
// 时间选择器（默认大小: 320px × 216px）
@property (nonatomic, strong) XYBasePickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *addressModelArr;

// 默认选中的值（@[省索引, 市索引, 区索引]）
@property (nonatomic, strong) NSArray *defaultSelectedArr;
// 是否开启自动选择
@property (nonatomic, assign) BOOL isAutoSelect;
// 是否展示区 县级
@property (nonatomic, assign) BOOL isAutoSelectArea;
/**
 * 选中后的回调
 * 在接收值得时候,要判断数组的值
 */
@property (nonatomic, copy) XYAddressResultBlock resultBlock;

@end

@implementation XYAddressPickerView

#pragma mark - 显示地址选择器
+ (void)showAddressPickerWithDefaultSelected:(NSArray *)defaultSelectedArr
                                isAutoSelect:(BOOL)isAutoSelect
                                 resultBlock:(XYAddressResultBlock)resultBlock {
    
    XYAddressPickerView *addressPickerView = [[XYAddressPickerView alloc] initWithDefaultSelected:defaultSelectedArr isAutoSelect:isAutoSelect isAutoSelectArea:YES resultBlock:resultBlock];
    [addressPickerView showWithAnimation:YES];
}

+ (void)showAddressPickerWithDefaultSelected:(NSArray *)defaultSelectedArr
                            isAutoSelectArea:(BOOL)isAutoSelectArea
                                isAutoSelect:(BOOL)isAutoSelect
                                 resultBlock:(XYAddressResultBlock)resultBlock {
    
    XYAddressPickerView *addressPickerView = [[XYAddressPickerView alloc] initWithDefaultSelected:defaultSelectedArr isAutoSelect:isAutoSelect isAutoSelectArea:isAutoSelectArea resultBlock:resultBlock];
    [addressPickerView showWithAnimation:YES];
}

#pragma mark - 初始化地址选择器
- (instancetype)initWithDefaultSelected:(NSArray *)defaultSelectedArr
                           isAutoSelect:(BOOL)isAutoSelect
                       isAutoSelectArea:(BOOL)isAutoSelectArea
                            resultBlock:(XYAddressResultBlock)resultBlock {
    if (self = [super init]) {
        // 默认选中
        if (defaultSelectedArr.count == 3) {
            self.defaultSelectedArr = defaultSelectedArr;
        } else {
            self.defaultSelectedArr = @[@8, @0, @0];
        }
        self.isAutoSelect = isAutoSelect;
        self.isAutoSelectArea = isAutoSelectArea;
        self.resultBlock = resultBlock;
        [self loadData];
        [self initUI];
    }
    return self;
}

#pragma mark - 获取地址数据
- (void)loadData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ProvinceCity" ofType:@"plist"];
    NSArray *arrData = [NSArray arrayWithContentsOfFile:filePath];
    for (NSDictionary *dic in arrData) {
        XYProvinceModel *proviceModel = [XYProvinceModel mj_objectWithKeyValues:dic];
        [self.addressModelArr addObject:proviceModel];
    }
}

#pragma mark - 初始化子视图
- (void)initUI {
    [super initUI];
    self.titleLabel.text = @"请选择城市";
    // 添加时间选择器
    [self.alertView addSubview:self.pickerView];
}

#pragma mark - 背景视图的点击事件
- (void)didTapBackgroundView:(UITapGestureRecognizer *)sender {
    [self dismissWithAnimation:NO];
}

#pragma mark - 弹出视图方法
- (void)showWithAnimation:(BOOL)animation {
    // 1.获取当前应用的主窗口
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
    
    NSInteger recordRowOfProvince = [self.defaultSelectedArr[0] integerValue];
    NSInteger recordRowOfCity = [self.defaultSelectedArr[1] integerValue];
    NSInteger recordRowOfTown = [self.defaultSelectedArr[2] integerValue];
    
    // 2.滚动到默认行
    
    [self scrollToRow:recordRowOfProvince secondRow:recordRowOfCity thirdRow:recordRowOfTown];
    
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
    if(self.resultBlock) {
        NSArray *arr = [self getChooseCityArr];
        self.resultBlock(arr);
    }
}

#pragma mark - 地址选择器
- (XYBasePickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[XYBasePickerView alloc]initWithFrame:CGRectMake(0, kTopViewHeight + 0.5, SCREEN_WIDTH, kDatePicHeight)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
    }
    return _pickerView;
}


#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (self.isAutoSelectArea) {
        return 3;
    }else {
        return 2;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    XYProvinceModel *provinceModel = self.addressModelArr[rowOfProvince];
    if (component == 0) {
        //返回省个数
        return self.addressModelArr.count;
    }
    if (component == 1) {
        //返回市个数
        return provinceModel.city.count;
    }
    if (self.isAutoSelectArea) {
        if (component == 2) {
            //返回区个数
            if (rowOfCity < provinceModel.city.count) {
                XYCityModel *cityModel = provinceModel.city[rowOfCity];
                return cityModel.town.count;
            }else {
                return 0;
            }
        }
    }
    return 0;

}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 40.0f;
}
#pragma mark - PickerView的代理方法
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *showTitleValue = @"";
    if (component == 0) {//省
        if (row >= self.addressModelArr.count) {
            return nil;
        }
        XYProvinceModel *provinceModel = self.addressModelArr[row];
        showTitleValue = provinceModel.name;
    }
    if (component == 1) {//市
        XYProvinceModel *provinceModel = self.addressModelArr[rowOfProvince];
        if (row >= provinceModel.city.count) {
            return nil;
        }
        XYCityModel *cityModel = provinceModel.city[row];
        showTitleValue = cityModel.name;
    }
    if (self.isAutoSelectArea) {
        if (component == 2) {//区
            XYProvinceModel *provinceModel = self.addressModelArr[rowOfProvince];
            XYCityModel *cityModel = provinceModel.city[rowOfCity];
            if (row >= cityModel.town.count) {
                return nil;
            }
            XYTownModel *townModel = cityModel.town[row];
            showTitleValue = townModel.name;
        }
    }
    
    return showTitleValue;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH - 30) / 3, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:18.0f];
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        rowOfProvince = row;
        rowOfCity = 0;
        rowOfTown = 0;
    } else if (component == 1) {
        rowOfCity = row;
        rowOfTown = 0;
    }
    if (self.isAutoSelectArea) {
        if (component == 2) {
            rowOfTown = row;
        }
    }
 
    // 滚动到指定行
    [self scrollToRow:rowOfProvince secondRow:rowOfCity thirdRow:rowOfTown];
    
    // 自动获取数据，滚动完就回调
    if (self.isAutoSelect) {
        NSArray *arr = [self getChooseCityArr];
        if (arr) {
            if (self.resultBlock) {
                self.resultBlock(arr);
            }
        }
    }
}

#pragma mark - Tool
- (NSArray *)getChooseCityArr {
    
    NSMutableArray *pArr = [NSMutableArray new];
    if (rowOfProvince < self.addressModelArr.count) {
        XYProvinceModel *provinceModel = self.addressModelArr[rowOfProvince];
        
        NSDictionary * provinceDic = @{
                                       @"provinceName" : provinceModel.name,
                                       @"code" : provinceModel.code
                                       };
        [pArr addObject:provinceDic];
        
        if (rowOfCity < provinceModel.city.count) {
            XYCityModel *cityModel = provinceModel.city[rowOfCity];
            
            NSDictionary *cityDic = @{
                                      @"cityName" : cityModel.name,
                                      @"code" : cityModel.code
                                      };
            [pArr addObject:cityDic];
            
            if (self.isAutoSelectArea) {
                if (rowOfTown < cityModel.town.count) {
                    XYTownModel *townModel = cityModel.town[rowOfTown];
                    
                    NSDictionary *townDic = @{
                                              @"townName": townModel.name,
                                              @"code" : townModel.code
                                              };
                    [pArr addObject:townDic];
                }
            }
        }
    }
    return pArr;
}

#pragma mark - 滚动到指定行
- (void)scrollToRow:(NSInteger)firstRow secondRow:(NSInteger)secondRow thirdRow:(NSInteger)thirdRow {
    if (firstRow < self.addressModelArr.count) {
        rowOfProvince = firstRow;
        XYProvinceModel *provinceModel = self.addressModelArr[firstRow];
        [self.pickerView selectRow:firstRow inComponent:0 animated:YES];
        
 
        if (secondRow < provinceModel.city.count) {
            rowOfCity = secondRow;
            [self.pickerView reloadComponent:1];
            [self.pickerView selectRow:secondRow inComponent:1 animated:YES];
            XYCityModel *cityModel = provinceModel.city[secondRow];
            if (thirdRow < cityModel.town.count) {
                rowOfTown = thirdRow;
                [self.pickerView reloadComponent:2];
                [self.pickerView selectRow:thirdRow inComponent:2 animated:YES];
            }
        }
        
        [self.pickerView reloadAllComponents];
    }
        
    // 是否自动滚动回调
    if (/* DISABLES CODE */ (false)) {
        NSArray *arr = [self getChooseCityArr];
        if (self.resultBlock != nil) {
            self.resultBlock(arr);
        }
    }
    
}

- (NSMutableArray *)addressModelArr {
    if (!_addressModelArr) {
        _addressModelArr = [[NSMutableArray alloc]init];
    }
    return _addressModelArr;
}


@end
