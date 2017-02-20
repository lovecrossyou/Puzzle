//
//  RRFMessageNoticeListController.m
//  Puzzle
//
//  Created by huibei on 16/10/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFMessageNoticeListController.h"
#import "RRFMessageNoticeListCell.h"
#import "NotificateMsgUtil.h"
#import "RRFMessageNoticeListModel.h"
#import "NotificateMsgUtil.h"
#import "RRFReplyListController.h"
#import "MyFriendCircleController.h"
@interface RRFMessageNoticeListController ()
@property(nonatomic,strong)NSArray *dataList;
@property(nonatomic,weak)UIButton *btnClear;
@end

@implementation RRFMessageNoticeListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 120.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView registerClass:[RRFMessageNoticeListCell class] forCellReuseIdentifier:@"RRFMessageNoticeListController"];
    [self getData];
    if (self.comeInType == 0) {
        [NotificateMsgUtil setAllUnread];
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshBadgeValue object:nil];
    }
    if (self.fromCircle) {
        [NotificateMsgUtil setAllCicleUnread];
    }
    else{
        [NotificateMsgUtil setAllUnread];

    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifyClearCircle object:nil];

}
-(void)settingNavItem
{
    UIButton *btnClear = [[UIButton alloc]init];
    [btnClear setTitle:@"清空" forState:UIControlStateNormal];
    btnClear.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [btnClear setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnClear setTitleColor:[UIColor colorWithHexString:@"93a0f4"] forState:UIControlStateDisabled];
    btnClear.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnClear addTarget:self action:@selector(clearAllData) forControlEvents:UIControlEventTouchUpInside];
    [btnClear sizeToFit];
    self.btnClear = btnClear;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:btnClear];
    self.navigationItem.rightBarButtonItem = item;
}
-(void)clearAllData
{
    if (self.fromCircle) {
        [NotificateMsgUtil clearAllCircleData];
    }
    else{
        [NotificateMsgUtil clearAllSLData];
    }
    self.dataList = nil;
    [self.tableView reloadData];
}
-(void)getData
{
    if (self.fromCircle) {
        //来自朋友圈
        if (self.comeInType == 0) {
            self.dataList = [NotificateMsgUtil loadCircleAll:YES];
        }else{
            self.dataList = [NotificateMsgUtil loadCircleAll];
            [self settingNavItem];
        }
    }
    else{
        if (self.comeInType == 0) {
            self.dataList = [NotificateMsgUtil loadMsgUnRead];
        }else{
            self.dataList = [NotificateMsgUtil loadAllMsg];
            [self settingNavItem];
        }
    }
    self.btnClear.enabled = self.dataList.count == 0 ? NO:YES;
    [self.tableView reloadData];
    
    
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RRFMessageNoticeListModel *model = self.dataList[indexPath.row];
    RRFMessageNoticeListCell *cell =  [[RRFMessageNoticeListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RRFMessageNoticeListController"];
    cell.model = model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RRFMessageNoticeListModel *model = self.dataList[indexPath.row];
    if (model.type == 21 ||model.type==22) {
        [self goMyCircle];
        return ;
    }
    RRFReplyListController *desc = [[RRFReplyListController alloc]init];
    desc.commentId = model.entityId;
    desc.commentName = model.userName;
    desc.title = @"全部回复";
    if (self.fromCircle) {
        desc.viewType = RRFCommentDetailInfoTypeFriendCircle;
    }else{
        desc.viewType = RRFCommentDetailInfoTypeComment;
    }
    [self.navigationController pushViewController:desc animated:YES];
}

#pragma mark - 我的朋友圈
-(void)goMyCircle{
    MyFriendCircleController* friendCircle = [[MyFriendCircleController alloc]init];
    friendCircle.title = @"朋友通讯录" ;
    [self.navigationController pushViewController:friendCircle animated:YES];
}

@end
