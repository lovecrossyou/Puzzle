//
//  JNQPageViewController.m
//  Puzzle
//
//  Created by HuHuiPay on 16/11/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQPageViewController.h"
#import "JNQRankViewController.h"
#import "JNQRankView.h"

@interface JNQPageViewController () <WMPageControllerDelegate, WMPageControllerDataSource,WMMenuViewDelegate>

@property (nonatomic, strong) JNQRankSelectView *selectView;

@end

@implementation JNQPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_rankViewType == RankViewTypeCurrent) {
        [self setNav];
    }
    [self buildUI];
    NSArray *viewControllers = @[[JNQRankViewController class], [JNQRankViewController class], [JNQRankViewController class]];
    NSArray *titles = @[@"年度排行", @"本月排行", @"本周排行"];
    self.viewControllerClasses = viewControllers;
    self.titles = titles;
    self.titleSizeSelected = 15;
    self.pageAnimatable = YES;
    self.menuHeight = 60;
    self.menuViewStyle = WMMenuViewStyleFlood;
    self.titleColorSelected = [UIColor whiteColor];
    self.titleColorNormal = [UIColor colorWithRed:168.0/255.0 green:20.0/255.0 blue:4/255.0 alpha:1];
    self.progressColor = [UIColor colorWithRed:168.0/255.0 green:20.0/255.0 blue:4/255.0 alpha:1];
    self.itemsWidths = @[@(70),@(100),@(70)]; // 这里可以设置不同的宽度
    self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
    self.menuView.alpha = 0.0f;
    self.menuView.delegate = self ;
    self.delegate = self;
    self.dataSource = self;
}

-(void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info{
    NSInteger index = [info[@"index"] integerValue];
    [self selectViewDidSelect:index];
}

- (void)setNav {
    UIButton *rightNav = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightNav setTitle:@"往期" forState:UIControlStateNormal];
    [rightNav setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightNav.titleLabel.font = PZFont(16);
    [[rightNav rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSArray *viewControllers = @[[JNQRankViewController class], [JNQRankViewController class], [JNQRankViewController class]];
        NSArray *titles = @[@"年度排行", @"本月排行", @"本周排行"];
        JNQPageViewController *pageVC = [[JNQPageViewController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles];
        pageVC.rankViewType = RankViewTypePrior;
        pageVC.title = @"往期争霸";
        [self.navigationController pushViewController:pageVC animated:YES];
    }];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightNav];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)buildUI {
    WEAKSELF
    UIImageView *backImgView = [[UIImageView alloc] init];
    [self.view insertSubview:backImgView atIndex:0];
    [backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [backImgView setImage:[UIImage imageNamed:@"ranking_lg"]];
    
    NSArray *btnTitle = [NSArray array];
    if (_rankViewType == RankViewTypeCurrent) {
        btnTitle = @[@"年度排行", @"本月排行", @"本周排行"];
    } else {
        btnTitle = @[@"上周排行", @"上月排行", @"上年排行"];
    }

    
    _selectView = [[JNQRankSelectView alloc] initWithFrame:CGRectMake(18, 12.5, SCREENWidth-36, 35)];
    [self.view insertSubview:_selectView atIndex:1];
    _selectView.backgroundColor = [UIColor clearColor];
    _selectView.titleArray = btnTitle;
    _selectView.btnBlock = ^(UIButton *button) {
        weakSelf.selectIndex = (int)button.tag;
        [weakSelf selectViewDidSelect:weakSelf.selectIndex];
    };
    [weakSelf selectViewDidSelect:self.selectIndex];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 3;
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    JNQRankViewController *rankVC = [[JNQRankViewController alloc] init];
    NSArray *rankArr = [NSArray array];
    if (self.rankViewType == RankViewTypeCurrent) {
        rankVC.rankViewType = RankViewTypeCurrent;
        rankArr = @[@(RankTypeCurrentYear), @(RankTypeCurrentMonth), @(RankTypeCurrentWeek)];
    } else {
        rankVC.rankViewType = RankViewTypePrior;
        rankArr = @[@(RankTypePriorWeek), @(RankTypePriorMonth), @(RankTypePriorYear)];
    }
    rankVC.rankType = [rankArr[index] integerValue];
    return rankVC;
}


- (void)selectViewDidSelect:(NSInteger)index {
    for (UIButton *btn in _selectView.subviews) {
        btn.selected = btn.tag == index ? YES : NO;
        btn.userInteractionEnabled = btn.tag == index ? NO : YES;
    }
}


- (void)setRankType:(RankType)rankType {
    _rankType = rankType;
    if (rankType == RankTypeCurrentYear) {
        self.selectIndex = 0;
    } else if (rankType == RankTypeCurrentMonth) {
        self.selectIndex = 1;
    } else if (rankType == RankTypeCurrentWeek) {
        self.selectIndex = 2;
    }
}

@end
