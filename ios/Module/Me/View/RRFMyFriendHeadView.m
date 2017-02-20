//
//  RRFMyFriendHeadView.m
//  Puzzle
//
//  Created by huibei on 16/11/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFMyFriendHeadView.h"
@interface RRFMyFriendHeadView()

@end
@implementation RRFMyFriendHeadView
-(instancetype)initWithTitle:(NSString*)title isShowDesc:(BOOL)isShow
{
    if (self = [super init]) {
        if (!isShow) {
            UIView* topLine = [[UIView alloc]init];
            topLine.backgroundColor = HBColor(243, 243, 243);
            [self addSubview:topLine];
            [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_equalTo(0);
                make.height.mas_equalTo(10);
            }];
        }
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = isShow == YES?@"你邀请1个朋友投注可获奖励100喜腾币，你的朋友每邀请5个朋友投注你可获奖励100喜腾币":@"";
        titleLabel.numberOfLines = 2;
        titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
        titleLabel.font = [UIFont systemFontOfSize:13];
        [titleLabel sizeToFit];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(12);
            make.right.mas_equalTo(-12);
        }];
        
        UIView *bgView = [[UIView alloc]init];
        bgView.userInteractionEnabled = NO;
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            if (isShow) {
                make.top.mas_equalTo(titleLabel.mas_bottom).offset(10);
            }else{
                make.bottom.mas_equalTo(0);
            }
            make.height.mas_equalTo(40);
        }];
        
        UIImageView *headView = [[UIImageView alloc]init];
        headView.image = [UIImage imageNamed:@"invite-friends_second-level"];
        [bgView addSubview:headView];
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.mas_equalTo(bgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        UILabel *subTitleLabel = [[UILabel alloc]init];
        subTitleLabel.text = title;
        subTitleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        subTitleLabel.font = [UIFont systemFontOfSize:14];
        [subTitleLabel sizeToFit];
        [bgView addSubview:subTitleLabel];
        [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headView.mas_right).offset(10);
            make.centerY.mas_equalTo(bgView.mas_centerY);
        }];
        
        UIImageView *arrowIcon =[[UIImageView alloc]init];
        arrowIcon.image = [UIImage imageNamed:@"arrow-right"];
        arrowIcon.alpha = 0.8;
        [bgView addSubview:arrowIcon];
        [arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(bgView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(8, 13));
            make.right.mas_equalTo(-15);
        }];
    }
    return self;
}

@end
