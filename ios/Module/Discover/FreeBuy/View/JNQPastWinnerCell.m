//
//  JNQPastWinnerCell.m
//  Puzzle
//
//  Created by HuHuiPay on 16/12/22.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQPastWinnerCell.h"
#import "PZTitleInputView.h"
#import "UIButton+WebCache.h"

@interface JNQPastWinnerCell () {
    PZTitleInputView *_topV;
    UIButton *_headBtn;
    UILabel *_nameL;
    UILabel *_areaIpL;
    UILabel *_luckCode;
    UILabel *_inCountL;
    UILabel *_announceTimeL;
}

@end

@implementation JNQPastWinnerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _topV = [[PZTitleInputView alloc] initWithTitle:@"期数：201606071214" placeHolder:@""];
        [self.contentView addSubview:_topV];
        [_topV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.width.mas_equalTo(self.contentView);
            make.height.mas_equalTo(40);
        }];
        _topV.titleLabel.font = PZFont(14);
        _topV.titleLabel.textColor = HBColor(51, 51, 51);
        _topV.textEnable = NO;
        [[_topV rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.clickBlock) {
                self.clickBlock();
            }
        }];
        
        
        UIView *userBV = [[UIView alloc] init];
        [self.contentView addSubview:userBV];
        [userBV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_topV.mas_bottom);
            make.left.width.mas_equalTo(self.contentView);
            make.height.mas_equalTo(114);
        }];
        userBV.backgroundColor = [UIColor whiteColor];
        
        _headBtn = [[UIButton alloc] init];
        [userBV addSubview:_headBtn];
        [_headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(userBV).offset(10);
            make.left.mas_equalTo(userBV).offset(15);
            make.width.height.mas_equalTo(42.5);
        }];
        _headBtn.layer.cornerRadius = 2;
        
        _nameL = [[UILabel alloc] init];
        [userBV addSubview:_nameL];
        [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headBtn);
            make.left.mas_equalTo(_headBtn.mas_right).offset(10);
            make.height.mas_equalTo(14.8);
        }];
        _nameL.font = PZFont(14);
        _nameL.textColor = HBColor(102, 102, 102);
        _nameL.text = @"获奖用户";
        
        _areaIpL = [[UILabel alloc] init];
        [userBV addSubview:_areaIpL];
        [_areaIpL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nameL.mas_bottom).offset(5);
            make.left.height.mas_equalTo(_nameL);
        }];
        _areaIpL.font = _nameL.font;
        _areaIpL.textColor = _nameL.textColor;
        
        _luckCode = [[UILabel alloc] init];
        [userBV addSubview:_luckCode];
        [_luckCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_areaIpL.mas_bottom).offset(5);
            make.left.height.mas_equalTo(_areaIpL);
        }];
        _luckCode.font = _areaIpL.font;
        _luckCode.textColor = BasicRedColor;
        _luckCode.text = @"幸运号码：";
        
        _inCountL = [[UILabel alloc] init];
        [userBV addSubview:_inCountL];
        [_inCountL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_luckCode.mas_bottom).offset(5);
            make.left.height.mas_equalTo(_luckCode);
        }];
        _inCountL.font = _areaIpL.font;
        _inCountL.textColor = BasicRedColor;
        _inCountL.text = @"参与份数：";
        
        _announceTimeL = [[UILabel alloc] init];
        [userBV addSubview:_announceTimeL];
        [_announceTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_inCountL.mas_bottom).offset(5);
            make.left.height.mas_equalTo(_inCountL);
        }];
        _announceTimeL.font = _areaIpL.font;
        _announceTimeL.textColor =_areaIpL.textColor;
        _announceTimeL.text = @"揭晓时间：";
        /*
        UIView *line = [[UIView alloc] init];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_topV.mas_bottom);
            make.centerX.mas_equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth-30, 0.5));
        }];
        line.backgroundColor = HBColor(231, 231, 231);*/
        
        UIView *sep = [[UIView alloc] init];
        [self.contentView addSubview:sep];
        [sep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(userBV.mas_bottom);
            make.left.width.mas_equalTo(userBV);
            make.height.mas_equalTo(10);
        }];
        sep.backgroundColor = HBColor(245, 245, 245);
    }
    return self;
}

- (void)setPubM:(FBPublicModel *)pubM {
    _pubM = pubM;
    _topV.titleLabel.text = [NSString stringWithFormat:@"期数：%ld", pubM.stage];
    [_headBtn sd_setImageWithURL:[NSURL URLWithString:pubM.userIcon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@""]];
    _nameL.text = [NSString stringWithFormat:@"获奖用户：%@", pubM.userName];
    _areaIpL.text = [NSString stringWithFormat:@"(%@ IP：%@)", pubM.area, pubM.ip];
    _luckCode.text = [NSString stringWithFormat:@"幸运号码：%ld", pubM.luckCode];
    NSMutableAttributedString *luckCodeString = [[NSMutableAttributedString alloc] initWithString:_luckCode.text];
    [luckCodeString addAttribute:NSForegroundColorAttributeName value:HBColor(102, 102, 102) range:[_luckCode.text rangeOfString:@"幸运号码："]];
    _luckCode.attributedText = luckCodeString;
    _inCountL.text = [NSString stringWithFormat:@"参与份数：%ld", pubM.bidCount];
    NSMutableAttributedString *inCountString = [[NSMutableAttributedString alloc] initWithString:_inCountL.text];
    [inCountString addAttribute:NSForegroundColorAttributeName value:HBColor(102, 102, 102) range:[_inCountL.text rangeOfString:@"参与份数："]];
    _inCountL.attributedText = inCountString;
    _announceTimeL.text = [NSString stringWithFormat:@"揭晓时间：%@", pubM.finishTime];
}
@end
