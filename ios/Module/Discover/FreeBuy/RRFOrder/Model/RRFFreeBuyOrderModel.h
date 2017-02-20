//
//  RRFFreeBuyOrderModel.h
//  Puzzle
//
//  Created by huipay on 2016/12/16.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JNQAddressModel.h"

@interface RRFBidRecordsModel : NSObject

@property(nonatomic,assign)NSInteger bidRecordId;
@property(nonatomic,assign)NSInteger purchaseCode;
@property(nonatomic,strong)NSString *createTime;

@end
@interface RRFFreeBuyOrderModel : NSObject

@property(nonatomic,assign)NSInteger purchaseGameShowId;

// 总需分数
@property(nonatomic,assign)NSInteger targetPurchaseCount;

// 进度
@property(nonatomic,assign)NSInteger rateOfProgress;
@property(nonatomic,strong)JNQAddressModel *addressInfo;
@property(nonatomic,strong)NSArray *bidRecords;
// 夺宝状态
//waiting(0, "等待开奖"),
//miss(1, "未中奖"),
//win(2, "已中奖"),
//evaluate(4, "已晒单"),
//waitEvaluate(7, "待晒单");
@property(nonatomic,strong)NSString *bidOrderStatus;
@property(nonatomic,strong)NSString *createTime;
@property(nonatomic,assign)int ID;
@property(nonatomic,assign)NSInteger luckCode;
// 在此参与
@property(nonatomic,assign)NSInteger nextPurchaseGameId;
// 夺宝活动的状态
//bidding(1, "正在夺宝"),
//finish_bid(2, "夺宝结束"),
//have_lottery(3, "已经开奖");
@property(nonatomic,strong)NSString *purchaseGameStatus;
@property(nonatomic,assign)NSInteger orderId;

@property(nonatomic,strong)NSString *picUrl;
@property(nonatomic,assign)CGFloat price;
@property(nonatomic,strong)NSString *productName;
// 总份
@property(nonatomic,assign)NSInteger purchaseGameCount;
@property(nonatomic,assign)NSInteger purchaseGameId;
@property(nonatomic,assign)NSInteger stage;


@end
