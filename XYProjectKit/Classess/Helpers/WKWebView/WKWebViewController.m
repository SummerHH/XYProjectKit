//
//  WKWebViewController.m
//  fula
//
//  Created by xiyedev on 2017/9/11.
//  Copyright © 2017年 ixiye company. All rights reserved.
//

#import "WKWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WKWebView.h>
#import <WebKit/WebKit.h>

#import "WebChatPayH5VIew.h"

typedef enum{
    loadWebURLString = 0,
    loadWebHTMLString,
    POSTWebURLString,
}wkWebLoadType;

static void *WkwebBrowserContext = &WkwebBrowserContext;

@interface WKWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,UINavigationControllerDelegate,UINavigationBarDelegate,UIGestureRecognizerDelegate>
{
    UILongPressGestureRecognizer *_longPress;
}
@property (nonatomic, strong) WKWebView *wkWebView;
//设置加载进度条
@property (nonatomic,strong) UIProgressView *progressView;
//仅当第一次的时候加载本地JS
@property(nonatomic,assign) BOOL needLoadJSPOST;
//网页加载的类型
@property(nonatomic,assign) wkWebLoadType loadType;
//保存的网址链接
@property (nonatomic, copy) NSString *URLString;
//保存POST请求体
@property (nonatomic, copy) NSString *postData;
//返回按钮
@property (nonatomic)UIBarButtonItem* customBackBarItem;
//关闭按钮
@property (nonatomic)UIBarButtonItem* closeButtonItem;
//分享按钮
@property (nonatomic)UIBarButtonItem *shareButtonItem;
//保存 url 的连接
@property (nonatomic, strong) NSMutableArray *mutableUrlArr;

@end

@implementation WKWebViewController


//注意，观察的移除
-(void)dealloc{
    
    [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [self.wkWebView removeObserver:self forKeyPath:@"title"];
    [self.wkWebView removeObserver:self forKeyPath:@"URL"];


    [self.wkWebView setNavigationDelegate:nil];
    [self.wkWebView setUIDelegate:nil];

    NSLog(@"++++++销毁了++++");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (_isNavHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    if (!self.isGoBackRootVC) {
        // 开启返回手势
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //加载web页面
    [self webViewloadURLType];
    
    //添加到主控制器上
    [self.view addSubview:self.wkWebView];
    
    //添加进度条
    [self.view addSubview:self.progressView];
    //添加刷新
    /*
    if (self.loadType == loadWebHTMLString) {
        __weak typeof(self) weakSelf = self;
        self.wkWebView.scrollView.mj_header = [XYRefreshHeader headerWithRefreshingBlock:^{

            [weakSelf loadHostPathURL:self.URLString];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.wkWebView.scrollView.mj_header endRefreshing];
            });
        }];
    }
     */
    
    if (_isNavHidden) {
        [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(kStatusBarHeight);
            make.left.right.bottom.mas_equalTo(self.view);
        }];
    }else {
        [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(self.view);
        }];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_isNavHidden == YES) {
        self.navigationController.navigationBarHidden = YES;
        //创建一个高20的假状态栏
        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kStatusBarHeight)];
        statusBarView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:statusBarView];
    }else{
        self.navigationController.navigationBarHidden = NO;
        if (self.isGoBackRootVC) { //禁用手势
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            }
        }else {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        }
        
        [self.navigationItem setLeftBarButtonItems:@[self.customBackBarItem]];
        
        if (self.isShareBtn) {
            
            self.navigationItem.rightBarButtonItem = self.shareButtonItem;
        }
    }
    
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.UIDelegate = self;
}

#pragma mark - 返回
-(void)customBackItemClicked{
    if (self.isGoBackRootVC) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    if (self.isGoBack) {
        if (self.appearMode == XYWKWebViewAppearModePush) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else {
        if (self.wkWebView.canGoBack) {
            [self.wkWebView goBack];
            //返回需要刷新页面
            if (self.isRolad) {
                [self.wkWebView reload];
            }
            
        }else{
            if (self.appearMode == XYWKWebViewAppearModePush) {
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }
    }
}

-(void)closeItemClicked{

    if (self.appearMode == XYWKWebViewAppearModePush) {
        if (self.isGoBackRootVC) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark ================ 加载方式 ================
- (void)webViewloadURLType{
    
    switch (self.loadType) {
        case loadWebURLString:{
            
            [self loadWebURLRequest:self.URLString];
            break;
        }
        case loadWebHTMLString:{
            [self loadHostPathURL:self.URLString];
            break;
        }
        case POSTWebURLString:{
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

- (void)loadHostPathURL:(NSString *)url{
    //加入 meta标签,解决文字自适应
    [self.wkWebView loadHTMLString:[NSString stringWithFormat:@"<meta content=\"width=device-width, initial-scale=1.0, maximum-scale=3.0, user-scalable=0;\" name=\"viewport\" />%@<div id=\"testDiv\" style = \"height:100px; width:100px\"></div>",url]  baseURL:[[NSBundle mainBundle] bundleURL]];
}

// 调用JS发送POST请求
- (void)postRequestWithJS {
    // 拼装成调用JavaScript的字符串
    NSString *jscript = [NSString stringWithFormat:@"post('%@',{%@});", self.URLString, self.postData];
    // 调用JS代码
    [self.wkWebView evaluateJavaScript:jscript completionHandler:^(id object, NSError * _Nullable error) {
    }];
}

#pragma make - setter --
- (void)setIsNavHidden:(BOOL)isNavHidden {
    _isNavHidden = isNavHidden;
}

- (void)setIsAllowsBackNavigationGestures:(BOOL)isAllowsBackNavigationGestures {
    _isAllowsBackNavigationGestures = isAllowsBackNavigationGestures;
    self.wkWebView.allowsBackForwardNavigationGestures = _isAllowsBackNavigationGestures;
}

- (void)setIsGoBack:(BOOL)isGoBack {
    _isGoBack = isGoBack;
}

#pragma mark - getter --
- (void)loadWebURLSring:(NSString *)string{
    
//    NSString *urlString = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.URLString = string;
    self.loadType = loadWebURLString;
}

- (void)loadWebHTMLSring:(NSString *)string{
    self.URLString = string;
    self.loadType = loadWebHTMLString;
}

- (void)POSTWebURLSring:(NSString *)string postData:(NSString *)postData{
    self.URLString = string;
    self.postData = postData;
    self.loadType = POSTWebURLString;
}

#pragma mark ================ 自定义返回/关闭按钮 ================
-(void)updateNavigationItems{
    if (self.isGoBack) {
        if (self.isGoBackRootVC) { //禁用手势
            if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            }
        }else {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            
        }
        [self.navigationItem setLeftBarButtonItems:@[self.customBackBarItem]];
        
    }else {
        if (self.wkWebView.canGoBack) {
            UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
            spaceButtonItem.width = 1;
            
            [self.navigationItem setLeftBarButtonItems:@[self.customBackBarItem,spaceButtonItem,self.closeButtonItem] animated:NO];
        }else{
            if (self.isGoBackRootVC) { //禁用手势
                if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
                    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
                }
            }else {
                self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            }
            [self.navigationItem setLeftBarButtonItems:@[self.customBackBarItem]];
        }
    }
}

//请求链接处理
-(void)pushCurrentSnapshotViewWithRequest:(NSURLRequest*)request{
    //    NSLog(@"push with request %@",request);

    //如果url是很奇怪的就不push
    if ([request.URL.absoluteString isEqualToString:@"about:blank"]) {
        //        NSLog(@"about blank!! return");
        return;
    }
}

#pragma mark ================ WKNavigationDelegate ================

//这个是网页加载完成，导航的变化
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    /*
     主意：这个方法是当网页的内容全部显示（网页内的所有图片必须都正常显示）的时候调用（不是出现的时候就调用），，否则不显示，或则部分显示时这个方法就不调用。
     */
    // 判断是否需要加载（仅在第一次加载）
    if (self.needLoadJSPOST) {
        // 调用使用JS发送POST请求的方法
        [self postRequestWithJS];
        // 将Flag置为NO（后面就不需要加载了）
        self.needLoadJSPOST = NO;
    }
    NSLog(@"网页加载完成");
    // 获取加载网页的标题
//    NSString * requestString = webView.URL.absoluteString;
//    NSLog(@"=====页面加载完成 %@ ",requestString);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self updateNavigationItems];
}

//开始加载
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    //开始加载的时候，让加载进度条显示
    self.progressView.hidden = NO;
//    NSLog(@"-- 开始加载 -- %@ ",[webView.URL absoluteString]);
    
    NSLog(@"开始加载");
}

//内容返回时调用
-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
    NSLog(@"内容开始返回的时候调用");
}

//服务器请求跳转的时候调用
-(void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"服务器请求跳转的时候调用");
}

//服务器开始请求的时候调用
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"服务器开始请求的时候调用");
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
    
    [self pushCurrentSnapshotViewWithRequest:navigationAction.request];
    //处理有些网页链接点击无效
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    
    //    NSLog(@"--拦截自定义连接-%@---",[navigationAction.request.URL absoluteString]);
    [self updateNavigationItems];
    
    NSLog(@"--连接-%@---",navigationAction.request);

    NSString *url = navigationAction.request.URL.absoluteString;
    if ([url containsString:@"https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb?"]) {
//  微信支付链接不要拼接redirect_url，如果拼接了还是会返回到浏览器的
        //传入的是微信支付链接：https://wx.tenpay.com/cgi-bin/mmpayweb-bin/checkmweb?prepay_id=wx22092249950765f0885685c01044602580&package=3951570505

        //这里把webView设置成一个像素点，主要是不影响操作和界面，主要的作用是设置referer和调起微信
        WebChatPayH5VIew *h5View = [[WebChatPayH5VIew alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        //url是没有拼接redirect_url微信h5支付链接
        [h5View loadingURL:url withIsWebChatURL:NO];
        [self.view addSubview:h5View];
        
        decisionHandler(WKNavigationActionPolicyCancel);
        
    } else {
        
        decisionHandler(WKNavigationActionPolicyAllow);
    }

}

// 内容加载失败时候调用
-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"页面加载超时");
}

//跳转失败的时候调用
-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    NSLog(@"跳转失败的时候调用");
}

//进度条
-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    
    NSLog(@"进度条");
//    // 在该函数里执行[webView reload](这个时候 webView.URL 取值尚不为 nil）解决白屏问题。
//    [webView reload];
}

// 如果是OC
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    
    NSLog(@"didReceiveAuthenticationChallenge");
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential * card = [[NSURLCredential alloc] initWithTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    NSLog(@"WKWebView GestureRecognizer YES");
    return YES;
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
        self.title = self.wkWebView.title;
    }else if ([keyPath isEqualToString:@"URL"] && object == self.wkWebView) {
        
        NSLog(@" wkWebView URL:  %@",_wkWebView.URL.absoluteString);
        NSString *urlString = _wkWebView.URL.absoluteString;
        /// 解决导航的关闭按钮
        BOOL isBool =[self.mutableUrlArr containsObject:urlString];
        if (!isBool) {
            if (strIsNullOrNoContent(urlString)) {
                return;
            }
            [self.mutableUrlArr addObject:urlString];
            if (self.mutableUrlArr.count > 1) {
                UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
                spaceButtonItem.width = 1;
                
                [self.navigationItem setLeftBarButtonItems:@[self.customBackBarItem,spaceButtonItem,self.closeButtonItem] animated:NO];
                
            }else {
                [self.navigationItem setLeftBarButtonItems:@[self.customBackBarItem]];
            }
            
        }else {
            /// URL 已经存在数组中,要解决返回时是否显示关闭按钮
            if (self.mutableUrlArr.count == 1) {
                [self.navigationItem setLeftBarButtonItems:@[self.customBackBarItem]];
            }
        }
       
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark ================ WKScriptMessageHandler ================

//拦截执行网页中的JS方法
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{

    NSLog(@"%@",NSStringFromSelector(_cmd));
    NSLog(@"%@",message.body);
    
    //服务器固定格式写法 window.webkit.messageHandlers.名字.postMessage(内容);
    //客户端写法 message.name isEqualToString:@"名字"]
  
    
}


//####################################################################################


//***********************************************
#pragma mark ================ 懒加载 ================

- (WKWebView *)wkWebView{
    if (!_wkWebView) {
        //设置网页的配置文件
        WKWebViewConfiguration * webViewConfig = [[WKWebViewConfiguration alloc]init];
        // 允许可以与网页交互，选择视图
        webViewConfig.selectionGranularity = YES;
        // web内容处理池
        webViewConfig.processPool = [[WKProcessPool alloc] init];
        //自定义配置,一般用于 js调用oc方法(OC拦截URL中的数据做自定义操作)
        WKUserContentController * userContentController = [[WKUserContentController alloc]init];

        webViewConfig.userContentController = userContentController;
        
        // 添加消息处理，注意：self指代的对象需要遵守WKScriptMessageHandler协议，结束时需要移除
//        [userContentController addScriptMessageHandler:self name:@""];
        
        // 是否支持记忆读取
        webViewConfig.suppressesIncrementalRendering = YES;
        // 允许用户更改网页的设置
        webViewConfig.userContentController = userContentController;
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:webViewConfig];
        _wkWebView.backgroundColor = [UIColor whiteColor];
        //kvo 添加进度监控
        [_wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:WkwebBrowserContext];
        [_wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        [_wkWebView addObserver:self forKeyPath:@"URL" options:NSKeyValueObservingOptionNew context:NULL];
        _wkWebView.translatesAutoresizingMaskIntoConstraints = NO;
//        //开启手势触摸
//        _wkWebView.allowsBackForwardNavigationGestures = YES;
        // 设置 可以前进 和 后退
        //适应你设定的尺寸
        [_wkWebView sizeToFit];
    }
    return _wkWebView;
}

-(UIBarButtonItem*)closeButtonItem {
    if (!_closeButtonItem) {
        _closeButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGENAMED(@"NavgationBar_close.png") style:UIBarButtonItemStylePlain target:self action:@selector(closeItemClicked)];
        
    }
    return _closeButtonItem;
}

-(UIBarButtonItem*)customBackBarItem{
    if (!_customBackBarItem) {
        _customBackBarItem = [[UIBarButtonItem alloc] initWithImage:IMAGENAMED(@"NavgationBar_black.png") style:UIBarButtonItemStylePlain target:self action:@selector(customBackItemClicked)];
    }
    
    return _customBackBarItem;
}


- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        if (_isNavHidden == YES) {
            _progressView.frame = CGRectMake(0, 20, self.view.bounds.size.width, 3);
        }else{
            _progressView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 3);
        }
        // 设置进度条的色彩
        [_progressView setTrackTintColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0]];
        _progressView.progressTintColor = [UIColor redColor];
    }
    return _progressView;
}

- (NSMutableArray *)mutableUrlArr {
    if (!_mutableUrlArr) {
        _mutableUrlArr = [NSMutableArray new];
    }
    return _mutableUrlArr;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

@end
