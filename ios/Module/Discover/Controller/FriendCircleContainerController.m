//
//  FriendCircleContainerController.m
//  Puzzle
//
//  Created by huibei on 16/12/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "FriendCircleContainerController.h"
#import "JCHATConversationListViewController.h"
#import "RRFFriendCircleController.h"
#import "XTChatUtil.h"
#import "MyFriendCircleController.h"
#import "CirclePopMenuController.h"
#import "ContactListController.h"
#import "FPPopoverController.h"
#import "FriendSearchController.h"
#import "PZNavController.h"
#import "JCHATConversationViewController.h"
@interface FriendCircleContainerController ()<WMPageControllerDelegate, WMPageControllerDataSource,WMMenuViewDelegate>

@property(assign,nonatomic) NSInteger currentIndex ;
@property(strong,nonatomic)FPPopoverController* popover ;
@end

@implementation FriendCircleContainerController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *viewControllers = @[[RRFFriendCircleController class],[JCHATConversationListViewController class]];
    NSArray *titles = @[@"动态",@"喜信"];
    self.viewControllerClasses = viewControllers;
    self.titleColorSelected = [UIColor colorWithHexString:@"4964ef"];
    self.titleColorNormal = [UIColor whiteColor];
    self.titles = titles;
    self.titleSizeSelected = 18;
    self.pageAnimatable = YES;
    
    UIView* titleView = self.navigationItem.titleView ;
    UIView* titleBgView = [[UIView alloc]init];
    titleBgView.layer.masksToBounds = YES ;
    titleBgView.layer.cornerRadius = 14 ;
    [titleView insertSubview:titleBgView atIndex:0];
    [titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(titleView.mas_centerX);
        make.centerY.mas_equalTo(titleView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(120, 28.0f));
    }];
    titleBgView.backgroundColor = [UIColor colorWithHexString:@"354ee9"];
    
    self.menuView.delegate = self ;
    self.delegate = self;
    self.dataSource = self;
    self.navigationItem.titleView.backgroundColor = [UIColor clearColor];
    [self setNavItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNavItemBadge) name:NotifyChat object:nil];

}

-(void)setNavItem
{
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"circle-of-friends_icon_mail-list"] style:UIBarButtonItemStylePlain target:self action:@selector(goMyCircle)];
    self.navigationItem.rightBarButtonItem = rightItem;//为导航栏添加右侧按钮
}

#pragma mark - 我的朋友圈
-(void)goMyCircle{
    MyFriendCircleController* friendCircle = [[MyFriendCircleController alloc]init];
    friendCircle.title = @"朋友通讯录" ;
    [self.navigationController pushViewController:friendCircle animated:YES];
}

-(void)rightItemClick:(UIButton*)sender{
    WEAKSELF
    CirclePopMenuController *menuVc=[[CirclePopMenuController alloc]init];
    menuVc.menuTitles = @[@"发起群聊" ,@"通讯录", @"添加朋友"];
    menuVc.menusImages = @[@"xixin_icon_group-chat" ,@"xixin_icon_mail-list", @"xixin_icon_add-friends-"];
    menuVc.view.backgroundColor = [UIColor clearColor];
    menuVc.itemBlock = ^(NSNumber* index){
        NSInteger row = [index integerValue];
        if (row == 0) {
//            [weakSelf creatGroupChat];
        }
        else if (row == 1){
            MyFriendCircleController* circle = [[MyFriendCircleController alloc]init];
            circle.title = @"朋友通讯录" ;
            [self.navigationController pushViewController:circle animated:YES];
        }
        else if(row ==2){
            FriendSearchController* friendSearch = [[FriendSearchController alloc]init];
            friendSearch.title = @"添加朋友" ;
            [weakSelf.navigationController pushViewController:friendSearch animated:YES];
        }
        [weakSelf.popover dismissPopoverAnimated:YES];
    };
    //2.新建一个popoverController，并设置其内容控制器
    self.popover= [[FPPopoverController alloc]initWithViewController:menuVc];
    //3.设置尺寸
    self.popover.contentSize = CGSizeMake(160,200 - 44 - 6);
    self.popover.tint = FPPopoverLightGrayTint ;
    //4.显示
    [self.popover presentPopoverFromView:sender];
}


#pragma mark - 返回
-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)menuView:(WMMenuView *)menu itemMarginAtIndex:(NSInteger)index{
    return 0.0f;
}


- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 2;
}


- (__kindof UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    if (index == 0) {
        RRFFriendCircleController *friendVC = [[RRFFriendCircleController alloc] init];
        return friendVC ;
    }
    JCHATConversationListViewController* chatVC = [[JCHATConversationListViewController alloc]init];
    
    return chatVC;
}

-(void)updateNavItemBadge{
    WEAKSELF
    [XTChatUtil getConversationBadge:^(NSNumber* unreadCount) {
        if (unreadCount != nil) {
//            weakSelf.selectIndex = 1 ;
//            [weakSelf reloadData];
        }
    }];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateNavItemBadge];
}


@end
