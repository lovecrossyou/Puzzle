//
//  JNQFriendCircleModel.h
//  Puzzle
//
//  Created by HuHuiPay on 16/9/3.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JNQFriendCircleModel : NSObject
//guessWithStockModel =         {
//    fassAmount = 2;
//    finalResult = "\U6da8";
//    guessAmount = 1000;
//    guessTime = "12-20 08:56:52";
//    guessType = "\U731c\U6da8";
//    identityType = 0;
//    sex = "\U5973";
//    stage = 20161220;
//    status = complete;
//    stockName = "\U521b\U4e1a\U677f\U6307";
//    stockResultType = right;
//    userIconUrl = "http://www.xiteng.com/group1/M00/00/2A/Cqr_HFhg9IiAfzOUAALmj3T7eSE924.jpg";
//    userId = 200;
//    userName = "\U4f60\U7684\U540d\U5b57";
//    userStatue = "<null>";
//    winMount = 898;
//};
// 粉丝数量
@property(nonatomic,assign)NSInteger fassAmount;
// 状态
@property(nonatomic,strong)NSString *status;
// 盈利的金额
@property(nonatomic,assign)NSInteger winMount;
// 点赞列表
@property(nonatomic,strong)NSArray *praiseUsers;
// 打赏列表
@property(nonatomic,strong)NSArray *presentUsers;
@property(nonatomic,assign)int ID;
@property(nonatomic,strong)NSString *sex;

@property(nonatomic,strong)NSString *isSelfComment;
// 投注期
@property(nonatomic,assign)NSInteger stage;
// 投注金额
@property(nonatomic,assign)NSInteger guessAmount;

// 投注时间
@property(nonatomic,strong)NSString *guessTime;
// 股票名称
@property(nonatomic,strong)NSString *stockName;
// 猜的结果
@property(nonatomic,strong)NSString *stockResultType;
// 投注 类型
@property(nonatomic,strong)NSString *guessType;

@property (nonatomic, strong) NSString *guessGameStatus;

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *userIconUrl;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userStatue;


// 是否点赞
@property (nonatomic, strong) NSString *isPraise;
// 点赞数量
@property (nonatomic, assign) NSInteger praiseAmount;

// 投注数量
@property (nonatomic, strong) NSString *stockNumber;
// 交易日期
@property (nonatomic, strong) NSString *tradeTime;
// 收盘
@property (nonatomic, strong) NSString *finalResult;

@property (nonatomic, assign) NSInteger guessWithStockId;
// 赔率
@property (nonatomic, strong) NSString *upOdds;
// 收益
@property(nonatomic,strong)NSString *guessResultAmount;
@end
