//
//  JNQFrendsCircleView.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNQSelfRankModel.h"



@interface JNQFriendsCircleView : UIView

@end

@interface JNQFriendsCircleHeaderView : UIView

@end

@interface JNQFriendsCircleRankHeaderView : UIView

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *rankLabel;
@property (nonatomic, strong) UIButton *incomeLabel;
@property (nonatomic, strong) UILabel *hitPercentLabel;
@property (nonatomic, strong) UIButton *genderTag;

@property (nonatomic, strong) JNQSelfRankModel *selfRankModel;
@property (nonatomic, assign) FriendRankType rankType;
@property (nonatomic, assign) RankType rank;

@end

@interface JNQFriendsCircleRankFootView : UIView

@property (nonatomic, strong) UIButton *loadMoreBtn;

@end

@interface JNQFriendsCircleSectionHeadView : UIView

@end
