//
//  RRFFriendCircleController.m
//  Puzzle
//
//  Created by huipay on 2016/11/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFFriendCircleController.h"
#import "JNQFriendRankViewController.h"
#import "RRFMeTool.h"
#import "JNQFailFooterView.h"
#import "RRFQuestionBarMsgModel.h"
#import "RRFFriendCircleView.h"
#import "CirclePopMenuController.h"
#import "MyFriendCircleController.h"
#import "ContactListController.h"
#import "FPPopoverController.h"
#import "InviteFriendController.h"
#import "RRFCommentsCell.h"
#import "MJRefresh.h"
#import "HBLoadingView.h"
#import "RRFPuzzleBarTool.h"
#import "RRFCommentsCellModel.h"
#import "JNQFriendsCircleCell.h"
#import "RRFFriendCircleModel.h"
#import "RRFReplyListController.h"
#import "RRFRewardController.h"
#import "PZParamTool.h"
#import "RRFDynamicController.h"
#import "RRFCommentInputView.h"
#import "FriendCircleSendController.h"
#import "RRFFriendCircleMeInfoModel.h"
#import "RRFDetailInfoController.h"
#import "RRFCommentNoticeView.h"
#import "RRFMessageNoticeListController.h"
#import "NotificateMsgUtil.h"
#import "RRFMessageNoticeListModel.h"
#import "JNQVIPUpdateViewController.h"
#import "JNQFriendRankPageViewController.h"
#import "RRFDetailInfoController.h"
#import "RRFCommentsCellModel.h"
#import "RRFFriendCircleReplyController.h"
#import "RedPaperSeleController.h"
#import "PZNavController.h"

#import "JNQRedPaperViewController.h"
#import "BonusPaperModel.h"
#import "JNQRedPaperClickedView.h"
#import "JNQHttpTool.h"
#import "BonusPaperTool.h"

@interface RRFFriendCircleController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)JNQFailFooterView *failFootView;
@property(strong,nonatomic)FPPopoverController* popover ;
@property(nonatomic,strong)NSMutableArray *allData;
@property(nonatomic,assign)int pageNo;
@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)RRFCommentInputView *botView;
@property(nonatomic,assign)CGPoint currentOffset;
@property(nonatomic,weak)RRFFriendCircleView *headView;
@property(nonatomic,assign)BOOL isRefreNotifyView;
@property(nonatomic,strong)RRFMessageNoticeListModel *messageModel;
@property(nonatomic,strong)NSString *isPraise;
@property(nonatomic,strong)RRFFriendCircleMeInfoModel *myInfoModel;

@property (nonatomic, strong) JNQRedPaperClickedView *clickedV;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, assign) NSInteger bonusPackageId;
@property (nonatomic, assign) BOOL isSend;
@end

@implementation RRFFriendCircleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 0;
    self.isRefreNotifyView = NO;
    WEAKSELF
    if (self.failFootView == nil) {
        self.failFootView = [[JNQFailFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64-270)];
        self.failFootView.reloadBlock = ^(){
            [weakSelf requestInfo];
        };
    }
    if (self.allData == nil) {
        self.allData = [[NSMutableArray alloc]init];
    }
    
    UITableView *tableView = [[UITableView alloc]init];
    [tableView registerClass:[RRFCommentsCell class] forCellReuseIdentifier:@"RRFFriendCircleController"];
    tableView.tableFooterView = [[UIView alloc]init];
    tableView.estimatedRowHeight = 120.0f;
    tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-50);
    }];
    
    MJRefreshNormalHeader *tabheader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestDateList:)];
    tabheader.lastUpdatedTimeLabel.hidden = YES;
    tabheader.stateLabel.textColor = HBColor(135, 135, 135);
    tabheader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.tableView.mj_header = tabheader;
    
    MJRefreshAutoNormalFooter *tabfooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestDateList:)];
    tabfooter.triggerAutomaticallyRefreshPercent = 1;
    tabfooter.automaticallyRefresh = YES;
    tabfooter.stateLabel.textColor = HBColor(135, 135, 135);
    self.tableView.mj_footer = tabfooter;
    
    RRFCommentInputView *botView = [[RRFCommentInputView alloc]initWithTitle:@"分享智慧，共享财富" redPaper:YES];
    botView.redPaperBlock = ^(){
        RedPaperSeleController* redPaper = [[RedPaperSeleController alloc]init];
        redPaper.title = @"发红包" ;
        redPaper.friendCircle = YES ;
        redPaper.sendRedPaperBlock = ^(id json,BonusPackage* model){
            NSLog(@"xx");
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        
        PZNavController* nav = [[PZNavController alloc]initWithRootViewController:redPaper];
        [nav redTheme];
        [weakSelf presentViewController:nav animated:YES completion:nil];
    };
    [botView addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
    self.botView = botView;
    [self.view addSubview:botView];
    [botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
   

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self requestInfo];
    [self setNavItem];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestDateList:) name:RRFFriendCircleRefre object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerClickNotificate:) name:HeaderClickNotificate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replyNotificate:) name:FriendCircleReplyNotificate object:nil];

}
-(void)replyNotificate:(NSNotification*)notificate
{
    RespModel *model = notificate.object;
    if ([model.isSelf isEqualToString:@"self"]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cencel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *delete = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self deletedCommentWithModel:model];
        }];
        [alertController addAction:cencel];
        [alertController addAction:delete];
        [self presentViewController:alertController animated:YES completion:^{}];
    }else{
        // 评论
        RRFFriendCircleReplyController *desc = [[RRFFriendCircleReplyController alloc]init];
        desc.title = [NSString stringWithFormat:@"回复%@",model.fromUserName];
        desc.responseId = model.responseId;
        desc.replyType = ReplyTypeReplyToReply;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:desc];
        [self presentViewController:nav animated:YES completion:nil];
    }
}
#pragma mark - headerClickNotificate
-(void)headerClickNotificate:(NSNotification*)notificate{
    PraiseUsersModel *model = notificate.object;
    RRFDetailInfoController *desc = [[RRFDetailInfoController alloc]init];
    desc.title = @"详细资料";
    desc.userId = model.userId;
    desc.verityInfo = NO;
    desc.detailInfoComeInType =  RRFDetailInfoComeInTypeOther;
    [self.navigationController pushViewController:desc animated:YES];
    
}

-(void)editClick
{
    WEAKSELF
    FriendCircleSendController* composeCircle = [[FriendCircleSendController alloc]init];
    composeCircle.title = @"发表动态" ;
    composeCircle.isRefre = ^(BOOL isRefre){
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:composeCircle animated:YES];
}

-(BOOL)checkNotifyStatus{
    NSArray* messages = [NotificateMsgUtil loadCircleAll:YES];
    return messages.count > 0 ? YES : NO;
}

-(void)setNavItem
{
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"circle-of-friends_icon_mail-list"] style:UIBarButtonItemStylePlain target:self action:@selector(goMyCircle)];
    self.navigationItem.rightBarButtonItem = rightItem;//为导航栏添加右侧按钮
}

-(void)inviteFriend:(UIButton*)sender{
    WEAKSELF
    CirclePopMenuController *menuVc=[[CirclePopMenuController alloc]init];
    menuVc.menuTitles = @[@"发起群聊" ,@"通讯录", @"添加朋友"];
    menuVc.menusImages = @[@"circle-of-friends_icon_weixin" ,@"circle-of-friends_icon_mail-list", @"circle-of-friends_icon_my-friends"];
    menuVc.view.backgroundColor = [UIColor clearColor];
    menuVc.itemBlock = ^(NSNumber* index){
        NSInteger row = [index integerValue];
        if (row == 0) {
            [weakSelf shareFriend];
        }
        else if (row == 1){
            ContactListController* contact = [[ContactListController alloc]init];
            contact.title = @"通讯录邀请" ;
            [self.navigationController pushViewController:contact animated:YES];
        }
        else if(row ==2){
            [weakSelf goMyCircle];
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

-(void)shareFriend{
    InviteFriendController* invite = [[InviteFriendController alloc]init];
    invite.title = @"邀请朋友" ;
    [self.navigationController pushViewController:invite animated:YES];
}
-(void)requestInfo
{
    [HBLoadingView showCircleView:self.view];
    [RRFMeTool requestFriendSelfProfitWithType:@"bonusXtbAmount" Success:^(id json) {
        [HBLoadingView hide];
        RRFFriendCircleMeInfoModel *model = [RRFFriendCircleMeInfoModel yy_modelWithJSON:json];
        self.myInfoModel = model;
        [self settingHeadViewWithModel:model];
        [self.tableView.mj_footer beginRefreshing];
    } failBlock:^(id json) {
        [self.tableView setTableFooterView:self.failFootView];
    }];
}
-(void)settingHeadViewWithModel:(RRFFriendCircleMeInfoModel *)model
{
    WEAKSELF
    RRFFriendCircleView *headView = [[RRFFriendCircleView alloc]init];
    BOOL showNotify = [self checkNotifyStatus];
    CGFloat headHeight = 419 - 62 ;
    if (showNotify) {
        headHeight  = 419 ;
    }
    NSArray* messagesArray = [NotificateMsgUtil loadCircleAll:YES];
    RRFMessageNoticeListModel *messageModel = messagesArray.firstObject;
    self.messageModel = messageModel;
    NSString *url = messageModel.iconUrl ;
    NSString *messageStr ;
    if (messageModel.type == 21||messageModel.type == 22) {
        messageStr  = @"1个朋友验证";
    }else{
        messageStr = [NSString stringWithFormat:@"%ld条新消息",messagesArray.count];
    }
    [headView.noticeView settingHeadView:url countStr:messageStr];
    [headView setShowNoticeView:showNotify];
    headView.model = model;
    headView.frame = CGRectMake(0, 0, SCREENWidth, headHeight);
    self.headView = headView;
    self.tableView.tableHeaderView = headView;
    [[headView.rankView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        JNQFriendRankPageViewController *rankVC = [[JNQFriendRankPageViewController alloc] init];
        rankVC.navigationItem.title = @"竞猜排行";
//        rankVC.rankType = FriendRankTypeIncome;
        [weakSelf.navigationController pushViewController:rankVC animated:YES];
    }];
    [[headView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        RRFDynamicController* person = [[RRFDynamicController alloc]init];
        RRFFriendCircleModel *meInfoM = [[RRFFriendCircleModel alloc]init];
        meInfoM.isSelfComment = @"self";
        meInfoM.userId = model.userId;
        meInfoM.iconUrl = model.iconUrl;
        meInfoM.userName = model.userName;
        meInfoM.selfSign = model.selfSign;
        meInfoM.userStatue = model.userStatue;
        meInfoM.sex = model.sex;
        meInfoM.isSelfComment = @"self";
        person.isMyFriend = YES;
        person.model = meInfoM;
        person.title = @"动态";
        [weakSelf.navigationController pushViewController:person animated:YES];
    }];
    [headView.noticeView addTarget:self action:@selector(goPush) forControlEvents:UIControlEventTouchUpInside];
}
-(void)goPush
{
    self.isRefreNotifyView = YES;
    if (self.messageModel.type == 21 ||self.messageModel.type==22) {
        [self goMyCircle];
        return ;
    }
    RRFMessageNoticeListController *messageVc = [[RRFMessageNoticeListController alloc]init];
    messageVc.title = @"消息列表";
    messageVc.comeInType = 0;
    messageVc.fromCircle = YES;
    [self.navigationController pushViewController:messageVc animated:YES];
}
-(void)requestDateList:(UIView *)sender
{
    WEAKSELF
    BOOL refreAll = NO;
    NSMutableArray *temp;
    if ([sender isKindOfClass:[MJRefreshHeader class]]) {
        refreAll = YES;
        self.currentOffset = CGPointZero;
    }
    if ([sender isKindOfClass:[NSNotification class]]) {
        refreAll = YES;
    }
    if (refreAll == YES) {
        self.pageNo = 0;
        temp = [[NSMutableArray alloc]init];
    }else{
        temp = [NSMutableArray arrayWithArray:self.allData];
    }
    [RRFPuzzleBarTool requestFriendCommentListWithCommentTypeId:0 commentType:@"userSelf" PageNo:self.pageNo Size:20 Success:^(id json) {
        BOOL last = [json[@"last"] boolValue];
        NSArray *dateArray = json[@"content"];
        for (NSDictionary *dic in dateArray) {
            RRFFriendCircleModel *model = [RRFFriendCircleModel yy_modelWithJSON:dic];
            [temp addObject:model];
        }
        weakSelf.allData = temp;
        if (temp.count == 0) {
            [weakSelf settingNoDataView];
        }else{
            weakSelf.tableView.tableFooterView = [UIView new];
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.pageNo ++;
        if (last) {
            [weakSelf.tableView.mj_footer setHidden:YES];
        }else{
            [weakSelf.tableView.mj_footer setHidden:NO];
        }
    } failBlock:^(id json) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.tableView.mj_footer.hidden = YES;
        [weakSelf.tableView setTableFooterView:weakSelf.failFootView];
    }];
}
#pragma mark - 我的朋友圈
-(void)goMyCircle{
    MyFriendCircleController* friendCircle = [[MyFriendCircleController alloc]init];
    friendCircle.title = @"我的朋友圈" ;
    [self.navigationController pushViewController:friendCircle animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RRFFriendCircleModel *model = self.allData[indexPath.row];
    model.indexPath = indexPath;
    RRFCommentsCell *cell = [[RRFCommentsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RRFFriendCircleController"];
    cell.friendModel = model;
    [self tableViewCellClick:cell IndexPath:indexPath];
    return cell;
}
-(void)tableViewCellClick:(id)sender IndexPath:(NSIndexPath*)indexPath
{
    WEAKSELF
    if ([sender isKindOfClass:[RRFCommentsCell class]]) {
        __block RRFCommentsCell *cell = (RRFCommentsCell*)sender;
        RRFFriendCircleModel *friendModel = _allData[indexPath.row];
        
        cell.menuClickedOperation = ^(NSNumber* typeNum){
            NSInteger type = [typeNum integerValue];
            // 评论
            if (![PZParamTool hasLogin]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"goLogin" object:nil];
                return;
            }
            if (type == 1) {
                // 评论
                RRFFriendCircleReplyController *desc = [[RRFFriendCircleReplyController alloc]init];
                desc.title = [NSString stringWithFormat:@"回复%@",friendModel.userName];
                desc.responseId = friendModel.ID;
                desc.replyType = ReplyTypeReply;
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:desc];
                [self presentViewController:nav animated:YES completion:nil];
            }else if(type == 2){
                // 打赏
                [weakSelf pushRewardControllerWithUserId:friendModel.userId entityId:friendModel.ID  entityType:@"dynamicAction" IndexPath:indexPath];
            }else{
                // 点赞
                __block NSString *beforeisPraise = friendModel.isPraise;
                NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
                [param setObject:@(friendModel.ID) forKey:@"commentId"];
                [PZParamTool agreedToWithUrl:@"client/friendCircle/addDynamicActionPraise" param:param Success:^(id json) {
                    // 更新点赞View
                    [weakSelf updateAgreeCellWithIndexPath:indexPath BeforeStatus:beforeisPraise];
                } failBlock:^(id json) {
                }];
            }
        };
        cell.deleteBlock = ^(){
            // 删除
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction *yseAction = [UIAlertAction actionWithTitle:@"删除评论" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf deletedCommentWithId:friendModel.ID indexPath:indexPath];
            }];
            [alertView addAction:yseAction];
            [alertView addAction:cancelAction];
            [weakSelf presentViewController:alertView animated:YES completion:^{}];
        };
        cell.goUserProfile = ^(){
            RRFDetailInfoController *desc = [[RRFDetailInfoController alloc]init];
            desc.title = @"详细资料";
            desc.userId = friendModel.userId;
            desc.verityInfo = NO;
            desc.detailInfoComeInType =  RRFDetailInfoComeInTypeOther;
            [weakSelf.navigationController pushViewController:desc animated:YES];
        };
        cell.checkBlock = ^(){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您现在还不是会员，升级会员立即查看！" message:@"" preferredStyle: UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            }];
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"立即升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                JNQVIPUpdateViewController *vipUpdateVC = [[JNQVIPUpdateViewController alloc] init];
                vipUpdateVC.navigationItem.title = @"升级会员";
                [weakSelf.navigationController pushViewController:vipUpdateVC animated:YES];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:deleteAction];
            [weakSelf presentViewController:alertController animated:YES completion:^{
            }];
        };
        cell.redPaperBlock = ^(NSNumber *bonusPackageId){
            _bonusPackageId = [bonusPackageId integerValue];
            _isSend = [cell.friendModel.isSelfComment isEqualToString:@"self"];
            [BonusPaperTool groupDraw:_bonusPackageId Success:^(id json) {
                BonusPaperModel* pModel = (BonusPaperModel *)json;
                [MBProgressHUD dismiss];
                if ([pModel.isReceive isEqualToString:@"alreadyReceive"] ||
                    (_isSend&&[pModel.bonusType isEqualToString:@"average"])) {
                    //跳转
                    //发方-群普通-过期(跳转)/结束(跳转)/进行(跳转)
                    //发方-群手气-已拆-过期(跳转)/结束(跳转)/进行(跳转)
                    //收方-群普通-已拆-X/结束(跳转)/X
                    //收方-群手气-已拆-过期(跳转)/结束(跳转)/进行(跳转)
                    JNQRedPaperViewController *vc = [[JNQRedPaperViewController alloc] init];
                    PZNavController *nav = [[PZNavController alloc]initWithRootViewController:vc];
                    vc.isSend = _isSend;
                    vc.pModel = pModel;
                    [self presentViewController:nav animated:YES completion:nil];
                } else if ([pModel.isReceive isEqualToString:@"noReceive"] && !(_isSend&&[pModel.bonusType isEqualToString:@"average"])
                           ) {
                    //弹出
                    //收方-群普通/手气-未拆-过期(弹出)/结束(弹出)/进行(弹出)
                    //发方-群手气-未拆-过期(弹出)/结束(弹出)/进行(弹出)
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    [window addSubview:self.backBtn];
                    [window addSubview:self.clickedV];
                    self.clickedV.isSend = _isSend;
                    self.clickedV.pModel = pModel;
                    [weakSelf showAnimateForView:weakSelf.clickedV];
                }
            } failBlock:^(id json) {
                [MBProgressHUD dismiss];
                NSError *error = (NSError *)json;
                NSString *errorStr = [JNQHttpTool errorDataString:error];
                if ([errorStr isEqualToString:@"红包已过期"]) {
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    [window addSubview:self.backBtn];
                    [window addSubview:self.clickedV];
                    [weakSelf showAnimateForView:weakSelf.clickedV];
                    self.clickedV.isOver = YES;
                    self.clickedV.isTimeOut = YES;
                }
            }];
        };
    }
    
}


-(void)updateAgreeCellWithIndexPath:(NSIndexPath *)indexPath BeforeStatus:(NSString *)beforeStatus
{
    NSString *afterStatus ;
    if ([beforeStatus isEqualToString:@"alreadyPraise"]) {
        afterStatus = @"noPraise";
    }else{
        afterStatus = @"alreadyPraise";
    }
    NSInteger currentId = self.myInfoModel.userId;
    RRFFriendCircleModel *friendCircleModel = self.allData[indexPath.row];
    friendCircleModel.isPraise = afterStatus;
    NSMutableArray *temp = [NSMutableArray arrayWithArray:friendCircleModel.praiseUsers];
    PraiseUsersModel *tempModel = [[PraiseUsersModel alloc]init];
    if ([beforeStatus isEqualToString:@"noPraise"]) {
        // 添加操作用户
        tempModel.userIconUrl = self.myInfoModel.iconUrl;
        tempModel.userId = currentId ;
        [temp addObject:tempModel];
    }else{
        // 删除操作用户
        for (PraiseUsersModel *model in friendCircleModel.praiseUsers) {
            if (model.userId == currentId) {
                tempModel = model;
                break;
            }
        }
        [temp removeObject:tempModel];
    }
    friendCircleModel.praiseUsers = [temp copy];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    });
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[NSNotificationCenter defaultCenter]postNotificationName:kTimeLineCellOperationButtonClickedNotification object:nil];
}

-(void)deletedCommentWithModel:(RespModel *)model
{
    
    NSString *url = @"client/friendCircle/deleteDynamicAction";
    NSString *type = @"dynamicActionResponse";
    __block NSInteger deletedId = model.responseId;
    [RRFPuzzleBarTool deleteCommentWithEntityWithUrl:url Type:type entityId:deletedId Success:^(id json) {
        [MBProgressHUD showInfoWithStatus:@"删除成功!"];
        NSIndexPath *indexPath = model.indexPath;
        RRFFriendCircleModel *friendCirclemodel = self.allData[indexPath.row];
        NSMutableArray *temp = [NSMutableArray arrayWithArray:friendCirclemodel.respModels];
        RespModel *tempReplyM = [[RespModel alloc]init];
        for (RespModel *replyM in friendCirclemodel.respModels) {
            NSInteger responseId = replyM.responseId;
            if (responseId == deletedId) {
                tempReplyM = replyM;
                break;
            }
        }
        [temp removeObject:tempReplyM];
        friendCirclemodel.respModels = [temp copy];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadRowsAtIndexPaths:@[model.indexPath] withRowAnimation:UITableViewRowAnimationNone];
        });
    } failBlock:^(id json) {
        
    }];

}

-(void)deletedCommentWithId:(NSInteger)ID indexPath:(NSIndexPath*)indexPath
{
    WEAKSELF
    [RRFPuzzleBarTool deleteCommentWithEntityWithUrl:@"client/friendCircle/deleteDynamicAction" Type:@"dynamicAction" entityId:ID Success:^(id json) {
        [weakSelf.allData removeObjectAtIndex:indexPath.row];
        [weakSelf.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [weakSelf.tableView reloadData];
    } failBlock:^(id json) {
        
    }];
}
#pragma mark - 进入打赏页
-(void)pushRewardControllerWithUserId:(NSInteger)userId entityId:(NSInteger)entityId entityType:(NSString *)entityType IndexPath:(NSIndexPath*)indexPath
{
    if (![PZParamTool hasLogin]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goLogin" object:nil];
        return;
    }
    RRFRewardController *desc = [[RRFRewardController alloc]init];
    desc.title = @"赞赏";
    desc.userId = userId;
    desc.entityId = entityId;
    desc.entityType = entityType;
    [self.navigationController pushViewController:desc animated:YES];
}
-(void)settingNoDataView
{
    NSString *titleStr = @"暂时没有评论!";
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-50-64-270)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 50, SCREENWidth-30, 50)];
    titleLabel.text = titleStr;
    titleLabel.numberOfLines=2;
    titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:titleLabel];
    self.tableView.tableFooterView = footerView;
}
-(void)setHeadNotifyView
{
    BOOL showNotify = [self checkNotifyStatus];
    CGFloat headHeight = 419 - 62 ;
    if (showNotify) {
        headHeight  = 419 ;
    }
    NSArray* messagesArray = [NotificateMsgUtil loadCircleAll:YES];
    RRFMessageNoticeListModel *messageModel = messagesArray.firstObject;
    self.messageModel = messageModel;
    NSString *url = messageModel.iconUrl ;
    NSString *messageStr ;
    if (messageModel.type == 21||messageModel.type == 22) {
        messageStr  = @"1个朋友验证";
    }else{
        messageStr = [NSString stringWithFormat:@"%ld条新消息",messagesArray.count];
    }
    [self.headView.noticeView settingHeadView:url countStr:messageStr];
    [self.headView setShowNoticeView:showNotify];
    self.headView.frame = CGRectMake(0, 0, SCREENWidth, headHeight);
    [self.tableView reloadData];
}

#pragma mark - 红包动画
-(void)showAnimateForView:(UIView*)myView{
    /* 放大缩小 */
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.7;
    group.repeatCount = 1;
    // 设定为放大
    CABasicAnimation *aniBig = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    // 动画选项设定
    aniBig.duration = 0.3; // 动画持续时间
    aniBig.repeatCount = 1; // 重复次数
    aniBig.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    // 缩放倍数
    aniBig.fromValue = [NSNumber numberWithFloat:0.6]; // 开始时的倍率
    aniBig.toValue = [NSNumber numberWithFloat:1.0]; // 结束时的倍率
    
    //缩小
    CABasicAnimation *aniSmall = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    // 动画选项设定
    aniSmall.duration = 0.4; // 动画持续时间
    aniSmall.repeatCount = 1; // 重复次数
    aniSmall.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    // 缩放倍数
    aniSmall.fromValue = [NSNumber numberWithFloat:0.6]; // 开始时的倍率
    aniSmall.toValue = [NSNumber numberWithFloat:1.0]; // 结束时的倍率
    
    //    合并动画组
    group.animations = @[aniBig];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    
    // 添加动画
    [myView.layer addAnimation:group forKey:@"scale-layer"];
}

- (JNQRedPaperClickedView *)clickedV {
    WEAKSELF
    if (!_clickedV) {
        _clickedV = [[JNQRedPaperClickedView alloc] initWithFrame:CGRectMake(25, (SCREENHeight-(SCREENWidth-50)*866/650)/2, SCREENWidth-50, (SCREENWidth-50)*866/650)];
        _clickedV.btnBlock = ^(UIButton *button) {
            [MBProgressHUD show];
            if (button.tag == 888) {
                [BonusPaperTool groupOpenBonus:weakSelf.bonusPackageId Success:^(id json) {
                    [MBProgressHUD dismiss];
                    [weakSelf backBtnDidClicked:weakSelf.backBtn];
                    BonusPaperModel* pModel = (BonusPaperModel *)json;
                    JNQRedPaperViewController *vc = [[JNQRedPaperViewController alloc] init];
                    PZNavController *nav = [[PZNavController alloc]initWithRootViewController:vc];
                    vc.pModel = pModel;
                    vc.isSend = weakSelf.isSend;
                    [weakSelf presentViewController:nav animated:YES completion:nil];
                } failBlock:^(id json) {
                    [MBProgressHUD dismiss];
                    NSError *error = (NSError *)json;
                    NSString *errorStr = [JNQHttpTool errorDataString:error];
                    if ([errorStr isEqualToString:@"红包已被抢完"]) {
                        weakSelf.clickedV.isOver = YES;
                    }
                }];
            } else if (button.tag == 666) {
                [BonusPaperTool groupDraw:weakSelf.bonusPackageId Success:^(id json) {
                    BonusPaperModel* pModel = (BonusPaperModel *)json;
                    [MBProgressHUD dismiss];
                    [weakSelf backBtnDidClicked:weakSelf.backBtn];
                    JNQRedPaperViewController *vc = [[JNQRedPaperViewController alloc] init];
                    PZNavController *nav = [[PZNavController alloc]initWithRootViewController:vc];
                    vc.isSend = weakSelf.isSend;
                    vc.pModel = pModel;
                    [weakSelf presentViewController:nav animated:YES completion:nil];
                } failBlock:^(id json) {
                    [MBProgressHUD dismiss];
                }];
                
            } else if (button.tag == 100) {
                [MBProgressHUD dismiss];
                [weakSelf backBtnDidClicked:weakSelf.backBtn];
            }
        };

    }
    return _clickedV;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
        _backBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [_backBtn addTarget:self action:@selector(backBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (void)backBtnDidClicked:(UIButton *)button {
    [UIView animateWithDuration:0.3 animations:^{
        //_clickedV.frame = CGRectMake(SCREENWidth/2-10, SCREENHeight/2-10, 20, 20);
    } completion:^(BOOL finished) {
        [_clickedV removeFromSuperview];
        [_backBtn removeFromSuperview];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableView.contentOffset = self.currentOffset;
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (self.isRefreNotifyView) {
        [self setHeadNotifyView];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.currentOffset = self.tableView.contentOffset;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HeaderClickNotificate object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RRFFriendCircleRefre object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FriendCircleReplyNotificate object:nil];

}


@end
