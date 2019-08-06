//
//  WebChatPayH5VIew.m
//  One
//
//  Created by MJL on 2018/1/12.
//  Copyright © 2018年 MJL. All rights reserved.
//

#import "WebChatPayH5VIew.h"


@interface WebChatPayH5VIew ()<UIWebViewDelegate>

@property (strong, nonatomic) UIWebView *myWebView;

@property (assign, nonatomic) BOOL isLoading;

@end

@implementation WebChatPayH5VIew

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.myWebView = [[UIWebView alloc] initWithFrame:self.frame];
        [self addSubview:self.myWebView];
        self.myWebView.delegate = self;
    }
    return self;
}

#pragma mark 加载地址
- (void)loadingURL:(NSString *)url withIsWebChatURL:(BOOL)isLoading {
    //首先要设置为NO
    self.isLoading = isLoading;
    [MBProgressHUD showActivityMessageInView:nil];
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = [request URL];
    NSString *newUrl = url.absoluteString;
    if (!self.isLoading) {
        if ([newUrl rangeOfString:@"weixin://wap/pay"].location != NSNotFound) {
            NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            [self.myWebView loadRequest:request];
            self.isLoading = YES;
            return NO;
        }
    } else {
        if ([newUrl rangeOfString:@"weixin://wap/pay"].location != NSNotFound) {
            self.myWebView = nil;
            UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
            [self addSubview:web];
            NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            [web loadRequest:request];
            return YES;
        }
    }
    
    NSDictionary *headers = [request allHTTPHeaderFields];
    BOOL hasReferer = [headers objectForKey:@"Referer"] != nil;
    if (hasReferer) {
        return YES;
    } else {
        // relaunch with a modified request
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                NSURL *url = [request URL];
                NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
                //设置授权域名
                [request setValue:@"www.zjlrr.cn://" forHTTPHeaderField: @"Referer"];
                [self.myWebView loadRequest:request];
            });
        });
        return NO;
    }
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {

    NSLog(@"++++++ 加载成功 ++++ ");
    
    [MBProgressHUD hideHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD hideHUD];
    [MBProgressHUD showMessage:@"调取微信失败"];
    
}


@end
