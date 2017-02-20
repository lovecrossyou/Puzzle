//
//  RRFModifyNameController.h
//  Puzzle
//
//  Created by huibei on 16/8/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//
typedef void(^ModifyNameRefreBlock)(NSString *name);

#import "PZBaseTableViewController.h"

@interface RRFModifyNameController : PZBaseTableViewController
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *placeholder;
@end
