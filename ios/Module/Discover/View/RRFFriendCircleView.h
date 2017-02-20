//
//  RRFFriendCircleSectionHeadView.h
//  Puzzle
//
//  Created by huipay on 2016/11/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRFFriendCircleModel,RRFFriendCircleMeInfoModel,RRFCommentNoticeView;
@interface RRFRankingView : UIControl
@property(nonatomic,strong)UILabel *subTitleLabel;
@end
@interface RRFPublishView : UIControl

@end

@interface RRFFriendCircleView : UIControl
@property(nonatomic,strong)RRFFriendCircleMeInfoModel *model;
@property(nonatomic,strong)RRFFriendCircleModel *infoM;
@property(nonatomic,strong)RRFRankingView *rankView;
@property(nonatomic,strong)RRFPublishView *sendView;
@property(nonatomic,assign)RRFFriendCircleType type;
@property(nonatomic,strong)RRFCommentNoticeView *noticeView;

-(void)setShowNoticeView:(BOOL)hidden;
@end
