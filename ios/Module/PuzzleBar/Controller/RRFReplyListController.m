//
//  RRFReplyListController.m
//  Puzzle
//
//  Created by huibei on 16/9/21.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFReplyListController.h"
#import "MJRefresh.h"
#import "RRFCommentDetailCell.h"
#import "RRFPuzzleBarTool.h"
#import "RRFCommentContentListModel.h"
#import "PZParamTool.h"
#import "STInputBar.h"
#import "RRFRespToRespListModel.h"
#import "TPKeyboardAvoidingTableView.h"
#import "UIViewController+ResignFirstResponser.h"
#import "JNQFailFooterView.h"
#import "HBLoadingView.h"
#import "RRFCommentsCellModel.h"
#import "RRFCommentDetailView.h"
#import "RRFRewardController.h"
#import "JNQFriendCircleModel.h"
#import "RRFFriendCirclebetView.h"
#import "JNQVIPUpdateViewController.h"
#import "RRFDetailInfoController.h"
#import "PZParamTool.h"
#import "LoginModel.h"
#import "RRFMeTool.h"
#import "RRFExceptionalListController.h"
#import "PZReactUIManager.h"
#import "LGAlertView.h"
#import "WXApi.h"
#import <UMSocialSnsPlatformManager.h>
#import "HomeTool.h"
#import "HBShareTool.h"
#import "SDWebImageManager.h"
#import "ImageModel.h"

@interface RRFReplyListController ()<UITableViewDelegate,UITableViewDataSource,LGAlertViewDelegate>
@property(nonatomic,strong)JNQFailFooterView *failFootView;
@property(nonatomic,weak)TPKeyboardAvoidingTableView *tableView;
@property(nonatomic,strong)NSMutableArray *allData;

@property(strong,nonatomic)RRFCommentContentListModel* currentModel ;
@property(nonatomic,assign)ReplyType replyType;
@property(nonatomic,assign)int pageNo;
@property(nonatomic,weak)STInputBar *inputBar;
// 回复的id
@property(nonatomic,assign)NSInteger responseId;



@property(strong,nonatomic) NSIndexPath* selectedIndexPath ;
@property(nonatomic,strong)RRFCommentsCellModel *commentModel;
@property(nonatomic,weak)RRFCommentDetailView *headView;
@property(nonatomic,assign)CGFloat headViewHeight;
@property(nonatomic,strong)LoginModel *currentUserM;

@property(weak,nonatomic)UIView* shareView ;
@property(weak,nonatomic)UIControl* maskView ;


@property(assign,nonatomic)BOOL showShare ;

@property NSString* shareTitle ;
@property NSString* shareContent ;
@property UIImage* shareImage ;

@property(assign,nonatomic) CGFloat shareHeight ;
@end

@implementation RRFReplyListController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF
    self.pageNo = 0;
    self.replyType = ReplyTypeReply;
    self.shareHeight = [WXApi isWXAppInstalled] ? 280 :160+30;
    if (self.allData == nil) {
        self.allData = [[NSMutableArray alloc]init];
    }
    if (self.failFootView == nil) {
        self.failFootView = [[JNQFailFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64)];
        self.failFootView.reloadBlock = ^(){
            [weakSelf.tableView.mj_header beginRefreshing];
        };
    }
    
    {
        //举报
        UIBarButtonItem* moreItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_more"] style:UIBarButtonItemStylePlain target:self action:@selector(navMoreClick)];
        moreItem.tintColor = [UIColor yellowColor];
        self.navigationItem.rightBarButtonItem = moreItem ;
    }
    
    
    if (self.showCancel) {
        UIBarButtonItem* cancelItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelController)];
        self.navigationItem.rightBarButtonItem = cancelItem ;
    }
    [self settingCommentDetailView];
    
    [self.tableView.mj_footer beginRefreshing];
    
    UIControl* maskView = [[UIControl alloc]init];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.4 ;
    maskView.hidden = YES ;
    [[UIApplication sharedApplication].keyWindow addSubview:maskView];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [[maskView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIView* x) {
        [weakSelf showShow:NO];
        x.hidden = YES ;
    }];
    self.maskView = maskView ;
    
    //分享
    UIView* rootView = [PZReactUIManager createWithPage:@"share_comment" params:nil size:CGSizeZero];
    [[UIApplication sharedApplication].keyWindow addSubview:rootView];
    [rootView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.shareHeight);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(self.shareHeight);
    }];
    self.shareView = rootView ;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden) name:UIKeyboardWillHideNotification object:nil];
    //分享  举报 黑名单
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reactShareNotificate:) name:@"ReactShareNotificate" object:nil];
}

-(void)navMoreClick{
    self.showShare = !self.showShare ;
    [self showShow:self.showShare];
}

-(void)showShow:(BOOL)show{
    self.showShare = show ;
    self.maskView.hidden = !show ;
    WEAKSELF
    [UIView animateWithDuration:1.5 animations:^{
        CGFloat offSet = show ? 0.0f:self.shareHeight;
        [weakSelf.shareView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(offSet);
        }];
        [weakSelf.shareView layoutIfNeeded];
    }];
}


-(void)reactShareNotificate:(NSNotification*)notificate{
    NSString* userInfo = notificate.object ;
    if (userInfo) {
        if ([userInfo isEqualToString:@"blackList"]) {
            [self addToBlackList];
        }
        else if ([userInfo isEqualToString:@"reportClick"]){
            [self reportClick];
        }
        else if([userInfo isEqualToString:@"cancelClick"]){}
        else{
            //分享
            [self shareTo:userInfo];
        }
    }
    [self showShow:NO];
}

-(void)shareTo:(NSString*)platform{
    WEAKSELF
    
    if (![WXApi isWXAppInstalled]) {
        [MBProgressHUD showInfoWithStatus:@"您没有安装微信应用"];
        return ;
    }
    if ([platform isEqualToString:@"微信好友"]) {
        platform = UMShareToWechatSession ;
    }
    else if ([platform isEqualToString:@"微信朋友圈"]){
        platform = UMShareToWechatTimeline ;

    }
    else if ([platform isEqualToString:@"新浪微博"]){
        platform = UMShareToSina ;

    }
    else if ([platform isEqualToString:@"QQ好友"]){
        platform = UMShareToQQ ;

    }
    UIImage* image = self.shareImage ?self.shareImage :[UIImage imageNamed:@"share_logo"] ;
    LoginModel* user = [PZParamTool currentUser];

    NSString *fullUrlStr = [NSString stringWithFormat:@"%@xitenggame/singleWrap/weiComment.html?commentId=%ld&xitengCode=%@",Base_url,(long)self.commentId,user.xtNumber];
    [[HBShareTool sharedInstance] shareSingleSNSWithType:platform title:self.shareTitle image:image url:fullUrlStr msg:self.shareContent presentedController:weakSelf];
}

#pragma mark - 举报
-(void)reportClick{
   WEAKSELF
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择举报类型" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *ADAction = [UIAlertAction actionWithTitle:@"广告或垃圾信息" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf report:action.title];
    }];
    UIAlertAction *sexAction = [UIAlertAction actionWithTitle:@"色情反动信息" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf report:action.title];

    }];
    UIAlertAction *attacksAction = [UIAlertAction actionWithTitle:@"人身攻击" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf report:action.title];

    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"其他" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf report:action.title];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:ADAction];
    [alertController addAction:sexAction];
    [alertController addAction:attacksAction];

    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


-(void)report:(NSString*)content{
    [RRFPuzzleBarTool reportWithCommentId:self.commentId comment:content success:^(id json) {
        [MBProgressHUD showInfoWithStatus:@"您的反馈已提交！"];
    } failBlock:^(id json) {
        
    }];
}

-(void)addToBlackList{
    [RRFPuzzleBarTool addBlackList:self.commentModel.userId success:^(id json) {
        [MBProgressHUD showInfoWithStatus:@"已加入黑名单！"];
    } failBlock:^(id json) {
        
    }];
}


-(void)keyboardWillHidden
{
    self.replyType = ReplyTypeReply;
    self.inputBar.placeHolder =[NSString stringWithFormat:@"回复:%@",self.commentName];
}

-(void)cancelController{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)settingCommentDetailView
{
    TPKeyboardAvoidingTableView *tableView = [[TPKeyboardAvoidingTableView alloc]init];
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 200.0;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [tableView registerClass:[RRFCommentDetailCell class] forCellReuseIdentifier:@"RRFReplyListController"];
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-44);
    }];
    
    MJRefreshNormalHeader *tabheader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getCommentList:)];
    tabheader.lastUpdatedTimeLabel.hidden = YES;
    tabheader.stateLabel.textColor = HBColor(135, 135, 135);
    tabheader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.tableView.mj_header = tabheader;
    
    MJRefreshAutoNormalFooter *tabfooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getCommentList:)];
    tabfooter.triggerAutomaticallyRefreshPercent = 1;
    tabfooter.automaticallyRefresh = YES;
    tabfooter.stateLabel.textColor = HBColor(135, 135, 135);
    self.tableView.mj_footer = tabfooter;
    
    
    WEAKSELF
    STInputBar *inputBar = [STInputBar inputBar];
    [inputBar setFitWhenKeyboardShowOrHide:YES];
    inputBar.floatBottom = YES ;
    inputBar.commonMode = NO ;
    [inputBar setDidSendClicked:^(NSString *text) {
        [weakSelf updateMessage:text];
    }];
    inputBar.placeHolder =[NSString stringWithFormat:@"回复:%@",self.commentName];
    [inputBar hiddenPhoto];
    [inputBar resignFirstResponder];
    self.inputBar = inputBar;
    [self.view addSubview:inputBar];
    [inputBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    [self setFooter];
    
}


-(void)setFooter{
    UIView* footer = [[UIView alloc]init];
    self.tableView.tableFooterView = footer;
}

-(void)getCommentList:(UIView *)sender
{
    WEAKSELF
    BOOL reset = NO ;
    if ([sender isKindOfClass:[MJRefreshHeader class]]) {
        self.pageNo = 0;
        reset = YES ;
    }
    NSString *url;
    if (self.viewType == RRFCommentDetailInfoTypeComment ) {
        url = @"commentDetail";
    }else{
        url = @"client/friendCircle/dynamicActionDetail";
    }
    [RRFPuzzleBarTool requestCommentDetailListWithUrl:url CommentId:self.commentId pageNo:_pageNo Success:^(id json) {
        
        if (self.viewType == RRFCommentDetailInfoTypeComment) {
            RRFCommentsCellModel *model = [RRFCommentsCellModel yy_modelWithJSON:json[@"commentModel"]];
            self.commentModel = model;
            [self settingCommentDetailViewWithModel:model Type:@"comment"];
        }else{
            if ([json[@"dynamicActionModel"][@"type"] isEqualToString:@"friendCircleComment"]) {
                RRFCommentsCellModel *model = [RRFCommentsCellModel yy_modelWithJSON:json[@"dynamicActionModel"][@"commentModel"]];
                model.isPraise = json[@"dynamicActionModel"][@"isPraise"];
                model.isSelfComment = json[@"dynamicActionModel"][@"isSelfComment"];
                NSArray *praiseUsersDic = json[@"dynamicActionModel"][@"praiseUsers"];
                NSMutableArray *praiseUsers = [[NSMutableArray alloc]init];
                for (NSDictionary *dic in praiseUsersDic) {
                    PraiseUsersModel *model = [PraiseUsersModel yy_modelWithJSON:dic];
                    [praiseUsers addObject:model];
                    
                }
                model.praiseUsers = praiseUsers;
                NSArray *presentUsersDic = json[@"dynamicActionModel"][@"presentUsers"];
                NSMutableArray *presentUsers = [[NSMutableArray alloc]init];
                for (NSDictionary *dic in presentUsersDic) {
                    PraiseUsersModel *model = [PraiseUsersModel yy_modelWithJSON:dic];
                    [presentUsers addObject:model];
                    
                }
                model.presentUsers = presentUsers;
                model.ID = [json[@"dynamicActionModel"][@"id"] intValue];
                model.time = json[@"dynamicActionModel"][@"time"];
                self.commentModel = model;
                [self settingCommentDetailViewWithModel:model Type:@"comment"];
            }else{
                JNQFriendCircleModel *model = [JNQFriendCircleModel yy_modelWithJSON:json[@"dynamicActionModel"][@"guessWithStockModel"]];
                model.isSelfComment = json[@"dynamicActionModel"][@"isSelfComment"];
                model.isPraise = json[@"dynamicActionModel"][@"isPraise"];
                NSArray *praiseUsersDic = json[@"dynamicActionModel"][@"praiseUsers"];
                NSMutableArray *praiseUsers = [[NSMutableArray alloc]init];
                for (NSDictionary *dic in praiseUsersDic) {
                    PraiseUsersModel *model = [PraiseUsersModel yy_modelWithJSON:dic];
                    [praiseUsers addObject:model];
                    
                }
                model.praiseUsers = praiseUsers;
                NSArray *presentUsersDic = json[@"dynamicActionModel"][@"presentUsers"];
                NSMutableArray *presentUsers = [[NSMutableArray alloc]init];
                for (NSDictionary *dic in presentUsersDic) {
                    PraiseUsersModel *model = [PraiseUsersModel yy_modelWithJSON:dic];
                    [presentUsers addObject:model];
                    
                }
                model.presentUsers = presentUsers;
                model.ID = [json[@"dynamicActionModel"][@"id"] intValue];
                [self settingCommentHeadViewWithModel:model Type:@"dynamicAction"];
            }
        }
        BOOL last = [[json objectForKey:@"last"] boolValue];
        NSArray *contentArray = [json objectForKey:@"content"];
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        if (contentArray.count > 0) {
            for (NSMutableDictionary *diction in contentArray) {
                RRFCommentContentListModel *model = [RRFCommentContentListModel yy_modelWithJSON:diction];
                [temp addObject:model];
            }
        }
        if (weakSelf.pageNo == 0 && reset) {
            weakSelf.allData = temp;
        }else{
            [weakSelf.allData addObjectsFromArray:temp];
        }
        if(self.allData.count == 0){
            [weakSelf settingNoDataView];
        }else{
            [weakSelf setFooter];
        }
        [weakSelf.tableView reloadData];
        self.pageNo ++;
        if (last) {
            [weakSelf.tableView.mj_footer setHidden:YES];
        }else{
            [weakSelf.tableView.mj_footer setHidden:NO];
        }
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
    } failBlock:^(id json) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer setHidden:YES];
        [weakSelf.tableView setTableFooterView:self.failFootView];
    }];
}
// 评论的头部
-(void)settingCommentDetailViewWithModel:(RRFCommentsCellModel *)model Type:(NSString *)type
{
    WEAKSELF
    self.shareTitle = @"喜腾沙龙" ;
    self.shareContent = model.content ;
    if (model.contentImages.count) {
        ImageModel* imageModel = model.contentImages.firstObject ;
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:imageModel.head_img] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            weakSelf.shareImage = image ;
        }];
    }
    RRFCommentDetailView *headView = [[RRFCommentDetailView alloc]init];
    headView.commentM = model;
    headView.type = type;
    CGFloat height = [headView viewHeightWithModel:model];
    self.headViewHeight = height;
    headView.frame = CGRectMake(0, 0, SCREENWidth, height);
    self.headView = headView;
    self.tableView.tableHeaderView = headView;
    headView.detailBlock = ^(NSNumber *typeNumber){
        NSInteger typeInt = [typeNumber integerValue];
        if (typeInt == 0) {
            if ([model.isSelfComment isEqualToString:@"self"]) {
                [weakSelf listWithId:model.ID];
            }else{
                // 打赏
                [weakSelf rewardWithEntityId:model.ID userId:model.userId entityType:@"dynamicAction"];
            }
        }else if (typeInt == 2){
            // 点赞
            if (self.viewType == RRFCommentDetailInfoTypeComment) {
                [self agreeBtnClickWithCommrntId:model.ID Model:model];
            }else{
                [weakSelf agreeBtnClickWithType:type CommrntId:model.ID Model:model];
            }
        }else{
            // 评论
            weakSelf.replyType = ReplyTypeReply;
            [weakSelf.inputBar setDidSendClicked:^(NSString *text) {
                [weakSelf updateMessage:text];
            }];
            weakSelf.inputBar.placeHolder =[NSString stringWithFormat:@"回复:%@",self.commentName];
            [weakSelf.inputBar becomeFirstResponder];
            
        }
    };

}
-(void)listWithId:(int)ID
{
    RRFExceptionalListController *desc = [[RRFExceptionalListController alloc]init];
    desc.title = @"点赞列表";
    desc.comeInType =  self.viewType == RRFCommentDetailInfoTypeComment?PraiseListTypeComment:PraiseListTypeFriendCircle;
    desc.type = CommentCellClickTypeReward;
    desc.entityType =  self.viewType == RRFCommentDetailInfoTypeComment ? @"comment":@"dynamicAction";
    desc.ID = ID;
    [self.navigationController pushViewController:desc animated:YES];
}
// 投注类型的头部
-(void)settingCommentHeadViewWithModel:(JNQFriendCircleModel *)model Type:(NSString *)type
{
    WEAKSELF
    RRFCommentDetailView *headView = [[RRFCommentDetailView alloc]init];
    headView.frienfCircleM = model;
    headView.type = @"dynamicAction";
    CGFloat height = [headView betViewHeightWithFriendCircleModel:model];
    self.headViewHeight = height;
    headView.frame = CGRectMake(0, 0, SCREENWidth, height);
    self.headView = headView;
    self.tableView.tableHeaderView = headView;
    headView.detailBlock = ^(NSNumber *typeNumber){
        NSInteger typeInt = [typeNumber integerValue];
        if (typeInt == 0) {
            if ([model.isSelfComment isEqualToString:@"self"]) {
                [weakSelf listWithId:model.ID];
            }else{
                // 打赏
                [weakSelf rewardWithEntityId:model.ID userId:model.userId entityType:@"dynamicAction"];
            }
        }else if (typeInt == 2){
                // 点赞
                [weakSelf agreeBtnClickWithType:type CommrntId:model.ID Model:model];
        }else{
            // 评论
            weakSelf.replyType = ReplyTypeReply;
            [weakSelf.inputBar setDidSendClicked:^(NSString *text) {
                [weakSelf updateMessage:text];
            }];
            weakSelf.inputBar.placeHolder =[NSString stringWithFormat:@"回复:%@",weakSelf.commentName];
            [weakSelf.inputBar becomeFirstResponder];
        }
    };
    headView.betView.betViewCheckBlock = ^(){
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
// 沙龙详情的点赞
-(void)agreeBtnClickWithCommrntId:(NSInteger)commentId Model:(id)model
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:@(commentId ) forKey:@"commentId"];
    [PZParamTool agreedToWithUrl:@"addPraise" param:param Success:^(id json) {
        RRFCommentsCellModel *commentM = (RRFCommentsCellModel *)model;
        NSMutableArray *temp = [[NSMutableArray alloc]initWithArray:commentM.praiseUsers];
        PraiseUsersModel *tempUserM = [[PraiseUsersModel alloc]init];
        if ([commentM.isPraise isEqualToString:@"alreadyPraise"]) {
            // 删除
            commentM.isPraise = @"noPraise";
            for (PraiseUsersModel *userM in commentM.praiseUsers) {
                if (userM.userId == [self.currentUserM.userId intValue]) {
                    tempUserM = userM;
                    break;
                }
            }
            [temp removeObject:tempUserM];
        }else{
            // 添加
            commentM.isPraise = @"alreadyPraise";
            tempUserM.userId = [self.currentUserM.userId integerValue];
            tempUserM.userIconUrl = self.currentUserM.icon;
            [temp addObject:tempUserM];
        }
        commentM.praiseUsers = [temp copy];
        self.headView.commentM = commentM;
        CGFloat height = [self.headView viewHeightWithModel:commentM];
        [self.tableView reloadData];
        self.headView.frame = CGRectMake(0, 0, SCREENWidth, height);
    } failBlock:^(id json) {
    }];
}

// 朋友圈点赞
-(void)agreeBtnClickWithType:(NSString *)type CommrntId:(NSInteger)commentId Model:(id)model
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:@(commentId) forKey:@"commentId"];
    [PZParamTool agreedToWithUrl:@"/client/friendCircle/addDynamicActionPraise" param:param Success:^(id json) {
        if ([type isEqualToString:@"comment"]) {
            RRFCommentsCellModel *commentM = (RRFCommentsCellModel *)model;
            NSMutableArray *temp = [[NSMutableArray alloc]initWithArray:commentM.praiseUsers];
            PraiseUsersModel *tempUserM = [[PraiseUsersModel alloc]init];
            if ([commentM.isPraise isEqualToString:@"alreadyPraise"]) {
                // 删除
                commentM.isPraise = @"noPraise";
                for (PraiseUsersModel *userM in commentM.praiseUsers) {
                    if (userM.userId == [self.currentUserM.userId intValue]) {
                        tempUserM = userM;
                        break;
                    }
                }
                [temp removeObject:tempUserM];
            }else{
                // 添加
                commentM.isPraise = @"alreadyPraise";
                tempUserM.userId = [self.currentUserM.userId integerValue];
                tempUserM.userIconUrl = self.currentUserM.icon;
                [temp addObject:tempUserM];
            }
            commentM.praiseUsers = [temp copy];
            self.headView.commentM = commentM;
            CGFloat height = [self.headView viewHeightWithModel:commentM];
            [self.tableView reloadData];
            self.headView.frame = CGRectMake(0, 0, SCREENWidth, height);
            
        }else{
            JNQFriendCircleModel *friendM = (JNQFriendCircleModel *)model;
            NSMutableArray *temp = [[NSMutableArray alloc]initWithArray:friendM.praiseUsers];
            PraiseUsersModel *tempUserM = [[PraiseUsersModel alloc]init];
            if ([friendM.isPraise isEqualToString:@"alreadyPraise"]) {
                // 删除
                friendM.isPraise = @"noPraise";
                for (PraiseUsersModel *userM in friendM.praiseUsers) {
                    if (userM.userId == [self.currentUserM.userId intValue]) {
                        tempUserM = userM;
                        break;
                    }
                }
                [temp removeObject:tempUserM];
            }else{
                // 添加
                friendM.isPraise = @"alreadyPraise";
                tempUserM.userId = [self.currentUserM.userId integerValue];
                tempUserM.userIconUrl = self.currentUserM.icon;
                [temp addObject:tempUserM];
            }
            friendM.praiseUsers = [temp copy];
            self.headView.frienfCircleM = friendM;
            CGFloat height = [self.headView betViewHeightWithFriendCircleModel:friendM];
            [self.tableView reloadData];
            self.headView.frame = CGRectMake(0, 0, SCREENWidth, height);
            
        }
    } failBlock:^(id json) {
    }];
}
#pragma mark - 进入打赏页
-(void)rewardWithEntityId:(NSInteger)entityId userId:(NSInteger)userId entityType:(NSString *)entityType
{
    if (![PZParamTool hasLogin]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goLogin" object:nil];
        return;
    }
    RRFRewardController *desc = [[RRFRewardController alloc]init];
    desc.title = @"赞赏";
    desc.userId = userId;
    desc.entityId = entityId;
    desc.entityType = entityType ;
    [self.navigationController pushViewController:desc animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"RRFReplyListController";
    RRFCommentContentListModel *model = _allData[indexPath.row];
    RRFCommentDetailCell *cell = [[RRFCommentDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    cell.contentListM = model;
    WEAKSELF
    cell.detailCellBlock = ^(NSNumber *type){
        weakSelf.currentModel = model ;
        weakSelf.selectedIndexPath = indexPath ;
        NSInteger blockType = [type intValue];
        if (blockType == 0) {
            // 回复
            if (![PZParamTool hasLogin]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"goLogin" object:nil];
                return;
            }
            weakSelf.replyType = ReplyTypeReplyToReply;
            weakSelf.inputBar.placeHolder =[NSString stringWithFormat:@"回复:%@",model.respCommentUserName];
            weakSelf.responseId = model.responseId;
            [weakSelf.inputBar becomeFirstResponder];
            
        }else if(blockType==1){
            // 删除
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction *yseAction = [UIAlertAction actionWithTitle:@"删除评论" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf deletedCommentWithId:model.responseId indexPath:indexPath];
            }];
            [alertView addAction:cancelAction];
            [alertView addAction:yseAction];
            [weakSelf presentViewController:alertView animated:YES completion:^{}];
        }
        else if (blockType == 2){
            RRFDetailInfoController *desc = [[RRFDetailInfoController alloc]init];
            desc.title = @"详细资料";
            desc.userId = model.respCommentUserId;
            desc.verityInfo = NO;
            desc.detailInfoComeInType =  RRFDetailInfoComeInTypeOther;
            [weakSelf.navigationController pushViewController:desc animated:YES];
        };
    };
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor whiteColor];
    headView.frame = CGRectMake(0, 0, SCREENWidth, 44);
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = [NSString stringWithFormat:@"全部回复(%lu)",(unsigned long)_allData.count];
    titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.frame = CGRectMake(12, 12, 100, 20);
    [headView addSubview:titleLabel];
    UIView *sepView = [[UIView alloc]init];
    sepView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    sepView.frame = CGRectMake(0, 43, SCREENWidth, 1);
    [headView addSubview:sepView];
    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}
-(void)deletedCommentWithId:(NSInteger)ID  indexPath:(NSIndexPath*)indexPath
{
    WEAKSELF
    NSString *url;
    NSString *type;
    if (self.viewType == RRFCommentDetailInfoTypeFriendCircle) {
        url = @"client/friendCircle/deleteDynamicAction";
        type = @"dynamicActionResponse";
    }else{
        url= @"deleteComment";
        type = @"response";
    }
    [RRFPuzzleBarTool deleteCommentWithEntityWithUrl:url Type:type entityId:ID Success:^(id json) {
        [_allData removeObjectAtIndex:indexPath.row];
        [weakSelf.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [weakSelf.tableView reloadData];
        if (self.viewType == RRFCommentDetailInfoTypeFriendCircle) {
            [[NSNotificationCenter defaultCenter] postNotificationName:RRFDynamicRefre object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:RRFFriendCircleRefre object:nil];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshCommentTableView object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshPersonalAskBarTableView object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshRRFHomePageTableView object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFMViewController object:nil];
        }
    } failBlock:^(id json) {
        
    }];
}
- (void)updateMessage:(NSString *)text{
    WEAKSELF
    if (text.length == 0) {
        [MBProgressHUD showInfoWithStatus:@"请输入内容"];
        return;
    }
    text = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *url;
    NSMutableDictionary *prame = [[NSMutableDictionary alloc]init];
    [prame setObject:text forKey:@"content"];
    if (self.replyType == ReplyTypeReplyToReply ) {
        // 回复的回复
        if (self.viewType == RRFCommentDetailInfoTypeComment) {
            url = @"addResponseToResponse";
        }else{
            url = @"client/friendCircle/addDynamicActionResponseToResponse";
        }
        [prame setObject:@(self.responseId) forKey:@"responseId"];
    }else{
        // 回复
        if (self.viewType == RRFCommentDetailInfoTypeComment) {
            url = @"addCommentResponse";
        }else{
            url = @"client/friendCircle/addDynamicActionResponse";
        }
        [prame setObject:@(self.commentId) forKey:@"commentId"];
    }
    [MBProgressHUD show];
    [PZParamTool replyCommentWithUrl:url param:prame Success:^(id json) {
        [MBProgressHUD dismiss];
        [MBProgressHUD showInfoWithStatus:@"评论成功!"];
        [weakSelf createReplyWithType:self.replyType content:text];
        [weakSelf resignAll];
        if (self.replyType != ReplyTypeReplyToReply) {
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshCommentTableView object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshPersonalAskBarTableView object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshRRFHomePageTableView object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFMViewController object:nil];


        }
        if (self.viewType == RRFCommentDetailInfoTypeFriendCircle) {
            [[NSNotificationCenter defaultCenter] postNotificationName:RRFDynamicRefre object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:RRFFriendCircleRefre object:nil];
        }
    } failBlock:^(id json) {
        [MBProgressHUD dismiss];
    }];
}

-(void)createReplyWithType:(ReplyType)type content:(NSString*)content{
    content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (type == ReplyTypeReply) {
        [self.tableView.mj_header beginRefreshing];
    }
    else{
        //回复 的回复
        RRFCommentContentListModel* currentM = self.currentModel ;
        NSMutableArray* list = [NSMutableArray arrayWithArray:currentM.respToRespList];
        RRFRespToRespListModel* m = [[RRFRespToRespListModel alloc]init];
        m.respTorespUserName = @"我" ;
        m.respTorespContent = content ;
        [list addObject:m];
        self.currentModel.respToRespList = list ;
        
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
}
-(void)settingNoDataView
{
    NSString *titleStr = @"暂时还没有人回复您!";
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWidth, 300)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 150, SCREENWidth-30, 50)];
    titleLabel.text = titleStr;
    titleLabel.numberOfLines=2;
    titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:titleLabel];
    self.tableView.tableFooterView = footerView;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RefreshCommentTableView object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RefreshPersonalAskBarTableView object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RRFDynamicRefre object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RRFFriendCircleRefre object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ReactShareNotificate" object:nil];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
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
            self.currentUserM = userM;
            [defaultRealm commitWriteTransaction];
        }
    } failBlock:^(id json) {
    }];
    

}

@end
