//
//  StockDetailModel.h
//  Puzzle
//
//  Created by huipay on 2016/8/30.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameModel.h"
@interface StockDetailModel : NSObject
//comesTime = "2016-08-29 16:00:00";
//gameEndTime = "2016-08-29 09:00:00";
//gameStartTime = "2016-08-28 15:00:00";
//guessDownRate = "79.0%";
//guessDownXtBAmount = 2201;
//guessUpRate = "21.0%";
//guessUpXtBAmount = 588;
//guessXtbCount = 2789;
//leastCathectic = 10;
//status = 2;
//stockGameId = 2;
//stockGameName = "\U4e0a\U8bc1\U7efc\U6307";
//tradeDay = "2016-08-29";

@property(assign,nonatomic)int bonusXtbAmount ;
@property(assign,nonatomic)int commentAmount ;

@property(strong,nonatomic)NSString* comesTime ;
@property(strong,nonatomic)NSString* gameEndTime ;
@property(strong,nonatomic)NSString* gameStartTime ;

@property(strong,nonatomic)NSString* guessDownRate ;
@property(strong,nonatomic)NSString* guessDownXtBAmount ;
@property(strong,nonatomic)NSString* guessUpRate ;

@property(strong,nonatomic)NSString* guessUpXtBAmount ;
@property(assign,nonatomic)int guessXtbCount ;
@property(assign,nonatomic)int leastCathectic ;
@property(assign,nonatomic)int status ;
@property(assign,nonatomic)int stockGameId ;
@property(assign,nonatomic)int stage ;

@property(strong,nonatomic)NSString* stockGameName ;
@property(strong,nonatomic)NSString* tradeDay ;

@property(strong,nonatomic)StockModel* stockModel ;
@end
