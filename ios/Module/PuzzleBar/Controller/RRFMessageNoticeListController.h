//
//  RRFMessageNoticeListController.h
//  Puzzle
//
//  Created by huibei on 16/10/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRFMessageNoticeListController : UITableViewController
// 0:未读  1:全部的
@property(nonatomic,assign)int comeInType;
@property(nonatomic,assign)BOOL fromCircle;
@end
