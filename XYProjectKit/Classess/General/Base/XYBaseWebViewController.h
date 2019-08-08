//
//  XYBaseWebViewController.h
//  XYProjectKit
//
//  Created by xiaoye on 2019/7/9.
//  Copyright © 2019 JiongYe. All rights reserved.
//

#import "XYBaseViewController.h"
#import <WebKit/WebKit.h>
#import <webkit/WKWebView.h>
#import <JavaScriptCore/JavaScriptCore.h>

@class XYBaseWebViewController;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XYWKWebViewAppearMode) {
    
    XYWKWebViewAppearModePush = 0, //默认 push
    XYWKWebViewAppearModePresent
};

@protocol XYBaseWebViewControllerDelegate <NSObject>

@optional
/// 左上边的返回按钮点击
- (void)backBtnClick:(UIButton *)backBtn webView:(WKWebView *)webView ;

/// 左上边的关闭按钮的点击
- (void)closeBtnClick:(UIButton *)closeBtn webView:(WKWebView *)webView;

/// 监听 self.webView.scrollView 的 contentSize 属性改变，从而对底部添加的自定义 View 进行位置调整
- (void)webView:(WKWebView *)webView scrollView:(UIScrollView *)scrollView contentSize:(CGSize)contentSize;

@end

@protocol XYBaseWebViewControllerDataSource <NSObject>

@optional
/// 默认需要, 是否需要进度条
- (BOOL)webViewController:(XYBaseWebViewController *)webViewController webViewIsNeedProgressIndicator:(WKWebView *)webView;

/// 默认需要自动改变标题
- (BOOL)webViewController:(XYBaseWebViewController *)webViewController webViewIsNeedAutoTitle:(WKWebView *)webView;

@end

@interface XYBaseWebViewController : XYBaseViewController<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,XYBaseWebViewControllerDelegate,XYBaseWebViewControllerDataSource>

/** 是否显示Nav */
@property (nonatomic,assign) BOOL isNavHidden;
/** 手势触摸返回上一层 默认 NO 不开启, YES 开启, */
@property (nonatomic, assign) BOOL isAllowsBackNavigationGestures;
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

NS_ASSUME_NONNULL_END
