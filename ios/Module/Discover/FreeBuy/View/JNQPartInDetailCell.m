//
//  JNQPartInDetailCell.m
//  Puzzle
//
//  Created by HuHuiPay on 16/12/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQPartInDetailCell.h"
#import "UIButton+WebCache.h"

@interface JNQPartInDetailCell () {
    UIButton *_headBtn;
    UILabel *_userNameL;
    UIButton *_sexBtn;
    UILabel *_inTimeL;
    UILabel *_inCountL;
    UILabel *_areaL;
    UILabel *_ipL;
}

@end

@implementation JNQPartInDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _headBtn = [[UIButton alloc] init];
        [self.contentView addSubview:_headBtn];
        [_headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView).offset(10);
            make.left.mas_equalTo(self.contentView).offset(15);
            make.width.height.mas_equalTo(42.5);
        }];
        _headBtn.layer.masksToBounds = YES;
        _headBtn.layer.borderColor = HBColor(231, 231, 231).CGColor;
        _headBtn.layer.borderWidth = 0.5;
        _headBtn.layer.cornerRadius = 3;
        [[_headBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.buttonBlock) {
                self.buttonBlock(_headBtn);
            }
        }];
        
        _userNameL = [[UILabel alloc] init];
        [self.contentView addSubview:_userNameL];
        [_userNameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headBtn).offset(3.25);
            make.left.mas_equalTo(_headBtn.mas_right).offset(10);
            make.height.mas_equalTo(18);
        }];
        _userNameL.font = PZFont(15);
        _userNameL.textColor = BasicBlueColor;
        
        _sexBtn = [[UIButton alloc] init];
        [self.contentView addSubview:_sexBtn];
        [_sexBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_userNameL.mas_right).offset(5);
            make.centerY.mas_equalTo(_userNameL);
            make.width.height.mas_equalTo(13.5);
        }];
        [_sexBtn setImage:[UIImage imageNamed:@"icon_girl"] forState:UIControlStateNormal];
        [_sexBtn setImage:[UIImage imageNamed:@"icon_man"] forState:UIControlStateSelected];
        
        _inTimeL = [[UILabel alloc] init];
        [self.contentView addSubview:_inTimeL];
        [_inTimeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_userNameL.mas_bottom);
            make.left.height.mas_equalTo(_userNameL);
        }];
        _inTimeL.font = PZFont(14);
        _inTimeL.textColor = HBColor(102, 102, 102);
        
        _inCountL = [[UILabel alloc] init];
        [self.contentView addSubview:_inCountL];
        [_inCountL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headBtn.mas_bottom).offset(5);
            make.left.mas_equalTo(_userNameL);
            make.height.mas_equalTo(13.5);
        }];
        _inCountL.font = PZFont(14);
        _inCountL.textColor = HBColor(102, 102, 102);
        
        _areaL = [[UILabel alloc] init];
        [self.contentView addSubview:_areaL];
        [_areaL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_inCountL.mas_bottom).offset(4);
            make.left.mas_equalTo(_inCountL);
            make.height.mas_equalTo(12.5);
        }];
        _areaL.font = PZFont(13);
        _areaL.textColor = HBColor(153, 153, 153);
        
        _ipL = [[UILabel alloc] init];
        [self.contentView addSubview:_ipL];
        [_ipL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.mas_equalTo(_areaL);
            make.left.mas_equalTo(_areaL.mas_right).offset(7.5);
        }];
        _ipL.font = PZFont(13);
        _ipL.textColor = HBColor(153, 153, 153);
        
        UIView *line = [[UIView alloc] init];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self.contentView);
            make.height.mas_equalTo(0.5);
        }];
        line.backgroundColor = HBColor(231, 231, 231);
    }
    return self;
}

- (void)setBidRecodModel:(JNQFBBidRecodModel *)bidRecodModel {
    _bidRecodModel = bidRecodModel;
    [_headBtn sd_setImageWithURL:[NSURL URLWithString:bidRecodModel.userIcon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@""]];
    _userNameL.text = bidRecodModel.userName;
    _sexBtn.selected = [bidRecodModel.sex isEqualToString:@"man"] ? YES : NO;
    _inTimeL.text = bidRecodModel.createTime;
    _inCountL.text = [NSString stringWithFormat:@"参与份数：%ld", bidRecodModel.bidCount];
    _areaL.text = bidRecodModel.area;
    _ipL.text = [NSString stringWithFormat:@"IP:%@",bidRecodModel.ip];
}

@end
