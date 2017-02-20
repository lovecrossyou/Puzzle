//
//  JNQRankView.h
//  Puzzle
//
//  Created by HuHuiPay on 16/9/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JNQFriendsCircleView.h"

@interface JNQRankView : UIView

@end

@interface JNQRankSelectView : UIView

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) ButtonBlock btnBlock;

//- (instancetype)initWithFrame:(CGRect)frame tagArray:(NSArray *)tagArray;

@end


@interface JNQRankHeaderView : UIControl

@property (nonatomic, strong) JNQFriendsCircleRankHeaderView *selfRankView;
@property (nonatomic, assign) RankType rankType;
@property (nonatomic, strong) UIImageView *backImgView;
@property (nonatomic, strong) UIButton *moreBtn;

@end
