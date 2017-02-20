//
//  JNQSelfRankModel.h
//  Puzzle
//
//  Created by HuHuiPay on 16/9/6.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JNQSelfRankModel : NSObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *selfSign;
@property (nonatomic, strong) NSString *userIntroduce;
@property (nonatomic, assign) NSInteger bonusXtbAmount;        //累计收益
@property (nonatomic, assign) NSInteger addGuessAmount;        //累计投注次数
@property (nonatomic, strong) NSString *userStatue;
@property (nonatomic, assign) NSInteger ranking;
@property (nonatomic, strong) NSString *weekRanking;
@property (nonatomic, strong) NSString *monthRanking;
@property (nonatomic, strong) NSString *yearRanking;
//收益
@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, assign) int identityType;
//命中率
@property (nonatomic, strong) NSString *userIconUrl;           //用户头像
@property (nonatomic, assign) NSInteger hitAmount;             //命中次数
@property (nonatomic, strong) NSString *hitRate;               //命中率
@property (nonatomic, strong) NSString *yields;                //收益率
@property (nonatomic, assign) NSInteger defeatPresonAMount;    //击败的人数
@property (nonatomic, assign) NSInteger addProfit;             //累计盈利
@property (nonatomic, assign) NSInteger cumulativeBetAmount;   //累计投注金额
@property (nonatomic, assign) NSInteger seriaAmount;           //连中的次数


@end
