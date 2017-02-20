//
//  JNQProductExchangeModel.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JNQProductExchangeModel : NSObject

@property (nonatomic, assign) NSInteger addressId;
@property (nonatomic, assign) int count;
@property (nonatomic, assign) NSInteger xtbPrice;
@property (nonatomic, assign) int tradeWay;
@property (nonatomic, strong) NSArray *productList;

@end
