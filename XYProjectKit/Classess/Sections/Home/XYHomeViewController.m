//
//  XYHomeViewController.m
//  XYProjectKit
//
//  Created by xiaoye on 2019/5/6.
//  Copyright © 2019 JiongYe. All rights reserved.
//

#import "XYHomeViewController.h"
#import "XYDebugTableViewController.h"
#import "XYBaseWebViewController.h"
#import "XYBaseNavigationViewController.h"
#import "XYLoginViewController.h"
#import "XYNavigationViewController.h"
#import "RTMPLiveViewController.h"

static NSString *const XYHomeTableCellIdentifier = @"XYHomeTableCellIdentifier";

@interface XYHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;


@end

@implementation XYHomeViewController

- (void)dealloc {

    NSLog(@" %@ : 销毁了", NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialization];
    
    XYWordArrowItem *item0 = [XYWordArrowItem itemWithTitle:@"导航栏" subTitle:@""];
    item0.itemClass = [XYNavigationViewController class];
    
    XYWordArrowItem *item1 = [XYWordArrowItem itemWithTitle:@"Live(直播)" subTitle:@""];
    item1.itemClass = [RTMPLiveViewController class];
    
    self.dataArr = @[item0,item1];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"PROJECT";

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"nextStep" style:UIBarButtonItemStylePlain target:self action:@selector(nextStepClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self xy_setNavBarTintColor:[UIColor orangeColor]];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"模态" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick:)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

- (void)nextStepClick:(UIButton *)sender {
    
    XYBaseWebViewController *webVc = [[XYBaseWebViewController alloc] init];
    [webVc loadWebURLSring:@"https://www.baidu.com"];
    [self.rt_navigationController pushViewController:webVc animated:YES complete:nil];
    
}

- (void)leftBtnClick:(UIButton *)sender {
    
    XYLoginViewController *loginVC = [[XYLoginViewController alloc] init];
    
    XYBaseNavigationViewController *navi = [[XYBaseNavigationViewController alloc] initWithRootViewController:loginVC];
       navi.modalPresentationStyle = UIModalPresentationFullScreen;
    [[[AppDelegate shareAppDelegate] getCurrentViewController] presentViewController:navi animated:YES completion:nil];
}


- (void)initialization {

    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark ******  UITableViewDataSource  *******
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XYHomeTableCellIdentifier forIndexPath:indexPath];
    
    XYWordArrowItem *item = self.dataArr[indexPath.row];
    
    cell.textLabel.text = item.title;
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XYWordArrowItem *item = self.dataArr[indexPath.row];
    if (item.itemClass) {
        UIViewController *vc = [[item.itemClass alloc] init];
        if ([vc isKindOfClass:[UIViewController class]]) {
            [self.rt_navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark ******  UItableView  *******
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:XYHomeTableCellIdentifier];
    }
    return _tableView;
}


@end
