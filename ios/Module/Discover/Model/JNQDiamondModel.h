//
//  JNQDiamondModel.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JNQDiamondModel : NSObject

@property (nonatomic, assign) int diamondCount;
@property (nonatomic, assign) int giveDiamondCount;
@property (nonatomic, strong) NSString *picture;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, assign) NSInteger shopId;
@property (nonatomic, assign) NSInteger tagId;
@property (nonatomic, strong) NSString *tagName;

@end
