//
//  XYMoveNavigationViewController.m
//  XYProjectKit
//
//  Created by xiaoye on 2020/4/5.
//  Copyright © 2020 JiongYe. All rights reserved.
//

#import "XYMoveNavigationViewController.h"
#import "XYNormalViewController.h"

// offsetY > -64 的时候导航栏开始偏移
#define NAVBAR_TRANSLATION_POINT 64
#define NavBarHeight 44

@interface XYMoveNavigationViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation XYMoveNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"浮动效果";
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.imgView;
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
    [self defualtAutomaticallyAdjustsView];
}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    
    [self initializeSelfVCSetting];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.tableView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.tableView.delegate = nil;
    [self setNavigationBarTransformProgress:0];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_TRANSLATION_POINT){
        [UIView animateWithDuration:0.3 animations:^{
            [self setNavigationBarTransformProgress:1];
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            [self setNavigationBarTransformProgress:0];
        }];
    }
}

- (void)setNavigationBarTransformProgress:(CGFloat)progress {
    [self.navigationController.navigationBar xy_setTranslationY:(-NavBarHeight * progress)];
    // 有系统的返回按钮，所以 hasSystemBackIndicator = YES
    [self.navigationController.navigationBar xy_setBarButtonItemsAlpha:(1 - progress) hasSystemBackIndicator:YES];
}

#pragma mark - tableview delegate / dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:nil];
    NSString *str = [NSString stringWithFormat:@"XYNavigationBar %zd",indexPath.row];
    cell.textLabel.text = str;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XYNormalViewController *normalVC = VCLOADFROMUISB(@"NavigationBar", @"XYNormalViewController");
    
    [self.rt_navigationController pushViewController:normalVC animated:YES complete:nil];
}

#pragma mark - getter / setter
- (UITableView *)tableView {
    if (_tableView == nil) {
        CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        _tableView = [[UITableView alloc] initWithFrame:frame
                                                  style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIImageView *)imgView {
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image6"]];
        _imgView.frame = CGRectMake(0, 0, kScreenWidth, 260);
    }
    return _imgView;
}
@end
