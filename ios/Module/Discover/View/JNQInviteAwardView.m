//
//  JNQInviteAwardView.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQInviteAwardView.h"
#import "InviteBonusesModel.h"
#import "UIImageView+WebCache.h"
#import "HBVerticalBtn.h"
#import "WXApi.h"
@implementation JNQInviteAwardView

@end

@implementation JNQInviteAwardHeadView {
    UIImageView *_headImg;
    UILabel *_name;
    UILabel *_inviteCount;
    UILabel *_awardLabel;
    UILabel *_allAwardLabel;
}

- (instancetype)initWithFrame:(CGRect)frame model:(InviteBonusesModel *)inviteBonuses{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HBColor(245, 245, 245);
        UILabel *attention = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, SCREENWidth, 20)];
        [self addSubview:attention];
        attention.textColor = HBColor(153, 153, 153);
        attention.font = PZFont(13);
        attention.text = [NSString stringWithFormat:@"   您每邀请1个朋友可获奖励%d喜腾币",inviteBonuses.oneLevelReward];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(-1, CGRectGetMaxY(attention.frame), SCREENWidth+2, 65)];
        [self addSubview:backView];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.borderWidth = 1;
        backView.layer.borderColor = HBColor(231, 231, 231).CGColor;
        
        _headImg = [[UIImageView alloc] initWithFrame:CGRectMake(12, 10, 45, 45)];
        [backView addSubview:_headImg];
        [_headImg sd_setImageWithURL:[NSURL URLWithString:inviteBonuses.selfUserIconUrl] placeholderImage:DefaultImage];

        _name = [[UILabel alloc] initWithFrame:CGRectMake(67, 10, SCREENWidth/2, 22.5)];
        [backView addSubview:_name];
        _name.textColor = HBColor(51, 51, 51);
        _name.font = PZFont(16);
        _name.text = inviteBonuses.selfUserName ;
        
        
        _inviteCount = [[UILabel alloc] initWithFrame:CGRectMake(67, CGRectGetMaxY(_name.frame), SCREENWidth/2, 22.5)];
        [backView addSubview:_inviteCount];
        _inviteCount.textColor = HBColor(51, 51, 51);
        _inviteCount.font = PZFont(13.5);
        _inviteCount.text = [NSString stringWithFormat:@"邀请人数%d",inviteBonuses.selfInviteAmount];
        
        _awardLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWidth/2, 0, SCREENWidth/2-12, 65)];
        [backView addSubview:_awardLabel];
        _awardLabel.textColor = HBColor(241, 47, 47);
        _awardLabel.textAlignment = NSTextAlignmentRight;
        _awardLabel.font = PZFont(13);
        _awardLabel.text = [NSString stringWithFormat:@"邀请奖励%d",inviteBonuses.selfInviteBonusCount];

        UILabel *atten = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(backView.frame)+10, SCREENWidth, 20)];
        [self addSubview:atten];
        atten.textColor = HBColor(153, 153, 153);
        atten.font = PZFont(13);
        atten.text = @"   您的朋友每邀请5个朋友您可获奖励100喜腾币";
    }
    return self;
}

@end


@implementation JNQShareView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        NSArray *iconArr = @[@"jnq_icon_wechat", @"jnq_icon_friend-circle", @"share_btn_weibo", @"share_btn_qq"];
        NSArray *titleArr = @[@"微信好友", @"微信朋友圈", @"新浪微博", @"QQ好友"];
        _shareBackView = [[UIScrollView alloc] init];
        [self addSubview:_shareBackView];
        [_shareBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self);
            make.height.mas_equalTo(100);
        }];
        NSArray *offsetA = @[@(-(SCREENWidth*3)/8), @(-SCREENWidth/8), @(SCREENWidth/8), @((SCREENWidth*3)/8)];
        for (int i = 0; i < iconArr.count; i++) {
            HBVerticalBtn *btn = [[HBVerticalBtn alloc] initWithIcon:iconArr[i] title:titleArr[i]];
            [_shareBackView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_shareBackView);
                make.centerX.mas_equalTo(_shareBackView).offset([offsetA[i] floatValue]);
                make.size.mas_equalTo(CGSizeMake(80, 70));
            }];
            [btn setFontSize:12];
            [btn setTextColor:HBColor(51, 51, 51)];
            btn.tag = i;
            [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                if (self.shareBlock) {
                    self.shareBlock(btn);
                }
            }];
        }
    
        _quitBtn = [[UIButton alloc] init];
        [self addSubview:_quitBtn];
        [_quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self).offset(-45);
            make.left.right.bottom.mas_equalTo(self);
            make.height.mas_equalTo(40);
        }];
        _quitBtn.backgroundColor = [UIColor whiteColor];
        [_quitBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_quitBtn setTitleColor:HBColor(51, 51, 51) forState:UIControlStateNormal];
        _quitBtn.titleLabel.font = PZFont(15);
        
        UIView *line = [[UIView alloc] init];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_shareBackView.mas_bottom);
            make.left.right.mas_equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
        line.backgroundColor = HBColor(231, 231, 231);
    }
    return self;
}

@end
