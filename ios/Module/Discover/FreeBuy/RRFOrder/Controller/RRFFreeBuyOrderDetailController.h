//
//  RRFFreeBuyOrderDetailController.h
//  Puzzle
//
//  Created by huipay on 2016/12/21.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZBaseTableViewController.h"
@class RRFFreeBuyOrderModel;
@interface RRFFreeBuyOrderDetailController : PZBaseTableViewController
@property(nonatomic,strong)RRFFreeBuyOrderModel *model;
@property(nonatomic,copy)ControllerRefreBlock isRefre;
@end
