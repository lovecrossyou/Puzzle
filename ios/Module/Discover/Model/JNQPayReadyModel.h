//
//  JNQPatReadyModel.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/30.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JNQPayReadyModel : NSObject

@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSString *descript;
@property (nonatomic, assign) NSInteger totalFee;
@property (nonatomic, assign) BOOL resubmit;

@end
