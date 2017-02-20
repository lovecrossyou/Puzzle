//
//  JNQPersonHomepageView.m
//  Puzzle
//
//  Created by HuHuiPay on 16/9/13.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQPersonHomepageView.h"
#import "UIButton+WebCache.h"
#import "PZTitleInputView.h"

@implementation JNQPersonHomepageView

@end

@implementation JNQPersonHomepageHeaderView {
    UILabel *_userNameLabel;
    UIButton *_vBtn;
    UIButton *_genderTag;
    
    UILabel *_yearRankLabel;
    UILabel *_profitLabel;
    UILabel *_hitRateLabel;
    
    UILabel *_signLabel;
    
    UILabel *_rankLabel;
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        UIImageView *headImgView = [[UIImageView alloc] init];
        [self addSubview:headImgView];
        [headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self);
            make.height.mas_equalTo(175);
        }];
        [headImgView setImage:[UIImage imageNamed:@"lg"]];
        
        //年排名
        _yearRankLabel = [[UILabel alloc] init];
        [headImgView addSubview:_yearRankLabel];
        [_yearRankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(headImgView);
            make.left.mas_equalTo(headImgView).offset(30);
            make.size.mas_equalTo(CGSizeMake(75, 44));
        }];
        _yearRankLabel.font = PZFont(13);
        _yearRankLabel.textColor = [UIColor whiteColor];
        _yearRankLabel.textAlignment = NSTextAlignmentCenter;
        _yearRankLabel.numberOfLines = 2;
        
        //命中率
        _hitRateLabel = [[UILabel alloc] init];
        [headImgView addSubview:_hitRateLabel];
        [_hitRateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(headImgView);
            make.width.height.mas_equalTo(_yearRankLabel);
            make.right.mas_equalTo(headImgView).offset(-30);
        }];
        _hitRateLabel.font = PZFont(13);
        _hitRateLabel.textColor = [UIColor whiteColor];
        _hitRateLabel.textAlignment = NSTextAlignmentCenter;
        _hitRateLabel.numberOfLines = 2;
        
        //累计盈利
        _profitLabel = [[UILabel alloc] init];
        [headImgView addSubview:_profitLabel];
        [_profitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(headImgView);
            make.height.mas_equalTo(_yearRankLabel);
            make.left.mas_equalTo(_yearRankLabel.mas_right);
            make.right.mas_equalTo(_hitRateLabel.mas_left);
        }];
        _profitLabel.font = PZFont(13);
        _profitLabel.textColor = [UIColor whiteColor];
        _profitLabel.textAlignment = NSTextAlignmentCenter;
        _profitLabel.numberOfLines = 2;
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_maddle"]];
        [_profitLabel addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(26);
            make.bottom.mas_equalTo(-8);
        }];
        
        //头像
        _headImgBtn = [[UIButton alloc] init];
        [self addSubview:_headImgBtn];
        [_headImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headImgView.mas_bottom).offset(-35);
            make.left.mas_equalTo(headImgView).offset(12);
            make.width.height.mas_equalTo(60);
        }];
        _headImgBtn.layer.masksToBounds = YES;
        _headImgBtn.layer.cornerRadius = 2;
        _headImgBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _headImgBtn.layer.borderWidth = 2.0f;
        
        
        //性别
        _genderTag = [[UIButton alloc] init];
        [self addSubview:_genderTag];
        [_genderTag mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(_headImgBtn).offset(5);
            make.size.mas_equalTo(15);
        }];
        [_genderTag setImage:[UIImage imageNamed:@"woman"] forState:UIControlStateNormal];
        [_genderTag setImage:[UIImage imageNamed:@"man"] forState:UIControlStateSelected];
        
        
        //名称
        _userNameLabel = [[UILabel alloc] init];
        [self addSubview:_userNameLabel];
        [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImgBtn.mas_right).offset(12);
            make.bottom.mas_equalTo(headImgView).offset(-8);
            make.height.mas_equalTo(20);
        }];
        _userNameLabel.font = PZFont(17);
        _userNameLabel.textColor = [UIColor whiteColor];
        
        //加v
        _vBtn = [[UIButton alloc] init];
        [self addSubview:_vBtn];
        [_vBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(_userNameLabel);
            make.left.mas_equalTo(_userNameLabel.mas_right).offset(6);
        }];
        [_vBtn setImage:[UIImage imageNamed:@"icon_v"] forState:UIControlStateNormal];
        
        //签名
        _signLabel = [[UILabel alloc] init];
        [self addSubview:_signLabel];
        [_signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headImgView.mas_bottom);
            make.bottom.mas_equalTo(_headImgBtn.mas_bottom);
            make.left.mas_equalTo(_headImgBtn.mas_right).offset(12);
        }];
        _signLabel.font = PZFont(12.5);
        _signLabel.textColor = HBColor(153, 153, 153);
        
        //简介
        _infoLabel = [[UILabel alloc] init];
        [self addSubview:_infoLabel];
        [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headImgBtn.mas_bottom).offset(10);
            make.left.mas_equalTo(_headImgBtn.mas_left);
            make.width.mas_equalTo(SCREENWidth-24);
            make.height.mas_equalTo(36);
        }];
        _infoLabel.font = PZFont(14);
        _infoLabel.textColor = HBColor(153, 153, 153);
        _infoLabel.numberOfLines = 2;
        
        
        _allInfoBtn = [[UIButton alloc] init];
        [self addSubview:_allInfoBtn];
        [_allInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_infoLabel.mas_bottom).offset(5);
            make.left.right.mas_equalTo(self);
            make.height.mas_equalTo(10);
        }];
        _allInfoBtn.contentMode = UIViewContentModeScaleAspectFit;
        [_allInfoBtn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
        [_allInfoBtn setImage:[UIImage imageNamed:@"fanning_up"] forState:UIControlStateSelected];
        
        _rankView = [[UIView alloc] init];
        [self addSubview:_rankView];
        [_rankView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_allInfoBtn.mas_bottom).offset(5);
            make.left.mas_equalTo(self).offset(-0.5);
            make.right.mas_equalTo(self).offset(0.5);
            make.height.mas_equalTo(50);
        }];
        _rankView.backgroundColor = [UIColor whiteColor];
        _rankView.layer.borderColor = HBColor(231, 231, 231).CGColor;
        _rankView.layer.borderWidth = 0.5;
        
        UIButton *imgB = [[UIButton alloc] init];
        [_rankView addSubview:imgB];
        [imgB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_equalTo(_rankView);
            make.width.mas_equalTo(35);
        }];
        imgB.contentMode = UIViewContentModeScaleAspectFit;
        [imgB setImage:[UIImage imageNamed:@"jnq_detaileds-information"] forState:UIControlStateNormal];
        
        UILabel *atten = [[UILabel alloc] init];
        [_rankView addSubview:atten];
        [atten mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(_rankView);
            make.left.mas_equalTo(imgB.mas_right);
        }];
        atten.font = PZFont(15);
        atten.textColor = HBColor(51, 51, 51);
        atten.text = @"股神争霸";
        
        _rankLabel = [[UILabel alloc] init];
        [_rankView addSubview:_rankLabel];
        [_rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(_rankView);
            make.right.mas_equalTo(_rankView).offset(-25);
        }];
        _rankLabel.font = PZFont(14);
        _rankLabel.textColor = HBColor(153, 153, 153);
        _rankLabel.textAlignment = NSTextAlignmentRight;
        
        _rankInput = [[PZTitleInputView alloc] initWithTitle:@"" placeHolder:@""];
        [_rankView addSubview:_rankInput];
        [_rankInput mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_rankView);
        }];
        _rankInput.textEnable = NO;
        _rankInput.indicatorEnable = YES;
        _rankInput.backgroundColor = [UIColor clearColor];
        
        UIView *sep = [[UIView alloc] init];
        [self addSubview:sep];
        [sep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(_rankView.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth, 15));
        }];
        sep.backgroundColor = HBColor(245, 245, 245);

    }
    return self;
}

- (void)setSelfRankModel:(JNQSelfRankModel *)selfRankModel {
    _selfRankModel = selfRankModel;
    [_headImgBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:selfRankModel.iconUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"common_head_default-diagram"]];
    _userNameLabel.text = [selfRankModel.userName isEqualToString:@""] || !selfRankModel.userName ? @"" : selfRankModel.userName;
    _genderTag.selected = [selfRankModel.sex isEqualToString:@"男"] ? YES : NO;
    _vBtn.hidden = [selfRankModel.userStatue isEqualToString:@"already_review"] ? NO : YES;
    
    _yearRankLabel.text = [NSString stringWithFormat:@"%@\n年度排行", selfRankModel.yearRanking];
    NSMutableAttributedString *yearRankString = [[NSMutableAttributedString alloc] initWithString:_yearRankLabel.text];
    [yearRankString addAttribute:NSFontAttributeName value:PZFont(17) range:NSMakeRange(0, _yearRankLabel.text.length-4)];
    _yearRankLabel.attributedText = yearRankString;
    
    _hitRateLabel.text = [NSString stringWithFormat:@"%@\n命中率", selfRankModel.hitRate];
    if (selfRankModel.hitRate == nil || [selfRankModel.hitRate isEqualToString:@""]) {
        _hitRateLabel.text = @"0%\n命中率";
    }
    NSMutableAttributedString *hitRateString = [[NSMutableAttributedString alloc] initWithString:_hitRateLabel.text];
    NSInteger length = selfRankModel.hitRate.length == 0 ? 2 : selfRankModel.hitRate.length;
    [hitRateString addAttribute:NSFontAttributeName value:PZFont(17) range:NSMakeRange(0, length)];
    _hitRateLabel.attributedText = hitRateString;
    
    _profitLabel.text = [NSString stringWithFormat:@"%ld\n累计盈利（   ）", selfRankModel.bonusXtbAmount];
    NSMutableAttributedString *profitString = [[NSMutableAttributedString alloc] initWithString:_profitLabel.text];
    [profitString addAttribute:NSFontAttributeName value:PZFont(17) range:NSMakeRange(0, _profitLabel.text.length-9)];
    _profitLabel.attributedText = profitString;
    
    _rankLabel.text = [NSString stringWithFormat:@"第 %@ 名", selfRankModel.yearRanking];
    _signLabel.text = selfRankModel.selfSign;
    _infoLabel.text = selfRankModel.userIntroduce;
}

@end
