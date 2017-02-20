//
//  RRFProblemCell.h
//  Puzzle
//
//  Created by huibei on 16/8/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//
#import <UIKit/UIKit.h>
@class RRFWenBarCellModel;
@interface RRFProblemCell : UITableViewCell
@property(nonatomic,strong)RRFWenBarCellModel *model;
@property(nonatomic,copy)ItemClickBlock rewardBlock;
@end
