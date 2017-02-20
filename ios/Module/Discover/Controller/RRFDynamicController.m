//
//  RRFDynamicController.m
//  Puzzle
//
//  Created by huipay on 2016/11/9.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFDynamicController.h"
#import "HBLoadingView.h"
#import "RRFMeTool.h"
#import "MJRefresh.h"
#import "JNQFailFooterView.h"
#import "RRFQuestionBarMsgModel.h"
#import "RRFFriendCircleView.h"
#import "RRFPersonalHomePageCell.h"
#import "RRFPuzzleBarTool.h"
#import "RRFFriendCircleModel.h"
#import "RRFReplyListController.h"
#import "RRFExceptionalListController.h"
#import "RRFDetailInfoController.h"
#import "RRFFriendCircleModel.h"
#import "FriendCircleSendController.h"
#import "RRFRewardController.h"
#import "PZParamTool.h"
#import "RRFMessageNoticeListController.h"
#import "JNQVIPUpdateViewController.h"

#import "JNQRedPaperViewController.h"
#import "BonusPaperModel.h"
#import "JNQRedPaperClickedView.h"
#import "JNQHttpTool.h"
#import "BonusPaperTool.h"
#import "PZNavController.h"
#import "RRFShareOrderDetailInfoController.h"

@interface RRFDynamicController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)JNQFailFooterView *failFootView;
@property(nonatomic,strong)NSMutableArray *allData;
@property(nonatomic,assign)int pageNo;
@property(nonatomic,assign)CGPoint currentOffset;
@property(nonatomic,assign)CGFloat headViewHeight;

@property (nonatomic, strong) JNQRedPaperClickedView *clickedV;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, assign) NSInteger bonusPackageId;
@property (nonatomic, assign) BOOL isSend;
@end

@implementation RRFDynamicController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 0;
    if (self.allData == nil) {
        self.allData = [[NSMutableArray alloc]init];
    }
    
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
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    if (self.isMyFriend) {
        [self.tableView.mj_footer beginRefreshing];
    }else{
        [self settingNoDataViewWithIsMyFriend:NO];
        [self.tableView.mj_header setHidden:YES];
        [self.tableView.mj_footer setHidden:YES];
    }
    [self settingHeadView];
    if ([self.model.isSelfComment isEqualToString:@"self"]) {
        [self settingNavItem];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestDateList:) name:RRFDynamicRefre object:nil];

}
-(void)settingNavItem
{
    UIButton *message = [[UIButton alloc]init];
    message.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [message setImage:[UIImage imageNamed:@"btn_news_list"] forState:UIControlStateNormal];
    message.titleLabel.textAlignment = NSTextAlignmentRight;
    [message addTarget:self action:@selector(messageList) forControlEvents:UIControlEventTouchUpInside];
    message.frame = CGRectMake(0, 0, 64, 44);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:message];
    self.navigationItem.rightBarButtonItem = item;
    
}
// 消息列表
-(void)messageList
{
    RRFMessageNoticeListController *desc = [[RRFMessageNoticeListController alloc]init];
    desc.title = @"消息";
    desc.comeInType = 1;
    desc.fromCircle = YES;
    [self.navigationController pushViewController:desc animated:YES];
}
-(void)settingHeadView
{
    WEAKSELF
    RRFFriendCircleType type;
    CGFloat height;
    if ([self.model.isSelfComment isEqualToString:@"self"]) {
        type = RRFFriendCircleTypeSelf;
        height = 396;
    }else{
        type = RRFFriendCircleTypeOther;
        height = 293;
    }
    self.headViewHeight = height;
    RRFFriendCircleView *headView = [[RRFFriendCircleView alloc]init];
    [headView setShowNoticeView:NO];
    headView.type = type;
    headView.infoM = self.model;
    headView.frame = CGRectMake(0, 0, SCREENWidth, height);
    self.tableView.tableHeaderView = headView;
    [[headView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        RRFDetailInfoController *descVC = [[RRFDetailInfoController alloc] init];
        descVC.userId = self.model.userId;
        descVC.navigationItem.title = @"详细资料";
        descVC.detailInfoComeInType = RRFDetailInfoComeInTypeDynamic;
        [weakSelf.navigationController pushViewController:descVC animated:YES];
    }];
    [[headView.sendView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        FriendCircleSendController* composeCircle = [[FriendCircleSendController alloc]init];
        composeCircle.title = @"发表动态" ;
        composeCircle.isRefre = ^(BOOL refre){
            [weakSelf.tableView.mj_header beginRefreshing];
        };
        [weakSelf.navigationController pushViewController:composeCircle animated:YES];
    }];
    
    
    if (self.failFootView == nil) {
        self.failFootView = [[JNQFailFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64-height)];
        self.failFootView.reloadBlock = ^(){
            [weakSelf.tableView.mj_footer beginRefreshing];
        };
    }
}

-(void)requestDateList:(UIView *)sender
{
    WEAKSELF
    BOOL refre = NO;
    NSMutableArray *temp;
    if ([sender isKindOfClass:[MJRefreshHeader class]]) {
        refre = YES;
        self.currentOffset = CGPointZero;
    }
    if ([sender isKindOfClass:[NSNotification class]]) {
        refre = YES;
    }
    if (refre) {
        self.pageNo = 0;
        temp = [[NSMutableArray alloc]init];
    }else{
        temp = [NSMutableArray arrayWithArray:self.allData];
    }
    [RRFPuzzleBarTool requestFriendCommentListWithCommentTypeId:self.model.userId commentType:@"otherUser" PageNo:self.pageNo Size:10 Success:^(id json) {
        BOOL last = [json[@"last"] boolValue];
        NSArray *dateArray = json[@"content"];
        for (NSDictionary *dic in dateArray) {
            RRFFriendCircleModel *model = [RRFFriendCircleModel yy_modelWithJSON:dic];
            [temp addObject:model];
        }
        weakSelf.allData = temp;
        if (temp.count == 0) {
            [weakSelf settingNoDataViewWithIsMyFriend:self.isMyFriend];
        }else{
            [weakSelf.tableView setTableFooterView:[UIView new]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView reloadData];
        weakSelf.pageNo ++;
        if (last) {
            [weakSelf.tableView.mj_footer setHidden:YES];
        }else{
            [weakSelf.tableView.mj_footer setHidden:NO];
        }
    } failBlock:^(id json) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.tableView.mj_footer.hidden = YES;
        [weakSelf.tableView setTableFooterView:weakSelf.failFootView];
    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    RRFFriendCircleModel *model = self.allData[indexPath.row];
    RRFPersonalHomePageCell *cell = [[RRFPersonalHomePageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RRFDynamicController"];
    cell.cellType = [model.isSelfComment isEqualToString:@"self"]?RRFPersonalHomePageCellTypeTypeSelf:DelegaterListControllerViewTypeOther;
    cell.friendModel = model;
    cell.redPaperBlock = ^(NSInteger paperId){
        //点击红包
        _bonusPackageId = paperId;
        _isSend = [cell.friendModel.isSelfComment isEqualToString:@"self"];
        [BonusPaperTool groupDraw:_bonusPackageId Success:^(id json) {
            BonusPaperModel* pModel = (BonusPaperModel *)json;
            [MBProgressHUD dismiss];
            if ([pModel.status isEqualToString:@"time_out"]) {
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                [window addSubview:self.backBtn];
                [window addSubview:self.clickedV];
                self.clickedV.pModel = pModel;
                [weakSelf showAnimateForView:weakSelf.clickedV];
            } else {
                if ((_isSend && [pModel.bonusType isEqualToString:@"average"] && [pModel.isReceive isEqualToString:@"alreadyReceive"]) || (_isSend && [pModel.bonusType isEqualToString:@"random"] && [pModel.isReceive isEqualToString:@"alreadyReceive"]) || (!_isSend && [pModel.bonusType isEqualToString:@"average"] && [pModel.isReceive isEqualToString:@"alreadyReceive"]) || (!_isSend && [pModel.bonusType isEqualToString:@"random"] && [pModel.isReceive isEqualToString:@"alreadyReceive"]) || (_isSend && [pModel.bonusType isEqualToString:@"average"] && [pModel.isReceive isEqualToString:@"noReceive"] && [pModel.status isEqualToString:@"empty_finish"])) {
                    JNQRedPaperViewController *vc = [[JNQRedPaperViewController alloc] init];
                    PZNavController *nav = [[PZNavController alloc]initWithRootViewController:vc];
                    vc.pModel = pModel;
                    if ([pModel.bonusType isEqualToString:@"average"]) {
                        vc.isSend = _isSend;
                    }
                    [self presentViewController:nav animated:YES completion:nil];
                } else if ((_isSend && [pModel.bonusType isEqualToString:@"average"] && [pModel.isReceive isEqualToString:@"noReceive"] && [pModel.status isEqualToString:@"running"]) || (_isSend && [pModel.bonusType isEqualToString:@"random"] && [pModel.isReceive isEqualToString:@"noReceive"]) || (!_isSend && [pModel.bonusType isEqualToString:@"average"] && [pModel.isReceive isEqualToString:@"noReceive"]) || (!_isSend && [pModel.bonusType isEqualToString:@"random"] && [pModel.isReceive isEqualToString:@"noReceive"])) {
                    UIWindow *window = [UIApplication sharedApplication].keyWindow;
                    [window addSubview:self.backBtn];
                    [window addSubview:self.clickedV];
                    self.clickedV.pModel = pModel;
                    [weakSelf showAnimateForView:weakSelf.clickedV];
                }
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
    [self tableViewCellClick:cell IndexPath:indexPath];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RRFFriendCircleModel *model = self.allData[indexPath.row];
    if ([model.type isEqualToString:@"bonusPackage"]){
      return;
    }else if ([model.type isEqualToString:@"awardOrder"]){
        // 中奖订单
        
        RRFShareOrderDetailInfoController *desc = [[RRFShareOrderDetailInfoController alloc]init];
        desc.title = @"晒单详情";
        desc.showOrderType = RRFShowOrderTypeWining;
        desc.winingOrderShowId = model.awardOrderModel.stockWinOrderShowId;
        [self.navigationController pushViewController:desc animated:YES];
    }else if ([model.type isEqualToString:@"exchangeOrder"]){
        // 礼品兑换订单
        RRFShareOrderDetailInfoController *desc = [[RRFShareOrderDetailInfoController alloc]init];
        desc.title = @"晒单详情";
        desc.showOrderType = RRFShowOrderTypeGift;
        desc.giftOrderShowId = model.exchangeOrderModel.commentId;
        [self.navigationController pushViewController:desc animated:YES];
    }else if ( [model.type isEqualToString:@"bidOrder"] ){
        // 0元夺宝订单
        RRFShareOrderDetailInfoController *desc = [[RRFShareOrderDetailInfoController alloc]init];
        desc.title = @"晒单详情";
        desc.showOrderType = RRFShowOrderTypeFreeBuy;
        desc.purchaseGameShowId = model.bidOrderModel.purchaseGameShowId;
        [self.navigationController pushViewController:desc animated:YES];
    }else{
        RRFReplyListController *desc = [[RRFReplyListController alloc]init];
        desc.commentId = model.ID;
        desc.title = @"全部回复";
        desc.commentName = model.userName;
        desc.viewType = RRFCommentDetailInfoTypeFriendCircle;
        [self.navigationController pushViewController:desc animated:YES];
    }
}
-(void)tableViewCellClick:(id)sender IndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    if ([sender isKindOfClass:[RRFPersonalHomePageCell class]]) {
        RRFFriendCircleModel *model = self.allData[indexPath.row];
        RRFPersonalHomePageCell *cell = (RRFPersonalHomePageCell *)sender;
        cell.cellClick = ^(NSNumber *tage){
            int type = [tage intValue];
            if (type == 0) {
                // 评论
                RRFReplyListController *desc = [[RRFReplyListController alloc]init];
                desc.commentId = model.ID;
                desc.title = @"全部回复";
                desc.commentName = model.userName;
                desc.viewType = RRFCommentDetailInfoTypeFriendCircle;
                [weakSelf.navigationController pushViewController:desc animated:YES];
            }else if (type == 1){
                // 点赞
                [weakSelf listWithTitle:@"点赞" type:CommentCellClickTypePraise commentId:model.ID];
            }else if (type == 2){
                 // 打赏
                if ([model.isSelfComment isEqualToString:@"self"]) {
                    [weakSelf listWithTitle:@"赞赏" type:CommentCellClickTypeReward commentId:model.ID];
                }else{
                    [weakSelf pushRewardControllerWithUserId:model.userId entityId:model.ID entityType:@"dynamicAction"];
                }
            }else {
                // 删除
                UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }];
                UIAlertAction *yseAction = [UIAlertAction actionWithTitle:@"删除评论" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf deletedCommentWithId:model.ID indexPath:indexPath];
                }];
                [alertView addAction:yseAction];
                [alertView addAction:cancelAction];
                [weakSelf presentViewController:alertView animated:YES completion:^{}];
            }
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
    }
}
-(void)deletedCommentWithId:(NSInteger)ID indexPath:(NSIndexPath*)indexPath
{
    WEAKSELF
    [RRFPuzzleBarTool deleteCommentWithEntityWithUrl:@"client/friendCircle/deleteDynamicAction" Type:@"dynamicAction" entityId:ID Success:^(id json) {
        [self.allData removeObjectAtIndex:indexPath.row];
        [weakSelf.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [weakSelf.tableView reloadData];
    } failBlock:^(id json) {
        
    }];
}
#pragma mark - 进入打赏页
-(void)pushRewardControllerWithUserId:(NSInteger)userId entityId:(NSInteger)entityId entityType:(NSString *)entityType
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
-(void)listWithTitle:(NSString *)title type:(CommentCellClickType)type commentId:(NSInteger)commentId
{
    RRFExceptionalListController *desc = [[RRFExceptionalListController alloc]init];
    desc.title = title;
    desc.type = type;
    desc.comeInType = PraiseListTypeFriendCircle;
    desc.entityType = @"dynamicAction";
    desc.ID = commentId ;
    [self.navigationController pushViewController:desc animated:YES];
}
-(void)settingNoDataViewWithIsMyFriend:(BOOL)isMyFriend
{
    NSString *titleStr ;
    if (isMyFriend) {
        if ([self.model.isSelfComment isEqualToString:@"self"]) {
            titleStr = @"你还没有发表任何评论!";
        }else{
            titleStr = @"他还没有发表任何状态！";
        }
    }else{
        titleStr = @"你不是他的好友，不能查看他的动态!";
    }
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWidth, 100)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 30, SCREENWidth-30, 50)];
    titleLabel.text = titleStr;
    titleLabel.numberOfLines=2;
    titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:titleLabel];
    self.tableView.tableFooterView = footerView;
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
                    if ([pModel.bonusType isEqualToString:@"average"]) {
                        vc.isSend = weakSelf.isSend;
                    }
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
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.currentOffset = self.tableView.contentOffset;
}
@end
