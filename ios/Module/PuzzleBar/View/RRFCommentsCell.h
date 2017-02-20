//
//  RRFCommentsCell.h
//  Puzzle
//
//  Created by huibei on 16/8/16.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

@class RRFCommentsCellModel ;
typedef void (^CommentsCellBlock)(NSInteger type);

#import <UIKit/UIKit.h>
@class RRFCommentsCellModel,RRFFriendCircleModel;
@interface RRFCommentsCell : UITableViewCell
@property(nonatomic,copy)CommentsCellBlock commentsCellClick;
// 去详情页
@property(nonatomic,copy)ItemClickBlock goUserProfile;
@property(nonatomic,strong)RRFCommentsCellModel *model;
@property(nonatomic,strong)RRFFriendCircleModel *friendModel;
@property (nonatomic, copy) ItemClickBlock checkBlock;
// 删除
@property (nonatomic, copy) ItemClickBlock deleteBlock;
// 领取红包
@property(nonatomic,copy)ItemClickParamBlock redPaperBlock;

@property (nonatomic, copy) void (^menuClickedOperation)(NSNumber* index);
-(void)hiddenPopMenu;
@end
