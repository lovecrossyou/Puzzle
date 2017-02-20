//
//  RRFNoticeModel.h
//  Puzzle
//
//  Created by huibei on 16/9/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RRFPrizeInfoModel;
@interface RRFNoticeModel : NSObject
//{
//    "content":[
//               "id":1,  //消息记录ID
//               "content":"",//消息内容
//               "messageType":"",//消息类型
//               "time":"",//消息接收时间
//               "isClick":false,//是否点击过
//               "relateId":12L,//关联ID
//               "award":{
//                   "rank":1,    //排名,int类型
//                   "userId":1， //中奖用户ID，long类型
//                   "userName":"小强",  //中奖用户姓名,String
//                   "phoneNumber":"13436836055",  //电话号码,String
//                   "profit":970000,  //盈利收益,Long
//                   "awardName":"iphone6s/金色/64G 1部",  //奖品名称,String
//                   "pic":"http://pic.jpg",  //奖品图片,String
//                   "userIcon":"http://usericon.jpg",  //用户头像,String
//                   "time":"09-21 10:05",  //中奖时间,String
//                   "content":"恭喜您，你的月收益为970000喜腾币，在本月猜涨跌排位赛中获得了第一名，赶快去领奖吧>>!"//中奖说明,String
//               }
//               ]
//}

//pay(1, "收款或付款"),
//createExchangeOrder(2, "用户已兑换商品"),
//createTradeOrder(3, "用户已下单"),
//orderConfirmed(4, "订单已确认"),
//delivery(5, "订单已发货"),
//comment(6, "朋友圈评论"),
//presentDiamond(7, "打赏钻石"),
//upgradeIdentity(8, "升级会员"),
//lottery(9, "开奖"),
//commentReply(10, "对评论进行回复"),
//replyToReply(11, "对回复进行回复"),
//weekAward(12, "周排行获奖"),
//monthAward(13, "月排行获奖"),
//yearAward(14, "年排行获奖"),
//praise(15,"点赞"),
//acceptInvite(16,"接受邀请"),
//hasGuess(17, "第一次投注"),
//joinMagpie(18, "加入喜鹊计划"),
//register(19, "注册");


@property(nonatomic,strong)NSString *messageType;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)RRFPrizeInfoModel *award;



@end

