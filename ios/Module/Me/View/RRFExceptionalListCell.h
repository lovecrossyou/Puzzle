//
//  RRFExceptionalListCell.h
//  Puzzle
//
//  Created by huibei on 16/8/25.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RRFPraiseListModel;
@interface RRFExceptionalListCell : UITableViewCell
@property(nonatomic,strong)RRFPraiseListModel *model;
@property(nonatomic,assign)CommentCellClickType type;
@end
