//
//  XYNetWorkingCache.h
//  ProjectUkitSet
//
//  Created by xiaoye on 2018/7/6.
//  Copyright © 2018年 ixiye. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <YYCache.h>
// 过期提醒
#define Deprecated(instead) NS_DEPRECATED(2_0, 2_0, 2_0, 2_0, instead)

#define XYNetworkCache(URL,Parameters) [XYNetWorkingCache httpCacheForURL:URL parameters:Parameters]


@interface XYNetWorkingCache : NSObject

#pragma mark - 网络数据缓存类

/**
 *  缓存网络数据,根据请求的 URL与parameters
 *  做KEY存储数据, 这样就能缓存多级页面的数据
 *
 *  @param httpData   服务器返回的数据
 *  @param URL        请求的URL地址
 *  @param parameters 请求的参数
 */
+ (void)setHttpCache:(id)httpData URL:(NSString *)URL parameters:(NSDictionary *)parameters;

/**
 *  根据请求的 URL与parameters 取出缓存数据
 *
 *  @param URL        请求的URL
 *  @param parameters 请求的参数
 *
 *  @return 缓存的服务器数据
 */
+ (id)httpCacheForURL:(NSString *)URL parameters:(NSDictionary *)parameters;

/**
 *  根据请求的URL与parameters 异步取出缓存数据
 *
 *  @param URL 请求的URL
 *  @param parameters 请求的参数
 *  @param block 异步回调缓存的数据
 */
+ (void)cacheForURL:(NSString *)URL parameters:(NSDictionary *)parameters withBlock:(void(^)(id<NSCoding> object))block;


/**
 *  获取网络缓存的总大小 动态单位(GB,MB,KB,B)
 *
 *  @return 网络缓存的总大小
 */
+ (NSString *)getAllHttpCacheSize;

/**
 *  删除所有网络缓存,
 */
+ (void)removeAllHttpCache;

/**
 *  删除所有网络缓存
 *  推荐使用该方法 不会阻塞主线程，同时返回Progress
 */
+ (void)removeAllHttpCacheBlock:(void(^)(int removedCount, int totalCount))progress
                       endBlock:(void(^)(BOOL error))end;

@end

/**
 
 static const NSInteger defaultCacheMaxCacheAge  = 60*60*24*7;

 
 [[NSNotificationCenter defaultCenter] addObserver:self
 selector:@selector(automaticCleanCache)
 name:UIApplicationWillTerminateNotification
 object:nil];
 
 [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backgroundCleanCache) name:UIApplicationDidEnterBackgroundNotification object:nil];
 
 */


/**
 
 
 #pragma  mark - 设置过期时间 清除某路径缓存文件
 - (void)automaticCleanCache{
 [self clearCacheWithTime:defaultCacheMaxCacheAge completion:nil];
 }
 
 - (void)clearCacheWithTime:(NSTimeInterval)time completion:(ZBCacheCompletedBlock)completion{
 [self clearCacheWithTime:time path:self.diskCachePath completion:completion];
 }
 
 - (void)clearCacheWithTime:(NSTimeInterval)time path:(NSString *)path completion:(ZBCacheCompletedBlock)completion{
 if (!time||!path)return;
 dispatch_async(self.operationQueue,^{
 // “-” time
 NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:-time];
 
 NSDirectoryEnumerator *fileEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:path];
 
 for (NSString *fileName in fileEnumerator){
 NSString *filePath = [path stringByAppendingPathComponent:fileName];
 
 NSDictionary *info = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
 NSDate *current = [info objectForKey:NSFileModificationDate];
 
 if ([[current laterDate:expirationDate] isEqualToDate:expirationDate]){
 [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
 }
 }
 if (completion) {
 dispatch_async(dispatch_get_main_queue(), ^{
 completion();
 });
 }
 });
 }
 
 - (void)backgroundCleanCacheWithPath:(NSString *)path{
 Class UIApplicationClass = NSClassFromString(@"UIApplication");
 if(!UIApplicationClass || ![UIApplicationClass respondsToSelector:@selector(sharedApplication)]) {
 return;
 }
 UIApplication *application = [UIApplication performSelector:@selector(sharedApplication)];
 __block UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
 // Clean up any unfinished task business by marking where you
 // stopped or ending the task outright.
 [application endBackgroundTask:bgTask];
 bgTask = UIBackgroundTaskInvalid;
 }];
 // Start the long-running task and return immediately.
 [self clearCacheWithTime:defaultCacheMaxCacheAge path:path completion:^{
 [application endBackgroundTask:bgTask];
 bgTask = UIBackgroundTaskInvalid;
 }];
 }
 
 - (void)backgroundCleanCache {
 [self backgroundCleanCacheWithPath:self.diskCachePath];
 }

 
 
 */
