//
//  XYNewFeatureViewController.m
//  XYProjectKit
//
//  Created by xiaoye on 2019/7/10.
//  Copyright © 2019 JiongYe. All rights reserved.
//

#import "XYNewFeatureViewController.h"
#import "XYNewFeatureCollectionViewCell.h"

NSString *const kCurrentVersionKey = @"kCurrentVersion";
static NSString *const XYNewFeatureCollectionViewCellIndenifier = @"XYNewFeatureCollectionViewCellIndenifier";

@interface XYNewFeatureViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray <NSString *> *imagesArray;

@end

@implementation XYNewFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.pageControl];
}

#pragma mark - 控制屏幕旋转的方法
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.imagesArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    XYNewFeatureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:XYNewFeatureCollectionViewCellIndenifier forIndexPath:indexPath];
    
    cell.image = [UIImage imageNamed:self.imagesArray[indexPath.row]];
    [cell setIndexPath:indexPath count:self.imagesArray.count];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.view.bounds.size;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger page = scrollView.contentOffset.x / scrollView.bounds.size.width + 0.5;
    
    self.pageControl.currentPage = page;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.layer.backgroundColor = [UIColor whiteColor].CGColor;
        [_collectionView registerClass:[XYNewFeatureCollectionViewCell class] forCellWithReuseIdentifier:XYNewFeatureCollectionViewCellIndenifier];
    }
    
    return _collectionView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.numberOfPages = self.imagesArray.count;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.center = CGPointMake(self.view.width * 0.5, self.view.height * 0.8);
    }
    return _pageControl;
}

- (NSArray <NSString *> *)imagesArray {
    
    if (!_imagesArray) {
        _imagesArray = @[@"intro_0.jpg",@"intro_1.jpg",@"intro_2.jpg",@"intro_3.jpg"];
    }
    return _imagesArray;
}

@end
