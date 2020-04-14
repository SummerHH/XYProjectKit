//
//  XYCustomNavigationBarViewController.m
//  XYProjectKit
//
//  Created by xiaoye on 2020/4/4.
//  Copyright © 2020 JiongYe. All rights reserved.
//

#import "XYCustomNavigationBarViewController.h"
#import "XYCustomNavigationBar.h"

#define NAVBAR_COLORCHANGE_POINT (IMAGE_HEIGHT - NAV_HEIGHT*2)
#define IMAGE_HEIGHT 280
#define NAV_HEIGHT 64

static NSString *const XYCustomNavigationBarCellIdentifier = @"XYCustomNavigationBarCellIdentifier";

@interface XYCustomNavigationBarViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) XYCustomNavigationBar *customNavBar;

@end

@implementation XYCustomNavigationBarViewController

- (void)dealloc {
    
    NSLog(@"%@ :已经销毁了", NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置自定义导航栏背景图片
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.customNavBar];
    
    [self initialization];
}

- (void)initialization {
 
    self.tableView.tableHeaderView = self.topView;

    self.customNavBar.barBackgroundImage = [UIImage imageNamed:@"millcolorGrad"];
    self.customNavBar.title = @"自定义导航栏";
    self.customNavBar.titleLabelColor = [UIColor whiteColor];
    [self.customNavBar xy_setBottomLineHidden:YES];
    // 设置初始导航栏透明度
    [self.customNavBar xy_setLeftButtonWithImage:[UIImage imageNamed:@"bbmf_ic_nav_close_24x24_"]];
    [self.customNavBar xy_setBackgroundAlpha:0];
    
    XYWeakSelf(self)
    self.customNavBar.onClickLeftButton = ^{
        XYStrongSelf(self)
        [self.rt_navigationController popViewControllerAnimated:YES complete:nil];
    };

    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self defualtAutomaticallyAdjustsView];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [self initializeSelfVCSetting];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > NAVBAR_COLORCHANGE_POINT) {
        CGFloat alpha = (offsetY - NAVBAR_COLORCHANGE_POINT) / NAV_HEIGHT;
        [self.customNavBar xy_setBackgroundAlpha:alpha];
    } else {
        [self.customNavBar xy_setBackgroundAlpha:0];
    }
}

#pragma mark - tableview delegate / dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:XYCustomNavigationBarCellIdentifier];
    NSString *str = [NSString stringWithFormat:@"XYNavigationBar %zd",indexPath.row];
    cell.textLabel.text = str;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}

#pragma mark - getter / setter

- (XYCustomNavigationBar *)customNavBar {
    if (!_customNavBar) {
        _customNavBar = [[XYCustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTopHeight)];
        _customNavBar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
        UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;
    }
    return _customNavBar;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:XYCustomNavigationBarCellIdentifier];
    }
    return _tableView;
}

- (UIImageView *)topView {
    if (_topView == nil) {
        _topView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image8"]];
        _topView.frame = CGRectMake(0, 0, self.view.frame.size.width, IMAGE_HEIGHT);
    }
    return _topView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
