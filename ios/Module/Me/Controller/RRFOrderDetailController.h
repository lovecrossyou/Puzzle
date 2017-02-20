//
//  RRFOrderDetailController.h
//  Puzzle
//
//  Created by huibei on 16/8/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZBaseViewController.h"

@interface RRFOrderDetailController : PZBaseViewController
// 订单的id
@property(nonatomic,assign)NSInteger orderId;
@property(nonatomic,copy)ControllerRefreBlock refreBlock;
@end
