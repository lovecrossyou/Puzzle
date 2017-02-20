//
//  JNQOrderModel.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/22.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JNQOrderModel : NSObject

@property (nonatomic, assign) NSInteger totalPrice;
@property (nonatomic, assign) NSInteger totalProductCount;
@property (nonatomic, assign) int productType;
@property (nonatomic, strong) NSArray *productList;
@property (nonatomic, assign) int orderType;

@end
