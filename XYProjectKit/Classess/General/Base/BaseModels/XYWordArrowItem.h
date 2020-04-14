//
//  XYWordArrowItem.h
//  XYProjectKit
//
//  Created by xiaoye on 2020/4/4.
//  Copyright © 2020 JiongYe. All rights reserved.
//

#import "XYWordItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface XYWordArrowItem : XYWordItem

/** ViewCntroller  */
@property (nonatomic, assign) Class itemClass;
@property (nonatomic, assign) BOOL isStoryboard;
@property (nonatomic, copy) NSString *storyboardName;
@property (nonatomic, copy) NSString *storyboardIdentifier;

@end

NS_ASSUME_NONNULL_END
