//
//  JNQProductDetailViewController.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PZBaseTableViewController.h"

@interface JNQProductDetailViewController : UIViewController

@property (nonatomic, assign) NSInteger productId;
@property (nonatomic, assign) ProductDetailViewType viewType;

@end
