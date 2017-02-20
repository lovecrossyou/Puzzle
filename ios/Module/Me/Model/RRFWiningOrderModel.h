//
//  RRFWiningOrderModel.h
//  Puzzle
//
//  Created by huipay on 2017/1/20.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JNQAddressModel;
@interface RRFWiningOrderModel : NSObject
//{
//    "awardRecordId": 5,
//    "awardName": "Apple iphone 7  32G 黑色",
//    "awardPicture": "http://www.xiteng.com/group1/M00/00/09/Cqr_HFg0.jpg",
//    "awardType": "周亚军",//获奖类型描述
//    "awardTypeName": "week",//获奖类型(年、月、周)
//    "profit": -30,//收益
//    "awardStatus": "acceptPrize",//状态
//    "rank": 2,//排名
//    "openResultTime": "2016-12-16 16:00:00",//开奖时间
//    "stage": 201651,//期号
//    "orderId": 2016122993601260,//订单号
//    "tradeOrderId":1,//订单ID
//    "createOrderTime": "2016-12-29 00:50:08",//领奖时间
//    "orderStatus": "待发货",
//    "deliveryAddressId": 107,
//    "deliveryAddressInfo": {
//        "deliveryAddressId": 107,
//        "recievName": "了了了了了",
//        "phoneNum": "12345698708",
//        "fullAddress": "北京北京东城区快乐啦啦啦啦"
//    }
//},

//create(0, "待发货"),
//send(1, "已发货"),
//finish(2, "已收货"),
//evaluate(3, "已评价"),
//acceptPrize(4, "已领奖"),
@property(nonatomic,assign)NSInteger awardRecordId;
@property(nonatomic,strong)NSString *awardName;
@property(nonatomic,strong)NSString *awardPicture;
@property(nonatomic,strong)NSString *awardType;
@property(nonatomic,strong)NSString *awardTypeName;
@property(nonatomic,assign)NSInteger profit;
@property(nonatomic,strong)NSString *awardStatus;
@property(nonatomic,assign)NSInteger rank;
@property(nonatomic,strong)NSString *openResultTime;
@property(nonatomic,assign)NSInteger stage;
@property(nonatomic,strong)NSNumber *orderId;
@property(nonatomic,assign)NSInteger tradeOrderId;
@property(nonatomic,assign)NSInteger stockWinOrderShowId;

@property(nonatomic,strong)NSString *createOrderTime;
@property(nonatomic,strong)NSString *orderStatus;
@property(nonatomic,assign)NSInteger deliveryAddressId;
@property(nonatomic,strong)JNQAddressModel *deliveryAddressInfo;

@end


@interface RRFWiningOrderListModel : NSObject
@property(nonatomic,strong)NSArray *content;
@property(nonatomic,assign)BOOL last;
@end

