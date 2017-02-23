//
//  JNQRedPaperClickedView.m
//  Puzzle
//
//  Created by HuHuiPay on 17/1/16.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "JNQRedPaperClickedView.h"
#import "UIImageView+WebCache.h"

@interface JNQRedPaperPreView : UIView {
    UIImageView *_headImgV;
    UILabel *_userNameL;
    UILabel *_attenL;
    UILabel *_blessL;
}
@property (nonatomic, strong) UIButton *getListBtn;
@property (nonatomic, strong) UIButton *getBtn;
@property (nonatomic, strong) BonusPaperModel *prePModel;
@property (nonatomic, assign) BOOL isSend;
@end

@implementation JNQRedPaperPreView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *back = [[UIImageView alloc] init];
        [self addSubview:back];
        [back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(self);
        }];
        [back setImage:[UIImage imageNamed:@"red_packet_lg"]];
        
        _getBtn = [[UIButton alloc] init];
        [self addSubview:_getBtn];
        [_getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self.mas_top).offset(CGRectGetHeight(frame)*190/866);
            make.width.height.mas_equalTo(100);
        }];
        _getBtn.layer.cornerRadius = 50;
        _getBtn.tag = 888;
        
        _headImgV = [[UIImageView alloc] init];
        [self addSubview:_headImgV];
        [_headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self);
            make.width.height.mas_equalTo(47.5);
        }];
        _headImgV.layer.cornerRadius = 2;
        
        _userNameL = [[UILabel alloc] init];
        [self addSubview:_userNameL];
        [_userNameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headImgV.mas_bottom);
            make.centerX.mas_equalTo(self);
            make.height.mas_equalTo(25);
        }];
        _userNameL.font = PZFont(13);
        _userNameL.textColor = HBColor(250, 216, 155);
        _userNameL.textAlignment = NSTextAlignmentCenter;
        
        _attenL = [[UILabel alloc] init];
        [self addSubview:_attenL];
        [_attenL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_userNameL.mas_bottom);
            make.centerX.mas_equalTo(self);
            make.height.mas_equalTo(20);
        }];
        _attenL.font = PZFont(13);
        _attenL.textColor = HBColor(250, 216, 155);
        _attenL.textAlignment = NSTextAlignmentCenter;
        
        _blessL = [[UILabel alloc] init];
        [self addSubview:_blessL];
        [_blessL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self).offset(-50);
            make.centerX.mas_equalTo(self);
            make.height.mas_equalTo(45);
            make.width.mas_equalTo(SCREENWidth-50-30);
        }];
        _blessL.font = PZFont(18);
        _blessL.textColor = HBColor(250, 216, 155);
        _blessL.textAlignment = NSTextAlignmentCenter;
        _blessL.numberOfLines = 2;
        
        _getListBtn = [[UIButton alloc] init];
        [self addSubview:_getListBtn];
        [_getListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.bottom.mas_equalTo(self).offset(-5);
            make.height.mas_equalTo(50);
        }];
        _getListBtn.backgroundColor = [UIColor clearColor];
        _getListBtn.titleLabel.font = PZFont(12);
        [_getListBtn setTitleColor:HBColor(250, 216, 155) forState:UIControlStateNormal];
        _getListBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_getListBtn setTitle:@"查看大家的手气 > " forState:UIControlStateNormal];
        _getListBtn.tag = 666;
        _getListBtn.hidden = YES;
    }
    return self;
}

- (void)setPrePModel:(BonusPaperModel *)prePModel {
    _prePModel = prePModel;
    [_headImgV sd_setImageWithURL:[NSURL URLWithString:prePModel.sendIconUrl] placeholderImage:[UIImage imageNamed:@""]];
    _userNameL.text = prePModel.sendUserName;
    _blessL.text = [prePModel.desInfo isEqualToString:@""] || prePModel.desInfo == nil ? @"恭喜发财，财源滚滚！" : prePModel.desInfo;
  if ((_isSend && ([prePModel.bonusType isEqualToString:@"average"] ||
                   [prePModel.place isEqualToString:@"single"])) ||
      (!_isSend&&(![prePModel.status isEqualToString:@"empty_finish"] ||
                  ([prePModel.status isEqualToString:@"empty_finish"]&&[prePModel.bonusType isEqualToString:@"average"])))) {
    _getListBtn.hidden = YES;
  } else if ([prePModel.bonusType isEqualToString:@"random"]&&(_isSend||(!_isSend&&[prePModel.status isEqualToString:@"empty_finish"]))) {
    _getListBtn.hidden = NO;
  }
    _attenL.text = [prePModel.bonusType isEqualToString:@"random"] && ([prePModel.place isEqualToString:@"friendCircle"] || [prePModel.place isEqualToString:@"group"]) ? @"发了一个红包，金额随机" : @"给你发了一个红包";
}

@end

@interface JNQRedPaperOverView : UIView
@property (nonatomic, strong) BonusPaperModel *overPModel;
@property (nonatomic, strong) UIButton *getListBtn;
@property (nonatomic, assign) BOOL isTimeOut;
@property (nonatomic, assign) BOOL isSend;
@end

@implementation JNQRedPaperOverView {
    UIImageView *_headImgV;
    UILabel *_userNameL;
    UILabel *_attenL;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *back = [[UIImageView alloc] init];
        [self addSubview:back];
        [back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.mas_equalTo(self);
        }];
        [back setImage:[UIImage imageNamed:@"red-packet_lg_finished"]];
        
        _headImgV = [[UIImageView alloc] init];
        [self addSubview:_headImgV];
        [_headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self).offset(-frame.size.height/4);
            make.width.height.mas_equalTo(47.5);
        }];
        _headImgV.layer.cornerRadius = 2;
        
        _userNameL = [[UILabel alloc] init];
        [self addSubview:_userNameL];
        [_userNameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(_headImgV.mas_bottom);
            make.height.mas_equalTo(35);
        }];
        _userNameL.font = PZFont(13);
        _userNameL.textColor = HBColor(250, 216, 155);
        _userNameL.textAlignment = NSTextAlignmentCenter;
        
        _attenL = [[UILabel alloc] init];
        [self addSubview:_attenL];
        [_attenL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.bottom.mas_equalTo(self.mas_centerY);
            make.height.mas_equalTo(50);
        }];
        _attenL.font = PZFont(20);
        _attenL.textColor = HBColor(250, 216, 155);
        _attenL.textAlignment = NSTextAlignmentCenter;
        
        _getListBtn = [[UIButton alloc] init];
        [self addSubview:_getListBtn];
        [_getListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.bottom.mas_equalTo(self).offset(-20);
            make.height.mas_equalTo(28);
        }];
        _getListBtn.backgroundColor = [UIColor clearColor];
        _getListBtn.titleLabel.font = PZFont(12);
        [_getListBtn setTitleColor:HBColor(250, 216, 155) forState:UIControlStateNormal];
        _getListBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_getListBtn setTitle:@"查看大家的手气> " forState:UIControlStateNormal];
        _getListBtn.tag = 666;
        _getListBtn.hidden = NO;
    }
    return self;
}

- (void)setOverPModel:(BonusPaperModel *)overPModel {
    _overPModel = overPModel;
    [_headImgV sd_setImageWithURL:[NSURL URLWithString:overPModel.sendIconUrl] placeholderImage:[UIImage imageNamed:@""]];
    _userNameL.text = overPModel.sendUserName;
    if ([overPModel.status isEqualToString:@"time_out"]) {
        _attenL.text = @"该红包已过期";
    } else if ([overPModel.bonusType isEqualToString:@"random"]&&[overPModel.status isEqualToString:@"empty_finish"]) {
        _attenL.text = @"手慢了，红包派完了";
    } else if ([overPModel.bonusType isEqualToString:@"average"]&&[overPModel.status isEqualToString:@"empty_finish"]) {
        _attenL.text = @"该红包已被领取";
    }
  if ((_isSend && ([overPModel.bonusType isEqualToString:@"average"] ||
                   [overPModel.place isEqualToString:@"single"])) ||
      (!_isSend&&(![overPModel.status isEqualToString:@"empty_finish"] ||
                  ([overPModel.status isEqualToString:@"empty_finish"]&&[overPModel.bonusType isEqualToString:@"average"])))) {
    _getListBtn.hidden = YES;
  } else if ([overPModel.bonusType isEqualToString:@"random"]&&(_isSend||(!_isSend&&[overPModel.status isEqualToString:@"empty_finish"]))) {
    _getListBtn.hidden = NO;
  }
}
@end


@implementation JNQRedPaperClickedView {
    JNQRedPaperPreView *_preV;
    JNQRedPaperOverView *_overV;
    UIButton *_quitBtn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _preV = [[JNQRedPaperPreView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [self addSubview:_preV];
        [_preV.getBtn addTarget:self action:@selector(btnsDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_preV.getListBtn addTarget:self action:@selector(btnsDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _preV.hidden = YES;
        
        _overV = [[JNQRedPaperOverView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        [self addSubview:_overV];
        [_overV.getListBtn addTarget:self action:@selector(btnsDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _overV.hidden = YES;
        
        _quitBtn = [[UIButton alloc] init];
        [self addSubview:_quitBtn];
        [_quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(self);
            make.width.height.mas_equalTo(44);
        }];
        _quitBtn.tag = 100;
        [_quitBtn setTitleColor:[[UIColor blackColor] colorWithAlphaComponent:0.4] forState:UIControlStateNormal];
        [_quitBtn setTitle:@"x" forState:UIControlStateNormal];
        [_quitBtn addTarget:self action:@selector(btnsDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setPModel:(BonusPaperModel *)pModel {
    _pModel = pModel;
    _preV.hidden = [pModel.status isEqualToString:@"running"] ? NO : YES;
    _overV.hidden = [pModel.status isEqualToString:@"running"] ? YES : NO;
    _preV.prePModel = pModel;
    _overV.overPModel = pModel;
    
}

- (void)setIsOver:(BOOL)isOver {
    _isOver = isOver;
    _overV.hidden = isOver ? NO : YES;
    _preV.hidden = isOver ? YES : NO;
}

- (void)setIsTimeOut:(BOOL)isTimeOut {
    _isTimeOut = isTimeOut;
    _overV.isTimeOut = isTimeOut;
}

- (void)setIsSend:(BOOL)isSend {
    _isSend = isSend;
    _preV.isSend = isSend;
    _overV.isSend = isSend;
}

- (void)btnsDidClicked:(UIButton *)button {
    if (self.btnBlock) {
        self.btnBlock(button);
    }
}

@end




