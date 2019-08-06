//
//  AppDelegate.m
//  XYProjectKit
//
//  Created by xiaoye on 2019/5/6.
//  Copyright © 2019 JiongYe. All rights reserved.
//

#import "AppDelegate.h"
#import <AvoidCrash/AvoidCrash.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self initWindow];
    
    // 异常信息监听
    #ifdef DEBUG
    //开始监听上报异常
    [AvoidCrash makeAllEffective];
    
    NSArray *noneSelClassStrings = @[
                                     @"NSNull",
                                     @"NSNumber",
                                     @"NSString",
                                     @"NSDictionary",
                                     @"NSArray"
                                     ];
    [AvoidCrash setupNoneSelClassStringsArr:noneSelClassStrings];
    NSArray *noneSelClassPrefix = @[
                                    @"XY"
                                    ];
    [AvoidCrash setupNoneSelClassStringPrefixsArr:noneSelClassPrefix];
    
    #endif
    //监听通知:AvoidCrashNotification, 获取AvoidCrash捕获的崩溃日志的详细信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithCrashMessage:) name:AvoidCrashNotification object:nil];
    

    return YES;
}

// 空指针异常错误处理
- (void)dealwithCrashMessage:(NSNotification *)note {
    //注意:所有的信息都在userInfo中
    NSLog(@"******************* 空指针异常 %@", note.userInfo);
    NSDictionary *dict = note.userInfo;
    if(dict) {
        NSString *name = [NSString stringWithFormat:@"空指针异常:%@", dict[@"errorPlace"]];
        NSString *reason = dict[@"errorReason"];
        NSException *ex = [[NSException alloc] initWithName:name reason:reason userInfo:dict];
        [Bugly reportException:ex];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"再见");
}




@end
