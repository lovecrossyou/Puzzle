//
//  RRFPersonalHomePageController.m
//  Puzzle
//
//  Created by huibei on 16/9/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFPersonalHomePageController.h"
#import "RRFPersonalHomePageView.h"
#import "RRFMeTool.h"
#import "RRFQuestionBarMsgModel.h"
#import "MJRefresh.h"
#import "RRFWenBarCellModel.h"
#import "RRFProblemCell.h"
#import "RRFattestationController.h"
#import "HomeTool.h"
#import "RRFCommentsCellModel.h"
#import "RRFPersonalHomePageCell.h"
#import "RRFReplyListController.h"
#import "RRFExceptionalListController.h"
#import "RRFPuzzleBarTool.h"
#import "RRFMessageNoticeListController.h"
#import "InsetsLabel.h"
#import "JNQFailFooterView.h"
#import "RRFDetailInfoController.h"
#import "RRFReplyListController.h"
#import "HBLoadingView.h"
@interface RRFPersonalHomePageController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak)RRFPersonalHomePageView *headView;
@property(nonatomic,strong)RRFQuestionBarMsgModel *infoModel;
@property(nonatomic,strong)JNQFailFooterView *failFootView;
@property(nonatomic,assign)CGPoint currenOffset;
@property(nonatomic,strong)NSMutableArray *allSectionData;
@property(nonatomic,assign)int pageNo;

@end

@implementation RRFPersonalHomePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF
    self.tableView.dataSource = self ;
    self.tableView.delegate = self ;
    self.tableView.estimatedRowHeight = 120.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.pageNo = 0;
    if (self.allSectionData == nil) {
        self.allSectionData = [[NSMutableArray alloc]init];
    }
    if (self.failFootView == nil) {
        self.failFootView = [[JNQFailFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64)];
        self.failFootView.reloadBlock = ^(){
            [weakSelf requestInfo];
        };
    }
    self.tableView.tableHeaderView = [UIView new];

    MJRefreshNormalHeader *tabheader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestQuestionList:)];
    tabheader.lastUpdatedTimeLabel.hidden = YES;
    tabheader.stateLabel.textColor = HBColor(135, 135, 135);
    tabheader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.tableView.mj_header = tabheader;
    
    MJRefreshAutoNormalFooter *tabfooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestQuestionList:)];
    tabfooter.triggerAutomaticallyRefreshPercent = 1;
    tabfooter.automaticallyRefresh = YES;
    tabfooter.stateLabel.textColor = HBColor(135, 135, 135);
    self.tableView.mj_footer = tabfooter;
    [self settingNavItem];
    [self requestInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestQuestionList:) name:RefreshRRFHomePageTableView object:nil];
}


-(void)requestInfo
{
    [HBLoadingView showCircleView:self.view];
    [RRFMeTool getQuestionBarMsgWithUserId:0 Success:^(id json) {
        [HBLoadingView hide];
        RRFQuestionBarMsgModel *model = [RRFQuestionBarMsgModel yy_modelWithJSON:json];
        self.infoModel = model;
        [self settingHeadViewWithModel:model];
        [self.tableView.mj_footer beginRefreshing];
    } failBlock:^(id json) {
        [HBLoadingView hide];
        [self.tableView setTableFooterView:self.failFootView];
    }];
}

- (void)settingHeadViewWithModel:(RRFQuestionBarMsgModel *)model {
    RRFPersonalHomePageView *headView = [[RRFPersonalHomePageView alloc]init];
    model.isFanning = NO;
    headView.type = @"RRFPersonalHomePageController";
    headView.userM = model;
    CGFloat height = [headView HeadViewHeightWithModel:model];
    headView.frame = CGRectMake(0, 0, SCREENWidth, height);
    self.headView = headView;
    self.tableView.tableHeaderView = headView;
    [headView.attestationBtn addTarget:self action:@selector(applicationReview) forControlEvents:UIControlEventTouchUpInside];
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
    [self.navigationController pushViewController:desc animated:YES];
}
#pragma mark - 招募
-(void)applicationReview
{
    RRFattestationController *desc = [[RRFattestationController alloc]init];
    desc.title = @"+V认证";
    [self.navigationController pushViewController:desc animated:YES];
}

-(void)requestQuestionList:(UIView *)sender
{
    WEAKSELF
    BOOL refre = NO;
    NSMutableArray *temp;
    if ([sender isKindOfClass:[MJRefreshHeader class]]) {
        refre = YES;
        self.currenOffset = CGPointZero;
    }
    if ([sender isKindOfClass:[NSNotification class]]) {
        refre = YES;
    }
    if (refre) {
        self.pageNo =0;
        temp = [[NSMutableArray alloc]init];
    }else{
        temp = [NSMutableArray arrayWithArray:self.allSectionData];
    }
    // 请求所有评论列表
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:@(self.pageNo) forKey:@"pageNo"];
    [param setObject:@(20) forKey:@"size"];
    [param setObject:@(0) forKey:@"commentTypeId"];
    [param setObject:@"userSelf" forKey:@"commentType"];
    [HomeTool getCommentListWithParam:param successBlock:^(id json) {
        BOOL last = [[json objectForKey:@"last"] boolValue];
        NSArray *dataArray = [json objectForKey:@"content"];
        for (NSDictionary *dic in dataArray) {
            RRFCommentsCellModel *model = [RRFCommentsCellModel yy_modelWithJSON:dic];
            [temp addObject:model];
        }
        self.allSectionData = temp;
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        if(self.allSectionData.count == 0){
            [weakSelf settingNoDataView];
        }else{
            [weakSelf.tableView setTableFooterView:[UIView new]];
        }
        [weakSelf.tableView reloadData];
        self.pageNo ++;
        if (last) {
            [weakSelf.tableView.mj_footer setHidden:YES];
        }else{
            [weakSelf.tableView.mj_footer setHidden:NO];
        }
        [MBProgressHUD dismiss];
    } fail:^(id json) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_footer setHidden:YES];
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return _allSectionData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"RRFPersonalHomePageController";
    RRFCommentsCellModel *model = _allSectionData[indexPath.row];
    RRFPersonalHomePageCell *cell =[[RRFPersonalHomePageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    [self tableViewCellClick:cell IndexPath:indexPath];
    cell.model = model;
    cell.cellType = RRFPersonalHomePageCellTypeTypeSelf;
    return cell;
}
-(void)tableViewCellClick:(id)sender IndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    if ([sender isKindOfClass:[RRFPersonalHomePageCell class]]) {
        RRFCommentsCellModel *model = _allSectionData[indexPath.row];
        RRFPersonalHomePageCell *cell = (RRFPersonalHomePageCell *)sender;
        cell.cellClick = ^(NSNumber *tage){
            int type = [tage intValue];
            if (type == 0) {
                // 评论
                RRFReplyListController *desc = [[RRFReplyListController alloc]init];
                desc.commentId = model.ID;
                desc.title = @"全部回复";
                desc.commentName = model.userName;
                desc.viewType = RRFCommentDetailInfoTypeComment;
                [weakSelf.navigationController pushViewController:desc animated:YES];
            }else if (type == 1){
                // 点赞
                [weakSelf listWithTitle:@"点赞" type:CommentCellClickTypePraise commentId:model.ID];
            }else if (type == 2){
                // 打赏
                [weakSelf listWithTitle:@"赞赏" type:CommentCellClickTypeReward commentId:model.ID];

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
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RRFCommentsCellModel *model = _allSectionData[indexPath.row];
    RRFReplyListController *desc = [[RRFReplyListController alloc]init];
    desc.commentId = model.ID;
    desc.commentName = model.userName;
    desc.title = @"全部回复";
    desc.viewType = RRFCommentDetailInfoTypeComment;
    [self.navigationController pushViewController:desc animated:YES];
}
-(void)deletedCommentWithId:(NSInteger)ID indexPath:(NSIndexPath*)indexPath
{
    WEAKSELF
    [RRFPuzzleBarTool deleteCommentWithEntityWithUrl:@"deleteComment" Type:@"comment" entityId:ID Success:^(id json) {
        [_allSectionData removeObjectAtIndex:indexPath.row];
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
-(void)settingNoDataView
{
    NSString *titleStr = @"您还有发表评论哦!";
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWidth, 100)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 50, SCREENWidth-30, 50)];
    titleLabel.text = titleStr;
    titleLabel.numberOfLines=2;
    titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:titleLabel];
    self.tableView.tableFooterView = footerView;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.currenOffset = self.tableView.contentOffset;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.contentOffset = self.currenOffset;
}
@end
