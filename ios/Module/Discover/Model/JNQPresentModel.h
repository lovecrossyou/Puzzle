//
//  JNQPresentStoreModel.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JNQPresentModel : NSObject

@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, strong) NSString *productName;
@property (nonatomic, assign) NSInteger sales;
@property (nonatomic, assign) NSInteger inventory;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, strong) NSString *picUrl;
@property (nonatomic, assign) NSInteger shopId;

@end
