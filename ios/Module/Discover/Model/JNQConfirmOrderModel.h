//
//  JNQConfirmOrderModel.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface JNQConfirmOrderModel : NSObject
@property (nonatomic, strong) NSString *iconstr;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, assign) int orderStatus;
@property (nonatomic, assign) int payType;
@property (nonatomic, strong) NSArray *productInfoList;
@property (nonatomic, assign) NSInteger realTotalFee;
@property (nonatomic, assign) NSInteger diamondPrice;
@property (nonatomic, assign) NSInteger exchangeXtbCount;
@property (nonatomic, assign) NSInteger giveXtbCount;

@end

@interface JNQProductPayResultModel : NSObject

@property (nonatomic, strong) NSString *orderNo;
@property (nonatomic, assign) NSInteger xtbPrice;
@property (nonatomic, strong) NSString *tradeTime;

@end

