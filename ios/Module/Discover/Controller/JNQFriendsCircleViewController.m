//
//  JNQFriendsCircleViewController.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQFriendsCircleViewController.h"
#import "PZCommonCellModel.h"
#import "CommonTableViewCell.h"
#import "JNQInviteAwardViewController.h"
#import "JNQFriendRankViewController.h"
#import "JNQFriendGuessViewController.h"
#import "InviteFriendController.h"
#import "FPPopoverController.h"
#import "CirclePopMenuController.h"
#import "ContactListController.h"
#import "MyFriendCircleController.h"
@interface JNQFriendsCircleViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSArray *_dataArray;
}
@property(strong,nonatomic)FPPopoverController* popover ;

@end

@implementation JNQFriendsCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = HBColor(245, 245, 245);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dataArray = [NSArray array];
    
    [self setNav];
    [self loadData];
}

- (void)setNav {
    UIButton *navRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [navRight setTitle:@"邀请" forState:UIControlStateNormal];
    [navRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    navRight.titleLabel.font = PZFont(13.5);
    navRight.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [navRight addTarget:self action:@selector(inviteFriend:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:navRight];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)loadData {
    PZCommonCellModel *inviteAward = [PZCommonCellModel cellModelWithIcon:@"friendcircle_icon_invitation" title:@"邀请奖励" subTitle:@"" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:[JNQInviteAwardViewController class]];

    PZCommonCellModel *guessRank = [PZCommonCellModel cellModelWithIcon:@"friendcircle_icon_rank" title:@"竞猜排行" subTitle:@"朋友盈利及猜中率排行" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:[JNQFriendRankViewController class]];
    guessRank.itemClick = ^() {
        JNQFriendRankViewController *rankVC = [[JNQFriendRankViewController alloc] init];
        rankVC.navigationItem.title = @"竞猜排行";
        rankVC.rankType = FriendRankTypeIncome;
        [self.navigationController pushViewController:rankVC animated:YES];
    };
    
    PZCommonCellModel *friendGuess = [PZCommonCellModel cellModelWithIcon:@"friendcircle_icon_guess" title:@"朋友猜吧" subTitle:@"朋友投注动态" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:[JNQFriendGuessViewController class]];
    
    _dataArray = @[@[inviteAward], @[guessRank], @[friendGuess]];
}

-(void)inviteFriend{
    InviteFriendController* invite = [[InviteFriendController alloc]init];
    invite.title = @"邀请朋友" ;
    [self.navigationController pushViewController:invite animated:YES];
}


-(void)inviteFriend:(UIButton*)sender{
    WEAKSELF
    CirclePopMenuController *menuVc=[[CirclePopMenuController alloc]init];
    menuVc.view.backgroundColor = [UIColor clearColor];
    menuVc.itemBlock = ^(NSNumber* index){
        NSInteger row = [index integerValue];
        if (row == 0) {
            [weakSelf inviteFriend];
        }
        else if (row == 1){
            ContactListController* contact = [[ContactListController alloc]init];
            contact.title = @"通讯录邀请" ;
            [self.navigationController pushViewController:contact animated:YES];
        }
        else if(row ==2){
            MyFriendCircleController* friendCircle = [[MyFriendCircleController alloc]init];
            friendCircle.title = @"我的朋友圈" ;
            [self.navigationController pushViewController:friendCircle animated:YES];
        }
        [weakSelf.popover dismissPopoverAnimated:YES];
    };
    //2.新建一个popoverController，并设置其内容控制器
    self.popover= [[FPPopoverController alloc]initWithViewController:menuVc];
    //3.设置尺寸
    self.popover.contentSize = CGSizeMake(160,200 - 44 - 20);
    self.popover.tint = FPPopoverLightGrayTint ;
    //4.显示
    [self.popover presentPopoverFromView:sender];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = _dataArray[section];
    return array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12.0f;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* headView = [[UIView alloc]init];
    headView.frame = CGRectMake(0, 0, SCREENWidth, 12.0f);
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
        cell.detailTextLabel.font = PZFont(13);
        cell.sepLine.backgroundColor = HBColor(211, 211, 211);
        cell.sepHeight = 0.35;
    }
    cell.accessoryType = model.accessoryType;
    cell.imageView.image = [UIImage imageNamed:model.icon];
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.subTitle;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.bottomLineSetFlush = indexPath.row == sec.count-1 ? YES : NO;
    cell.topLineShow = indexPath.row == 0 ? YES : NO;
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

@end
