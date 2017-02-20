//
//  RRFCommentDetailCell.h
//  Puzzle
//
//  Created by huibei on 16/8/18.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRFCommentContentListModel;
@interface RRFCommentDetailCell : UITableViewCell
@property(nonatomic,copy)ItemClickParamBlock detailCellBlock;
@property(nonatomic,strong)RRFCommentContentListModel *contentListM;

@end
