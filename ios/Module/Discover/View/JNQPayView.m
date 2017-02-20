//
//  JNQPayView.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQPayView.h"
#import "UIImageView+WebCache.h"
@implementation JNQPayView

@end

@implementation JNQPayHeaderView {
    //钻石
//    UILabel *_diamondCount;
//    UILabel *_diamondPrice;
//    UIImageView *_diamondImg;
    //会员
    UILabel *_vipType;
    UILabel *_vipPayCount;
    //代理
    
    UIImageView *_imgView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HBColor(245, 245, 245);
        
        _backBtn = [[HBVerticalBtn alloc] initWithIcon:@"icon_pay-success" title:@""];
        [self addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(15, -0.5, 15, -0.5));
        }];
        _backBtn.layer.borderColor = HBColor(231, 231, 231).CGColor;
        _backBtn.layer.borderWidth = 0.5;
        _backBtn.backgroundColor = [UIColor whiteColor];
        [_backBtn setFontSize:15];
        _backBtn.hidden = YES;
        
        //会员
        _vipPayBackView = [[UIView alloc] init];
        [self addSubview:_vipPayBackView];
        [_vipPayBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
            make.width.mas_equalTo(SCREENWidth+1);
            make.height.mas_equalTo(65);
        }];
        _vipPayBackView.backgroundColor = [UIColor whiteColor];
        _vipPayBackView.layer.borderColor = HBColor(231, 231, 231).CGColor;
        _vipPayBackView.layer.borderWidth = 0.5;
        _vipPayBackView.hidden = YES;
        
        UILabel *vipAtten = [[UILabel alloc] init];
        [_vipPayBackView addSubview:vipAtten];
        [vipAtten mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(_vipPayBackView).offset(12);
            make.height.mas_equalTo(18);
        }];
        vipAtten.font = PZFont(15);
        vipAtten.textColor = HBColor(51, 51, 51);
        vipAtten.text = @"购买：";
        
        UILabel *vipAtten2 = [[UILabel alloc] init];
        [_vipPayBackView addSubview:vipAtten2];
        [vipAtten2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(vipAtten.mas_bottom).offset(5);
            make.left.height.mas_equalTo(vipAtten);
        }];
        vipAtten2.font = PZFont(15);
        vipAtten2.textColor = HBColor(51, 51, 51);
        vipAtten2.text = @"实付金额：";
        
        _vipType = [[UILabel alloc] init];
        [_vipPayBackView addSubview:_vipType];
        [_vipType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.bottom.mas_equalTo(vipAtten);
            make.left.mas_equalTo(vipAtten.mas_right);
        }];
        _vipType.font = PZFont(13);
        _vipType.textColor = HBColor(51, 51, 51);
        
        _vipPayCount = [[UILabel alloc] init];
        [_vipPayBackView addSubview:_vipPayCount];
        [_vipPayCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.bottom.mas_equalTo(vipAtten2);
            make.left.mas_equalTo(vipAtten2.mas_right);
        }];
        _vipPayCount.font = PZFont(15);
        _vipPayCount.textColor = BasicRedColor;
    }
    return self;
}

//支付结果
- (void)setPayResult:(NSString *)payResult {
    [_backBtn setFontSize:16];
    if ([payResult isEqualToString:@"paySuccess"]) {
        [_backBtn setTitle:@"支付成功"];
        [_backBtn setIcon:@"icon_pay-success"];
        [_backBtn setTextColor:BasicBlueColor];
    } else if ([payResult isEqualToString:@"payFail"]) {
        [_backBtn setTitle:@"支付失败"];
        [_backBtn setIcon:@"icon_pay_failure"];
        [_backBtn setTextColor:BasicRedColor];
    } else if ([payResult isEqualToString:@"exchangeSuccess"]) {
        [_backBtn setTitle:@"兑换成功"];
        [_backBtn setIcon:@"icon_pay-success"];
        [_backBtn setTextColor:BasicBlueColor];
    } else if ([payResult isEqualToString:@"exchangeFail"]) {
        [_backBtn setTitle:@"兑换失败"];
        [_backBtn setIcon:@"icon_pay_failure"];
        [_backBtn setTextColor:BasicRedColor];
    }
}

//会员相关
- (void)setVipModel:(JNQVIPModel *)vipModel {
    _vipModel = vipModel;
    _vipType.text = vipModel.identityName;
    _vipPayCount.text = [NSString stringWithFormat:@"￥ %.2f", (float)vipModel.price/100];
    NSMutableAttributedString *vipPriceString = [[NSMutableAttributedString alloc] initWithString:_vipPayCount.text];
    [vipPriceString addAttribute:NSFontAttributeName value:PZFont(12) range:[_vipPayCount.text rangeOfString:@"￥"]];
    _vipPayCount.attributedText = vipPriceString;
}

//代理相关
- (void)setPayCount:(NSInteger)payCount {
    _payCount = payCount;
    [_backBtn setFontSize:1.5];
    _backBtn.titleView.numberOfLines = 3;
    [_backBtn setTitle:[NSString stringWithFormat:@"喜鹊加盟费\n\n￥ %.2f", (float)payCount/100]];
    [_backBtn setTextColor:BasicRedColor];
    NSMutableAttributedString *payCountString = [[NSMutableAttributedString alloc] initWithString:_backBtn.titleView.text];
    [payCountString addAttribute:NSFontAttributeName value:PZFont(18) range:[_backBtn.titleView.text rangeOfString:[NSString stringWithFormat:@"%.2f", (float)payCount/100]]];
    [payCountString addAttribute:NSFontAttributeName value:PZFont(13) range:[_backBtn.titleView.text rangeOfString:@"喜鹊加盟费"]];
    [payCountString addAttribute:NSFontAttributeName value:PZFont(12) range:[_backBtn.titleView.text rangeOfString:@"￥"]];
    [payCountString addAttribute:NSForegroundColorAttributeName value:HBColor(51, 51, 51) range:[_backBtn.titleView.text rangeOfString:@"喜鹊加盟费"]];
    _backBtn.titleView.attributedText = payCountString;
    [_backBtn setIcon:@""];
}

@end


@implementation JNQPayDiamondHeaderView {
    UIImageView *_imgView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HBColor(245, 245, 245);
        
        _diamondPayBackView = [[UIView alloc] init];
        [self addSubview:_diamondPayBackView];
        [_diamondPayBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(15);
            make.centerX.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth+1, 90));
        }];
        _diamondPayBackView.backgroundColor = [UIColor whiteColor];
        _diamondPayBackView.layer.borderColor = HBColor(231, 231, 231).CGColor;
        _diamondPayBackView.layer.borderWidth = 0.5;
//        _diamondPayBackView.hidden = YES;
        
        _imgView = [[UIImageView alloc] init];
        _imgView.backgroundColor = [UIColor whiteColor];
        [_diamondPayBackView addSubview:_imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_diamondPayBackView);
            make.left.mas_equalTo(_diamondPayBackView).offset(12);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
        _diamondCount = [[UILabel alloc] init];
        [_diamondPayBackView addSubview:_diamondCount];
        [_diamondCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_imgView).offset(10);
            make.left.mas_equalTo(_imgView.mas_right).offset(12);
            make.height.mas_equalTo(16);
        }];
        _diamondCount.font = PZFont(15);
        _diamondCount.textColor = HBColor(51, 51, 51);
        
        _diamondGiveCount = [[UILabel alloc] init];
        [_diamondPayBackView addSubview:_diamondGiveCount];
        [_diamondGiveCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_diamondCount.mas_bottom).offset(8);
            make.left.mas_equalTo(_diamondCount);
            make.height.mas_equalTo(15);
        }];
        _diamondGiveCount.font = PZFont(12.5);
        _diamondGiveCount.textColor = HBColor(153, 153, 153);
        
        _payPrice = [[UILabel alloc] init];
        [self addSubview:_payPrice];
        [_payPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_diamondPayBackView.mas_bottom).offset(-0.5);
            make.centerX.width.mas_equalTo(_diamondPayBackView);
            make.height.mas_equalTo(40);
        }];
        _payPrice.backgroundColor = [UIColor whiteColor];
        _payPrice.font = PZFont(12);
        _payPrice.textColor = BasicRedColor;
        _payPrice.textAlignment = NSTextAlignmentCenter;
        _payPrice.layer.borderColor = HBColor(231, 231, 231).CGColor;
        _payPrice.layer.borderWidth = 0.5;
    }
    return self;
}

- (void)setConfirmModel:(JNQConfirmOrderModel *)confirmModel {
    _confirmModel = confirmModel;
    if (_viewType == 1) {
        _diamondCount.text = [NSString stringWithFormat:@"钻石%ld颗", confirmModel.realTotalFee/100];
        _diamondGiveCount.text = [NSString stringWithFormat:@"兑换喜腾币%ld，赠送喜腾币%ld", confirmModel.exchangeXtbCount, confirmModel.giveXtbCount];
        _payPrice.text = [NSString stringWithFormat:@"￥%.2f", (float)confirmModel.realTotalFee/100];
        NSMutableAttributedString *payPriceString = [[NSMutableAttributedString alloc] initWithString:_payPrice.text];
        [payPriceString addAttribute:NSFontAttributeName value:PZFont(15) range:[_payPrice.text rangeOfString:[NSString stringWithFormat:@"%ld", confirmModel.realTotalFee/100]]];
        _payPrice.attributedText = payPriceString;
    } else if (_viewType == 7) {

        _diamondCount.text = confirmModel.desc;
        [_imgView sd_setImageWithURL:[NSURL URLWithString:confirmModel.iconstr] placeholderImage:DefaultImage];
        _diamondGiveCount.textColor = BasicRedColor;
        _diamondGiveCount.text = [NSString stringWithFormat:@"%.0f颗钻", (float)confirmModel.realTotalFee/100];
        _payPrice.text = [NSString stringWithFormat:@"￥%.2f", (float)confirmModel.realTotalFee/100];
        NSMutableAttributedString *realFeeString = [[NSMutableAttributedString alloc] initWithString:_payPrice.text];
        [realFeeString addAttribute:NSFontAttributeName value:PZFont(15) range:[_payPrice.text rangeOfString:[NSString stringWithFormat:@"%ld", confirmModel.realTotalFee/100]]];
        _payPrice.attributedText = realFeeString;
    }
}
-(void)setDiamondModel:(JNQDiamondModel *)diamondModel {
    _diamondModel = diamondModel;
    _diamondCount.text = [NSString stringWithFormat:@"钻石%d颗", diamondModel.diamondCount];
    _diamondGiveCount.text = [NSString stringWithFormat:@"赠送%d颗", diamondModel.giveDiamondCount];
    _payPrice.text = [NSString stringWithFormat:@"￥%.2f", (float)diamondModel.price/100];
    NSMutableAttributedString *payPriceString = [[NSMutableAttributedString alloc] initWithString:_payPrice.text];
    [payPriceString addAttribute:NSFontAttributeName value:PZFont(15) range:[_payPrice.text rangeOfString:[NSString stringWithFormat:@"%.2f", (float)diamondModel.price/100]]];
    _payPrice.attributedText = payPriceString;
}

- (void)setVipModel:(JNQVIPModel *)vipModel {
    _vipModel = vipModel;
    _diamondGiveCount.textColor = BasicRedColor;
    _diamondCount.text = vipModel.identityName;
    _diamondGiveCount.text = [NSString stringWithFormat:@"%.0f颗钻", (float)vipModel.price/100];
    _payPrice.text = [NSString stringWithFormat:@"￥%.2f", (float)vipModel.price/100];
    NSMutableAttributedString *realFeeString = [[NSMutableAttributedString alloc] initWithString:_payPrice.text];
    [realFeeString addAttribute:NSFontAttributeName value:PZFont(15) range:[_payPrice.text rangeOfString:[NSString stringWithFormat:@"%.0f", vipModel.price/100]]];
    _payPrice.attributedText = realFeeString;
    if ([_vipModel.identityName isEqualToString:@"黄金会员"]) {
        [_imgView setImage:[UIImage imageNamed:@"icon_goldvip-1"]];
    } else if ([_vipModel.identityName isEqualToString:@"铂金会员"]) {
        [_imgView setImage:[UIImage imageNamed:@"icon_Platinum-vip-1"]];
    } else if ([_vipModel.identityName isEqualToString:@"钻石会员"]) {
        [_imgView setImage:[UIImage imageNamed:@"icon_diamonds-vip-1"]];
    }
}

- (void)setViewType:(NSInteger)viewType {
    _viewType = viewType;
    if (viewType == 1) {
        [_imgView setImage:[UIImage imageNamed:@"diamonds_photo_list"]];
    } else if (viewType == 3) {
    } else if (viewType == 7) {
        [_imgView setImage:[UIImage imageNamed:@"member_icon_y"]];
    }
}
@end







@implementation JNQPayReadyFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _payBtn = [[UIButton alloc] initWithFrame:CGRectMake(22.5, 35, SCREENWidth-45, 40)];
        [self addSubview:_payBtn];
        _payBtn.backgroundColor = [UIColor colorWithHexString:@"4964ef"];
        _payBtn.layer.cornerRadius = 3;
        [_payBtn setTitle:@"立即支付" forState:UIControlStateNormal];
        [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return self;
}

@end

@implementation JNQPayFooterView {
    UIView *_backView;
    UILabel *_payOrderNo;
    UILabel *_payUse;
    UILabel *_atten;
    UILabel *_payCount;
    UILabel *_payType;
    UILabel *_payTime;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HBColor(245, 245, 245);
        
        _backView = [[UIView alloc] init];
        [self addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(self);
            make.height.mas_equalTo(115);
        }];
        _backView.backgroundColor = [UIColor whiteColor];
        
        //交易单号
        _payOrderNo = [[UILabel alloc] init];
        [_backView addSubview:_payOrderNo];
        [_payOrderNo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(_backView).offset(15);
            make.height.mas_equalTo(17);
        }];
        _payOrderNo.font = PZFont(15);
        _payOrderNo.textColor = HBColor(51, 51, 51);
        
        //购买什么
        _payUse = [[UILabel alloc] init];
        [_backView addSubview:_payUse];
        [_payUse mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_payOrderNo.mas_bottom).offset(10);
            make.left.height.mas_equalTo(_payOrderNo);
        }];
        _payUse.font = PZFont(15);
        _payUse.textColor = HBColor(51, 51, 51);
        
        _atten = [[UILabel alloc] init];
        [_backView addSubview:_atten];
        [_atten mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_payUse.mas_bottom).offset(10);
            make.left.mas_equalTo(_payUse);
            make.height.mas_equalTo(17);
        }];
        _atten.font = PZFont(13);
        _atten.textColor = HBColor(51, 51, 51);
        
        //支付金额
        _payCount = [[UILabel alloc] init];
        [_backView addSubview:_payCount];
        [_payCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_payUse.mas_bottom).offset(37);
            make.left.height.mas_equalTo(_payOrderNo);
        }];
        _payCount.font = PZFont(15);
        _payCount.textColor = HBColor(51, 51, 51);
        
        //支付方式
        _payType = [[UILabel alloc] init];
        [_backView addSubview:_payType];
        [_payType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_payCount.mas_bottom).offset(10);
            make.left.height.mas_equalTo(_payOrderNo);
        }];
        _payType.font = PZFont(15);
        _payType.textColor = HBColor(51, 51, 51);
        
        //交易时间
        _payTime = [[UILabel alloc] init];
        [_backView addSubview:_payTime];
        [_payTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_payType.mas_bottom).offset(10);
            make.left.height.mas_equalTo(_payOrderNo);
        }];
        _payTime.font = PZFont(15);
        _payTime.textColor = HBColor(51, 51, 51);
        
        //重新支付
        _payBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 175, SCREENWidth-30, 40)];
        [self addSubview:_payBtn];
        _payBtn.backgroundColor = BasicBlueColor;
        [_payBtn setTitle:@"重新支付" forState:UIControlStateNormal];
        _payBtn.hidden = YES;
        
        //取消支付
        _quitBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(_payBtn.frame)+10, SCREENWidth-30, 40)];
        [self addSubview:_quitBtn];
        _quitBtn.backgroundColor = HBColor(153, 153, 153);
        [_quitBtn setTitle:@"取消支付" forState:UIControlStateNormal];
        _quitBtn.hidden = YES;
    }
    return self;
}
//(1钻石 2喜腾币 3会员 4兑换商品 5喜鹊代理)
- (void)setOrderType:(NSInteger)orderType {
    _orderType = orderType;
    CGFloat backViewHeight = orderType == 1 ? 182 : 155;
    [_backView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(backViewHeight);
    }];
    CGFloat attenHeight = orderType == 1 ? 17 : 0;
    [_atten mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(attenHeight);
    }];
    CGFloat margin = orderType == 1 ? 37 : 10;
    [_payCount mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_payUse.mas_bottom).offset(margin);
    }];
}

- (void)setConfirmOrderModel:(JNQConfirmOrderModel *)confirmOrderModel {
    _confirmOrderModel = confirmOrderModel;
    _payOrderNo.text = [NSString stringWithFormat:@"交易单号：%ld", confirmOrderModel.orderId];
    NSString *str;
    if (_orderType == 1) {
        str = [NSString stringWithFormat:@"购买钻石：%ld颗", confirmOrderModel.realTotalFee/100];
        _atten.text = _isDelegateBuyDiamond == YES?@"":[NSString stringWithFormat:@"(兑换喜腾币：%ld   赠送喜腾币：%ld)", confirmOrderModel.exchangeXtbCount, confirmOrderModel.giveXtbCount];
    } else if (_orderType == 3) {
        str = [NSString stringWithFormat:@"购买会员：%@", _vipIdentity];
    } else if (_orderType == 4) {
        str = @"购买商品：兑换礼品";
        _payType.text = @"支付方式：喜腾币支付";
    } else if (_orderType == 5) {
        str = @"支付代理：喜鹊代理";
    } else if (_orderType == 7) {
        str = @"购买会员：每日运程会员";
    }
    _payUse.text = str;
    NSString *payCountStr = _orderType == 4 ? [NSString stringWithFormat:@"支付喜腾币：%.0f", (float)confirmOrderModel.realTotalFee] : [NSString stringWithFormat:@"支付金额：%.2f元", (float)confirmOrderModel.realTotalFee/100];
    _payCount.text = payCountStr;
    _payTime.text = [NSString stringWithFormat:@"交易时间：%@", confirmOrderModel.createTime];
    if (_isDelegateBuyDiamond) {
        [_payCount mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_payUse.mas_bottom).offset(10);
        }];
    }else{
        [_payCount mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_atten.mas_bottom).offset(10);
        }];
    }
}

- (void)setPayTypeStr:(NSString *)payTypeStr {
    _payTypeStr = payTypeStr;
    if ([_payTypeStr isEqualToString:AlipayClient]) {
        _payType.text = @"支付方式：支付宝";
    } else if ([_payTypeStr isEqualToString:UnionPay]) {
        _payType.text = @"支付方式：银联支付";
    } else if ([_payTypeStr isEqualToString:WeixinPay]) {
        _payType.text = @"支付方式：微信支付";
    }
}

@end
