//
//  HomeHeadView.m
//  Puzzle
//
//  Created by 朱理哲 on 2016/8/13.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "HomeHeadView.h"
#import "CompositeIndexView.h"
#import "CompositeIndexPanel.h"
#import "PZMenuView.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "StockGameList.h"
#import "HomeTool.h"
#import "HomeRankCell.h"
#import "HomeRankModel.h"
#import "HomeRankListModel.h"
#import "EChatHeadCell.h"
#import "JustNowWithStockModel.h"
#import "JustNowWithStockListModel.h"
#import "HomeScrollRecentBet.h"
@interface HomeHeadView()<SDCycleScrollViewDelegate>{
    int incomeLimit ;
}
@property(weak,nonatomic)HomeScrollRecentBet* rankListTableView ;
@property(strong,nonatomic)NSArray* rankList ;
@property(strong,nonatomic)NSString* rankType ;


@property(weak,nonatomic)CompositeIndexPanel* indexPanel ;


@property(strong,nonatomic)NSArray* stockListJustNow ;

@end

@implementation HomeHeadView
-(instancetype)initWithStock:(StockGameList *)stockM incomeLimit:(int)limit{
    if (self = [super init]) {
        incomeLimit = limit ;
        self.backgroundColor = [UIColor clearColor];
        //bgView
        UIImageView* bgView = [[UIImageView alloc]init];
        bgView.backgroundColor = [UIColor colorWithHexString:@"2e343e"];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        
        WEAKSELF
        self.rankType = @"currentWeek" ;
        //banner
        RRFHomeHeaderView* banner = [[RRFHomeHeaderView alloc]init];
        [self addSubview:banner];
        [banner mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(HomeBannerHeight+100);
        }];
        [[banner.avtivityBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.avtivityBlock) {
                self.avtivityBlock();
            }
        }];
        self.banner = banner ;
        
        UIImageView* headerBgView = [[UIImageView alloc]init];
        headerBgView.image = [UIImage imageNamed:@"home-date-bg"];
        [self addSubview:headerBgView];
        [headerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(HomeBannerHeight);
            make.height.mas_equalTo(100);
        }];
        
        CompositeIndexPanel* indexPanel = [[CompositeIndexPanel alloc]initWithStock:stockM];
        indexPanel.betBlock = ^(GameModel* indexM){
            weakSelf.betBlock(indexM);
        };
        indexPanel.guessUpBlock = ^(GameModel* indexM){
            weakSelf.guessUpBlock(indexM);
        };
        indexPanel.guessDownBlock = ^(GameModel* indexM){
            weakSelf.guessDownBlock(indexM);
        };
        
        self.indexPanel = indexPanel ;
        [self addSubview:indexPanel];
        [indexPanel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(stockM.content.count*(HomeStockHeight + 12));
            make.top.mas_equalTo(banner.mas_bottom);
        }];
    
        //footer
        //时时投注
        HomeScrollRecentBet* recentBetList = [[HomeScrollRecentBet alloc]init];
        recentBetList.itemClick = ^(){
            if (weakSelf.recentBetClick) {
                weakSelf.recentBetClick();
            }
        };
        [self addSubview:recentBetList];
        [recentBetList mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(indexPanel.mas_bottom);
            make.bottom.mas_equalTo(-12);
        }];
        
        
        UIImageView* topView = [[UIImageView alloc]init];
        topView.image = [UIImage imageNamed:@"homepage_interval"];
        [self addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(12);
            make.bottom.mas_equalTo(0);
        }];
        [self addSubview:topView];
        
        
        self.rankListTableView = recentBetList ;
        //时时投注
        [self requestStockJustNow];
        
    }
    return self ;
}

-(void)requestRankListWithLimit:(int)limit{
    WEAKSELF
    [HomeTool getRankListWithPageNo:0 pageSize:limit type:self.rankType SuccessBlock:^(id json) {
        [MBProgressHUD dismiss];
        HomeRankListModel* rankListM = [HomeRankListModel yy_modelWithJSON:json];
        weakSelf.rankListTableView.recentList = rankListM.content ;
    } fail:^(id json) {
        
    }];
}


-(void)updateStockData:(StockGameList *)stockModel{    
//    股票数据刷新
    [self.indexPanel updateStockData:stockModel];
//    刷新最新投注数据
    [self requestStockJustNow];
}

-(void)updateDate:(StockGameList *)stockModel{
    //时间倒计时
    [self.banner updateDate:stockModel];
}


-(void)requestStockJustNow{
    WEAKSELF
    //    刚刚投注的列表
    [HomeTool getJustNowWithStockListWithPageNo:0 pageSize:15 SuccessBlock:^(id json) {
        [MBProgressHUD dismiss];
        JustNowWithStockListModel* model = [JustNowWithStockListModel yy_modelWithJSON:json];
        weakSelf.rankListTableView.recentList =  model.content;
    } fail:^(id json) {
        [MBProgressHUD dismiss];
    }];
}
@end
