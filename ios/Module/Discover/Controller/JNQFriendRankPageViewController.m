//
//  JNQFriendRankPageViewController.m
//  Puzzle
//
//  Created by HuHuiPay on 16/11/18.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQFriendRankPageViewController.h"
#import "JNQFriendRankViewController.h"
#import "JNQOperateSelectView.H"

@interface JNQFriendRankPageViewController () <WMPageControllerDelegate, WMPageControllerDataSource,WMMenuViewDelegate>

@property (nonatomic, strong) JNQOperateSelectView *selectView;

@end

@implementation JNQFriendRankPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUI];
    NSArray *viewControllers = @[[JNQFriendRankViewController class], [JNQFriendRankViewController class]];
    NSArray *titles = @[@"年度排行", @"本月排行", @"本周排行"];
    self.viewControllerClasses = viewControllers;
    self.titles = titles;
    self.titleSizeSelected = 15;
    self.pageAnimatable = YES;
    self.menuHeight = 45;
    self.menuViewStyle = WMMenuViewStyleFlood;
    self.titleColorSelected = [UIColor whiteColor];
    self.titleColorNormal = [UIColor colorWithRed:168.0/255.0 green:20.0/255.0 blue:4/255.0 alpha:1];
    self.progressColor = [UIColor colorWithRed:168.0/255.0 green:20.0/255.0 blue:4/255.0 alpha:1];
    self.itemsWidths = @[@(70),@(100)]; // 这里可以设置不同的宽度
    self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
    self.menuView.alpha = 0.0f;
    self.menuView.delegate = self ;
    self.delegate = self;
    self.dataSource = self;
}


- (void)buildUI {
    WEAKSELF
    _selectView = [[JNQOperateSelectView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 45) btnCount:2];
    [self.view insertSubview:_selectView atIndex:0];
    NSArray *btnTitle = @[@"收益排名", @"命中率排名"];
    _selectView.btnTitleArray = btnTitle;
    _selectView.buttonBlock = ^(UIButton *button) {
        weakSelf.selectIndex = (int)button.tag;
        [weakSelf selectViewDidSelect:button.tag];
    };

}

- (void)selectViewDidSelect:(NSInteger)index {
    [_selectView.glideView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_selectView).offset(SCREENWidth/2*index);
    }];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 2;
}

-(void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info{
    NSInteger index = [info[@"index"] integerValue];
    [self selectViewDidSelect:index];
}

- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    JNQFriendRankViewController *friendRankVC = [[JNQFriendRankViewController alloc] init];
    friendRankVC.rankType = index ? FriendRankTypeHit : FriendRankTypeIncome;
    return friendRankVC;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
