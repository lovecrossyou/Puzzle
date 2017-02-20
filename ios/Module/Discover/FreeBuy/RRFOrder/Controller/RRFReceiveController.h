//
//  RRFReceiveController.h
//  Puzzle
//
//  Created by huipay on 2016/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZBaseTableViewController.h"
@class RRFFreeBuyOrderModel,RRFWiningOrderModel;
@interface RRFReceiveController : PZBaseTableViewController
@property(nonatomic,copy)ControllerRefreBlock isRefre;
@property(nonatomic,strong)RRFFreeBuyOrderModel *model;
@property(nonatomic,strong)RRFWiningOrderModel *winingM;

@end
