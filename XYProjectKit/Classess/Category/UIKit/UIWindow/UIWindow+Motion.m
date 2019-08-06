//
//  UIWindow+Motion.m
//  ProjectUkitSet
//
//  Created by xiaoye on 2018/7/4.
//  Copyright © 2018年 xiaoye. All rights reserved.
//

#import "UIWindow+Motion.h"
#import <AudioToolbox/AudioToolbox.h>

#ifdef DEBUG
#import <FLEXManager.h>
#endif

@implementation UIWindow (Motion)

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"开始摇一摇");
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    
    //摇动结束
    if (event.subtype == UIEventSubtypeMotionShake) {
        NSLog(@"摇一摇结束");
#ifdef DEBUG
        [[FLEXManager sharedManager] showExplorer];
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//振动效果 需要#import <AudioToolbox/AudioToolbox.h>
        //播放声音
        SystemSoundID soundID;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"motion" ofType:@"mp3"];
        if (path) {
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
            AudioServicesPlaySystemSound (soundID);
        }
#endif
        
    }
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"摇一摇取消");
}

- (BOOL)canBecomeFirstResponder {
    
    return YES;
}


@end
