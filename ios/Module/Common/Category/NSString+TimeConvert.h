//
//  NSString+TimeConvert.h
//  HuiBeiWaterMerchant
//
//  Created by huibei on 16/5/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TimeConvert)
-(NSString *)timestamp2Normal;
-(NSString *)orderState;
-(NSString *)clientOrderState;
-(NSString *)winingOrderListCellOpentionStatus;
// 支付方式
-(NSString *)payWay;
// 支付结果里的支付方式
-(NSString *)resultPayWay;

//时间本地化
-(NSString*)localizedTime;
-(NSString *)localized60Time;

// 幸运的logo 隐藏
-(BOOL)hiddenLuck;
-(NSString *)operationBtnStr ;
// 夺宝订单的状态
-(NSString *)bidOrderStatusOperationBtnStr;
// 是否幸运
-(BOOL)isLuck;
@end
