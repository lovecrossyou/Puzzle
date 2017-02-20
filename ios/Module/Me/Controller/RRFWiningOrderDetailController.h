//
//  RRFWiningOrderDetailController.h
//  Puzzle
//
//  Created by huipay on 2017/2/7.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "PZBaseTableViewController.h"
@class RRFWiningOrderModel;
@interface RRFWiningOrderDetailController : PZBaseTableViewController
@property(nonatomic,strong)RRFWiningOrderModel *model;
@property(nonatomic,copy)ControllerRefreBlock refreBlock;
@end
