//
//  RRFPersonalAskBarController.m
//  Puzzle
//
//  Created by huibei on 16/8/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//
#import "RRFPersonalAskBarController.h"
#import "QuestionBarListModel.h"
#import "MJRefresh.h"
#import "HomeTool.h"
#import "RRFCommentsCellModel.h"
#import "RRFProblemCell.h"
#import "RRFReplyListController.h"
#import "RRFRewardController.h"
#import "RRFPuzzleBarTool.h"
#import "RRFWenBarCellModel.h"
#import "UIImage+Image.h"

#import "RRFPuzzleBarView.h"
#import "PZParamTool.h"
#import "RRFPuzzleBarTool.h"
#import "TPKeyboardAvoidingTableView.h"
#import "MJRefresh.h"
#import "RRFMeTool.h"
#import "RRFQuestionBarMsgModel.h"
#import "RRFReplyListController.h"
#import "InsetsLabel.h"
#import "JNQPersonalHomepageViewController.h"
#import "HBLoadingView.h"
#import "RRFPersonalHomePageCell.h"
#import "RRFDetailInfoController.h"
#import "JNQFailFooterView.h"
#import "HBLoadingView.h"
#import "RRFExceptionalListController.h"
#import "RRFPersonalHomePageView.h"

@interface RRFPersonalAskBarController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,assign)TabelTViewType viewType;
@property(nonatomic,weak)RRFEditorTextView *editView;
@property(nonatomic,strong)RRFQuestionBarMsgModel *infoModel ;
@property(nonatomic,weak)RRFPersonalHomePageView *headView;
@property(nonatomic,assign)int pageNo;
@property(nonatomic,strong)NSMutableArray *allData ;
@property(nonatomic,assign)CGFloat tableViewHeight;
@property(nonatomic,assign)CGPoint currentOffset;
@property(nonatomic,strong)JNQFailFooterView *failFootView;

@end

@implementation RRFPersonalAskBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF
    self.tableView.delegate = self ;
    self.tableView.dataSource =self ;
    self.view.backgroundColor = [UIColor whiteColor];
    self.pageNo = 0;
    self.viewType = CommentsTableView;
    if (self.allData == nil) {
        self.allData = [[NSMutableArray alloc]init];
    }
    if (self.failFootView == nil) {
        self.failFootView = [[JNQFailFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64)];
        self.failFootView.reloadBlock = ^(){
            [weakSelf requestInfo];
        };
    }
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 120;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[RRFPersonalHomePageCell class] forCellReuseIdentifier:@"RRFPersonalAskBarController"];
    
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
    [self requestInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestDataList:) name:RefreshPersonalAskBarTableView object:nil];
}



-(void)requestInfo
{
    WEAKSELF
    [HBLoadingView showCircleView:self.view];
    [RRFMeTool getQuestionBarMsgWithUserId:self.userId Success:^(id json) {
        [HBLoadingView hide];
        RRFQuestionBarMsgModel *model = [RRFQuestionBarMsgModel yy_modelWithJSON:json];
        weakSelf.infoModel = model;
        [weakSelf settingHeadViewWithModel:model];
        [self.tableView.mj_footer beginRefreshing];
    } failBlock:^(id json) {
        [weakSelf.tableView setTableFooterView:weakSelf.failFootView];
    }];
}
- (void)settingHeadViewWithModel:(RRFQuestionBarMsgModel *)model {
    RRFPersonalHomePageView *headView = [[RRFPersonalHomePageView alloc]init];
    headView.type = @"RRFPersonalAskBarController";
    model.isFanning = NO;
    headView.userM = model;
    CGFloat height = [headView HeadViewHeightWithModel:model];
    headView.frame = CGRectMake(0, 0, SCREENWidth, height);
    self.headView = headView;
    self.tableView.tableHeaderView = headView;
    [headView.fanningBtn addTarget:self action:@selector(fanning:) forControlEvents:UIControlEventTouchUpInside];
    [[headView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        RRFDetailInfoController *desc = [[RRFDetailInfoController alloc]init];
        desc.userId = model.userId;
        desc.title = @"详细资料";
        desc.detailInfoComeInType = RRFDetailInfoComeInTypeOther;
        [self.navigationController pushViewController:desc animated:YES];
    }];
}
-(void)fanning:(UIButton *)btn
{
    BOOL selected = btn.selected;
    btn.selected = !selected;
    if (btn.selected == NO) {
        self.infoModel.isFanning = NO;
    }else{
        self.infoModel.isFanning = YES;
    }
    CGFloat height = [self.headView HeadViewHeightWithModel:self.infoModel];
    self.headView.frame = CGRectMake(0, 0, SCREENWidth, height);
    [self.tableView reloadData];
}
-(void)requestDataList:(UIView *)sender
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
        [self requestInfo];
    }
    if (refreAll) {
        self.pageNo = 0;
        temp = [[NSMutableArray alloc]init];
    }else{
        temp = [NSMutableArray arrayWithArray:self.allData];
    }
    // 请求所有评论列表
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:@(self.pageNo) forKey:@"pageNo"];
    [param setObject:@(20) forKey:@"size"];
    [param setObject:@(self.userId) forKey:@"commentTypeId"];
    [param setObject:@"userSelf" forKey:@"commentType"];
    [HomeTool getCommentListWithParam:param successBlock:^(id json) {
        BOOL last = [[json objectForKey:@"last"] boolValue];
        NSArray *dataArray = [json objectForKey:@"content"];
        for (NSDictionary *dic in dataArray) {
            RRFCommentsCellModel *model = [RRFCommentsCellModel yy_modelWithJSON:dic];
            [temp addObject:model];
        }
        weakSelf.allData = temp;
        if (weakSelf.allData.count == 0) {
            [weakSelf settingNoDataView];
        }else{
            [weakSelf.tableView setTableFooterView:[UIView new]];
        }
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView reloadData];
        weakSelf.pageNo ++;
        if (last) {
            [weakSelf.tableView.mj_footer setHidden:YES];
        }
    } fail:^(id json) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_footer setHidden:YES];
    }];
}
-(void)settingNoDataView
{
    NSString *titleStr = @"您还没有发表过任何动态哦!";
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWidth, 60)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 30, SCREENWidth-30, 30)];
    titleLabel.text = titleStr;
    titleLabel.numberOfLines=2;
    titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:titleLabel];
    self.tableView.tableFooterView = footerView;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"RRFPersonalAskBarController";
    RRFCommentsCellModel *model = self.allData[indexPath.row];
    RRFPersonalHomePageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil){
        cell = [[RRFPersonalHomePageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    [self tableViewCellClick:cell IndexPath:indexPath];
    cell.model = model;
    cell.cellType = [model.isSelfComment isEqualToString:@"self"]?RRFPersonalHomePageCellTypeTypeSelf:DelegaterListControllerViewTypeOther;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RRFCommentsCellModel *model = _allData[indexPath.row];
    RRFReplyListController *desc = [[RRFReplyListController alloc]init];
    desc.commentId = model.ID;
    desc.commentName = model.userName;
    desc.title = @"全部回复";
    desc.viewType = RRFCommentDetailInfoTypeComment;
    [self.navigationController pushViewController:desc animated:YES];
 
}
-(void)tableViewCellClick:(id)sender IndexPath:(NSIndexPath*)indexPath
{
    WEAKSELF
    if ([sender isKindOfClass:[RRFPersonalHomePageCell class]]) {
        RRFPersonalHomePageCell *cell = (RRFPersonalHomePageCell*)sender;
        RRFCommentsCellModel *model = self.allData[indexPath.row];
        cell.cellClick = ^(NSNumber *tage){
            int type = [tage intValue];
            if (type == 0) {// 评论
                // 评论列表
                RRFReplyListController *desc = [[RRFReplyListController alloc]init];
                desc.commentId = model.ID;
                desc.commentName = model.userName;
                desc.title = @"全部回复";
                desc.viewType = RRFCommentDetailInfoTypeComment;
                [weakSelf.navigationController pushViewController:desc animated:YES];
            }else if(type == 1){
                [weakSelf listWithTitle:@"点赞" type:CommentCellClickTypePraise commentId:model.ID];
            }else if(type == 2){//  打赏
                if ([model.isSelfComment isEqualToString:@"self"]) {
                    [weakSelf listWithTitle:@"赞赏" type:CommentCellClickTypeReward commentId:model.ID];
                }else{
                    [weakSelf pushRewardControllerWithUserId:model.userId entityId:model.ID entityType:@"comment"];
                }
            }else if(type == 3){
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
    }
    
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
-(void)deletedCommentWithId:(NSInteger)ID indexPath:(NSIndexPath*)indexPath
{
    WEAKSELF
    [RRFPuzzleBarTool deleteCommentWithEntityWithUrl:@"deleteComment" Type:@"comment" entityId:ID Success:^(id json) {
        [weakSelf.allData removeObjectAtIndex:indexPath.row];
        [weakSelf.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [weakSelf.tableView reloadData];
    } failBlock:^(id json) {
        
    }];
}

-(void)listWithTitle:(NSString *)title type:(CommentCellClickType)type commentId:(NSInteger)commentId
{
    RRFExceptionalListController *desc = [[RRFExceptionalListController alloc]init];
    desc.title = title;
    desc.type = type;
    desc.entityType = @"comment" ;
    desc.ID = commentId ;
    desc.comeInType = PraiseListTypeComment;
    [self.navigationController pushViewController:desc animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.contentOffset = self.currentOffset;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.currentOffset = self.tableView.contentOffset;
}
@end
