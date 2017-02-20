//
//  RRFHomeHeaderView.m
//  Puzzle
//
//  Created by huibei on 16/9/30.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFHomeHeaderView.h"
#import "PZDateUtil.h"
#import "GameModel.h"
#import "SDCycleScrollView.h"
#import "PurchaseGameActivity.h"
@interface RRFHomeHeaderView ()<SDCycleScrollViewDelegate>{
    NSMutableArray* imagesURLStrings ;
    
}
@property(weak,nonatomic) UIButton *betTimeLabel ;
@property(weak,nonatomic)UILabel *timeLabel ;
@property(weak,nonatomic)SDCycleScrollView *cycleScrollView ;
@property(strong,nonatomic)NSArray* activities ;
@end
@implementation RRFHomeHeaderView
-(instancetype)init
{
    if (self = [super init]) {
        imagesURLStrings = [NSMutableArray array];
        self.backgroundColor = [UIColor clearColor];
        //        banner
        SDCycleScrollView* cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWidth, HomeBannerHeight) delegate:self placeholderImage:[UIImage imageNamed:@"homepage_ranking_default-diagram"]];
        self.cycleScrollView = cycleScrollView ;
        cycleScrollView.infiniteLoop = YES ;
        cycleScrollView.backgroundColor = HBColor(243, 243, 243);
        cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];
        cycleScrollView.titleLabelTextColor = [UIColor colorWithHexString:@"ffba26"] ;
        cycleScrollView.titleLabelTextFont = PZFont(12.0f);
        cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill ;
        cycleScrollView.delegate = self ;
        cycleScrollView.autoScrollTimeInterval = 6.0 ;
        [self addSubview:cycleScrollView];
        
     
        
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.font = [UIFont systemFontOfSize:17];
        [timeLabel sizeToFit];
        [self addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(cycleScrollView.mas_bottom).offset(24);

        }];
        self.timeLabel = timeLabel ;
        
        
        UIButton *betTimeLabel = [[UIButton alloc]init];
        [betTimeLabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [betTimeLabel setImage:[UIImage imageNamed:@"home_icon_time"] forState:UIControlStateNormal];
        betTimeLabel.titleLabel.font = [UIFont systemFontOfSize:14];
        [betTimeLabel sizeToFit];
        [self addSubview:betTimeLabel];
        [betTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(-16);
        }];
        self.betTimeLabel = betTimeLabel ;
        
    }
    return self;
}

-(void)configModel:(NSArray *)models{
    [imagesURLStrings removeAllObjects];
    self.activities = models ;
    for ( PurchaseGameActivity* model in models) {
        [imagesURLStrings addObject:model.picUrl];
    }
    self.cycleScrollView.imageURLStringsGroup = imagesURLStrings;
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    PurchaseGameActivity* model = self.activities[index];
    if (self.activityClickBlock) {
        self.activityClickBlock(model);
    }
}

-(void)updateDate:(StockGameList*)stockModel{
    NSString* timeStr = [NSString stringWithFormat:@" 截止投注:%@",[PZDateUtil intervalSinceNow:[self getStockEndTimeWithStock:stockModel]]] ;
    //截止日期刷新
    [self.betTimeLabel setTitle:timeStr forState:UIControlStateNormal];
    //开盘日期
    GameModel* stockM = [self getFirstM:stockModel];
    NSString* openTime = stockM.tradeDay ;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"YYYY-MM-dd" ;
    NSDate* d = [formatter dateFromString:openTime];
    openTime = [PZDateUtil dateToMDW:d] ;
    
    NSString *timeLableStr = [NSString stringWithFormat:@"%d期  %@",stockM.stage ,openTime];
    self.timeLabel.text = timeLableStr;
}

-(GameModel*)getFirstM:(StockGameList*)stockList{
    NSArray* stocks = stockList.content ;
    if (stocks.count > 0) {
        return [stocks firstObject];
    }
    return nil ;
}

-(NSString*)getStockEndTimeWithStock:(StockGameList*)stockM{
    GameModel* gameModel = [self getFirstM:stockM];
    if (gameModel != nil) {
        return gameModel.gameEndTime ;
    }
    return @"" ;
}


@end
