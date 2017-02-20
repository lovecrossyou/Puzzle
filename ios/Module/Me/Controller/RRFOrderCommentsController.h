//
//  CommentsController.h
//  HuiBeiWaterMerchant
//
//  Created by huibei on 16/5/28.
//  Copyright © 2016年 HuiBei. All rights reserved.
//
typedef void (^RefreBlock)(BOOL refre);
#import <UIKit/UIKit.h>

@interface RRFOrderCommentsController : UITableViewController
@property(nonatomic,assign)NSInteger orderId;
@property(nonatomic,copy) RefreBlock refreBlock;
@end
