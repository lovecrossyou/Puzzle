//
//  RRFFriendCircleModel.h
//  Puzzle
//
//  Created by huipay on 2016/11/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BonusPaperModel;
@interface CommentModel:NSObject
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSArray *contentImages;
@property(nonatomic,strong)NSString *title;

@end
@interface RespModel : NSObject
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,assign)NSInteger responseId;
@property(nonatomic,assign)NSInteger fromUserId;
@property(nonatomic,strong)NSString *fromUserName;
@property(nonatomic,strong)NSString *isSelf;
@property(nonatomic,strong)NSString *respContent;
@property(nonatomic,strong)NSString *respType;
@property(nonatomic,assign)NSInteger toUserId;
@property(nonatomic,strong)NSString *toUserName;



@end
@interface ExchangeOrderModel : NSObject
@property(nonatomic,assign)NSInteger productId;
@property(nonatomic,strong)NSString *productName;
@property(nonatomic,strong)NSString *picUrl;
@property(nonatomic,assign)NSInteger xtbAmount;


@end
@interface ExchangeOrderListModel : NSObject
//晒单的id
@property(nonatomic,assign)NSInteger commentId;

@property(nonatomic,strong)NSArray *productList;



@end
// 中奖订单信息
@interface AwardOrderModel : NSObject

@property(nonatomic,assign)NSInteger awardId;
@property(nonatomic,assign)NSInteger awardRecordId;
@property(nonatomic,strong)NSString *productName;
@property(nonatomic,strong)NSString *picUrl;
@property(nonatomic,strong)NSString *awardType;
@property(nonatomic,strong)NSString *awardTypeName;
@property(nonatomic,strong)NSString *openResultTime;
@property(nonatomic,strong)NSString *bonusAmount;
@property(nonatomic,assign)NSInteger rank;
// 晒单的id
@property(nonatomic,assign)NSInteger stockWinOrderShowId;


@end

@interface BidOrderModel : NSObject
// 晒单的id
@property(nonatomic,assign)NSInteger purchaseGameShowId;

@property(nonatomic,assign)NSInteger purchaseGameId;
@property(nonatomic,assign)NSInteger bidOrderId;
@property(nonatomic,strong)NSString *productName;
@property(nonatomic,strong)NSString *picUrl;

// 期数
@property(nonatomic,assign)NSInteger stage;
//幸运号码
@property(nonatomic,strong)NSString *luckCode;
//开奖时间
@property(nonatomic,strong)NSString *openResultTime;
//参与份数
@property(nonatomic,assign)NSInteger bidCount;



@end
@interface GuessWithStockModel : NSObject

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

// 粉丝数量
@property(nonatomic,assign)NSInteger fassAmount;
// 盈利数额
@property(nonatomic,assign)NSInteger winMount;
// 投注结果
@property(nonatomic,strong)NSString *finalResult;
// 投注数量
@property(nonatomic,assign)NSInteger guessAmount;
// 状态
//noStart(1,"未开始"),
//is_about_to_begin(2,"即将开始"),
//ongoing(3,"进行中"),
//pause(0,"暂停"),
//wait_for_the_lottery(4, "等待开奖"),
//complete(5, "已完成");
@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *guessTime;
@property(nonatomic,strong)NSString *guessType;
@property(nonatomic,strong)NSString *stockName;
@property(nonatomic,strong)NSString *stockResultType;
@property(nonatomic,assign)NSInteger stage;

@property(nonatomic,assign)NSInteger userId;
@property(nonatomic,strong)NSString *userIconUrl;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *userStatue;

@end

@interface RRFFriendCircleModel : NSObject
// 礼品兑换订单详情
@property(nonatomic,strong)ExchangeOrderListModel *exchangeOrderModel;
// 中奖订单详情
@property(nonatomic,strong)AwardOrderModel *awardOrderModel;
// 0元夺宝的订单详情
@property(nonatomic,strong)BidOrderModel *bidOrderModel;

@property(nonatomic,strong)BonusPaperModel* bonusPackageModel;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)NSArray *respModels;
@property(nonatomic,strong)CommentModel *commentModel;
@property(nonatomic,strong)NSString *descriptionStr;
@property(nonatomic,assign)NSInteger guessAmount;
@property(nonatomic,strong)GuessWithStockModel *guessWithStockModel;
@property(nonatomic,strong)NSString *iconUrl;
@property(assign,nonatomic)int ID;
// 自己是否点赞
@property(nonatomic,strong)NSString *isPraise;
// 朋友圈中是否打赏过
@property(nonatomic,strong)NSString *isPresentXitengB;
// 是否是自己发的 self自己 other 其它
@property(nonatomic,strong)NSString *isSelfComment;
// 签名
@property(nonatomic,strong)NSString *selfSign;

@property(nonatomic,strong)NSString *ranking;
// 性别
@property(nonatomic,strong)NSString *sex;

@property(assign,nonatomic)NSInteger userId;
@property(nonatomic,strong)NSString *userName;
// 是否已经认证
@property(nonatomic,strong)NSString *userStatue;
//friendCircleComment
@property(nonatomic,strong)NSString *type;
//aise表示 没赞过 alreadyPraise表示已经赞过
@property(nonatomic,strong)NSString *time;
//打赞钻石的数量 responseAmount
@property(assign,nonatomic)int presentDiamondAmount;
//赞的数量
@property(assign,nonatomic)int praiseAmount;
//回复的数量
@property(assign,nonatomic)int responseAmount;

// 朋友圈中打赏的数量
@property(assign,nonatomic)int presentXitengBAmount;

// 是否是自己打赏 //noPresnt没打赏 alreadyPresnt已经打赏
@property(nonatomic,strong)NSString *isPresentDiamond;
// 点赞的列表
@property(nonatomic,strong)NSArray *praiseUsers;
// 打赏的列表
@property(nonatomic,strong)NSArray *presentUsers;


//content =     (
//               {
//                   commentModel = "<null>";
//                   description = "\U4eb2,\U6211\U9001\U4f60100\U559c\U817e\U5e01,";
//                   guessAmount = "<null>";
//                   guessWithStockModel =             {
//                       finalResult = "--";
//                       guessAmount = 10;
//                       guessTime = "11-12 13:18:12";
//                       guessType = "\U731c\U8dcc";
//                       identityType = 0;
//                       sex = "\U7537";
//                       stage = 20161112;
//                       stockName = "\U4e0a\U8bc1\U7efc\U6307";
//                       stockResultType = wrong;
//                       userIconUrl = "http://wx.qlogo.cn/mmopen/zw9xd1aIFpHfYv2Pn8laNSTjM70p1VnuooDtYEHtWsvEpKZZ2CMpmibSWfvkGR9pYBUibfcEtLl8P11xoPFQpeMax7StUPPjhq/0";
//                       userId = 27;
//                       userName = "\U90ed\U5609\U5949\U5b5d";
//                       userStatue = "<null>";
//                   };
//                   iconUrl = "http://wx.qlogo.cn/mmopen/zw9xd1aIFpHfYv2Pn8laNSTjM70p1VnuooDtYEHtWsvEpKZZ2CMpmibSWfvkGR9pYBUibfcEtLl8P11xoPFQpeMax7StUPPjhq/0";
//                   id = 135;
//                   isPraise = noPraise;
//                   isPresentXitengB = alreadyPresnt;
//                   isSelfComment = other;
//                   praiseAmount = 0;
//                   presentXitengBAmount = 0;
//                   ranking = "<null>";
//                   responseAmount = 0;
//                   selfSign = "<null>";
//                   sex = "\U7537";
//                   time = "2016-11-12";
//                   type = guessWithStock;
//                   userId = 27;
//                   userName = "\U90ed\U5609\U5949\U5b5d";
//                   userStatue = "<null>";
//               },
@end
