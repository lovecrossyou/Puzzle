//
//  JNQInviteAwardView.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HBVerticalBtn;

typedef void(^ShareBlock)(HBVerticalBtn *shareBtn);


@class InviteBonusesModel ;
@interface JNQInviteAwardView : UIView

@end

@interface JNQInviteAwardHeadView : UIView
-(instancetype)initWithFrame:(CGRect)frame model:(InviteBonusesModel*)inviteBonuses ;
@end

@interface JNQShareView : UIView
@property (nonatomic, strong) UILabel *atten;
@property (nonatomic, strong) UIScrollView *shareBackView;
@property (nonatomic, strong) UIButton *quitBtn;
@property (nonatomic, strong) ShareBlock shareBlock;

@end
