//
//  HomeHeadView.h
//  Puzzle
//
//  Created by 朱理哲 on 2016/8/13.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRFHomeHeaderView.h"

@class StockGameList ;

@interface HomeHeadView : UIView
@property(copy,nonatomic)ItemClickParamBlock betBlock;
@property(copy,nonatomic)ItemClickBlock moreBlock;
@property(copy,nonatomic)ItemClickBlock avtivityBlock;
@property(copy,nonatomic)ItemClickBlock recentBetClick ;
@property(weak,nonatomic)RRFHomeHeaderView* banner ;
@property(copy,nonatomic) void(^guessUpBlock)(id model);
@property(copy,nonatomic) void(^guessDownBlock)(id model);


-(instancetype)initWithStock:(StockGameList*)stockM incomeLimit:(int)limit;

-(void)updateStockData:(StockGameList*)stockModel;
-(void)updateDate:(StockGameList*)stockModel;

@end
