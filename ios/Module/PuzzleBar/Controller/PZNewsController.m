//
//  PZNewsController.m
//  Puzzle
//
//  Created by huibei on 16/12/22.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZNewsController.h"
#import "PZNewsCell.h"
#import "PZNewsWebController.h"
#import "PZAccessInfo.h"
#import "PZParamTool.h"
#import "PZHttpTool.h"
#import "PZNewsCellModel.h"
#import "HBLoadingView.h"
#import "MJRefresh.h"
#import "PZNewsCategoryModel.h"
#import "SDCycleScrollView.h"

@interface PZNewsController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>
@property(strong,nonatomic) NSArray* newsList ;
@property(assign,nonatomic) NSInteger pageNo ;
@property(strong,nonatomic) NSArray* activities ;
@property(weak,nonatomic)SDCycleScrollView* cycleScrollView;
@property (nonatomic, strong) NSArray *titlesGroup;

@end

@implementation PZNewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self ;
    self.tableView.dataSource = self ;
    self.newsList = @[];
    self.pageNo = 0 ;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 120;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    MJRefreshNormalHeader *tabheader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData:)];
    tabheader.lastUpdatedTimeLabel.hidden = YES;
    tabheader.stateLabel.textColor = HBColor(135, 135, 135);
    tabheader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.tableView.mj_header = tabheader;
    
    MJRefreshAutoNormalFooter *tabfooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestData:)];
    tabfooter.triggerAutomaticallyRefreshPercent = 1;
    tabfooter.automaticallyRefresh = YES;
    tabfooter.stateLabel.textColor = HBColor(135, 135, 135);
    self.tableView.mj_footer = tabfooter;

    [self.tableView.mj_footer beginRefreshing];
    [self requestHeader];
}
-(void)createHeader{
    
    
    
    
    SDCycleScrollView* cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWidth, 140) delegate:self placeholderImage:nil];
    self.cycleScrollView = cycleScrollView ;
    cycleScrollView.infiniteLoop = YES ;
    cycleScrollView.backgroundColor = HBColor(243, 243, 243);
    cycleScrollView.titleLabelTextColor = [UIColor colorWithHexString:@"ffba26"] ;
    cycleScrollView.titleLabelTextFont = PZFont(12.0f);
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight ;
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill ;
    cycleScrollView.delegate = self ;
    cycleScrollView.autoScrollTimeInterval = 6.0 ;
    self.tableView.tableHeaderView = cycleScrollView ;
}

-(void)requestHeader{
    WEAKSELF
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"pageNo":@(self.pageNo),
                            @"size":@(5),
                            @"type":self.model.type
                            };
    NSString* pathUrl = @"http://114.251.53.22/xitengweixinopen/newMessage/top";
    [PZHttpTool postRequestFullUrl:pathUrl parameters:param successBlock:^(id json) {
        PZNewsCellListModel* listM = [PZNewsCellListModel yy_modelWithJSON:json];
        NSMutableArray* imagesURLStrings = [NSMutableArray array];
        NSMutableArray* titlesStrings = [NSMutableArray array];

        NSArray* activities = listM.content ;
        if (activities.count) {
            [weakSelf createHeader];
        }
        else{
            weakSelf.tableView.tableHeaderView = nil ;
        }
        weakSelf.activities = activities ;
        for ( PZNewsCellModel* model in activities) {
            [imagesURLStrings addObject:model.thumbnail_pic_s03];
            [titlesStrings addObject:model.title];
        }
        weakSelf.cycleScrollView.imageURLStringsGroup = imagesURLStrings;
        weakSelf.cycleScrollView.titlesGroup = titlesStrings;

        [HBLoadingView dismiss];
    } fail:^(id json) {
        [HBLoadingView dismiss];
    }];

}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    PZNewsCellModel* model = self.activities[index];
    PZNewsWebController* web = [[PZNewsWebController alloc]init];
    web.model = model ;
    [self.navigationController pushViewController:web animated:YES];
}


-(void)requestData:(UIView *)sender{
    NSMutableArray* temp = [NSMutableArray arrayWithArray:self.newsList];
    if ([sender isKindOfClass:[MJRefreshNormalHeader class]]) {
        [self requestHeader];
        // refresh
        self.pageNo = 0 ;
        [temp removeAllObjects];
    }
    WEAKSELF
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"pageNo":@(self.pageNo),
                            @"size":@(10),
                            @"type":self.model.type
                            };
    NSString* pathUrl = @"http://114.251.53.22/xitengweixinopen/newMessage/list";
    [PZHttpTool postRequestFullUrl:pathUrl parameters:param successBlock:^(id json) {
        weakSelf.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        PZNewsCellListModel* listM = [PZNewsCellListModel yy_modelWithJSON:json];
        [temp addObjectsFromArray:listM.content];
        weakSelf.newsList = temp ;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer setHidden:listM.last];
        weakSelf.pageNo++;
        [HBLoadingView dismiss];
    } fail:^(id json) {
        [HBLoadingView dismiss];
    }];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PZNewsCellModel* model = self.newsList[indexPath.row];
    PZNewsCell* cell = [[PZNewsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PZNewsCell"];
    [cell configModel:model];
    return cell ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsList.count ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PZNewsCellModel* model = self.newsList[indexPath.row];
    PZNewsWebController* web = [[PZNewsWebController alloc]init];
    web.model = model ;
    [self.navigationController pushViewController:web animated:YES];
}


@end
