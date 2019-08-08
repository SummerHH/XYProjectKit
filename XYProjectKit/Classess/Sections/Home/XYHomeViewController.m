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

static NSString *const XYHomeTableCellIdentifier = @"XYHomeTableCellIdentifier";

@interface XYHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *titlesArr;
@property (nonatomic, strong) NSArray *viewControllersArr;

@end

@implementation XYHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initialization];
    
    self.titlesArr = @[@"普通样式",
                       @"横屏播放",
                       @"列表点击播放"];
    
    self.viewControllersArr = @[@"XYNormalViewController",
                                @"XYNotAutoPlayViewController",
                                @"XYFullScreenViewController"];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"哈哈哈";
    /*
    [self xy_setNavBarBarTintColor:[UIColor redColor]];
    [self xy_setNavBarBackgroundAlpha:1.0f];
    [self xy_setNavBarTitleColor:[UIColor blueColor]];
    */
    [self xy_setNavBarShadowImageHidden:YES];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"nextStep" style:UIBarButtonItemStylePlain target:self action:@selector(nextStepClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self xy_setNavBarTintColor:[UIColor orangeColor]];
    
}

- (void)nextStepClick:(UIButton *)sender {
    
    XYBaseWebViewController *webVc = [[XYBaseWebViewController alloc] init];
    [webVc loadWebURLSring:@"https://www.baidu.com"];
    [self.rt_navigationController pushViewController:webVc animated:YES complete:nil];
    
}

- (void)initialization {

    [self.view addSubview:self.tableView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

#pragma mark ******  UITableViewDataSource  *******
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titlesArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:XYHomeTableCellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = self.titlesArr[indexPath.row];
    if (indexPath.row == 1) {
        UITextField *textField = [[UITextField alloc] init];
        textField.frame = CGRectMake(130, 0, 200, 40);
        textField.backgroundColor = [UIColor purpleColor];
        textField.borderStyle = UITextBorderStyleLine;
        [cell.contentView addSubview:textField];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *vcString = self.viewControllersArr[indexPath.row];
    UIViewController *viewController = [[NSClassFromString(vcString) alloc] init];

    viewController.navigationItem.title = self.titlesArr[indexPath.row];
    [self.rt_navigationController pushViewController:viewController animated:YES];
    
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
