//
//  MyFriendCircleController.h
//  Puzzle
//
//  Created by huipay on 2016/11/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PZBaseTableViewController.h"
@interface MyFriendCircleController : PZBaseTableViewController
@property(copy,nonatomic)void(^chooseCompleteBlock)(NSArray* persons);
@property(assign,nonatomic) BOOL seleteMode ;
@end
