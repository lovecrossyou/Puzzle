//
//  GuessPageHeadView.h
//  Puzzle
//
//  Created by huipay on 2016/8/18.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^GuessGameBlock)(NSString* amount);
typedef void(^GoBuyXTBlock)();

@class GameModel,StockDetailModel ;
@interface GuessPageHeadView : UIControl
@property(assign,nonatomic)BOOL isUp ;
@property(copy,nonatomic)GuessGameBlock guessGameBlock;
//
@property(copy,nonatomic)GoBuyXTBlock bugXTBlock;

-(instancetype)initWithIndexM:(GameModel*)gameM stockDetailM:(StockDetailModel*)stockDetail type:(int)up;
-(void)keyboardUp;
-(void)keyboardDown;
@end
