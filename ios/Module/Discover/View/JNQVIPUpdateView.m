//
//  JNQVIPUpdateView.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/12.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQVIPUpdateView.h"

@implementation JNQVIPUpdateView

@end

@implementation JNQVIPUpdateHeaderView {
    UILabel *_attentionLabel;
    UILabel *_desLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HBColor(247, 41, 41);
        
        _backBtn = [[UIButton alloc] init];
        [self addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        _backBtn.backgroundColor = BasicRedColor;
        
        _attentionLabel = [[UILabel alloc] init];
        [self addSubview:_attentionLabel];
        [_attentionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(20);
            make.left.right.mas_equalTo(self);
            make.height.mas_equalTo(30);
        }];
        _attentionLabel.font = PZFont(25);
        _attentionLabel.textColor = [UIColor whiteColor];
        _attentionLabel.textAlignment = NSTextAlignmentCenter;
        _attentionLabel.text = @"会员特权";
        
        _desLabel = [[UILabel alloc] init];
        _desLabel.font = PZFont(14);
        _desLabel.textColor = [UIColor whiteColor];
        _desLabel.textAlignment = NSTextAlignmentCenter;
        _desLabel.numberOfLines = 0;
        NSString* infoString = @"您当前是普通会员，不可查看股神争霸赛排名top20最新投注动态，升级会员可查看";
        NSMutableAttributedString *desString = [[NSMutableAttributedString alloc] initWithString:infoString];
        [desString addAttribute:NSForegroundColorAttributeName value:HBColor(254, 205, 52) range:NSMakeRange(4, 4)];
        _desLabel.attributedText = desString;
        [_desLabel sizeToFit];
        [self addSubview:_desLabel];
        [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_attentionLabel.mas_bottom).offset(5);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.width.mas_equalTo(SCREENWidth-20);
        }];
    
        _vipBtn = [[UIButton alloc] init];
        [self addSubview:_vipBtn];
        [_vipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(self);
            make.height.mas_equalTo(22);
            make.bottom.mas_equalTo(-10);
        }];
        [_vipBtn setImage:[UIImage imageNamed:@"btn_look"] forState:UIControlStateNormal];
        [_vipBtn setTitle:@"偷偷瞄一眼" forState:UIControlStateNormal];
        [_vipBtn setTitleColor:BasicGoldColor forState:UIControlStateNormal];
        _vipBtn.titleLabel.font = PZFont(13.5);
        _vipBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    return self;
}

- (void)setIdentityName:(NSString *)identityName {
    _identityName = identityName;
    _attentionLabel.text = identityName;
}

- (void)setStartTime:(NSString *)startTime endTime:(NSString *)endTime {
    NSMutableAttributedString *desString;
    if ([_identityName isEqualToString:@"普通会员"]) {
        _desLabel.text = @"您当前是普通会员，不可查看股神争霸赛排名top20最新投注动态，升级会员可查看";
        desString = [[NSMutableAttributedString alloc] initWithString:_desLabel.text];
        [desString addAttribute:NSForegroundColorAttributeName value:BasicGoldColor range:NSMakeRange(4, 4)];
    } else {
        _desLabel.text = [NSString stringWithFormat:@"会员期限：%@至%@\n会员可查看股神争霸赛排名top20最新投注动态", startTime, endTime];
        desString = [[NSMutableAttributedString alloc] initWithString:_desLabel.text];
        [desString addAttribute:NSForegroundColorAttributeName value:BasicGoldColor range:[_desLabel.text rangeOfString:[NSString stringWithFormat:@"%@", startTime]]];
        [desString addAttribute:NSForegroundColorAttributeName value:BasicGoldColor range:[_desLabel.text rangeOfString:[NSString stringWithFormat:@"%@", endTime]]];
        [desString addAttribute:NSFontAttributeName value:PZFont(13) range:[_desLabel.text rangeOfString:[NSString stringWithFormat:@"%@", startTime]]];
        [desString addAttribute:NSFontAttributeName value:PZFont(13) range:[_desLabel.text rangeOfString:[NSString stringWithFormat:@"%@", endTime]]];
    }
    _desLabel.attributedText = desString;

}

@end
