//
//  JNQRedPaperView.m
//  Puzzle
//
//  Created by HuHuiPay on 17/1/16.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "JNQRedPaperView.h"
#import "UIImageView+WebCache.h"

@interface JNQRedPaperHeaderUserView : UIView {
    UIImageView *_headImgV;
    UILabel *_nameL;
    UILabel *_blessL;
}

@property (nonatomic, strong) BonusPaperModel *userPModel;

@end

@implementation JNQRedPaperHeaderUserView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *topV = [[UIView alloc] init];
        [self addSubview:topV];
        [topV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_top);
            make.left.width.mas_equalTo(self);
            make.height.mas_equalTo(SCREENHeight*2);
        }];
        topV.backgroundColor = HBColor(227, 85, 75);
        
        UIImageView *topBackV = [[UIImageView alloc] init];
        [self addSubview:topBackV];
        [topBackV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.width.mas_equalTo(self);
            make.height.mas_equalTo(60);
        }];
        [topBackV setImage:[UIImage imageNamed:@"bg_red_chat"]];
        
        _headImgV = [[UIImageView alloc] init];
        [self addSubview:_headImgV];
        [_headImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_top).offset(60);
            make.centerX.mas_equalTo(self);
            make.width.height.mas_equalTo(60);
        }];
        _headImgV.layer.cornerRadius = 2;
        
        _nameL = [[UILabel alloc] init];
        [self addSubview:_nameL];
        [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_headImgV.mas_bottom).offset(8);
            make.centerX.mas_equalTo(self);
            make.height.mas_equalTo(25);
        }];
        _nameL.font = PZFont(13);
        _nameL.textColor = HBColor(51, 51, 51);
        _nameL.textAlignment = NSTextAlignmentCenter;
        
        _blessL = [[UILabel alloc] init];
        [self addSubview:_blessL];
        [_blessL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nameL.mas_bottom);
            make.centerX.mas_equalTo(self);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(SCREENWidth-30);
        }];
        _blessL.font = PZFont(12);
        _blessL.textColor = HBColor(153, 153, 153);
        _blessL.textAlignment = NSTextAlignmentCenter;
        _blessL.numberOfLines = 2;
    }
    return self;
}

- (void)setUserPModel:(BonusPaperModel *)userPModel {
    _userPModel = userPModel;
    [_headImgV sd_setImageWithURL:[NSURL URLWithString:userPModel.sendIconUrl] placeholderImage:[UIImage imageNamed:@""]];
    _nameL.text = userPModel.sendUserName;
    _blessL.text = [userPModel.desInfo isEqualToString:@""] || userPModel.desInfo == nil ? @"恭喜发财，财源滚滚！" : userPModel.desInfo;
}

@end


@interface JNQRedPaperHeaderPriceView : UIView
@property (nonatomic, strong) UIButton *getPrice;
@property (nonatomic, assign) NSInteger mount;
@end

@implementation JNQRedPaperHeaderPriceView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _getPrice = [[UIButton alloc] init];
        [self addSubview:_getPrice];
        [_getPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(10);
            make.centerX.mas_equalTo(self);
            make.height.mas_equalTo(60);
        }];
        _getPrice.titleLabel.font = PZFont(45);
        [_getPrice setTitleColor:HBColor(51, 51, 51) forState:UIControlStateNormal];
        _getPrice.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        _getPrice.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_getPrice setTitle:@"   100" forState:UIControlStateNormal];
        
        UIButton *leftBtn = [[UIButton alloc] init];
        [_getPrice addSubview:leftBtn];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_getPrice);
            make.bottom.mas_equalTo(_getPrice).offset(-16);
            make.width.height.mas_equalTo(30);
        }];
        [leftBtn setImage:[UIImage imageNamed:@"xitengbi"] forState:UIControlStateNormal];
        leftBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        
        UILabel *attenL = [[UILabel alloc] init];
        [self addSubview:attenL];
        [attenL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_getPrice.mas_bottom);
            make.centerX.mas_equalTo(self);
            make.height.mas_equalTo(50);
        }];
        attenL.font = PZFont(13);
        attenL.textColor = HBColor(227, 85, 75);
        attenL.textAlignment = NSTextAlignmentCenter;
        attenL.text = @"已存入喜腾账户";
    }
    return self;
}

- (void)setMount:(NSInteger)mount {
    _mount = mount;
    [_getPrice setTitle:[NSString stringWithFormat:@"   %ld", mount] forState:UIControlStateNormal];
}

@end

@implementation JNQRedPaperHeaderView {
    JNQRedPaperHeaderUserView *_userV;
    JNQRedPaperHeaderPriceView *_priceV;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _userV = [[JNQRedPaperHeaderUserView alloc] init];
        [self addSubview:_userV];
        [_userV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.width.mas_equalTo(self);
            make.height.mas_equalTo(153);
        }];
        
        _priceV = [[JNQRedPaperHeaderPriceView alloc] init];
        [self addSubview:_priceV];
        [_priceV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_userV.mas_bottom);
            make.left.width.mas_equalTo(self);
            make.height.mas_equalTo(127);
        }];
        _priceV.hidden = YES;
    }
    return self;
}

- (void)setIsSend:(BOOL)isSend {
    _isSend = isSend;
}

- (void)setPModel:(BonusPaperModel *)pModel {
    _pModel = pModel;
    _userV.userPModel = pModel;
    if ([pModel.place isEqualToString:@"group"] || [pModel.place isEqualToString:@"friendCircle"]) {
        if (([pModel.status isEqualToString:@"empty_finish"] && [pModel.isReceive isEqualToString:@"noReceive"]) || ([pModel.status isEqualToString:@"running"] && [pModel.isReceive isEqualToString:@"noReceive"])) {
            _priceV.hidden = YES;
        } else if (([pModel.status isEqualToString:@"empty_finish"] && [pModel.isReceive isEqualToString:@"alreadyReceive"]) || ([pModel.status isEqualToString:@"running"] && [pModel.isReceive isEqualToString:@"alreadyReceive"]) || ([pModel.status isEqualToString:@"time_out"] && [pModel.isReceive isEqualToString:@"alreadyReceive"])) {
            _priceV.hidden = NO;
        }
    } else {
        _priceV.hidden = _isSend;
    }
    _priceV.mount = [pModel.place isEqualToString:@"group"] || [pModel.place isEqualToString:@"friendCircle"] ? pModel.selfReceiveMonut : pModel.mount;
}

@end

@implementation JNQRedPaperView



@end
