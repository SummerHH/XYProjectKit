//
//  XYCustomDatePickView.m
//  fula
//
//  Created by xiaoye on 2018/5/11.
//  Copyright © 2018年 ixiye company. All rights reserved.
//

#import "XYCustomDatePickView.h"
#import "XYBasePickerView.h"
#import "NSDate+Extension.h"


@interface XYCustomDatePickView() <UIPickerViewDelegate,UIPickerViewDataSource> {
 
    NSString *_title;

    //日期存储数组
    NSMutableArray *_yearArray;
    NSMutableArray *_monthArray;
    NSMutableArray *_dayArray;
    NSMutableArray *_hourArray;
    NSMutableArray *_minuteArray;
    NSString *_dateFormatter;
    //记录位置
    NSInteger yearIndex;
    NSInteger monthIndex;
    NSInteger dayIndex;
    NSInteger hourIndex;
    NSInteger minuteIndex;
    
    //最大最小年
    NSInteger maxYear;
    NSInteger minYear;
    
    NSInteger preRow;
    NSDate *_startDate;
    
    BOOL _isAutoSelect;
}


@property (nonatomic, strong) XYBasePickerView *pickerView;
@property (nonatomic, assign) XYDatePickerStyle datePickerStyle;
@property (nonatomic, retain) NSDate *maxLimitDate;
@property (nonatomic, retain) NSDate *minLimitDate;
//* 默认滚动的时间 */
@property (nonatomic, retain) NSDate *scrollToDate;

@property (nonatomic, copy) XYSelectDateResultBlock resultBlock;

@end

@implementation XYCustomDatePickView

#pragma mark - 自定义时间选择器 -
+ (void)showCustomDatePickerWithTitle:(NSString *)title
                      datePickerStyle:(XYDatePickerStyle)datePickerStyle
                      defaultSelValue:(NSDate *)defaultSelValue
                         minLimitDate:(NSDate *)minLimitDate
                         maxLimitDate:(NSDate *)maxLimitDate
                         isAutoSelect:(BOOL)isAutoSelect
                          resultBlock:(XYSelectDateResultBlock)resultBlock {
    
    
    XYCustomDatePickView *datePickerView = [[XYCustomDatePickView alloc] initWithCustomDatePickerTitle:title datePickerStyle:datePickerStyle defaultSelValue:defaultSelValue minLimitDate:minLimitDate maxLimitDate:maxLimitDate isAutoSelect:isAutoSelect resultBlock:resultBlock];
    
    [datePickerView showWithAnimation:YES];
}

- (instancetype)initWithCustomDatePickerTitle:(NSString *)title
                              datePickerStyle:(XYDatePickerStyle)datePickerStyle
                              defaultSelValue:(NSDate *)defaultSelValue
                                 minLimitDate:(NSDate *)minLimitDate
                                 maxLimitDate:(NSDate *)maxLimitDate
                                 isAutoSelect:(BOOL)isAutoSelect
                                  resultBlock:(XYSelectDateResultBlock)resultBlock {
    
    if (self = [super init]) {
        _title = title;
        self.datePickerStyle = datePickerStyle;
        self.minLimitDate = minLimitDate;
        self.maxLimitDate = maxLimitDate;
        _resultBlock = resultBlock;
        _isAutoSelect = isAutoSelect;
        if (!self.maxLimitDate && !self.minLimitDate) {
            maxYear = 2099;
            minYear = 2000;
        }
        else {
            maxYear = [self.maxLimitDate year];
            minYear = [self.minLimitDate year];
        }
        
//        NSLog(@"*****%@*****%@***",minLimitDate,maxLimitDate);
        switch (datePickerStyle) {
            case XYDateStyleShowYearMonthDayHourMinute:
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
            case XYDateStyleShowMonthDayHourMinute:
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
            case XYDateStyleShowYearMonthDay:
                _dateFormatter = @"yyyy-MM-dd";
                break;
            case XYDateStyleShowYearMonth:
                _dateFormatter = @"yyyy-MM";
                break;
            case XYDateStyleShowMonthDay:
                _dateFormatter = @"yyyy-MM-dd";
                break;
            case XYDateStyleShowHourMinute:
                _dateFormatter = @"HH:mm";
                break;
            default:
                _dateFormatter = @"yyyy-MM-dd HH:mm";
                break;
        }
        
        [self initView];
        
        // 默认选中今天的日期
        if (defaultSelValue) {
            _scrollToDate = defaultSelValue;
        }
        else {
            _scrollToDate = [NSDate date];
        }
        [self getNowDate:_scrollToDate animated:NO];
        
    }
    return self;
}

- (void)initView {
    
    [super initUI];
    self.titleLabel.text = _title;
    // 添加时间选择器
    [self.alertView addSubview:self.pickerView];
    
    [self defaultConfig];
}

- (void)defaultConfig {
    
    preRow = (self.scrollToDate.year-minYear)*12+self.scrollToDate.month-1;
    //设置年月日时分数据
    _yearArray = [self setArray:_yearArray];
    _monthArray = [self setArray:_monthArray];
    _dayArray = [self setArray:_dayArray];
    _hourArray = [self setArray:_hourArray];
    _minuteArray = [self setArray:_minuteArray];
    
    for (int i=0; i<60; i++) {
        NSString *num = [NSString stringWithFormat:@"%02d",i];
        if (0<i && i<=12)
            [_monthArray addObject:num];
        if (i<24)
            [_hourArray addObject:num];
        [_minuteArray addObject:num];
    }
    
    for (NSInteger i = minYear; i <= maxYear; i++) {
        NSString *num = [NSString stringWithFormat:@"%ld",(long)i];
        [_yearArray addObject:num];
    }
    
    //最大最小限制
    if (!self.maxLimitDate) {
        self.maxLimitDate = [NSDate date:@"2099-12-31 23:59" WithFormat:@"yyyy-MM-dd HH:mm"];
    }
    //最小限制
    if (!self.minLimitDate) {
        self.minLimitDate = [NSDate date:@"2000-01-01 00:00" WithFormat:@"yyyy-MM-dd HH:mm"];
    }
}

#pragma mark - UIPickerViewDelegate,UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    switch (self.datePickerStyle) {
        case XYDateStyleShowYearMonthDayHourMinute:
            return 5;
        case XYDateStyleShowMonthDayHourMinute:
            return 4;
        case XYDateStyleShowYearMonthDay:
            return 3;
        case XYDateStyleShowYearMonth:
            return 2;
        case XYDateStyleShowMonthDay:
            return 2;
        case XYDateStyleShowHourMinute:
            return 2;
        default:
            return 0;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSArray *numberArr = [self getNumberOfRowsInComponent];
    return [numberArr[component] integerValue];
}

-(NSArray *)getNumberOfRowsInComponent {
    
    NSInteger yearNum = _yearArray.count;
    NSInteger monthNum = _monthArray.count;
    
    NSInteger dayNum = [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
    NSInteger hourNum = _hourArray.count;
    NSInteger minuteNUm = _minuteArray.count;
    NSInteger timeInterval = maxYear - minYear;
   
    switch (self.datePickerStyle) {
        case XYDateStyleShowYearMonthDayHourMinute:
            return @[@(yearNum),@(monthNum),@(dayNum),@(hourNum),@(minuteNUm)];
            break;
        case XYDateStyleShowMonthDayHourMinute:
            return @[@(monthNum*timeInterval),@(dayNum),@(hourNum),@(minuteNUm)];
            break;
        case XYDateStyleShowYearMonthDay:
            return @[@(yearNum),@(monthNum),@(dayNum)];
            break;
        case XYDateStyleShowYearMonth:
            return @[@(yearNum),@(monthNum)];
            break;
        case XYDateStyleShowMonthDay:
            return @[@(monthNum*timeInterval),@(dayNum),@(hourNum)];
            break;
        case XYDateStyleShowHourMinute:
            return @[@(hourNum),@(minuteNUm)];
            break;
        default:
            return @[];
            break;
    }
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 40.0f;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *customLabel = (UILabel *)view;
    if (!customLabel) {
        customLabel = [[UILabel alloc] init];
        customLabel.textAlignment = NSTextAlignmentCenter;
        [customLabel setFont:[UIFont systemFontOfSize:18]];
    }
    NSString *title;
    
    switch (self.datePickerStyle) {
        case XYDateStyleShowYearMonthDayHourMinute:
            if (component==0) {
                title = [NSString stringWithFormat:@"%@年",_yearArray[row]];
            }
            if (component==1) {
                title = [NSString stringWithFormat:@"%@月",_monthArray[row]];
            }
            if (component==2) {
                title = [NSString stringWithFormat:@"%@日",_dayArray[row]];
            }
            if (component==3) {
                title = [NSString stringWithFormat:@"%@时",_hourArray[row]];
            }
            if (component==4) {
                title = [NSString stringWithFormat:@"%@分",_minuteArray[row]];
            }
            break;
        case XYDateStyleShowYearMonthDay:
            if (component==0) {
                title = [NSString stringWithFormat:@"%@年",_yearArray[row]];
            }
            if (component==1) {
                title = [NSString stringWithFormat:@"%@月",_monthArray[row]];
            }
            if (component==2) {
                title = [NSString stringWithFormat:@"%@日",_dayArray[row]];
            }
            break;
        case XYDateStyleShowYearMonth:
            if (component==0) {
                title = [NSString stringWithFormat:@"%@年",_yearArray[row]];
            }
            if (component==1) {
                title = [NSString stringWithFormat:@"%@月",_monthArray[row]];
            }
            break;
        case XYDateStyleShowMonthDayHourMinute:
            if (component==0) {
                title = [NSString stringWithFormat:@"%@月",_monthArray[row%12]];
            }
            if (component==1) {
                title = [NSString stringWithFormat:@"%@日",_dayArray[row]];
            }
            if (component==2) {
                title = [NSString stringWithFormat:@"%@时",_hourArray[row]];
            }
            if (component==3) {
                title = [NSString stringWithFormat:@"%@分",_minuteArray[row]];
            }
            break;
        case XYDateStyleShowMonthDay:
            if (component==0) {
                title = [NSString stringWithFormat:@"%@月",_monthArray[row%12]];
            }
            if (component==1) {
                title = [NSString stringWithFormat:@"%@日",_dayArray[row]];
            }
            break;
        case XYDateStyleShowHourMinute:
            if (component==0) {
                title = [NSString stringWithFormat:@"%@时",_hourArray[row]];
            }
            if (component==1) {
                title = [NSString stringWithFormat:@"%@分",_minuteArray[row]];
            }
            break;
        default:
            title = @"";
            break;
    }
    
    customLabel.text = title;
    
    return customLabel;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    switch (self.datePickerStyle) {
        case XYDateStyleShowYearMonthDayHourMinute:{
            
            if (component == 0) {
                yearIndex = row;
            }
            if (component == 1) {
                monthIndex = row;
            }
            if (component == 2) {
                dayIndex = row;
            }
            if (component == 3) {
                hourIndex = row;
            }
            if (component == 4) {
                minuteIndex = row;
            }
            if (component == 0 || component == 1){
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                }
            }
        }
            break;
            
            
        case XYDateStyleShowYearMonthDay:{
            
            if (component == 0) {
                yearIndex = row;
            }
            if (component == 1) {
                monthIndex = row;
            }
            if (component == 2) {
                dayIndex = row;
            }
            if (component == 0 || component == 1){
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                }
            }
        }
            break;
            
        case XYDateStyleShowYearMonth:{
            
            if (component == 0) {
                yearIndex = row;
            }
            if (component == 1) {
                monthIndex = row;
            }
        }
            break;
            
        case XYDateStyleShowMonthDayHourMinute:{
            
            
            if (component == 1) {
                dayIndex = row;
            }
            if (component == 2) {
                hourIndex = row;
            }
            if (component == 3) {
                minuteIndex = row;
            }
            
            if (component == 0) {
                
                [self yearChange:row];
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                }
            }
            [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
            
        }
            break;
            
        case XYDateStyleShowMonthDay:{
            if (component == 1) {
                dayIndex = row;
            }
            if (component == 0) {
                
                [self yearChange:row];
                [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
                if (_dayArray.count-1<dayIndex) {
                    dayIndex = _dayArray.count-1;
                }
            }
            [self DaysfromYear:[_yearArray[yearIndex] integerValue] andMonth:[_monthArray[monthIndex] integerValue]];
        }
            break;
            
        case XYDateStyleShowHourMinute:{
            if (component == 0) {
                hourIndex = row;
            }
            if (component == 1) {
                minuteIndex = row;
            }
        }
            break;
            
        default:
            break;
    }
    
    [pickerView reloadAllComponents];
    
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",_yearArray[yearIndex],_monthArray[monthIndex],_dayArray[dayIndex],_hourArray[hourIndex],_minuteArray[minuteIndex]];
    
//    NSLog(@"^^^^^字符串 %@ =======",dateStr);

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    self.scrollToDate = [dateFormatter dateFromString:dateStr];

    //判断滚动的区域
    if ([self.scrollToDate compare:self.minLimitDate] == NSOrderedAscending) {
        self.scrollToDate = self.minLimitDate;
        [self getNowDate:self.minLimitDate animated:YES];
    }else if ([self.scrollToDate compare:self.maxLimitDate] == NSOrderedDescending){
        self.scrollToDate = self.maxLimitDate;
        [self getNowDate:self.maxLimitDate animated:YES];
    }
    _startDate = self.scrollToDate;
    
    // 是否是自动滚动
    if (_isAutoSelect) {
        if (self.resultBlock) {
            self.resultBlock(_startDate);
        }
    }
//    NSLog(@"+++++++ %@ +++++",self.scrollToDate);

}

-(void)yearChange:(NSInteger)row {
    
    monthIndex = row%12;
    
    //年份状态变化
    if (row-preRow <12 && row-preRow>0 && [_monthArray[monthIndex] integerValue] < [_monthArray[preRow%12] integerValue]) {
        yearIndex ++;
    } else if(preRow-row <12 && preRow-row > 0 && [_monthArray[monthIndex] integerValue] > [_monthArray[preRow%12] integerValue]) {
        yearIndex --;
    }else {
        NSInteger interval = (row-preRow)/12;
        yearIndex += interval;
    }
    
    preRow = row;
}

#pragma mark - tools
//通过年月求每月天数
- (NSInteger)DaysfromYear:(NSInteger)year andMonth:(NSInteger)month
{
    NSInteger num_year  = year;
    NSInteger num_month = month;
    
    BOOL isrunNian = num_year%4==0 ? (num_year%100==0? (num_year%400==0?YES:NO):YES):NO;
    switch (num_month) {
        case 1:case 3:case 5:case 7:case 8:case 10:case 12:{
            [self setdayArray:31];
            return 31;
        }
        case 4:case 6:case 9:case 11:{
            [self setdayArray:30];
            return 30;
        }
        case 2:{
            if (isrunNian) {
                [self setdayArray:29];
                return 29;
            }else{
                [self setdayArray:28];
                return 28;
            }
        }
        default:
            break;
    }
    return 0;
}

//设置每月的天数数组
- (void)setdayArray:(NSInteger)num
{
    [_dayArray removeAllObjects];
    for (int i=1; i<=num; i++) {
        [_dayArray addObject:[NSString stringWithFormat:@"%02d",i]];
    }
}

//滚动到指定的时间位置
- (void)getNowDate:(NSDate *)date animated:(BOOL)animated
{
    if (!date) {
        date = [NSDate date];
    }
    
    [self DaysfromYear:date.year andMonth:date.month];
    
    yearIndex = date.year-minYear;
    monthIndex = date.month-1;
    dayIndex = date.day-1;
    hourIndex = date.hour;
    minuteIndex = date.minute;
    
    //循环滚动时需要用到
    preRow = (self.scrollToDate.year-minYear)*12+self.scrollToDate.month-1;
    
    NSArray *indexArray;
    
    if (self.datePickerStyle == XYDateStyleShowYearMonthDayHourMinute)
        indexArray = @[@(yearIndex),@(monthIndex),@(dayIndex),@(hourIndex),@(minuteIndex)];
    if (self.datePickerStyle == XYDateStyleShowYearMonthDay)
        indexArray = @[@(yearIndex),@(monthIndex),@(dayIndex)];
    if (self.datePickerStyle == XYDateStyleShowYearMonth)
        indexArray = @[@(yearIndex),@(monthIndex)];
    if (self.datePickerStyle == XYDateStyleShowMonthDayHourMinute)
        indexArray = @[@(monthIndex),@(dayIndex),@(hourIndex),@(minuteIndex)];
    if (self.datePickerStyle == XYDateStyleShowMonthDay)
        indexArray = @[@(monthIndex),@(dayIndex)];
    if (self.datePickerStyle == XYDateStyleShowHourMinute)
        indexArray = @[@(hourIndex),@(minuteIndex)];
    
    [self.pickerView reloadAllComponents];
    
    for (int i=0; i<indexArray.count; i++) {
        if ((self.datePickerStyle == XYDateStyleShowMonthDayHourMinute || self.datePickerStyle == XYDateStyleShowMonthDay)&& i==0) {
            NSInteger mIndex = [indexArray[i] integerValue]+(12*(self.scrollToDate.year - minYear));
            [self.pickerView selectRow:mIndex inComponent:i animated:animated];
        } else {
            [self.pickerView selectRow:[indexArray[i] integerValue] inComponent:i animated:animated];
        }
    }
    
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",_yearArray[yearIndex],_monthArray[monthIndex],_dayArray[dayIndex],_hourArray[hourIndex],_minuteArray[minuteIndex]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    self.scrollToDate = [dateFormatter dateFromString:dateStr];
    
    _startDate = self.scrollToDate;


    NSLog(@"######自动滚动的区域 %@ ",dateStr);

}

-(void)setMinLimitDate:(NSDate *)minLimitDate {
    _minLimitDate = minLimitDate;
    if ([_scrollToDate compare:self.minLimitDate] == NSOrderedAscending) {
        _scrollToDate = self.minLimitDate;
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

- (NSMutableArray *)setArray:(id)mutableArray {
    if (mutableArray)
        [mutableArray removeAllObjects];
    else
        mutableArray = [NSMutableArray array];
    return mutableArray;
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
    
    if (self.resultBlock) {
        self.resultBlock(_startDate);
    }
}

@end
