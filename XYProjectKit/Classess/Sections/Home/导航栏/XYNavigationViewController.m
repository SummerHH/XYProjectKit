//
//  XYNavigationViewController.m
//  XYProjectKit
//
//  Created by xiaoye on 2020/4/4.
//  Copyright © 2020 JiongYe. All rights reserved.
//

#import "XYNavigationViewController.h"
#import "XYNormalViewController.h"
#import "XYNavigationBarHiddenViewController.h"
#import "XYNoSideslipViewController.h"
#import "XYBaseWebViewController.h"
#import "XYCustomNavigationBarViewController.h"
#import "XYGradualChangeViewController.h"
#import "XYMoveNavigationViewController.h"

static NSString *const TableViewReuseIdentifier = @"tableViewReuseIdentifier";

@interface XYNavigationViewController ()

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation XYNavigationViewController

- (void)dealloc {
    
    NSLog(@"%@ :已经销毁了", NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"导航栏样式";
    
    XYWordArrowItem *item = [XYWordArrowItem itemWithTitle:@"默认导航" subTitle:@""];
    item.isStoryboard = YES;
    item.storyboardName = @"NavigationBar";
    item.storyboardIdentifier = @"XYNormalViewController";
    
    XYWordArrowItem *item1 = [XYWordArrowItem itemWithTitle:@"隐藏导航栏" subTitle:@""];
    item1.isStoryboard = YES;
    item1.storyboardName = @"NavigationBar";
    item1.storyboardIdentifier = @"XYNavigationBarHiddenViewController";

    XYWordArrowItem *item2 = [XYWordArrowItem itemWithTitle:@"自定义导航栏" subTitle:@""];
      item2.itemClass = [XYCustomNavigationBarViewController class];

    XYWordArrowItem *item3 = [XYWordArrowItem itemWithTitle:@"禁止返回" subTitle:@""];
    item3.isStoryboard = YES;
    item3.storyboardName = @"NavigationBar";
    item3.storyboardIdentifier = @"XYNoSideslipViewController";

    XYWordArrowItem *item4 = [XYWordArrowItem itemWithTitle:@"Push and remove" subTitle:@""];
    item4.isStoryboard = YES;
    item4.storyboardName = @"NavigationBar";
    item4.storyboardIdentifier = @"XYPushRemoveViewController";

    XYWordArrowItem *item5 = [XYWordArrowItem itemWithTitle:@"渐变导航栏" subTitle:@""];
    item5.itemClass = [XYGradualChangeViewController class];
    
    XYWordArrowItem *item6 = [XYWordArrowItem itemWithTitle:@"测试IQKeyboardyManger" subTitle:@""];
    item6.isStoryboard = YES;
    item6.storyboardName = @"NavigationBar";
    item6.storyboardIdentifier = @"XYIQKeyboardTestViewController";

    XYWordArrowItem *item7 = [XYWordArrowItem itemWithTitle:@"测试IQKeyboardyManger对 Tabble的影响" subTitle:@""];
    item7.isStoryboard = YES;
    item7.storyboardName = @"NavigationBar";
    item7.storyboardIdentifier = @"XYIQKeyboardyTableViewController";
    
    XYWordArrowItem *item8 = [XYWordArrowItem itemWithTitle:@"导航栏上移" subTitle:@""];
    item8.itemClass = [XYMoveNavigationViewController class];
    

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:TableViewReuseIdentifier];

    self.dataArr = @[item,item1,item2,item3,item4,item5,item8,item6,item7];
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"webView" style:UIBarButtonItemStylePlain target:self action:@selector(rightitemClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewReuseIdentifier forIndexPath:indexPath];
    
    XYWordArrowItem *item = self.dataArr[indexPath.row];
    
    cell.textLabel.text = item.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XYWordArrowItem *item = self.dataArr[indexPath.row];
    
    if (item.itemClass && !item.isStoryboard) {
        UIViewController *vc = [[item.itemClass alloc] init];
        if ([vc isKindOfClass:[UIViewController class]]) {
            [self.rt_navigationController pushViewController:vc animated:YES];
        }
    }else {
        if (!strIsNullOrNoContent(item.storyboardName) && !strIsNullOrNoContent(item.storyboardIdentifier)) {
            UIViewController *vc = VCLOADFROMUISB(item.storyboardName, item.storyboardIdentifier);
            [self.rt_navigationController pushViewController:vc animated:YES complete:nil];
        }
    }
}

- (void)rightitemClick:(UIButton *)sender {
    
    XYBaseWebViewController *webVc = [[XYBaseWebViewController alloc] init];
    [webVc loadWebURLSring:@"https://www.baidu.com"];
    webVc.isNavHidden = YES;
    [self.rt_navigationController pushViewController:webVc animated:YES complete:nil];
}


/**
 
 /// 1. 彩蛋
 
 pod 'RTInteractivePush'
 UINavigationController (RTInteractivePush)，可以实现屏幕右侧的UIScreenEdgePanGestureRecognizer

 //实现，控制器内部实现
 - (UIViewController*)rt_nextSiblingController
 返回右滑要push的controller
 
 /// 2.自定义按钮和导航实现
 //默认使用的是RTRoot框架内部的导航效果和返回按钮，如果要自定义，必须将此属性设置为NO，然后实现下方方法；self.rt_navigationController.useSystemBackBarButtonItem = NO;
 
 - (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action{

 }

 - (Class)rt_navigationBarClass {
 
     return [RTCustomNavigationBar class];
 }
 
 /// 3. 隐藏导航栏,千万记住可不是rt_navigationController
 self.navigationController.navigationBar.hidden = YES

 /// 4. 禁止左滑
 在`-viewDidLoad`中设置了左项，则默认情况下将禁用交互式弹出窗口，如果您真的需要，您仍然可以将“rt_disableInteractivePop”设置为**NO**。
 
 */


@end
