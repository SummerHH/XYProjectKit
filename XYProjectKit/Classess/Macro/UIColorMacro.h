//
//  UIColorMacro.h
//  XYProjectKit
//
//  Created by xiaoye on 2020/3/16.
//  Copyright © 2020 JiongYe. All rights reserved.
//

#ifndef UIColorMacro_h
#define UIColorMacro_h


// tabBar 默认颜色
#define kTabBarItemNormalTintColor @"#757575"
// tabBar 高亮颜色
#define kTabBarItemSelectedTintColor @"#FB7299"
/// 白色
#define kFFFFFFLightColor         [UIColor colorFromHexString:@"#FF6347"]
/// 导航栏黑色
#define k1B1B1BColor              [UIColor colorFromHexString:@"#696969"]

#define kNavigationColor  [UIColor colorWithLightColor:kFFFFFFLightColor DarkColor:k1B1B1BColor]

/// 导航字体颜色
#define kNavigationTitleColor [UIColor colorWithLightColor:[UIColor blackColor] DarkColor:[UIColor whiteColor]]


/// 白色背景和黑色背景切换
#define kDarkBackGroundColor [UIColor colorWithLightColor:kFFFFFFLightColor DarkColor:k151515DarkColor]

/// 灰白色和暗黑灰背景色
#define kBackGroundColor [UIColor colorWithLightColor:kf6f6f6Color DarkColor:k282828Color]

#endif /* UIColorMacro_h */

