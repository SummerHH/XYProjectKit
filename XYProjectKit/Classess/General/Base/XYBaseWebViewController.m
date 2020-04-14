//
//  XYBaseWebViewController.m
//  XYProjectKit
//
//  Created by xiaoye on 2019/7/9.
//  Copyright © 2019 JiongYe. All rights reserved.
//

#import "XYBaseWebViewController.h"

typedef NS_ENUM(NSInteger,XYWebLoadType) {
    XYWebLoadTypeURLString = 0,
    XYWebLoadTypeHTMLString,
    XYWebLoadTypePOSTURLString
};

static void *WkwebBrowserContext = &WkwebBrowserContext;

@interface XYBaseWebViewController ()

@property (nonatomic, strong) WKWebView *wkWebView;
/// 设置加载进度条
@property (nonatomic,strong) UIProgressView *progressView;
/// 仅当第一次的时候加载本地JS
@property(nonatomic,assign) BOOL needLoadJSPOST;
/// 网页加载的类型
@property(nonatomic,assign) XYWebLoadType loadType;
/// 保存的网址链接
@property (nonatomic, copy) NSString *URLString;
/// 保存POST请求体
@property (nonatomic, copy) NSString *postData;
/// 保存请求链接
@property (nonatomic)NSMutableArray* snapShotsArray;
/// 返回按钮
@property (nonatomic)UIBarButtonItem* customBackBarItem;
/// 关闭按钮
@property (nonatomic)UIBarButtonItem* closeButtonItem;

@end

@implementation XYBaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //加载web页面
    [self webViewloadURLType];
    
    //添加到主控制器上
    [self.view addSubview:self.wkWebView];
    
    //添加进度条
    [self.view addSubview:self.progressView];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    if (_isNavHidden) {
        [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(kStatusBarHeight);
            make.left.right.bottom.mas_equalTo(self.view);
        }];
        
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kStatusBarHeight);
            make.left.right.mas_equalTo(self.view);
            make.height.mas_equalTo(3.0f);
        }];
        
    }else {
        [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self.view);
            make.height.mas_equalTo(3.0f);
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_isNavHidden == YES) {
        self.navigationController.navigationBar.hidden = YES;
        //创建一个高20的假状态栏
        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kStatusBarHeight)];
        statusBarView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
        UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;
        statusBarView.backgroundColor = kNavigationColor;
        [self.view addSubview:statusBarView];
    }else{
        self.navigationItem.leftBarButtonItems = @[self.customBackBarItem];
    }
    
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.UIDelegate = self;
}

-(void)updateNavigationItems{
    
    if (self.wkWebView.canGoBack) {
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButtonItem.width = 1;
        self.navigationItem.leftBarButtonItems = @[self.customBackBarItem,spaceButtonItem,self.closeButtonItem];
        
    }else {
        self.navigationItem.leftBarButtonItems = @[self.customBackBarItem];
    }
}

-(void)customBackItemClicked:(UIButton *)sender {

    [self backBtnClick:sender webView:self.wkWebView];
}

-(void)closeItemClicked:(UIButton *)sender {
    
    [self closeBtnClick:sender webView:self.wkWebView];
}

#pragma make - setter --
- (void)setIsNavHidden:(BOOL)isNavHidden {
    _isNavHidden = isNavHidden;
}

- (void)setIsAllowsBackNavigationGestures:(BOOL)isAllowsBackNavigationGestures {
    _isAllowsBackNavigationGestures = isAllowsBackNavigationGestures;
    self.wkWebView.allowsBackForwardNavigationGestures = _isAllowsBackNavigationGestures;
}

#pragma mark ================ 加载方式 ================

- (void)loadWebURLSring:(NSString *)string{
    
    self.URLString = string;
    self.loadType = XYWebLoadTypeURLString;
}

- (void)loadWebHTMLSring:(NSString *)string{
    self.URLString = string;
    self.loadType = XYWebLoadTypeHTMLString;
}

- (void)POSTWebURLSring:(NSString *)string postData:(NSString *)postData{
    self.URLString = string;
    self.postData = postData;
    self.loadType = XYWebLoadTypePOSTURLString;
}

- (void)webViewloadURLType{
    
    switch (self.loadType) {
        case XYWebLoadTypeURLString:{
            
            [self loadWebURLRequest:self.URLString];
            break;
        }
        case XYWebLoadTypeHTMLString:{
            [self loadWebHtmlURL:self.URLString];
            break;
        }
        case XYWebLoadTypePOSTURLString: {
            // JS发送POST的Flag，为真的时候会调用JS的POST方法
            self.needLoadJSPOST = YES;
            //POST使用预先加载本地JS方法的html实现，请确认WKJSPOST存在
            [self loadHostPathURL:@"WKJSPOST"];
            break;
        }
    }
}

- (void)loadWebURLRequest:(NSString *)URLString {
    
    NSURL *url = [NSURL URLWithString:URLString];
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15];
    [self.wkWebView loadRequest:mutableRequest];
}

- (void)loadWebHtmlURL:(NSString *)urlString {
    
    //加入 meta标签,解决文字自适应
    [self.wkWebView loadHTMLString:[NSString stringWithFormat:@"<meta content=\"width=device-width, initial-scale=1.0, maximum-scale=3.0, user-scalable=0;\" name=\"viewport\" />%@<div id=\"testDiv\" style = \"height:100px; width:100px\"></div>",urlString]  baseURL:[[NSBundle mainBundle] bundleURL]];
}

/// 加载本地 Html 文件
- (void)loadHostPathURL:(NSString *)url{
    //获取JS所在的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:url ofType:@"html"];
    //获得html内容
    NSString *html = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //加载js
    [self.wkWebView loadHTMLString:html baseURL:[[NSBundle mainBundle] bundleURL]];
}

// 调用JS发送POST请求
- (void)postRequestWithJS {
    // 拼装成调用JavaScript的字符串
    NSString *jscript = [NSString stringWithFormat:@"post('%@',{%@});", self.URLString, self.postData];
    // 调用JS代码
    [self.wkWebView evaluateJavaScript:jscript completionHandler:^(id object, NSError * _Nullable error) {
    }];
}

#pragma mark - LMJWebViewControllerDelegate
// 导航条左边的返回按钮的点击
- (void)backBtnClick:(UIButton *)backBtn webView:(WKWebView *)webView {
    if (self.wkWebView.goBack) {
        [self.wkWebView goBack];
    }else {
        [self closeBtnClick:backBtn webView:webView];
    }
}

// 关闭按钮的点击
- (void)closeBtnClick:(UIButton *)closeBtn webView:(WKWebView *)webView {
    // 判断两种情况: push 和 present
    if ((self.navigationController.presentedViewController || self.navigationController.presentingViewController) && self.navigationController.childViewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.rt_navigationController popViewControllerAnimated:YES];
    }
}

// 监听 self.webView.scrollView 的 contentSize 属性改变，从而对底部添加的自定义 View 进行位置调整
- (void)webView:(WKWebView *)webView scrollView:(UIScrollView *)scrollView contentSize:(CGSize)contentSize {
    NSLog(@"%@\n%@\n%@", webView, scrollView, NSStringFromCGSize(contentSize));
}

#pragma mark - LMJWebViewControllerDataSource
// 默认需要, 是否需要进度条
- (BOOL)webViewController:(XYBaseWebViewController *)webViewController webViewIsNeedProgressIndicator:(WKWebView *)webView {
    return YES;
}

// 默认需要自动改变标题
- (BOOL)webViewController:(XYBaseWebViewController *)webViewController webViewIsNeedAutoTitle:(WKWebView *)webView {
    return YES;
}

#pragma mark ================ WKNavigationDelegate ================

// 1, 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    //    //拨打电话
    //    //兼容安卓的服务器写法:<a class = "mobile" href = "tel://电话号码"></a>
    NSURL *URL = navigationAction.request.URL;
    NSString *scheme = [URL scheme];
    if ([scheme isEqualToString:@"tel"]) {
        NSString *resourceSpecifier = [URL resourceSpecifier];
        NSString *callPhone = [NSString stringWithFormat:@"telprompt://%@", resourceSpecifier];
        /// 防止iOS 10及其之后，拨打电话系统弹出框延迟出现
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callPhone]];
        });
        
    }else if ([scheme isEqualToString:@"sms"]) {
        NSString *resourceSpecifier = [URL resourceSpecifier];
        NSString *smsString = [NSString stringWithFormat:@"sms://%@", resourceSpecifier];
        /// 防止iOS 10及其之后，发送短信系统弹出框延迟出现
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:smsString]];
            
        });
        
    }else if ([scheme isEqualToString:@"mailto"]) {
        NSString *resourceSpecifier = [URL resourceSpecifier];
        NSString *emailString = [NSString stringWithFormat:@"mailto://%@",resourceSpecifier];
        /// 防止iOS 10及其之后，发送邮件系统弹出框延迟出现
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:emailString]];
        });
    }
    
    //处理有些网页链接点击无效
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    
    [self updateNavigationItems];
    decisionHandler(WKNavigationActionPolicyAllow);
}

//开始加载
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    //开始加载的时候，让加载进度条显示
    self.progressView.hidden = NO;
    
    NSLog(@"开始加载");
}

// 4, 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}

//服务器请求跳转的时候调用
-(void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"服务器请求跳转的时候调用");
}

//跳转失败的时候调用
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"跳转失败的时候调用");
}

// 5,内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    
}

// 7页面加载完调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    // 判断是否需要加载（仅在第一次加载）
    if (self.needLoadJSPOST) {
        // 调用使用JS发送POST请求的方法
        [self postRequestWithJS];
        // 将Flag置为NO（后面就不需要加载了）
        self.needLoadJSPOST = NO;
    }
    NSLog(@"网页加载完成");

    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [self updateNavigationItems];
}

// 8页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"页面加载失败");
    [MBProgressHUD showErrorMessage:@"网页加载失败"];
}

//当 WKWebView 总体内存占用过大，页面即将白屏的时候，系统会调用回调函数
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    // 在该函数里执行[webView reload](这个时候 webView.URL 取值尚不为 nil）解决白屏问题。
    [webView reload];
}

// 3, 6, 加载 HTTPS 的链接，需要权限认证时调用  \  如果 HTTPS 是用的证书在信任列表中这不要此代理方法
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler {
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential * card = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
    }
}

//拦截执行网页中的JS方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSLog(@"%@",NSStringFromSelector(_cmd));
    NSLog(@"%@",message.body);
    
    //服务器固定格式写法 window.webkit.messageHandlers.名字.postMessage(内容);
    //客户端写法 message.name isEqualToString:@"名字"]
    
}

//KVO监听进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.wkWebView) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.wkWebView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:animated];
        
        // Once complete, fade out UIProgressView
        if(self.wkWebView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }else if ([keyPath isEqualToString:@"title"] && object == self.wkWebView) {
        
        if (!strIsNullOrNoContent(self.wkWebView.title) && [self webViewController:self webViewIsNeedAutoTitle:self.wkWebView]) {
            self.navigationItem.title = self.wkWebView.title;
        }
    }else if ([keyPath isEqualToString:@"contentSize"] && object == self.wkWebView) {
        [self webView:self.wkWebView scrollView:self.wkWebView.scrollView contentSize:self.wkWebView.scrollView.contentSize];

    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark ================ WKUIDelegate ================

// 获取js 里面的提示
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

// js 信息的交流
-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

// 交互。可输入的文本。
-(void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"textinput" message:@"JS调用输入框" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor redColor];
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        //设置网页的配置文件
        WKWebViewConfiguration * webViewConfig = [[WKWebViewConfiguration alloc]init];
        // 允许可以与网页交互，选择视图
        webViewConfig.selectionGranularity = YES;
        // web内容处理池
        webViewConfig.processPool = [[WKProcessPool alloc] init];
        //初始化偏好设置属性：preferences
        webViewConfig.preferences = [WKPreferences new];
        //The minimum font size in points default is 0;
        webViewConfig.preferences.minimumFontSize = 0;
        //是否支持JavaScript
        webViewConfig.preferences.javaScriptEnabled = YES;
        //不通过用户交互，是否可以打开窗口
        webViewConfig.preferences.javaScriptCanOpenWindowsAutomatically = YES;
        // 检测各种特殊的字符串：比如电话、网站
        if (@available(iOS 10.0, *)) {
            webViewConfig.dataDetectorTypes = UIDataDetectorTypeAll;
        }
        // 播放视频
        webViewConfig.allowsInlineMediaPlayback = YES;
        // 是否支持记忆读取
        webViewConfig.suppressesIncrementalRendering = YES;
        //自定义配置,一般用于 js调用oc方法(OC拦截URL中的数据做自定义操作)
        WKUserContentController * userContentController = [[WKUserContentController alloc]init];
        // 允许用户更改网页的设置
        webViewConfig.userContentController = userContentController;
        
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:webViewConfig];
        _wkWebView.backgroundColor = [UIColor whiteColor];
        //kvo 添加进度监控
        [_wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:WkwebBrowserContext];
        [_wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        [_wkWebView addObserver:self.wkWebView.scrollView forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
        
        _wkWebView.translatesAutoresizingMaskIntoConstraints = NO;
        _wkWebView.opaque = NO;
        //适应你设定的尺寸
        [_wkWebView sizeToFit];
    }
    return _wkWebView;
}

-(UIBarButtonItem*)closeButtonItem {
    if (!_closeButtonItem) {
        _closeButtonItem = [UIBarButtonItem barButtonItemWithImage:IMAGENAMED(@"icon-nav-close_15x15_.png") highImage:nil target:self action:@selector(closeItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButtonItem;
}

-(UIBarButtonItem*)customBackBarItem{
    if (!_customBackBarItem) {
        _customBackBarItem = [UIBarButtonItem barButtonItemWithImage:IMAGENAMED(@"bblink_ic_nav_back_22x22_.png") highImage:nil target:self action:@selector(customBackItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _customBackBarItem;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        // 设置进度条的色彩
        [_progressView setTrackTintColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0]];
        _progressView.progressTintColor = [UIColor redColor];
        
        if ([self respondsToSelector:@selector(webViewController:webViewIsNeedProgressIndicator:)]) {
            if (![self webViewController:self webViewIsNeedProgressIndicator:self.wkWebView]) {
                _progressView.hidden = YES;
            }
        }
    }
    return _progressView;
}

//注意，观察的移除
-(void)dealloc {
    
    NSLog(@"XYBaseWebViewController----dealloc");
    [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [self.wkWebView removeObserver:self forKeyPath:@"title"];
    [self.wkWebView removeObserver:self.wkWebView.scrollView forKeyPath:@"contentSize"];
    
    self.wkWebView.UIDelegate = nil;
    self.wkWebView.navigationDelegate = nil;
    self.wkWebView.scrollView.delegate = nil;
}

@end
