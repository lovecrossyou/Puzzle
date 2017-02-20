//
//  JNQPayUtil.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JNQPayReadyModel.h"

typedef void(^PZRequestSuccess) (id json);
typedef void(^PZRequestFailure) (id json);

@interface PZPayUtil : NSObject

+(PZPayUtil *)sharedInstance;
-(void)payWithPayReadyModel:(JNQPayReadyModel *)payReadyModel complete:(ItemClickParamBlock)complete sender:(UIViewController *)sender;

@end
