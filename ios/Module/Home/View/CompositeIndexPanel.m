//
//  CompositeIndexPanel.m
//  Puzzle
//
//  Created by huipay on 2016/8/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "CompositeIndexPanel.h"
#import "CompositeIndexView.h"
#import "GameModel.h"
#import "StockGameList.h"
#import "PZDateUtil.h"


@interface CompositeIndexPanel()
@property(weak,nonatomic)UILabel* endDateView ;
@end

@implementation CompositeIndexPanel

-(instancetype)initWithStock:(StockGameList*)stockM{
    if (self = [super init]) {
        WEAKSELF
        UIView* lastView ;
        NSInteger tag = 100 ;
        for (GameModel* indexM in stockM.content) {
            CompositeIndexView* indexView = [[CompositeIndexView alloc]initWithStock:indexM];
            indexView.layer.masksToBounds = YES ;
            indexView.layer.cornerRadius = 12 ;
            indexView.tag = ++tag ;
            [[indexView.leftBetGo rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                weakSelf.guessUpBlock(indexM);
            }];
            [[indexView.rightBetGo rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                weakSelf.guessDownBlock(indexM);
            }];
            [[indexView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                [weakSelf goBet:indexM];
            }];
            
            [self addSubview:indexView];
            if (lastView != nil) {
                [indexView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(lastView.mas_bottom).offset(15);
                    make.height.mas_equalTo(HomeStockHeight);
                    make.left.mas_equalTo(12);
                    make.right.mas_equalTo(-12);
                }];
            }
            else{
                [indexView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(0);
                    make.height.mas_equalTo(HomeStockHeight);
                    make.left.mas_equalTo(12);
                    make.right.mas_equalTo(-12);
                }];
            }
            lastView = indexView ;
        }
    }
    return self ;
}

-(void)updateDate:(StockGameList*)stockModel{
    //    截止日期刷新
    self.endDateView.text = [NSString stringWithFormat:@"距离截止日期还剩:%@",[PZDateUtil intervalSinceNow:[self getStockEndTimeWithStock:stockModel]]] ;
}

-(void)updateStockData:(StockGameList*)stockM{
    NSInteger tag = 100 ;
    for (GameModel* gameM in stockM.content) {
        CompositeIndexView* indexView = [self viewWithTag:++tag];
        [indexView updateStockData:gameM];
    }
}


-(NSString*)getStockEndTimeWithStock:(StockGameList*)stockM{
    NSArray* stocks = stockM.content ;
    if (stocks.count > 0) {
        GameModel* gameModel = [stocks firstObject] ;
        return gameModel.gameEndTime ;
    }
    return @"" ;
}

#pragma mark - 投注
-(void)goBet:(GameModel* )indexM{
    self.betBlock(indexM);
}
@end
