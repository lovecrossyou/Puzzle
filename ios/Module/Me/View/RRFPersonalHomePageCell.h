//
//  RRFPersonalHomePageCell.h
//  Puzzle
//
//  Created by huibei on 16/9/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRFCommentsCellModel,RRFFriendCircleModel;
@interface RRFPersonalHomePageCell : UITableViewCell
@property(nonatomic,strong)RRFCommentsCellModel *model;
@property(nonatomic,strong)RRFFriendCircleModel *friendModel;
@property(nonatomic,copy)ItemClickParamBlock cellClick;
@property(nonatomic,assign)RRFPersonalHomePageCellType cellType;
@property(nonatomic,copy)ItemClickBlock checkBlock;

@property(nonatomic,copy)  void(^redPaperBlock)(NSInteger redPaperID);
@end
