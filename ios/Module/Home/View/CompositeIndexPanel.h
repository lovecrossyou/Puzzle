//
//  CompositeIndexPanel.h
//  Puzzle
//
//  Created by huipay on 2016/8/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StockGameList ;
@interface CompositeIndexPanel : UIView
@property(copy,nonatomic)ItemClickParamBlock betBlock;
-(instancetype)initWithStock:(StockGameList*)stockM;
-(void)updateStockData:(StockGameList*)stockModel;
-(void)updateDate:(StockGameList*)stockModel;
@property(copy,nonatomic) void(^guessUpBlock)(id model);
@property(copy,nonatomic) void(^guessDownBlock)(id model);

@end
