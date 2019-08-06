//
//  XYPlayerController.h
//  XYProjectKit
//
//  Created by xiaoye on 2019/6/14.
//  Copyright © 2019 JiongYe. All rights reserved.
//  承载视频播放器的基类

#import <Foundation/Foundation.h>
#import "XYPlayerMediaPlaybackProtocol.h"
#import "XYPlayerMediaControlProtocol.h"
#import "XYVoidPlayerViewSkin.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYPlayerController : NSObject

/// 正常模式下的某一帧视频图
@property (nonatomic, strong) UIView *containerView;

/// 当前视频管理类必须遵循 `XYPlayerMediaPlayback` 协议.
@property (nonatomic, strong) id <XYPlayerMediaPlaybackProtocol> currentPlayerManager;

/// playerView 必须遵循  `XYPlayerMediaControl` 协议.
@property (nonatomic, strong) UIView <XYPlayerMediaControlProtocol> *controlView;

/// 初始化界面皮肤 默认皮肤为蓝色
@property (nonatomic, assign) XYVoidPlayerViewSkin viewSkin;

/**
 功能: 创建一个XYPlayerController来播放单个视频
 参数: playerManager 遵循 XYPlayerMediaPlaybackProtocol 协议
      containerView 要查看视频某一帧，必须设置contrainerView
      skin 视频播放器的皮肤样式
 */
+ (instancetype)playerWithPlayerManager:(id<XYPlayerMediaPlaybackProtocol>)playerManager
                          containerView:(UIView *)containerView
                                   skin:(XYVoidPlayerViewSkin)skin;

/**
 功能: 创建一个XYPlayerController来播放单个视频
 参数: playerManager 遵循 XYPlayerMediaPlaybackProtocol 协议
      containerView 要查看视频某一帧，必须设置contrainerView
      skin 视频播放器的皮肤样式
 */
- (instancetype)initWithPlayerManager:(id<XYPlayerMediaPlaybackProtocol>)playerManager
                        containerView:(UIView *)containerView
                                 skin:(XYVoidPlayerViewSkin)skin;

/**
 功能: 创建一个XYPlayerController来播放单个视频 在tableViewCell 中 或 UICollerctionView 中使用
 参数: scrollView 传入一个 继承自 UIScrollView 的视图
      playerManager 遵循 XYPlayerMediaPlaybackProtocol 协议
      containerViewTag 播放视图的索引
      skin 视频播放器的皮肤样式
 */
+ (instancetype)playerWithScrollView:(UIScrollView *)scrollView
                       playerManager:(id <XYPlayerMediaPlaybackProtocol>)playerManager
                       containerViewTag:(NSInteger)containerViewTag
                                skin:(XYVoidPlayerViewSkin)skin;

/**
 功能: 创建一个XYPlayerController来播放单个视频 在tableViewCell 中 或 UICollerctionView 中使用
 参数: scrollView 传入一个 继承自 UIScrollView 的视图
      playerManager 遵循 XYPlayerMediaPlaybackProtocol 协议
      containerViewTag 播放视图的索引
      skin 视频播放器的皮肤样式
 */
- (instancetype)initWithScrollView:(UIScrollView *)scrollView
                     playerManager:(id <XYPlayerMediaPlaybackProtocol>)playerManager
                  containerViewTag:(NSInteger)containerViewTag
                              skin:(XYVoidPlayerViewSkin)skin;

- (void)updateScrollViewPlayerToCell;

- (void)updateNoramlPlayerWithContainerView:(UIView *)containerView;


@end

NS_ASSUME_NONNULL_END
