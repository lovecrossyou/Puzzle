//
//  RRFPrizeController.h
//  Puzzle
//
//  Created by huibei on 16/9/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZBaseViewController.h"
@class RRFNoticeModel;
@interface RRFPrizeController : PZBaseViewController
@property(nonatomic,weak)RRFNoticeModel *model;
@property(nonatomic,copy)ControllerRefreBlock refreBlock;
@end
