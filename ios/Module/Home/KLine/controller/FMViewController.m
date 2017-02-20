//
//  FMViewController.m
//  Kline
//
//  Created by zhaomingxi on 14-2-9.
//  Copyright (c) 2014年 zhaomingxi. All rights reserved.
//

#import "FMViewController.h"
#import "lineView.h"
#import "UIColor+helper.h"
#import "EChatHeadView.h"
#import "ChartCommentCell.h"
#import "EChatFooter.h"
#import "GuessPageController.h"
#import "HomePostCommentController.h"
#import "GameModel.h"
#import "HomeTool.h"
#import "YYModel.h"
#import "CommentListModel.h"
#import "RRFCommentsCellModel.h"
#import "RRFRewardController.h"
#import "RRFPuzzleBarTool.h"
#import "HomePostCommentController.h"
#import "RRFReplyListController.h"
#import "PZParamTool.h"
#import "StockDetailModel.h"
#import "JustNowWithStockListModel.h"
#import "RRFCommentsCell.h"
#import "MJRefresh.h"
#import "RRFReplyListController.h"
#import "RRFPersonalAskBarController.h"
#import "HBLoadingView.h"
#import "StockDetailModel.h"
#import "RRFDetailInfoController.h"
@interface FMViewSectionView()
@property(weak,nonatomic)UILabel* titleLabel ;

@end


@implementation FMViewSectionView
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel* titleLabel = [[UILabel alloc]init];
        [titleLabel sizeToFit];
        titleLabel.text = @"评论" ;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        self.titleLabel = titleLabel ;
        
//        UISegmentedControl* segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"最新",@"最热"]];
//        [self addSubview:segmentControl];
//        [segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(titleLabel.mas_right).offset(12);
//            make.size.mas_equalTo(CGSizeMake(90, 28));
//            make.centerY.mas_equalTo(self.mas_centerY);
//        }];
//        segmentControl.selectedSegmentIndex = 0 ;
        
        UIView* sepLabel = [[UIView alloc]init];
        sepLabel.backgroundColor = [UIColor colorR:243 colorG:243 colorB:243];
        [self addSubview:sepLabel];
        [sepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        
    }
    return self ;
}

-(void)setStockDetailM:(StockDetailModel *)stockDetailM{
    if (stockDetailM.commentAmount > 0) {
        self.titleLabel.text = [NSString stringWithFormat:@"评论 %d",stockDetailM.commentAmount] ;
    }
    else{
        self.titleLabel.text = @"评论" ;
    }
}

@end



@interface FMViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    lineView *lineview;
    UIButton *btnDay;
    UIButton *btnWeek;
    UIButton *btnMonth;
}

@property(strong,nonatomic)CommentListModel* comList ;

@property(weak,nonatomic) UITableView* tableView ;

@property(strong,nonatomic) NSTimer* timer60 ;
@property(weak,nonatomic)EChatHeadView* headView ;
@property(strong,nonatomic)StockDetailModel* m ;


@property(strong,nonatomic) NSMutableArray* commentlist ;
@property(assign,nonatomic) NSInteger pageNo ;
@property(assign,nonatomic) NSInteger pageSize ;
@property(assign,nonatomic) BOOL resetData ;

@property(strong,nonatomic)NSIndexPath* indexPath ;
@end

@implementation FMViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    WEAKSELF
    self.pageNo = 0 ;
    self.pageSize = 15 ;
    
    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self ;
    tableView.dataSource = self ;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-66);
    }];
    self.tableView = tableView ;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 68.0;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[RRFCommentsCell class] forCellReuseIdentifier:@"FMViewController"];
    
    MJRefreshAutoNormalFooter *tabfooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestCommentList:)];
    tabfooter.triggerAutomaticallyRefreshPercent = 1;
    tabfooter.automaticallyRefresh = YES;
    tabfooter.stateLabel.textColor = HBColor(135, 135, 135);
    self.tableView.mj_footer = tabfooter;

    // 右上角
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_edit"] style:UIBarButtonItemStylePlain target:self action:@selector(editClick)];
    self.navigationItem.rightBarButtonItem = rightItem ;
    
    [self requestDetailStockWithCompleteBlock:^(id json) {
        [weakSelf createHeadViewWithStockDetailModel:json];
        [weakSelf createFooter];
        [HBLoadingView hide];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestCommentList:) name:RefreshFMViewController object:nil];
    [HBLoadingView showCircleView:self.view];
}

-(void)hide{
    [HBLoadingView hide];    
}

-(NSMutableArray *)commentlist{
    if (_commentlist == nil) {
        _commentlist = [NSMutableArray array];
    }
    return _commentlist ;
}


-(void)createFooter{
    WEAKSELF
    EChatFooter* footer = [[EChatFooter alloc]init];
    [self.view addSubview:footer];
    footer.itemClick = ^(NSNumber* isUp){
        GuessPageController* guessPage = [[GuessPageController alloc]init];
        guessPage.indexM = weakSelf.indexM ;
        guessPage.title = @"投注" ;
        guessPage.guessType = [isUp boolValue]== YES ? 0 : 1 ;
        [weakSelf.navigationController pushViewController:guessPage animated:YES];
    };
    [footer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(66);
    }];
}


-(void)requestCommentList:(UIView *)sender{
    WEAKSELF
    NSMutableArray* allDatas ;
    self.indexPath = nil;
    if ([sender isKindOfClass:[NSNotification class]]) {
        self.pageNo = 0 ;
        allDatas = [NSMutableArray array];
    }
    if ([sender isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        if (self.resetData) {
            self.pageNo = 0 ;
            allDatas = [NSMutableArray array];
        }
        else{
            allDatas = [NSMutableArray arrayWithArray:self.commentlist];
        }
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:@(self.indexM.stockGameId) forKey:@"commentTypeId"];
    [param setObject:@(self.pageNo) forKey:@"pageNo"];
    [param setObject:@(self.pageSize) forKey:@"size"];
    [param setObject:@"stockGame" forKey:@"commentType"];
    [HomeTool getCommentListWithParam:param successBlock:^(id json) {
        CommentListModel* comList = [CommentListModel yy_modelWithJSON:json];
        NSArray* datas = comList.content ;
        if (datas != nil) {
            [allDatas addObjectsFromArray:datas];
        }
        weakSelf.commentlist = allDatas ;
        [weakSelf reloadTableView];
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.pageNo ++ ;
        if (comList.last) {
            [weakSelf.tableView.mj_footer setHidden:YES];
        }
    } fail:^(id json) {
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}


-(void)requestDetailStockWithCompleteBlock:(PZRequestSuccess)complete{
    WEAKSELF
    [HomeTool getStockGameDetailWithStockId:self.indexM.stockGameId successBlock:^(id json) {
        StockDetailModel* m = [StockDetailModel yy_modelWithJSON:json];
        weakSelf.m = m ;
        complete(m);
    } fail:^(id json) {
        
    }];
}

-(void)updateStockData{
    WEAKSELF
    [self requestDetailStockWithCompleteBlock:^(id json) {
        [weakSelf.headView updateStock:self.m];
    }];
    [self.tableView.mj_footer beginRefreshing];
}

-(void)createHeadViewWithStockDetailModel:(StockDetailModel*)m{
    EChatHeadView* headView = [[EChatHeadView alloc]initWithModel:m];
    headView.frame = CGRectMake(0, 0, SCREENWidth, 420 + 120+80+20 - 144 + 48);
    self.tableView.tableHeaderView  = headView ;
    self.headView = headView ;
}

#pragma mark - 写评论
-(void)editClick{
    HomePostCommentController* postCom = [[HomePostCommentController alloc]init];
    self.resetData = YES ;
    postCom.indexM = self.indexM ;
    [self.navigationController pushViewController:postCom animated:YES];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentlist.count ;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45.0f ;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    FMViewSectionView* sectionView = [[FMViewSectionView alloc]init];
    sectionView.stockDetailM = self.m ;
    return sectionView ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RRFCommentsCellModel* commentM = self.commentlist[indexPath.row];
    RRFCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FMViewController"];
    if(cell == nil){
        cell = [[RRFCommentsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FMViewController"];
    }
    [self tableViewCellClick:cell IndexPath:indexPath];
    cell.model = commentM;
    return cell;

}
-(void)tableViewCellClick:(id)sender IndexPath:(NSIndexPath*)indexPath
{
    WEAKSELF
    if ([sender isKindOfClass:[RRFCommentsCell class]]) {
        RRFCommentsCell *cell = (RRFCommentsCell*)sender;
        RRFCommentsCellModel *model = self.commentlist[indexPath.row];
        cell.commentsCellClick = ^(NSInteger type){
            if (type == 0) {
                // 评论列表
                RRFReplyListController *desc = [[RRFReplyListController alloc]init];
                desc.viewType = RRFCommentDetailInfoTypeComment;
                desc.commentId = model.ID;
                desc.commentName = model.userName;
                desc.title = @"全部回复";
                [weakSelf.navigationController pushViewController:desc animated:YES];
            }else if(type == 1){
                // 打赏
                [weakSelf pushRewardControllerWithUserId:model.userId entityId:model.ID entityType:@"comment"];
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
    RRFCommentsCellModel* model = self.commentlist[indexPath.row];
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
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[NSNotificationCenter defaultCenter]postNotificationName:kTimeLineCellOperationButtonClickedNotification object:nil];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.indexPath = indexPath ;
    RRFCommentsCellModel *model = self.commentlist[indexPath.row];
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
        [weakSelf.commentlist removeObjectAtIndex:indexPath.row];
        [weakSelf.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [weakSelf reloadTableView];
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


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    开启定时器
    self.timer60 = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateStockData) userInfo:nil repeats:YES];
    [self.timer60 setFireDate:[NSDate distantPast]];
}


//页面消失，进入后台不显示该页面，关闭定时器
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //关闭定时器
    [self.timer60 invalidate];
    self.timer60 = nil ;
}

@end
