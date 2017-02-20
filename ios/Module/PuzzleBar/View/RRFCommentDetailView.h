//
//  RRFCommentDetailView.h
//  Puzzle
//
//  Created by huibei on 16/8/22.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRFCommentsCellModel,JNQFriendCircleModel,RRFFriendCirclebetView;
@interface RRFCommentDetailView : UIView
@property(nonatomic,weak)RRFFriendCirclebetView *betView;

@property(nonatomic,copy)ItemClickParamBlock detailBlock;
@property(nonatomic,strong)RRFCommentsCellModel *commentM;
@property(nonatomic,strong)JNQFriendCircleModel *frienfCircleM;
@property(nonatomic,strong)NSString *type;
-(CGFloat)viewHeightWithModel:(RRFCommentsCellModel *)model;
-(CGFloat)betViewHeightWithFriendCircleModel:(JNQFriendCircleModel *)model;
@end


@interface RRFCommentDetailBottmoView : UIControl

@end
