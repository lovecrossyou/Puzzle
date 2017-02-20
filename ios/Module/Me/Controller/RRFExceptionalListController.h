//
//  RRFExceptionalListController.h
//  Puzzle
//
//  Created by huibei on 16/8/25.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZBaseTableViewController.h"

@interface RRFExceptionalListController : PZBaseTableViewController
@property(nonatomic,strong)NSString *entityType;
@property(nonatomic,assign)CommentCellClickType type;
@property(nonatomic,assign)PraiseListType comeInType;

@property(nonatomic,assign)NSInteger ID;
@property(nonatomic,assign) BOOL showCancel ;
@end
