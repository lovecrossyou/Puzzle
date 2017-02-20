//
//  GameModel.h
//  Puzzle
//
//  Created by huipay on 2016/8/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockModel : NSObject
//    "stockName": "上证指数",
//    "todayOpend": null,//今日开盘价
//    "yesterDayClosed": null,//昨日收盘价
//    "nowPrice": null,//当前价格
//    "todayMaxPrice": null,//今日最高价格
//    "todayMinPrice": null,//今日最低价格
//    "turnoverStockAmount": "3105.6775",//成交的股票数量
//    "turnoverStockMoney": "3087.8794",//成交的金额
//    "currentPoint": "3091.3287",//当前点数
//    "changeRate": "3090.6488",//涨跌率
//    "chg": "3090.7127"//涨跌幅
@property(strong,nonatomic) NSString* stockName ;
@property(strong,nonatomic) NSString* todayOpend ;
@property(strong,nonatomic) NSString* yesterDayClosed ;
@property(strong,nonatomic) NSString* nowPrice ;
@property(strong,nonatomic) NSString* todayMaxPrice ;
@property(strong,nonatomic) NSString* todayMinPrice ;
@property(strong,nonatomic) NSString* turnoverStockAmount ;
@property(strong,nonatomic) NSString* turnoverStockMoney ;
@property(strong,nonatomic) NSString* currentPoint ;
@property(strong,nonatomic) NSString* changeRate ;
@property(strong,nonatomic) NSString* chg ;

@property(strong,nonatomic)NSString* dayImg ;
@property(strong,nonatomic)NSString* minImg ;
@property(strong,nonatomic)NSString* monthImg ;
@property(strong,nonatomic)NSString* weekImg ;




@end

@interface GameModel : NSObject
//"stockGameId": 1,  //id
//"stockGameName": "上证综指",//游戏名称
//"guessUpXtBAmount": 0,//猜涨的 喜腾币数量
//"guessDownXtBAmount": 0,//猜跌的喜腾币的数量
//"status": 2,//状态  1未开始 2进行中 3 等待开奖 4 已完成
//"tradeDay": "2016-08-23"//交易日

@property(assign,nonatomic) int stockGameId ;
@property(strong,nonatomic) NSString* stockGameName ;
@property(strong,nonatomic) NSString* guessUpXtBAmount ;
@property(strong,nonatomic) NSString* guessDownXtBAmount ;
@property(strong,nonatomic) NSString* tradeDay ;
@property(strong,nonatomic) NSString* gameStartTime ;
@property(strong,nonatomic) NSString* gameEndTime ;
@property(strong,nonatomic) NSString* stockCode ;
@property(strong,nonatomic) NSString* status ;
@property(strong,nonatomic) StockModel* stockModel ;
@property(strong,nonatomic) NSString* upOdds ;
@property(assign,nonatomic)int stage ;
@property(strong,nonatomic)NSString* comesTime ;

//"gameStartTime": "2016-09-02 00:00:00",
//"gameEndTime": "2016-09-06 18:51:50",
//"stockCode": "000001",
//"stockModel": {  //股票的数据模型
//    "stockName": "上证指数",
//    "todayOpend": null,//今日开盘价
//    "yesterDayClosed": null,//昨日收盘价
//    "nowPrice": null,//当前价格
//    "todayMaxPrice": null,//今日最高价格
//    "todayMinPrice": null,//今日最低价格
//    "turnoverStockAmount": "3105.6775",//成交的股票数量
//    "turnoverStockMoney": "3087.8794",//成交的金额
//    "currentPoint": "3091.3287",//当前点数
//    "changeRate": "3090.6488",//涨跌率
//    "chg": "3090.7127"//涨跌幅
//}

@end
