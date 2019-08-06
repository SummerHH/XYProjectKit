//
//
//  UConstants.h
//  fula
//
//  Created by xiaoye on 2018/2/24.
//  Copyright © 2018年 ixiye company. All rights reserved.
//


#ifndef Medical_Wisdom_UConstants_h
#define Medical_Wisdom_UConstants_h

/******************************************************/

/****  debug log **/ //NSLog输出信息

#ifdef DEBUG

#define NSLog(FORMAT, ...){ NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];\
[dateFormatter setDateStyle:NSDateFormatterMediumStyle];\
[dateFormatter setTimeStyle:NSDateFormatterShortStyle];\
[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"]; \
NSString *timeStr = [dateFormatter stringFromDate:[NSDate date]];\
fprintf(stderr,"%s | %s:%d | %s\n", [timeStr UTF8String], [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);}

#endif


#pragma mark - Frame(宏 x,y,width,height)

#define MainScreenScale [[UIScreen mainScreen]scale] //屏幕的分辨率 当结果为1时，显示的是普通屏幕，结果为2时，显示的是Retian屏幕
// App Frame Height&Width
#define Application_Frame  [[UIScreen mainScreen] applicationFrame] //除去信号区的屏幕的frame
#define APP_Frame_Height   [[UIScreen mainScreen] applicationFrame].size.height //应用程序的屏幕高度
#define App_Frame_Width    [[UIScreen mainScreen] applicationFrame].size.width  //应用程序的屏幕宽度

// 支持横竖屏的宏
#define kScreenWidth            ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)

#define kScreenHeight           ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)


// View 坐标(x,y)和宽高(width,height)
#define X(v)               (v).frame.origin.x
#define Y(v)               (v).frame.origin.y


#define MinX(v)            CGRectGetMinX((v).frame) // 获得控件屏幕的x坐标
#define MinY(v)            CGRectGetMinY((v).frame) // 获得控件屏幕的Y坐标

#define MidX(v)            CGRectGetMidX((v).frame) //横坐标加上到控件中点坐标
#define MidY(v)            CGRectGetMidY((v).frame) //纵坐标加上到控件中点坐标

#define MaxX(v)            CGRectGetMaxX((v).frame) //横坐标加上控件的宽度
#define MaxY(v)            CGRectGetMaxY((v).frame) //纵坐标加上控件的高度


//    系统控件的默认高度

#define kCellDefaultHeight (44.f)

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

#define kNavBarHeight 44.0

#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)

#define kTabBarBottomHeight  34.0

#define kTopHeight (kStatusBarHeight + kNavBarHeight)

#define ksafeAreaLayoutGuideBottom  isIPhoneNotchScreen() ? 34.0f : 0.0f

#define DesignHeight 667.0
#define DesignWidth 375.0

#define GetWidth(width)  kScreenWidth < DesignWidth ? width : kScreenWidth / DesignWidth * (width)
#define GetHeight(height) kScreenHeight < DesignHeight ? height : kScreenHeight / DesignHeight * (height)

//中英状态下键盘的高度
#define kEnglishKeyboardHeight  (216.f)
#define kChineseKeyboardHeight  (252.f)

#pragma mark - Funtion Method (宏 方法)
//PNG JPG 图片路径
#define PNGPATH(NAME)          [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"png"]
#define JPGPATH(NAME)          [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"jpg"]
#define PATH(NAME,EXT)         [[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]

//加载图片
#define PNGIMAGE(NAME)         [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]]
#define JPGIMAGE(NAME)         [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"jpg"]]
#define IMAGE(NAME,EXT)        [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]]
#define IMAGENAMED(NAME)       [UIImage imageNamed:NAME]


#define XYWeakSelf(type)    __weak typeof(type) weak##type = type; // weak
#define XYStrongSelf(type)  __strong typeof(type) type = weak##type; // strong

// 角度和弧度转换

#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)

//字体大小（常规/粗体）
#define BOLDSYSTEMFONT(FONTSIZE) [UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)     [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME,FONTSIZE)      [UIFont fontWithName:(NAME) size:(FONTSIZE)]

//不同屏幕尺寸字体适配
#define kScreenWidthRatio  (UIScreen.mainScreen.bounds.size.width / 375.0)
#define kScreenHeightRatio (UIScreen.mainScreen.bounds.size.height / 667.0)
#define AdaptedWidth(x)  ceilf((x) * kScreenWidthRatio)
#define AdaptedHeight(x) ceilf((x) * kScreenHeightRatio)
#define AdaptedFontSize(R)     [UIFont systemFontOfSize:AdaptedWidth(R)]

// 微软雅黑
#define YC_YAHEI_FONT(FONTSIZE) [UIFont fontWithName:@"MicrosoftYaHei" size:(FONTSIZE)]
// 英文 和 数字
#define YC_ENGLISH_FONT(FONTSIZE) [UIFont fontWithName:@"Helvetica Light" size:(FONTSIZE)]

#define RGBACOLOR(r,g,b,a)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

// 找window
#define kWindow                 [[UIApplication sharedApplication].delegate window]

// 文件路径
#define kCachePath              [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]

#define kDocumentPath           [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

#define kUserInfoFillPath [kDocumentPath stringByAppendingPathComponent:@"LeRongRong"]

// 当前设备系统版本号
#define kAppSystemVersion [[UIDevice currentDevice].systemVersion doubleValue]
// App 外部版本号
#define kAppVersion             [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
// 内部版本号
#define kAppBundleVersion       [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
// App应用的名称
#define kAppDisplayName         [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

// 随机颜色
#define kRandColor RGBACOLOR(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255), 1.0)

//当前语言
#define CURRENTLANGUAGE           ([[NSLocale preferredLanguages] objectAtIndex:0])

//是否Retina屏
#define isRetina                  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) :NO)

// 是否是iPad
#define isPad                      (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
// 设备
#define kDevice_Is_iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)


//NSUSerDefault
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

//加载storyboard
#define VCLOADFROMUISB(NAME, IDENTIFIER) [[UIStoryboard storyboardWithName:NAME bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:IDENTIFIER]


//判断设备室真机还是模拟器
#if TARGET_OS_IPHONE
/** iPhone Device */
#endif

#if TARGET_IPHONE_SIMULATOR
/** iPhone Simulator */
#endif

#endif

