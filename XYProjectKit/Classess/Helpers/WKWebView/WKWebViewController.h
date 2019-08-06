//
//  WKWebViewController.h
//  fula
//
//  Created by xiyedev on 2017/9/11.
//  Copyright © 2017年 ixiye company. All rights reserved.
//


typedef NS_ENUM(NSInteger, XYWKWebViewAppearMode) {
    
    XYWKWebViewAppearModePush = 0, //默认 push
    XYWKWebViewAppearModePresent
};

#import <UIKit/UIKit.h>

@interface WKWebViewController : UIViewController

/** 是否显示Nav 默认 NO , YES 隐藏*/
@property (nonatomic, assign) BOOL isNavHidden;
/** 是否开启手势触摸 默认 NO 不开启, YES 开启, */
@property (nonatomic, assign) BOOL isAllowsBackNavigationGestures;
/** 是否需要返回上一层, 默认 NO , YES 不需要*/
@property (nonatomic, assign) BOOL isGoBack;
/** 是否返回 root , 默认 NO 否, YES 是*/
@property (nonatomic, assign) BOOL isGoBackRootVC;
/** 是否需要导航显示分享按钮 默认 NO , YES 显示 */
@property (nonatomic, assign) BOOL isShareBtn;
/** 是否需要返回刷新 默认 NO , YES 需要*/
@property (nonatomic, assign) BOOL  isRolad;


/** 是 push 还是模态*/
@property (nonatomic, assign) XYWKWebViewAppearMode appearMode;

/**
 加载纯外部链接网页

 @param string URL地址
 */
- (void)loadWebURLSring:(NSString *)string;

/**
 加载本地网页
 
 @param string 本地HTML文件名
 */
- (void)loadWebHTMLSring:(NSString *)string;

/**
 加载外部链接POST请求(注意检查 XFWKJSPOST.html 文件是否存在 )
 postData请求块 注意格式：@"\"username\":\"xxxx\",\"password\":\"xxxx\""
 
 @param string 需要POST的URL地址
 @param postData post请求块
 */
- (void)POSTWebURLSring:(NSString *)string postData:(NSString *)postData;


@end


