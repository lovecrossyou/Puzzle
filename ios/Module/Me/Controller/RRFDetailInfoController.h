//
//  RRFDetailInfoController.h
//  Puzzle
//
//  Created by huibei on 16/11/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZBaseTableViewController.h"

@interface RRFDetailInfoController : PZBaseTableViewController
@property(nonatomic,assign)NSInteger userId;
@property(nonatomic,assign)RRFDetailInfoComeInType detailInfoComeInType;
@property(assign,nonatomic)BOOL verityInfo ;
@end
