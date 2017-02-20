//
//  RRFNoticeListController.m
//  Puzzle
//
//  Created by huibei on 16/9/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFNoticeListController.h"
#import "RRFNoticeCell.h"
#import "RRFMeTool.h"
#import "RRFNoticeModel.h"
#import "RRFPrizeController.h"
#import "JNQFailFooterView.h"
#import "HBLoadingView.h"
#import "RRFPrizeInfoModel.h"
#import "HomeTool.h"
#import <JMessage/JMessage.h>
#import "VerifyFriendController.h"
#import "RRFFreeBuyOrderViewController.h"
@interface RRFNoticeListController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,assign)int pageNo;
@property(nonatomic,strong)NSArray *allData;
@property(nonatomic,strong)JNQFailFooterView *failFootView;
@end

@implementation RRFNoticeListController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF
    self.pageNo = 0;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[RRFNoticeCell class] forCellReuseIdentifier:@"RRFNoticeListController"];
    [self requestData];
    if (self.showCancel) {
        UIBarButtonItem* cancelItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelController)];
        self.navigationItem.rightBarButtonItem = cancelItem ;
    }
    if (self.failFootView == nil) {
        self.failFootView = [[JNQFailFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64)];
        self.failFootView.reloadBlock = ^(){
            [weakSelf requestData];
        };
    }
    //重置消息数量
    [self resetPushMsg];
}

-(void)resetPushMsg{
    [HomeTool pushMsgUpdateSuccessBlock:^(id json) {
        [JPUSHService resetBadge];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    } fail:^(id json) {
        
    }];
}

-(void)cancelController{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)requestData
{
    [HBLoadingView showCircleView:self.view];
    [RRFMeTool requestNoticeListWithPageNo:self.pageNo Success:^(id json) {
        NSArray *dicArray = json[@"content"];
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in dicArray) {
            RRFNoticeModel *model = [RRFNoticeModel yy_modelWithJSON:dic];
            [temp addObject:model];
        }
        self.allData = temp;
        if (self.allData.count == 0) {
            [self settingNoDataView];
        }else{
            [self.tableView setTableFooterView:nil];
        }
        [self.tableView reloadData];
        [HBLoadingView hide];
    } failBlock:^(id json) {
        [HBLoadingView hide];
        [self.tableView setTableFooterView:self.failFootView];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RRFNoticeModel *model = self.allData[indexPath.row];
    RRFNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];
    if (cell == nil) {
        cell = [[RRFNoticeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RRFNoticeListController"];
    }
    if ([model.messageType isEqualToString:@"friendInvite"] ||[model.messageType isEqualToString:@"bidWin"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.model = model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    RRFNoticeModel *model = self.allData[indexPath.row];
    if (model.award.accept) {
        [MBProgressHUD showInfoWithStatus:@"已领取！"];
        return ;
    }
    if ([model.messageType isEqualToString:@"weekAward"] || [model.messageType isEqualToString:@"monthAward"] || [model.messageType isEqualToString:@"yearAward"]) {
        RRFPrizeController *desc = [[RRFPrizeController alloc]init];
        desc.title = @"领取";
        desc.model = model;
        desc.refreBlock = ^(BOOL refre){
            if (refre) {
                [weakSelf requestData];
            }
        };
        [self.navigationController pushViewController:desc animated:YES];
    }
    if ([@"bidWin" isEqualToString:model.messageType]) {
        RRFFreeBuyOrderViewController *desc = [[RRFFreeBuyOrderViewController alloc]init];
        desc.title = @"待领奖";
        desc.status = @"win";
        desc.comminType = RRFFreeBuyOrderTypeMe;
        [self.navigationController pushViewController:desc animated:YES];
    }
    if ([model.messageType isEqualToString:@"friendInvite"]) {
        VerifyFriendController* verifyController = [[VerifyFriendController alloc]init];
        verifyController.title = @"验证朋友" ;
        [self.navigationController pushViewController:verifyController animated:YES];
    }
}


-(void)settingNoDataView
{
    NSString *titleStr = @"暂时没有通知!";
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, (SCREENHeight-64)/2, SCREENWidth-30, 50)];
    titleLabel.text = titleStr;
    titleLabel.numberOfLines=2;
    titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:titleLabel];
    self.tableView.tableFooterView = footerView;
}
@end
