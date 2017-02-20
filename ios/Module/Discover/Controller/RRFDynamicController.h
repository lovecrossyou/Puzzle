//
//  RRFDynamicController.h
//  Puzzle
//
//  Created by huipay on 2016/11/9.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZBaseTableViewController.h"
@class RRFFriendCircleModel;
@interface RRFDynamicController : PZBaseTableViewController
@property(nonatomic,assign)BOOL isMyFriend;
@property(nonatomic,strong)RRFFriendCircleModel *model;

@end
