//
//  RRFBettingStatisticalModel.h
//  Puzzle
//
//  Created by huibei on 16/8/27.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRFBettingStatisticalModel : NSObject
//{
//    "cumulativeBetAmount": "0",//累计投注
//    "yields": "收益率",//收益率
//    "addGuessAmount": "1",//累计投注次数
//    "hitRate": "12%",//命中率
//    "hitAmount": "1",//命中次数
//    
//    "defeatPresonAMount": "1"//击败人数
//    “addProfit": "1"//累计盈利
//}



//累计投注
@property(nonatomic,assign)NSInteger cumulativeBetAmount;

//收益率
@property(nonatomic,strong)NSString *yields;

//累计投注次数
@property(nonatomic,assign)NSInteger addGuessAmount;

//命中率
@property(nonatomic,strong)NSString *hitRate;

//命中次数
@property(nonatomic,assign)NSInteger hitAmount;

//击败人数
@property(nonatomic,assign)NSInteger defeatPresonAMount;


//累计盈利
@property(nonatomic,assign)NSInteger addProfit;
@end
