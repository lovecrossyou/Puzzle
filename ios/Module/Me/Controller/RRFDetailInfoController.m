//
//  RRFDetailInfoController.m
//  Puzzle
//
//  Created by huibei on 16/11/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFDetailInfoController.h"
#import "PZCommonCellModel.h"
#import "CommonTableViewCell.h"
#import "RRFDetailInfoHeadView.h"
#import "RRFMeTool.h"
#import "RRFDetailInfoModel.h"
#import "RRFPersonalAskBarController.h"
#import "HomeTool.h"
#import "RRFDynamicController.h"
#import "HBLoadingView.h"
#import "RRFFriendCircleModel.h"
#import "JNQPersonalHomepageViewController.h"
#import <STPopup/STPopup.h>
#import "CommonPopOutController.h"
#import "RRFFriendCircleController.h"
#import "JCHATConversationViewController.h"
#import "RRFModifyNameController.h"
@interface RRFDetailInfoController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSArray *allData;
@end

@implementation RRFDetailInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (self.verityInfo) {
        [self requestVerityInfo];
    }
    else{
        [self requestInfo];
    }
//    [self rightNavItem];
}
-(void)rightNavItem
{
    UIButton *rightItem = [[UIButton alloc]init];
    rightItem.frame = CGRectMake(0, 0, 44, 44);
    rightItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightItem setTitle:@"备注" forState:UIControlStateNormal];
    [rightItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightItem.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightItem addTarget:self action:@selector(reviseName) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:rightItem
                             ];
    self.navigationItem.rightBarButtonItem = item;
}
-(void)reviseName
{
    RRFModifyNameController *desc = [[RRFModifyNameController alloc]init];
    desc.title = @"修改备注";
    desc.placeholder = @"添加备注名";
//    desc.name = name;
    [self.navigationController pushViewController:desc animated:YES];
}
#pragma mark - 朋友验证
-(void)requestVerityInfo{
    WEAKSELF
    [HBLoadingView showCircleView:self.view];
    [RRFMeTool requestFriendVerifyInfoWithInviteId:self.userId Success:^(id json) {
        NSDictionary *infoDic = json[@"clientFriendInfoMsg"];
        RRFDetailInfoModel *model = [RRFDetailInfoModel yy_modelWithDictionary:infoDic];
        [weakSelf settingTableViewWithModel:model];
        [weakSelf.tableView reloadData];
        [HBLoadingView hide];
    } failBlock:^(id json) {
        [HBLoadingView hide];
    }];
}

-(void)requestInfo
{
    WEAKSELF
    [HBLoadingView showCircleView:self.view];
    [RRFMeTool requestFriendTnfoWithUserId:self.userId Success:^(id json) {
        NSDictionary *infoDic = json[@"clientFriendInfoMsg"];
        RRFDetailInfoModel *model = [RRFDetailInfoModel yy_modelWithDictionary:infoDic];
        [weakSelf settingTableViewWithModel:model];
        [weakSelf.tableView reloadData];
        [HBLoadingView hide];
    } failBlock:^(id json) {
        [HBLoadingView hide];
    }];
}
-(void)settingTableViewWithModel:(RRFDetailInfoModel *)model
{
    WEAKSELF
    RRFDetailInfoHeadView *headView = [[RRFDetailInfoHeadView alloc]initWithModel:model];
    headView.frame = CGRectMake(0, 0, SCREENWidth, 180);
    self.tableView.tableHeaderView = headView;
    
    RRFDetailInfoFootView *footView = [[RRFDetailInfoFootView alloc]init];
    [footView.titleBtn setTitle:model.authorityTypeContent forState:UIControlStateNormal];
    footView.frame = CGRectMake(0, 0, SCREENWidth, 84);
    self.tableView.tableFooterView = footView;
    [[footView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSInteger type = model.authorityTypeValue ;
//        1添加朋友圈  2通过验证 3朋友圈  4自己
        if (type == 1) {
            [MBProgressHUD show];
            [HomeTool addFriendWithUserId:model.userId successBlock:^(id json) {
                [MBProgressHUD dismiss];
                [weakSelf showNotice];
            } fail:^(id json) {
                [MBProgressHUD dismiss];
            }];
        }
        else if(type == 2){
//            2通过验证
            [MBProgressHUD show];
            [HomeTool verifyFriendWithUserId:self.userId successBlock:^(id json) {
                [footView.titleBtn setTitle:@"查看朋友圈" forState:UIControlStateNormal];
                model.authorityTypeValue = 3 ;
                [MBProgressHUD dismiss];
            } fail:^(id json) {
                [MBProgressHUD dismiss];
            }];
        }
        else if(type == 3){
            [weakSelf sendMsgToFriend:model.xtNumber];
//                RRFFriendCircleController* circleVc = [[RRFFriendCircleController alloc]init];
//                circleVc.title = @"朋友圈";
//                [self.navigationController pushViewController:circleVc animated:YES];
        }
        else if(type == 4){
//            4自己
            RRFFriendCircleController* circleVc = [[RRFFriendCircleController alloc]init];
            circleVc.title = @"朋友圈";
            [self.navigationController pushViewController:circleVc animated:YES];
        }
    }];
    
    PZCommonCellModel *mode1 = [PZCommonCellModel cellModelWithIcon:@"detaileds-information_personal-dynamics" title:@"个人动态" subTitle:[NSString stringWithFormat:@"%ld",model.dynamicNum] accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:nil];
    mode1.itemClick = ^(){
        
        if(self.detailInfoComeInType == RRFDetailInfoComeInTypeDynamic){
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            RRFDynamicController *desc = [[RRFDynamicController alloc]init];
            desc.title = @"动态";
            RRFFriendCircleModel* friendModel = [[RRFFriendCircleModel alloc]init];
            friendModel.userId = self.userId ;
            friendModel.iconUrl = model.icon;
            friendModel.userName = model.cnName;
            friendModel.sex = model.sex == 1?@"男":@"女";
            friendModel.selfSign = model.selfSign;
            friendModel.isSelfComment = model.authorityTypeValue == 4 ? @"self" : @"other" ;
            desc.model = friendModel ;
            BOOL isMyFriend = NO;
            if (model.authorityTypeValue != 1 && model.authorityTypeValue != 2) {
                isMyFriend = YES;
            }else{
                isMyFriend = NO;
            }
            desc.isMyFriend = isMyFriend;
            [self.navigationController pushViewController:desc animated:YES];
        }
    };
    PZCommonCellModel *mode2 = [PZCommonCellModel cellModelWithIcon:@"jnq_detaileds-information" title:@"投注记录" subTitle:[NSString stringWithFormat:@"%ld",model.guessGameNum] accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:nil];
    mode2.itemClick = ^(){
        if(self.detailInfoComeInType == RRFDetailInfoComeInTypeBet){
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            JNQPersonalHomepageViewController *desc = [[JNQPersonalHomepageViewController alloc]init];
            desc.otherUserId = self.userId;
            desc.title = @"个人投注";
            desc.rankingType = @"currentWeek";
            [weakSelf.navigationController pushViewController:desc animated:YES];
        }
    };
    
    PZCommonCellModel *mode3 = [PZCommonCellModel cellModelWithIcon:@"detaileds-information_icon_comment" title:@"沙龙评论" subTitle:[NSString stringWithFormat:@"%ld",model.commentNum] accessoryType:UITableViewCellAccessoryDisclosureIndicator descVc:nil];
    mode3.itemClick = ^(){
        if(self.detailInfoComeInType == RRFDetailInfoComeInTypeTypeHomePage){
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            RRFPersonalAskBarController *desc = [[RRFPersonalAskBarController alloc]init];
            desc.userId = model.userId;
            desc.title = @"沙龙评论";
            [self.navigationController pushViewController:desc animated:YES];
        };
    };
    PZCommonCellModel *mode4 = [PZCommonCellModel cellModelWithIcon:@"detaileds_ attribute" title:@"属性" subTitle:model.relationTypeContent accessoryType:UITableViewCellAccessoryNone descVc:nil];
    if (model.authorityTypeValue==4) {
        self.allData = @[@[mode1,mode2,mode3]];
    }else{
        self.allData = @[@[mode1,mode2,mode3],@[mode4]];
    }
}

#pragma mark - 注册
-(void)showNotice{
    WEAKSELF
    NSString* descString = @"你已成功发送验证申请等待\n对方验证通过" ;
    [MBProgressHUD showInfoWithStatus:descString];
    [weakSelf.navigationController popViewControllerAnimated:YES];
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

-(void)sendMsgToFriend:(NSString*)userName{
    __block JCHATConversationViewController *sendMessageCtl = [[JCHATConversationViewController alloc] init];
    WEAKSELF
    [MBProgressHUD show];
    [JMSGConversation createSingleConversationWithUsername:userName appKey:JMESSAGE_APPKEY completionHandler:^(id resultObject, NSError *error) {
        [MBProgressHUD dismiss];
        if (error == nil) {
            sendMessageCtl.conversation = resultObject;
            [weakSelf.navigationController pushViewController:sendMessageCtl animated:YES];
        } else {
            [MBProgressHUD showInfoWithStatus:@"用户不存在"];
        }
    }];
}

@end
