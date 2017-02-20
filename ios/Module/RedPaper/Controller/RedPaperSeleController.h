//
//  RedPaperSeleController.h
//  Puzzle
//
//  Created by huibei on 17/1/11.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "PZBaseTableViewController.h"
@class BonusPackage;
@interface RedPaperSeleController : PZBaseTableViewController
@property(assign,nonatomic)BOOL singleBonusPaper ;
@property(assign,nonatomic)BOOL friendCircle ;
@property(assign,nonatomic) NSInteger menbers ;
@property(copy,nonatomic) void(^sendRedPaperBlock)(id json,BonusPackage* model);
@end
