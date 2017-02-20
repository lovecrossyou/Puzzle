//
//  JNQBidRecordViewController.h
//  Puzzle
//
//  Created by HuHuiPay on 16/12/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JNQBidRecordViewController : UIViewController

@property (nonatomic, assign) NSInteger bidOrderId;
@property (nonatomic, assign) int purchaseGameCount;
@property (nonatomic, strong) NSMutableArray *bidRecordA;
@property (nonatomic, assign) BOOL isCompleteV;

@end
