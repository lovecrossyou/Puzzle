//
//  RRFCommentController.m
//  Puzzle
//
//  Created by huibei on 16/9/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFCommentController.h"
#import "MJRefresh.h"
#import "HomeTool.h"
#import "RRFCommentsCellModel.h"
#import "RRFCommentsCell.h"
#import "RRFWenBarCellModel.h"
#import "RRFRewardController.h"
#import "RRFPuzzleBarTool.h"
#import "PZParamTool.h"
#import "RRFFocusController.h"
#import "HomePostCommentController.h"
#import "RRFReplyListController.h"
#import "RRFPersonalAskBarController.h"
#import "RRFFocusController.h"
#import "RRFCommentInputView.h"
#import "PZNavController.h"
#import "RRFCommentNoticeView.h"
#import "RRFMessageNoticeListController.h"
#import "NotificateMsgUtil.h"
#import "RRFMessageNoticeListModel.h"
#import "JNQFailFooterView.h"
#import "HBLoadingView.h"
#import "RRFDetailInfoController.h"
#import "PZReactUIManager.h"
#import "ReactSingleTool.h"

#define commentPanelHeight 224 - 64
@interface RRFCommentController ()<UITableViewDelegate,UITableViewDataSource,PersonManagerDelegate>

@property(nonatomic,weak)UITableView *tableView;
@property(nonatomic,weak)RRFCommentInputView *botView;
@property(nonatomic,strong)JNQFailFooterView *failFootView;
@property(strong,nonatomic) NSMutableArray* allData ;
@property(assign,nonatomic) int pageNo ;
//@property(assign,nonatomic) CGPoint currentOffset;
// 是否点赞
@property(nonatomic,strong)NSString *isPraise;

@property(strong,nonatomic)NSIndexPath* indexPath ;

@end

@implementation RRFCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    UIView* rootView = [PZReactUIManager createWithPage:@"commentlist" params:nil size:CGSizeZero];
  self.view = rootView ;
  
  
  [ReactSingleTool sharedInstance].delegate = self ;
  return;
    WEAKSELF
    self.pageNo = 0;
    UITableView *tableView = [[UITableView alloc]init];
    tableView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    tableView.delegate = self ;
    tableView.dataSource = self ;
    [tableView registerClass:[RRFCommentsCell class] forCellReuseIdentifier:@"RRFCommentController"];
    tableView.tableFooterView = [[UIView alloc]init];
    tableView.estimatedRowHeight = 120.0f;
    tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-50);
    }];
    
    RRFCommentInputView *botView = [[RRFCommentInputView alloc]initWithTitle:@"聊聊你对市场的看法" redPaper:NO];
    [botView addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
    self.botView = botView;
    [self.view addSubview:botView];
    [botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    MJRefreshNormalHeader *tabheader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestDataList:)];
    tabheader.lastUpdatedTimeLabel.hidden = YES;
    tabheader.stateLabel.textColor = HBColor(135, 135, 135);
    tabheader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.tableView.mj_header = tabheader;
    
    MJRefreshAutoNormalFooter *tabfooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestDataList:)];
    tabfooter.triggerAutomaticallyRefreshPercent = 1;
    tabfooter.automaticallyRefresh = YES;
    tabfooter.stateLabel.textColor = HBColor(135, 135, 135);
    self.tableView.mj_footer = tabfooter;
    
    if (self.failFootView == nil) {
        self.failFootView = [[JNQFailFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64)];
        self.failFootView.reloadBlock = ^(){
            [weakSelf.tableView.mj_header beginRefreshing];
        };
    }
    
    [self settingNavItem];
    [self.tableView.mj_footer beginRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreHeadView) name:RefreshCommentNoticeView object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestDataList:) name:RefreshCommentTableView object:nil];
}

#pragma mark - 实现 头像点击代理
-(void)headClick{
  
}


-(NSMutableArray *)allData{
    if (_allData == nil) {
        _allData = [[NSMutableArray alloc]init];
    }
    return _allData ;
}


-(void)refreHeadView
{
    NSInteger unReadMsgCount = [NotificateMsgUtil unReadMsgCount];
    NSArray *modelList = [NotificateMsgUtil  loadMsgUnRead];
    RRFMessageNoticeListModel *model = [modelList firstObject] ;
    NSString *headStr = model.iconUrl;
    [self settingNoticeViewWithCount:unReadMsgCount HeadStr:headStr];
}

-(void)settingNoticeViewWithCount:(NSInteger)count HeadStr:(NSString *)headStr
{
    RRFCommentNoticeView *noticeView = [[RRFCommentNoticeView alloc]init];
    NSString* countString = [NSString stringWithFormat:@"%ld条消息",(long)count];
    [noticeView settingHeadView:headStr countStr:countString];
    noticeView.frame = CGRectMake(0, 0, SCREENWidth, 56);
    [noticeView addTarget:self action:@selector(goMessageList) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView setTableHeaderView:noticeView];
}
-(void)sendCommentWithMsg:(NSString*)content{
    WEAKSELF
    [HBLoadingView showCircleView:self.view];
    [HomeTool addCommentWithStockId:0 imgs:nil content:content successBlock:^(id json) {
        weakSelf.refreshCallBack();
        [HBLoadingView hide];
    } fail:^(id json) {
        [HBLoadingView hide];
    }];
}
-(void)goMessageList
{
    RRFMessageNoticeListController *desc = [[RRFMessageNoticeListController alloc]init];
    desc.title = @"消息列表";
    desc.fromCircle = NO ;
    desc.comeInType = 0;
    [self.navigationController pushViewController:desc animated:YES];
}
#pragma mark - 写评论
-(void)editClick{
    WEAKSELF
    if (![PZParamTool hasLogin]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goLogin" object:nil];
        return;
    }
    HomePostCommentController* commentVC = [[HomePostCommentController alloc]init];
    commentVC.title = @"聊聊你对市场的看法" ;
    commentVC.isRefre = ^(BOOL refresh){
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:commentVC animated:NO];
}
- (void)settingNavItem {
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithTitle:@"关注" style:UIBarButtonItemStylePlain target:self action:@selector(focusOn)];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} forState:UIControlStateNormal];
    [rightItem setTitlePositionAdjustment:UIOffsetMake(-6, 0) forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - 关注
-(void)focusOn
{
    if(![PZParamTool hasLogin]){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goLogin" object:nil];
        return;
    }
    RRFFocusController *desc = [[RRFFocusController alloc]init];
    desc.title = @"已关注";
    [self.navigationController pushViewController:desc animated:YES];
}
-(void)requestDataList:(UIView *)sender
{
    WEAKSELF
    BOOL reloadAll = NO ;
    NSMutableArray *temp;
    self.indexPath = nil;
    if ([sender isKindOfClass:[MJRefreshHeader class]]) {
        reloadAll = YES ;
    }
    if ([sender isKindOfClass:[NSNotification class]]) {
        reloadAll = YES ;
    }
    if (reloadAll) {
        self.pageNo = 0;
        temp = [[NSMutableArray alloc]init];
    }
    else{
        temp = [NSMutableArray arrayWithArray:self.allData];
    }
    // 请求所有评论列表
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:@(self.pageNo) forKey:@"pageNo"];
    [param setObject:@(8) forKey:@"size"];
    [param setObject:@"all" forKey:@"commentType"];
    [HomeTool getCommentListWithParam:param successBlock:^(id json) {
        BOOL last = [[json objectForKey:@"last"] boolValue];
        NSArray *dataArray = [json objectForKey:@"content"];
        for (NSDictionary *dic in dataArray) {
            RRFCommentsCellModel *model = [RRFCommentsCellModel yy_modelWithJSON:dic];
            [temp addObject:model];
        }
        weakSelf.allData = temp ;
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if(temp.count == 0){
            [weakSelf settingNoDataView];
        }else{
            [weakSelf.tableView setTableFooterView:[UIView new]];
        }
        weakSelf.pageNo ++;
        if (last) {
            weakSelf.tableView.mj_footer.hidden = YES;
        }else{
            [weakSelf.tableView.mj_footer setHidden:NO];
        }
        [weakSelf reloadTableView];
    } fail:^(id json) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.tableView.mj_footer.hidden = YES;
        [weakSelf.tableView setTableFooterView:weakSelf.failFootView];
    }];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"RRFCommentController";
    RRFCommentsCellModel *model = _allData[indexPath.row];
    model.indexPath = indexPath;
    RRFCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil){
        cell = [[RRFCommentsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.model = model;
    [cell hiddenPopMenu];
    [self tableViewCellClick:cell IndexPath:indexPath];
    return cell;
    
}
-(void)tableViewCellClick:(id)sender IndexPath:(NSIndexPath*)indexPath
{
    WEAKSELF
    if ([sender isKindOfClass:[RRFCommentsCell class]]) {
        
        __block RRFCommentsCell *cell = (RRFCommentsCell*)sender;
        RRFCommentsCellModel *model = _allData[indexPath.row];
        cell.menuClickedOperation = ^(NSNumber* typeNum){
            NSInteger type = [typeNum integerValue];
            // 评论
            if (![PZParamTool hasLogin]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"goLogin" object:nil];
                return;
            }
            if (type == 1) {
                RRFReplyListController *desc = [[RRFReplyListController alloc]init];
                desc.commentId = model.ID;
                desc.commentName = model.userName;
                desc.title = @"全部回复";
                desc.viewType = RRFCommentDetailInfoTypeComment;
                [weakSelf.navigationController pushViewController:desc animated:YES];
            }else if(type == 2){
                // 打赏
                [weakSelf pushRewardControllerWithUserId:model.userId entityId:model.ID entityType:@"comment" IndexPath:indexPath];
            }else{
                // 点赞
                __block NSString *isPraise = model.isPraise;
                NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
                [param setObject:@(model.ID) forKey:@"commentId"];
                [PZParamTool agreedToWithUrl:@"addPraise" param:param Success:^(id json) {
                    [weakSelf refreCellWithIndexPath:indexPath BeforeStatus:isPraise];
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
                [weakSelf deletedCommentWithId:model.ID indexPath:indexPath];
            }];
            [alertView addAction:yseAction];
            [alertView addAction:cancelAction];
            [weakSelf presentViewController:alertView animated:YES completion:^{}];
        };
        cell.goUserProfile = ^(){
            if (![PZParamTool hasLogin]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"goLogin" object:nil];
                return;
            }
            RRFDetailInfoController *desc = [[RRFDetailInfoController alloc]init];
            desc.title = @"详细资料";
            desc.userId = model.userId;
            desc.verityInfo = NO;
            desc.detailInfoComeInType =  RRFDetailInfoComeInTypeOther;
            [weakSelf.navigationController pushViewController:desc animated:YES];
        };
    }
    
}

-(void)refreCellWithIndexPath:(NSIndexPath*)indexPath BeforeStatus:(NSString *)beforeStatus
{
    RRFCommentsCellModel *model = _allData[indexPath.row];
    NSString *afterStatus;
    int amount ;
    if ([beforeStatus isEqualToString:@"alreadyPraise"]) {
        afterStatus = @"noPraise";
        amount = model.praiseAmount - 1;
    }else{
        afterStatus = @"alreadyPraise";
        amount = model.praiseAmount + 1;
    }
    model.isPraise = afterStatus;
    model.praiseAmount = amount;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    });
}
-(void)deletedCommentWithId:(NSInteger)ID indexPath:(NSIndexPath*)indexPath
{
    WEAKSELF
    if (![PZParamTool hasLogin]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goLogin" object:nil];
        return;
    }
    [RRFPuzzleBarTool deleteCommentWithEntityWithUrl:@"deleteComment" Type:@"comment" entityId:ID Success:^(id json) {
        [weakSelf.allData removeObjectAtIndex:indexPath.row];
        [weakSelf.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } failBlock:^(id json) {
        
    }];
}

-(void)reloadTableView{
    WEAKSELF
    if (self.indexPath != nil) {
        [self.tableView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadRowsAtIndexPaths:@[weakSelf.indexPath] withRowAnimation:UITableViewRowAnimationNone];
            weakSelf.indexPath = nil ;
        });
    }
    else{
        [self.tableView reloadData];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[NSNotificationCenter defaultCenter]postNotificationName:kTimeLineCellOperationButtonClickedNotification object:nil];
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![PZParamTool hasLogin]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goLogin" object:nil];
        return;
    }
    self.indexPath = indexPath ;
    RRFCommentsCellModel *model = _allData[indexPath.row];
    RRFReplyListController *desc = [[RRFReplyListController alloc]init];
    desc.commentId = model.ID;
    desc.commentName = model.userName;
    desc.title = @"全部回复";
    desc.viewType = RRFCommentDetailInfoTypeComment;
    [self.navigationController pushViewController:desc animated:YES];
}
-(void)settingNoDataView
{
    NSString *titleStr = @"暂时没有评论!";
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-50-64-50)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, (SCREENHeight-50-64-50)/2, SCREENWidth-30, 50)];
    titleLabel.text = titleStr;
    titleLabel.numberOfLines=2;
    titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:titleLabel];
    self.tableView.tableFooterView = footerView;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSInteger unReadMsgCount = [NotificateMsgUtil unReadMsgCount];
    if (unReadMsgCount>0) {
        NSArray *modelList = [NotificateMsgUtil  loadMsgUnRead];
        RRFMessageNoticeListModel *model = [modelList firstObject] ;
        NSString *headStr = model.iconUrl;
        [self settingNoticeViewWithCount:unReadMsgCount HeadStr:headStr];
    }else{
        [self.tableView setTableHeaderView:nil];
    }
//    self.tableView.contentOffset = self.currentOffset ;
}


//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    self.currentOffset = self.tableView.contentOffset ;
//}

@end
