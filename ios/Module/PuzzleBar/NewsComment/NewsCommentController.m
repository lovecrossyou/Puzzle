//
//  NewsCommentController.m
//  Puzzle
//
//  Created by huibei on 16/12/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "NewsCommentController.h"
#import "StackTableViewCell.h"
#import "STInputBar.h"
#import "NewsHttpTool.h"
#import "NewsCommentModel.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "MJRefresh.h"
#import "PZCache.h"
#import "PZParamTool.h"
#import "RRFCommentDetailCell.h"
#import "RRFCommentContentListModel.h"
#import "RRFDetailInfoController.h"
#import "RRFPuzzleBarTool.h"
#import "RRFRespToRespListModel.h"

@interface NewsCommentController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) NSMutableArray* dataSource;
@property (nonatomic, strong) NSMutableArray* dataModels;

@property(weak,nonatomic)STInputBar* inputBar  ;
@property(weak,nonatomic)UITableView* tableView  ;
@property(assign,nonatomic) NSInteger CommentResponseId ;
@property(assign,nonatomic) int pageNo ;
@property(strong,nonatomic) NSIndexPath* indexPath ;
@property(nonatomic,strong)RRFCommentContentListModel *currentModel;
@property(nonatomic,strong)NSIndexPath *selectedIndexPath;
@property(nonatomic,assign)ReplyType replyType;
@property(nonatomic,assign)NSInteger responseId;
@end

@implementation NewsCommentController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF
    self.view.backgroundColor = [UIColor grayColor];
    self.edgesForExtendedLayout = UIRectEdgeTop;
    UITableView* tableView = [[UITableView alloc]init];
    self.dataSource = [NSMutableArray array];
    self.dataModels = [NSMutableArray array];
    tableView.tableFooterView = [UIView new];
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 200.0;
    self.tableView = tableView ;
    [self.view addSubview:tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-44);
    }];
    
    self.tableView.delegate = self ;
    self.tableView.dataSource =self ;
    [self.tableView registerClass:[StackTableViewCell class] forCellReuseIdentifier:@"StackTableViewCell"];
    
    STInputBar *inputBar = [STInputBar inputBar];
    [inputBar setFitWhenKeyboardShowOrHide:YES];
    inputBar.floatBottom = YES ;
    inputBar.commonMode = NO ;
    [inputBar setDidSendClicked:^(NSString *text) {
        if (![PZParamTool hasLogin]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"goLogin" object:nil];
            return;
        }
        LoginModel* user = [PZParamTool currentUser];
        NSString* userName = user.cnName ;
        if (userName == nil) {
            userName = user.phone_num;
        }
        if (weakSelf.CommentResponseId != 0) {
            [NewsHttpTool postCommentRespWithId:weakSelf.CommentResponseId content:text successBlock:^(id json) {
                [weakSelf.inputBar resignFirstResponder];
                weakSelf.CommentResponseId = 0 ;
                weakSelf.pageNo = 0 ;
                [weakSelf.dataModels removeAllObjects];
                [weakSelf.dataSource removeAllObjects];
                [weakSelf loadDataSource];
            } fail:^(id json) {
                
            }];
        }
        else{
            [NewsHttpTool postCommentWithId:weakSelf.commentId content:text successBlock:^(id json) {
                [MBProgressHUD dismiss];
                [weakSelf.inputBar resignFirstResponder];
                NewsCommentModel* model = [[NewsCommentModel alloc]init];
                model.responseModels = @[];
                model.content = text ;
                model.userName = userName ;
                NSString* commenterSource = [weakSelf getCommentSource];
                model.commenterSource = commenterSource ;
                NSMutableArray *tempM = [NSMutableArray arrayWithArray:self.dataModels];
                NSMutableArray *temp = [NSMutableArray arrayWithArray:self.dataSource];

                [tempM insertObject:model atIndex:0];
                [temp insertObject:@[text] atIndex:0];
                weakSelf.dataModels = tempM ;
                weakSelf.dataSource = temp ;
                [weakSelf.tableView reloadData];
            } fail:^(id json) {
                [MBProgressHUD dismiss];
            }];
        }
    }];
    
    inputBar.placeHolder =[NSString stringWithFormat:@"说点什么吧"];
    [inputBar hiddenPhoto];
    self.inputBar = inputBar;
    [self.view addSubview:inputBar];
    [inputBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    
    MJRefreshAutoNormalFooter *tabfooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadDataSource)];
    tabfooter.triggerAutomaticallyRefreshPercent = 1;
    tabfooter.automaticallyRefresh = YES;
    tabfooter.stateLabel.textColor = HBColor(135, 135, 135);
    self.tableView.mj_footer = tabfooter;
    [tabfooter beginRefreshing];
}

-(NSString*)getCommentSource{
    NSString* phoneModel = [PZCache sharedInstance].phoneType ;
    NSDictionary* addrInfo = [PZCache sharedInstance].addrInfo ;
    if (addrInfo != nil) {
        NSString* city = addrInfo[@"city"] ;
        NSString* county = addrInfo[@"county"] ;
        return [NSString stringWithFormat:@"%@%@ %@",city,county,phoneModel];
    }
    return [NSString stringWithFormat:@"火星网友 %@",phoneModel];
}

- (void)loadDataSource {
    WEAKSELF
    NSMutableArray* tempDataSource = [NSMutableArray arrayWithArray:self.dataSource];
    NSMutableArray* tempDataModels = [NSMutableArray arrayWithArray:self.dataModels];
    [NewsHttpTool getNewsCommentListListWithPageNo:self.pageNo pageSize:10 commentId:self.commentId successBlock:^(id json) {
        NewsCommentListModel* listM = [NewsCommentListModel yy_modelWithJSON:json];
        for (NewsCommentModel* model in listM.content) {
            NSMutableArray* respModels = [NSMutableArray array];
            for (NewsCommentResponseModels* m in model.responseModels) {
                [respModels addObject:m.respContent];
            }
            [tempDataModels addObject:model];
            [respModels addObject:model.content];
            [tempDataSource addObject:respModels];
        }
        [weakSelf.tableView.mj_footer endRefreshing];
        if (listM.last) {
            [weakSelf.tableView.mj_footer setHidden:YES];
        }
        weakSelf.dataModels = tempDataModels ;
        weakSelf.dataSource = tempDataSource ;
        weakSelf.tableView.emptyDataSetSource = weakSelf ;
        weakSelf.tableView.emptyDataSetDelegate = weakSelf ;
        weakSelf.pageNo++;
        [weakSelf.tableView reloadData];
    } fail:^(id json) {
        
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.inputBar resignFirstResponder];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF
    NSString *cellId = @"NewsCommentController";
    
    RRFCommentContentListModel *model = [self switchModelWithIndexPath:indexPath];
    RRFCommentDetailCell *cell = [[RRFCommentDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    cell.contentListM = model;
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
            weakSelf.indexPath = indexPath ;
            weakSelf.CommentResponseId = model.responseId ;
            [weakSelf.inputBar assignResponder];
            
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
-(RRFCommentContentListModel *)switchModelWithIndexPath:(NSIndexPath *)indexPath
{
    NewsCommentModel* model = self.dataModels[indexPath.row];
    RRFCommentContentListModel *commentM = [[RRFCommentContentListModel alloc]init];
    commentM.time = model.time;
    commentM.sex = model.sex;
    commentM.respCommentContent = model.content;
    commentM.isSelfResponse = model.isSelfComment;
    commentM.respCommentUserName = model.userName;
    commentM.respCommentUserIconUrl = model.userIconUrl;
    commentM.respCommentUserId = model.userId;
    commentM.responseId = model.ID;
    NSArray *responseModels = model.responseModels;
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    for (int i = 0; i < responseModels.count; i++) {
        NewsCommentResponseModels *responseModel = responseModels[i];
        RRFRespToRespListModel *respToRespListM = [[RRFRespToRespListModel alloc]init];
        respToRespListM.noStr = [NSString stringWithFormat:@"%d",i + 1];
        respToRespListM.respTorespUserName = responseModel.fromUserName;
        respToRespListM.respTorespContent = responseModel.respContent;
        [temp addObject:respToRespListM];
    }
    commentM.respToRespList = temp ;
//    commentM.respCommentPraiseAmount = model.fassAmount;
    return commentM;
}

-(void)deletedCommentWithId:(NSInteger)ID  indexPath:(NSIndexPath*)indexPath
{
//    WEAKSELF
//    NSString *url;
//    NSString *type;
//    if (self.viewType == RRFCommentDetailInfoTypeFriendCircle) {
//        url = @"client/friendCircle/deleteDynamicAction";
//        type = @"dynamicActionResponse";
//    }else{
//        url= @"deleteComment";
//        type = @"response";
//    }
//    [RRFPuzzleBarTool deleteCommentWithEntityWithUrl:url Type:type entityId:ID Success:^(id json) {
//        [_allData removeObjectAtIndex:indexPath.row];
//        [weakSelf.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        [weakSelf.tableView reloadData];
//        if (self.viewType == RRFCommentDetailInfoTypeFriendCircle) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:RRFDynamicRefre object:nil];
//            [[NSNotificationCenter defaultCenter] postNotificationName:RRFFriendCircleRefre object:nil];
//        }else{
//            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshCommentTableView object:nil];
//            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshPersonalAskBarTableView object:nil];
//            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshRRFHomePageTableView object:nil];
//            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFMViewController object:nil];
//        }
//    } failBlock:^(id json) {
//        
//    }];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor whiteColor];
    headView.frame = CGRectMake(0, 0, SCREENWidth, 44);
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = [NSString stringWithFormat:@"全部回复(%lu)",(unsigned long)self.dataModels.count];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.indexPath = indexPath ;
    NewsCommentModel* model = self.dataModels[indexPath.row];
    self.CommentResponseId = model.ID ;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.inputBar assignResponder];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"来，抢个沙发";
    
    NSDictionary *attributes = @{NSFontAttributeName: PZFont(13.0f),
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}



@end
