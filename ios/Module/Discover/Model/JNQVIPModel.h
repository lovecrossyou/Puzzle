//
//  JNQVIPModel.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JNQVIPModel : NSObject

@property (nonatomic, assign) int expires;
@property (nonatomic, assign) NSInteger giveXtb;
@property (nonatomic, assign) NSString *identityName;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) int productId;
@property (nonatomic, strong) NSString *profitContent;

@end
