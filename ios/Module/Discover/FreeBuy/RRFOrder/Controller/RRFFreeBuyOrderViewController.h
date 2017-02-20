//
//  RRFFreeBuyOrderViewController.h
//  Puzzle
//
//  Created by huipay on 2016/12/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZBaseTableViewController.h"

@interface RRFFreeBuyOrderViewController : PZBaseTableViewController
@property(nonatomic,assign)NSString *status;
@property(nonatomic,assign) BOOL showCancel ;
@property(nonatomic,assign) BOOL showSwitchPanel ;

@property(nonatomic,assign)RRFFreeBuyOrderType comminType;
@end
