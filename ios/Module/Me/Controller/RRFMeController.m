//
//  RRFMeController.m
//  Puzzle
//
//  Created by huibei on 16/8/2.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFMeController.h"
#import "RRFMeView.h"
#import "RRFMeTool.h"
#import "PZCommonCellModel.h"
#import "RRFGeneralController.h"
#import "RRFMeInfoController.h"
#import "RRFAssetsController.h"
#import "RRFBettingRecordController.h"
#import "JNQShoppingCartViewController.h"
#import "LoginModel.h"
#import "RRFMeTool.h"
#import "PZParamTool.h"
#import "CommonTableViewCell.h"


#import "RRFApplyForController.h"
#import "RRFPersonalHomePageController.h"
#import "RRFNoticeListController.h"
#import "RRFNoLoginMyInfoView.h"
#import "HBLoadingView.h"
#import "RRFMyFriendController.h"
#import "PZCache.h"
#import "HomeTool.h"
#import "RRFMyOrderViewController.h"
#import "RRFXTPlanViewController.h"
#import "RRFApplyForController.h"

@interface RRFMeController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_allData;
    RRFMeView *_headView;
}
@property(weak,nonatomic)UIView* tipView ;

@end

@implementation RRFMeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self settingTableView];

}


#pragma mark - 更新updateBadge 数字
-(void)updateBadge{
    //    查询未读消息条数
    [HomeTool pushMsgUnReadCountWithSuccessBlock:^(id json) {
        int unread_count = [json[@"unread_count"] intValue];
        if (unread_count) {
            NSUInteger section = _allData.count -1 ;
            NSUInteger row = 0 ;
            NSIndexPath* indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            CommonTableViewCell* msgCell = [self.tableView cellForRowAtIndexPath:indexPath];
            [self notifyCircle:msgCell];
        }
        else{
            [self notifyClearCircle];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshMeBadgeValue object:nil];
    } fail:^(id json) {
        [self notifyClearCircle];
    }];
}


-(void)notifyCircle:(UIView*)cell{
    if (self.tipView != nil) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView* tipView = [[UIView alloc]init];
        tipView.backgroundColor = [UIColor redColor];
        tipView.layer.cornerRadius = 3 ;
        tipView.alpha = 0.8 ;
        [cell addSubview:tipView];
        [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(6, 6));
            make.left.mas_equalTo(90+15);
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



-(void)requestUserInfo
{
    if ([PZParamTool hasLogin]) {
        [RRFMeTool requestUserInfoWithSuccess:^(id json) {
            if(json != nil){
                RLMRealm *defaultRealm = [RLMRealm defaultRealm];
                [defaultRealm beginWriteTransaction];
                LoginModel* userM = [LoginModel yy_modelWithJSON:json[@"userInfo"]];
                LoginModel *userInfo = [PZParamTool currentUser];
                userInfo.cnName = userM.cnName;
                userInfo.identityType = userM.identityType;
                userInfo.icon = userM.icon;
                userInfo.phoneNumber =userM.phoneNumber;
                userInfo.xtNumber =userM.xtNumber;
                userInfo.userId =userM.userId;
                userInfo.sex = userM.sex;
                userInfo.selfSign = userM.selfSign;
                userInfo.address = userM.address;
                [defaultRealm commitWriteTransaction];
                [self settingHeadUIViewWithModel:userInfo];
            }
        } failBlock:^(id json) {
        }];
    }else{
        RRFNoLoginMyInfoView* noLoginView = [[RRFNoLoginMyInfoView alloc]init];
        noLoginView.frame = CGRectMake(0, 0, SCREENWidth, 109);
        self.tableView.tableHeaderView = noLoginView;
        [[noLoginView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"goLogin" object:nil];
        }];
    }
}
-(void)settingHeadUIViewWithModel:(LoginModel *)model{
    WEAKSELF
    _headView = [[RRFMeView alloc]initWithUserInfo:model];
    [[_headView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        RRFMeInfoController *headVc = [[RRFMeInfoController alloc]init];
        headVc.title = @"个人信息";
        [weakSelf.navigationController pushViewController:headVc animated:YES];
    }];
   
    _headView.frame = CGRectMake(0, 0, SCREENWidth, 105.0f);
    self.tableView.tableHeaderView = _headView;

}
-(void)settingTableView
{
    WEAKSELF
    PZCommonCellModel *mode1 = [PZCommonCellModel cellModelWithIcon:@"me_icon_assets" title:@"我的资产" subTitle:@"" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:[RRFAssetsController class]];
    PZCommonCellModel *mode2 = [PZCommonCellModel cellModelWithIcon:@"me_icon-_record" title:@"投注记录" subTitle:@"" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:[RRFBettingRecordController class]];
    PZCommonCellModel *mode9 = [PZCommonCellModel cellModelWithIcon:@"me_icon_invitation" title:@"邀请朋友" subTitle:@"" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:[RRFMyFriendController class]];
    PZCommonCellModel *mode7 = [PZCommonCellModel cellModelWithIcon:@"me_icon_plan" title:@"喜鹊计划" subTitle:@"" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:nil];
    mode7.itemClick = ^(){
        
        [weakSelf requestCheckIsDelegater];
    };

    PZCommonCellModel *mode3 = [PZCommonCellModel cellModelWithIcon:@"me_icon-_order" title:@"订单" subTitle:@"兑换礼品账单详情" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:[RRFMyOrderViewController class]];
    
    PZCommonCellModel *mode5 = [PZCommonCellModel cellModelWithIcon:@"me_icon_comment" title:@"我的沙龙" subTitle:@"发表的评论" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:[RRFPersonalHomePageController class]];
    PZCommonCellModel *mode6 = [PZCommonCellModel cellModelWithIcon:@"me_icon-_news" title:@"消息" subTitle:@"" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:[RRFNoticeListController class]];
  
    PZCommonCellModel *mode8 = [PZCommonCellModel cellModelWithIcon:@"me_icon_common" title:@"通用" subTitle:@"" accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:[RRFGeneralController class]];
    _allData = @[@[mode1,mode2],@[mode9,mode7],@[mode3,mode5],@[mode6,mode8]];
}
-(void)requestCheckIsDelegater
{
    WEAKSELF
    [MBProgressHUD show];
    [RRFMeTool checkIsDelegaterWithSuccess:^(id json) {
        NSString *str = json;
        NSString *title = @"喜鹊计划";
        if ([str isEqualToString:@"already_apply"]) {
            RRFXTPlanViewController *desc = [[RRFXTPlanViewController alloc]init];
            desc.title = title;
            [self.navigationController pushViewController:desc animated:YES];
        }else{
            RRFApplyForController *desc  = [[RRFApplyForController alloc]init];
            desc.title = title;
            [weakSelf.navigationController pushViewController:desc animated:YES];
        }
        [MBProgressHUD dismiss];
    } failBlock:^(id json) {
        [MBProgressHUD dismiss];
    }];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _allData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sec = _allData[section];
    return sec.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sec = _allData[indexPath.section];
    PZCommonCellModel *model = sec[indexPath.row];
    
    CommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRFMeController"];
    if (!cell) {
        cell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"RRFMeController"];
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![PZParamTool hasLogin]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goLogin" object:nil];
        return;
    }
    NSArray *sec = _allData[indexPath.section];
    PZCommonCellModel *model = sec[indexPath.row];
    if (model.itemClick) {
        model.itemClick();
        return;
    }
    UIViewController *desc = [[model.descVc alloc]init];
    desc.title = model.title;
    [self.navigationController pushViewController:desc animated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self updateBadge];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestUserInfo];

}
@end
