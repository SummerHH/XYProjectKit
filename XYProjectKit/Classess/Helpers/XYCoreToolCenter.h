//
//  XYCoreToolCenter.h
//  fula
//
//  Created by xiyedev on 2017/11/1.
//  Copyright © 2017年 ixiye company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYCoreToolCenter : NSObject

extern void ShowSuccessStatus(NSString *statues);
extern void ShowErrorStatus(NSString *statues);
extern void ShowMaskStatus(NSString *statues);
extern void ShowMessage(NSString *statues);
extern void ShowProgress(CGFloat progress);
extern void DismissHud(void);

@end
