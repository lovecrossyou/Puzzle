//
//  JNQFBCompleteViewController.h
//  Puzzle
//
//  Created by HuHuiPay on 16/12/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBProductListModel.h"

@interface JNQFBCompleteViewController : UITableViewController

@property (nonatomic, strong) FBProductModel *productM;
@property (nonatomic, assign) NSInteger inCount;

@end