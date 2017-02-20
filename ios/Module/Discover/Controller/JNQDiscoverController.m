//
//  JNQDiscoverController.m
//  Puzzle
//
//  Created by huibei on 16/8/3.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQDiscoverController.h"
#import "FPPopoverController.h"
#import "ContactListController.h"
#import "JNQPageViewController.h"
#import "InviteFriendController.h"
#import "CirclePopMenuController.h"
#import "JNQDiamondViewController.h"
#import "MyFriendCircleController.h"
#import "RRFFriendCircleController.h"
#import "JNQVIPUpdateViewController.h"
#import "JNQInviteAwardViewController.h"
#import "JNQPresentAwardViewController.h"
#import "JNQFriendsCircleViewController.h"

#import "PZCommonCellModel.h"

#import "CommonTableViewCell.h"

#import "PZParamTool.h"
#import "PZCache.h"
#import "JCHATConversationListViewController.h"
#import "PZNavController.h"
#import "XTChatUtil.h"
#import "UIBarButtonItem+Badge.h"
#import "FriendCircleContainerController.h"
#import "KxMenu.h"
#import "FreeBuyController.h"
#import "FortuneController.h"
#import "RRFFriendCircleController.h"
@interface JNQDiscoverController () <UITableViewDelegate, UITableViewDataSource, WMPageControllerDelegate, WMPageControllerDataSource,FPPopoverControllerDelegate> {
    NSArray *_dataArray;
}
@property(strong,nonatomic)FPPopoverController* popover ;
@property(weak,nonatomic)UIView* tipView ;

@property(strong,nonatomic)UIBarButtonItem *rightItem ;
@property(strong,nonatomic)CirclePopMenuController *menuVc;
@property(weak,nonatomic) UITableView* tableView ;
@end

@implementation JNQDiscoverController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self setNavItem];
    self.edgesForExtendedLayout = UIRectEdgeNone ;
    _dataArray = [NSMutableArray array];
    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    self.tableView  = tableView ;
    
    self.tableView.backgroundColor = HBColor(245, 245, 245);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self loadDiscoverData];
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAll) name:RefreshDiscover object:nil];
//    朋友圈提示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyCircle:) name:NotifyCircle object:nil];
//    朋友圈提示消除
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyClearCircle) name:NotifyClearCircle object:nil];
}

-(void)notifyCircle:(NSNotification*)notificate{
    if (self.tipView != nil) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        CommonTableViewCell* cell = self.tableView.visibleCells[1] ;
        UIView* tipView = [[UIView alloc]init];
        tipView.backgroundColor = [UIColor redColor];
        tipView.layer.cornerRadius = 3 ;
        tipView.alpha = 0.8 ;
        [cell addSubview:tipView];
        [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(6, 6));
            make.left.mas_equalTo(90+15+6);
            make.centerY.mas_equalTo(cell.mas_centerY);
        }];
        self.tipView = tipView ;
    });
}

-(void)notifyClearCircle{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.tipView != nil) {
            [self.tipView removeFromSuperview];
            self.tipView = nil ;
        }
    });
}

-(void)refreshAll{
    [ self loadDiscoverData];
    [self.tableView reloadData];
}

-(void)setNavItem
{
    UIButton *right = [[UIButton alloc]init];
    right.titleLabel.textAlignment = NSTextAlignmentRight;
    [right setImage:[UIImage imageNamed:@"find_btn_xixin"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(goChat) forControlEvents:UIControlEventTouchUpInside];
    right.frame = CGRectMake(0, 0, 44, 44);
    right.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)goChat{
    [XTChatUtil autoLogin:^(id resultObject, NSError *error) {
        JCHATConversationListViewController* chat = [[JCHATConversationListViewController alloc]init];
        chat.title = @"喜信";
        [self.navigationController pushViewController:chat animated:YES];
    }];
}

#pragma mark - 会话/朋友圈
-(void)chatConversation{
    WEAKSELF
    [XTChatUtil getConversationBadge:^(NSNumber* unreadCount) {
        __block int selectIndex = 0 ;
        if (unreadCount != nil) {
            selectIndex = 1 ;
        }
        FriendCircleContainerController* chatViewController = [[FriendCircleContainerController alloc]init];
        chatViewController.showOnNavigationBar = YES;
        chatViewController.menuViewStyle = WMMenuViewStyleFlood;
        chatViewController.itemsWidths = @[@(54),@(54)]; // 这里可以设置不同的宽度
        chatViewController.progressWidth = 64.0f ;
        chatViewController.progressColor = [UIColor whiteColor];
        chatViewController.progressViewIsNaughty = YES ;
        chatViewController.menuHeight = 32.0f ;
        chatViewController.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        chatViewController.selectIndex = selectIndex ;
        [weakSelf.navigationController pushViewController:chatViewController animated:YES];
    }];
}


- (void)showMenu:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:@"微信邀请"
                     image:[UIImage imageNamed:@"circle-of-friends_icon_weixin"]
                    target:self
                    action:@selector(inviteFriend)],
      
      [KxMenuItem menuItem:@"短信邀请"
                     image:[UIImage imageNamed:@"circle-of-friends_icon_mail-list"]
                    target:self
                    action:@selector(msgClick)],
      
      [KxMenuItem menuItem:@"朋友通讯录"
                     image:[UIImage imageNamed:@"circle-of-friends_icon_my-friends"]
                    target:self
                    action:@selector(goMyCircle)]
      ];
    CGRect frame = CGRectMake(SCREENWidth - 105+24, -44, 100, 50);
    [KxMenu showMenuInView:self.tableView
                  fromRect:frame
                 menuItems:menuItems];
}

-(void)msgClick{
    ContactListController* contact = [[ContactListController alloc]init];
    contact.title = @"短信邀请" ;
    [self.navigationController pushViewController:contact animated:YES];
}

-(void)inviteFriend{
    InviteFriendController* invite = [[InviteFriendController alloc]init];
    invite.title = @"邀请朋友" ;
    [self.navigationController pushViewController:invite animated:YES];
}

-(void)goMyCircle{
    MyFriendCircleController* friendCircle = [[MyFriendCircleController alloc]init];
    friendCircle.title = @"我的朋友圈" ;
    [self.navigationController pushViewController:friendCircle animated:YES];
}

- (void)loadDiscoverData {
    WEAKSELF
    PZCommonCellModel *frendsCircle = [PZCommonCellModel cellModelWithIcon:@"fing_icon_friend" title:@"朋友圈" subTitle:@"朋友动态" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:[RRFFriendCircleController class]];
    //喜信
    PZCommonCellModel *xMessage = [PZCommonCellModel cellModelWithIcon:@"find_icon_xixin" title:@"喜信" subTitle:@"即时聊天" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:nil];
    xMessage.itemClick = ^() {
        [weakSelf goChat];
    };
    PZCommonCellModel *vipUpdate = [PZCommonCellModel cellModelWithIcon:@"fing_icon_vip" title:@"升级会员" subTitle:@"" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:[JNQVIPUpdateViewController class]];
    PZCommonCellModel *guessRank = [PZCommonCellModel cellModelWithIcon:@"fing_icon_ranking-list" title:@"股神争霸" subTitle:@"收益排行榜" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:[JNQPageViewController class]];
    guessRank.itemClick = ^() {
        JNQPageViewController *pageVC = [[JNQPageViewController alloc] init];
        pageVC.rankViewType = RankViewTypeCurrent;
        pageVC.title = @"股神争霸";
        [self.navigationController pushViewController:pageVC animated:YES];
    };
    
    PZCommonCellModel *diamondPay = [PZCommonCellModel cellModelWithIcon:@"fing_icon_diamonds" title:@"购买钻石" subTitle:@"" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:[JNQDiamondViewController class]];
    PZCommonCellModel *presentStore = [PZCommonCellModel cellModelWithIcon:@"fing_icon_mall" title:@"礼品商城" subTitle:@"" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:[JNQPresentAwardViewController class]];
    
    PZCommonCellModel *dailyHoroscope = [PZCommonCellModel cellModelWithIcon:@"find_icon_horoscope" title:@"每日运程" subTitle:@"" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:[FortuneController class]];
    PZCommonCellModel *freeBuyStore = [PZCommonCellModel cellModelWithIcon:@"find_icon_o" title:@"0元夺宝" subTitle:@"" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:[FreeBuyController class]];
    
    BOOL appOpen = [PZCache sharedInstance].versionRelease ;
    if (appOpen) {
        _dataArray = @[@[frendsCircle,xMessage], @[vipUpdate, diamondPay], @[freeBuyStore, presentStore],@[dailyHoroscope]];
    }
    else{
        _dataArray = @[@[frendsCircle,xMessage], @[guessRank], @[presentStore]];
    }
}

#pragma mark - Tableview Datasource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = _dataArray[section];
    return array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = section ? 10 : 15;
    return height;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* headView = [[UIView alloc]init];
    CGFloat height = section ? 10 : 7.5;
    headView.frame = CGRectMake(0, 0, SCREENWidth, height);
    headView.backgroundColor = HBColor(245, 245, 245);
    return headView ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sec = _dataArray[indexPath.section];
    PZCommonCellModel *model = sec[indexPath.row];
    CommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JNQDiscoverController"];
    if (!cell) {
        cell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"JNQDiscoverController"];
        cell.textLabel.font = PZFont(16.5);
        cell.textLabel.textColor = HBColor(51, 51, 51);
        cell.detailTextLabel.textColor = HBColor(153, 153, 153);
        cell.detailTextLabel.font = PZFont(12);
        cell.sepLine.backgroundColor = HBColor(211, 211, 211);
        cell.sepHeight = 0.35;
    }
    cell.accessoryType = model.accessoryType;
    cell.imageView.image = [UIImage imageNamed:model.icon];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.subTitle;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == sec.count-1) {
        cell.bottomLineSetFlush = YES;
    } else {
        cell.bottomLineSetFlush = NO;
    }
    if (indexPath.row == 0) {
        cell.topLineShow = YES;
    } else {
        cell.topLineShow = NO;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sec = _dataArray[indexPath.section];
    PZCommonCellModel *model = sec[indexPath.row];
    if (model.itemClick) {
        model.itemClick();
    }
    else{
        UIViewController *desc = [[model.descVc alloc]init];
        desc.title = model.title;
        [self.navigationController pushViewController:desc animated:YES];
    }
}

-(void)updateNavItemBadge{
    WEAKSELF
    [XTChatUtil getConversationBadge:^(NSNumber* unreadCount) {
        if (unreadCount != nil) {
            [weakSelf notifyCircle:nil];
        }
        else{
            [weakSelf notifyClearCircle];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateNavItemBadge];
}


@end
