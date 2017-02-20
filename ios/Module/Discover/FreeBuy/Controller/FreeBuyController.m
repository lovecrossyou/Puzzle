//
//  FreeBuyController.m
//  Puzzle
//
//  Created by huibei on 16/12/9.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "FreeBuyController.h"
#import "JNQBookFBOrderViewController.h"
#import "JNQFBComContentPageController.h"
#import "FreeBuyHeader.h"
#import "FreeBuyCell.h"
#import "FBPublicListController.h"
#import "FBShareOrderController.h"
#import "PZWebController.h"
#import "FBTool.h"
#import "FBProductListModel.h"
#import "PurchaseGameActivity.h"
#import "PZWebController.h"
#import "FBActivityProductController.h"
#import "FBNewWinnerModel.h"
#import "HBLoadingView.h"
#import "MJRefresh.h"
#import "PZStateMenu.h"
#import "FBNewWinnerModel.h"
#import "RRFFreeBuyOrderViewController.h"
#import "PZParamTool.h"
@interface FreeBuyController ()<UITableViewDelegate,UITableViewDataSource,PZStateMenuDelegate>
@property(strong,nonatomic)PZStateMenu* sectionView ;
@property(weak,nonatomic)FreeBuyHeader* header ;
@property(strong,nonatomic) NSArray* productList ;
@property(strong,nonatomic) NSArray* menuTitles ;
// 人气
@property(nonatomic,assign)int popularity;
//价格排序
@property(nonatomic,assign)int price;
//进度条
@property(nonatomic,assign)int rateOfProgress;

@property(assign,nonatomic) int pageNo ;

//current menu index
@property(assign,nonatomic) NSInteger currentIndex ;


@property(assign,nonatomic) BOOL refreshData ;


@property(assign,nonatomic)CGPoint currentOffset ;

@property(weak,nonatomic)UITableView* tableView ;
@end

@implementation FreeBuyController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF
    self.popularity = 1;
    self.rateOfProgress = 1;
    self.price = 1;

    self.menuTitles = @[@"人气",@"进度",@"价格"];
    self.pageNo = 0 ;
    
    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.delegate = self ;
    tableView.dataSource = self ;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    self.tableView = tableView ;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    
    FreeBuyHeader* header = [[FreeBuyHeader alloc]init];
    self.header  = header ;
    //轮播图
    header.messageClickBlock = ^(FBNewWinnerModel* model){
        JNQFBComContentPageController *vc = [[JNQFBComContentPageController alloc] init];
        vc.fbPurchaseGameId = model.purchaseGameId;
        [self.navigationController pushViewController:vc animated:YES];
    };
    header.activityClickBlock = ^(PurchaseGameActivity* model){
        if ([model.type isEqualToString:@"link"]) {
            //新闻
            PZWebController* web = [[PZWebController alloc]init];
            web.pathUrl = model.link ;
            web.title = model.title ;
            [weakSelf.navigationController pushViewController:web animated:YES];
        }
        else if ([model.type isEqualToString:@"product"]){
            //促销商品
            FBActivityProductController* avtivity = [[FBActivityProductController alloc]init];
            avtivity.title = model.title ;
            [weakSelf.navigationController pushViewController:avtivity animated:YES];
        }
    };
    header.itemClickBlock = ^(int index){
        if (![PZParamTool hasLogin]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"goLogin" object:nil];
            return;
        }
        if (index == 0) {
            //揭晓
            FBPublicListController* public = [[FBPublicListController alloc]init];
            public.title = @"揭晓" ;
            [weakSelf.navigationController pushViewController:public animated:YES];
        }
        else if (index==1){
            //晒单
            FBShareOrderController* public = [[FBShareOrderController alloc]init];
            public.title = @"晒单" ;
            [weakSelf.navigationController pushViewController:public animated:YES];
        }
        else if (index==2){
            // 订单
            RRFFreeBuyOrderViewController *desc = [[RRFFreeBuyOrderViewController alloc]init];
            desc.title = @"夺宝订单";
            desc.comminType = RRFFreeBuyOrderTypeFreeBuy;
            [weakSelf.navigationController pushViewController:desc animated:YES];
        }else{
            //帮助
            PZWebController* public = [[PZWebController alloc]init];
            public.title = @"帮助" ;
            NSString* pathUrl = [NSString stringWithFormat:@"%@xitenggame/singleWrap/zeroGetCowryHelp.html",Base_url];
            public.pathUrl = pathUrl ;
            [weakSelf.navigationController pushViewController:public animated:YES];
        }
    };
    header.frame = CGRectMake(0, 0, SCREENWidth, FreeBuyBannerHeight+80+44);
    self.tableView.tableHeaderView = header ;
    self.tableView.estimatedRowHeight = 120.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[FreeBuyCell class] forCellReuseIdentifier:@"FreeBuyCell"];
    self.tableView.delegate = self ;
    self.tableView.dataSource = self ;
    
    MJRefreshAutoNormalFooter *tabfooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getPurchaseGameList:)];
    tabfooter.triggerAutomaticallyRefreshPercent = 1;
    tabfooter.automaticallyRefresh = YES;
    tabfooter.stateLabel.textColor = HBColor(135, 135, 135);
    self.tableView.mj_footer = tabfooter;
    
    MJRefreshNormalHeader* refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(getPurchaseGameList:)];
    refreshHeader.stateLabel.textColor = [UIColor lightGrayColor];
    refreshHeader.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
    self.tableView.mj_header = refreshHeader ;

    [HBLoadingView showCircleView:self.view];
    //轮播图
    [FBTool getPurchaseGameActivity:@"purchaseGame" successBlock:^(id json) {
        PurchaseGameActivityList* listM = [PurchaseGameActivityList yy_modelWithJSON:json];
        [weakSelf.header configModel:listM.content];
    } fail:^(id json) {
        
    }];
    //最新中奖信息
    [FBTool getNewstWinSuccessBlock:^(id json) {
        FBNewWinnerListModel* listM = [FBNewWinnerListModel yy_modelWithJSON:json];
        [weakSelf.header configWinners:listM.content];
        [HBLoadingView dismiss];
    } fail:^(id json) {
        [HBLoadingView dismiss];
    }];
}

-(void)getPurchaseGameList:(UIView*)sender{
    NSMutableArray* temp = [NSMutableArray arrayWithArray:self.productList];
    if ([sender isKindOfClass:[MJRefreshNormalHeader class]]||sender==nil) {
        // refresh
        self.pageNo = 0 ;
        [temp removeAllObjects];
    }
    //商品列表
    WEAKSELF
    NSMutableDictionary *filterDic = [[NSMutableDictionary alloc]init];
    if (self.currentIndex==0) {
        [filterDic setObject:@(self.popularity) forKey:@"popularity"];
    }
    else if (self.currentIndex == 1){
        [filterDic setObject:@(self.rateOfProgress) forKey:@"rateOfProgress"];
    }
    else{
        [filterDic setObject:@(self.price) forKey:@"price"];
    }
    [FBTool getPurchaseGameListWithPageNo:self.pageNo pageSize:15 FilterDic:filterDic SuccessBlock:^(id json) {
        FBProductListModel* list = [FBProductListModel yy_modelWithJSON:json];
        [temp addObjectsFromArray:list.content];
        weakSelf.productList = temp ;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer setHidden:list.last];
        self.pageNo++;
    } fail:^(id json) {
        
    }];
}

-(UIView*)createSectionView{
    if (self.sectionView == nil) {
        _sectionView = [[PZStateMenu alloc]initWithTitles:@[@"人气",@"进度",@"价格"]];
        _sectionView.delegate = self ;
        _sectionView.frame = CGRectMake(0, 1, SCREENWidth, 44);
        
        UIView* topline = [[UIView alloc]init];
        topline.backgroundColor = HBColor(243, 243, 243);
        topline.frame = CGRectMake(0, 0, SCREENWidth, 1);
        [_sectionView addSubview:topline];
        
        UIView* botline = [[UIView alloc]init];
        botline.backgroundColor = HBColor(243, 243, 243);
        botline.frame = CGRectMake(0, 43, SCREENWidth, 1);
        [_sectionView addSubview:botline];
    }
    return self.sectionView ;
}


#pragma mark - menu Deledate
-(void)didSelecteItemAt:(NSInteger)currentIndex{
    self.currentIndex = currentIndex ;
    if (currentIndex == 0) {
        self.popularity = self.popularity*-1 ;
    }
    else if(currentIndex == 1){
        self.rateOfProgress = self.rateOfProgress*-1 ;
    }
    else{
        self.price = self.price*-1 ;
    }
    self.pageNo = 0 ;
    [self getPurchaseGameList:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0f;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self createSectionView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray* list = self.productList ;
    return list.count  ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAKSELF
    FreeBuyCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FreeBuyCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    NSArray* list = self.productList ;
    FBProductModel* model = list[indexPath.row];
    cell.productDetailBlock = ^(){
        [weakSelf goProductDetail:model];
    };
    cell.clickBlock = ^() {
        if (![PZParamTool hasLogin]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"goLogin" object:nil];
            return;
        }
        JNQBookFBOrderViewController *bookFBOrderVC = [[JNQBookFBOrderViewController alloc] init];
        bookFBOrderVC.navigationItem.title = @"夺宝订单";
        bookFBOrderVC.productM = model;
        [self.navigationController pushViewController:bookFBOrderVC animated:YES];
    };
    [cell configModel:model];
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FBProductModel *model = _productList[indexPath.row] ;
    [self goProductDetail:model];
}

-(void)goProductDetail:(FBProductModel *)model{
    JNQFBComContentPageController *vc = [[JNQFBComContentPageController alloc] init];
    vc.fbPurchaseGameId = model.purchaseGameId;
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.currentOffset = self.tableView.contentOffset ;
    if (self.refreshData) {
        [self getPurchaseGameList:nil];
    }
    else{
        [self.tableView.mj_footer beginRefreshing];
        self.refreshData = YES ;
    }
}

@end
