//
//  JNQConfirmOrderView.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/18.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQConfirmOrderView.h"

@implementation JNQConfirmOrderView

@end

@implementation JNQConfirmOrderHeaderView {
    UILabel *_des;
    UILabel *_atten;
    UIButton *_defaultBtn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HBColor(245, 245, 245);
        
        _nonDefaultView = [[UIView alloc] init];//WithFrame:CGRectMake(-0.5, 22.5, SCREENWidth+1, 45)];
        [self addSubview:_nonDefaultView];
        [_nonDefaultView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.centerY.mas_equalTo(self).offset(6);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth+1, 45));
        }];
        _nonDefaultView.backgroundColor = [UIColor whiteColor];
        _nonDefaultView.layer.borderColor = HBColor(231, 231, 231).CGColor;
        _nonDefaultView.layer.borderWidth = 0.5;
        _nonDefaultView.hidden = YES;
        
        _addrSelectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 45)];
        [_nonDefaultView addSubview:_addrSelectBtn];
        [_addrSelectBtn setTitle:@"选择地址" forState:UIControlStateNormal];
        [_addrSelectBtn setTitleColor:HBColor(119, 119, 119) forState:UIControlStateNormal];
        _addrSelectBtn.titleLabel.font = PZFont(15);
        [_addrSelectBtn addTarget:self action:@selector(senderDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _defaultView = [[PZTitleInputView alloc] initWithTitle:@""];
        [self addSubview:_defaultView];
        _defaultView.frame = CGRectMake(0, 0, SCREENWidth, 90);
        _defaultView.backgroundColor = [UIColor whiteColor];
        _defaultView.indicatorEnable = YES;
        _defaultView.textEnable = NO;
        [_defaultView addTarget:self action:@selector(senderDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        _defaultView.hidden = YES;
        
        _receiveNumber = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWidth/2, 15, SCREENWidth/2-30, 20)];
        [_defaultView addSubview:_receiveNumber];
        _receiveNumber.textColor = HBColor(153, 153, 153);
        _receiveNumber.font = PZFont(13);
        _receiveNumber.textAlignment = NSTextAlignmentRight;
        
        _des = [[UILabel alloc] init];
        [_defaultView addSubview:_des];
        [_des mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.defaultView).offset(12);
            make.top.mas_equalTo(self.defaultView).offset(15);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(80);
        }];
        _des.textColor = HBColor(119, 119, 119);
        _des.font = PZFont(15);
        _des.text = @"收  件  人：";
        
        _receiveName = [[UILabel alloc] init];
        [_defaultView addSubview:_receiveName];
        [_receiveName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_des);
            make.left.mas_equalTo(_des.mas_right);
            make.height.mas_equalTo(20);
            make.right.mas_equalTo(_receiveNumber.mas_left).offset(-10);
        }];
        _receiveName.textColor = HBColor(153, 153, 153);
        _receiveName.font = PZFont(13);

        _atten = [[UILabel alloc] init];
        [_defaultView addSubview:_atten];
        [_atten mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.defaultView).offset(12);
            make.top.mas_equalTo(_receiveName.mas_bottom).offset(5);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(80);
        }];
        _atten.textColor = HBColor(119, 119, 119);
        _atten.font = PZFont(15);
        _atten.text = @"收货地址：";
        
        _defaultBtn = [[UIButton alloc]init];
        [_defaultView addSubview:_defaultBtn];
        [_defaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_atten).offset(1);
            make.left.mas_equalTo(_atten.mas_right);
            make.height.mas_equalTo(14);
        }];
        _defaultBtn.contentMode = UIViewContentModeScaleAspectFit;
        [_defaultBtn setImage:[UIImage imageNamed:@"icon_d"] forState:UIControlStateNormal];

        _receiveAddr = [[UILabel alloc] init];
        [_defaultView addSubview:_receiveAddr];
        [_receiveAddr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_atten.mas_right);
            make.top.mas_equalTo(_atten);
            make.right.mas_equalTo(_defaultView).offset(-30);
//            make.bottom.mas_equalTo(_defaultView).offset(-10);
        }];
        _receiveAddr.textColor = HBColor(153, 153, 153);
        _receiveAddr.font = PZFont(13.5);
        _receiveAddr.numberOfLines = 0;
        
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"addrDefault-16"]];
        [_defaultView addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(_defaultView);
            make.height.mas_equalTo(2);
        }];
    }
    return self;
}

- (void)senderDidClicked:(id)sender {
    if (self.block) {
        self.block();
    }
}

- (void)setAddrModel:(JNQAddressModel *)addrModel {
    _addrModel = addrModel;
    _receiveName.text = addrModel.recievName;
    _receiveNumber.text = addrModel.phoneNum;
    _defaultBtn.hidden = addrModel.isDefault ? NO : YES;
    
    _receiveAddr.text = addrModel.isDefault ? [NSString stringWithFormat:@"         %@", addrModel.fullAddress] : addrModel.fullAddress;
    if(addrModel.addressId != 0){
        _defaultView.hidden = !addrModel.addressId ? YES : NO;
        _nonDefaultView.hidden = !_defaultView.hidden;
    }else{
        _defaultView.hidden = !addrModel.deliveryAddressId ? YES : NO;
        _nonDefaultView.hidden = !_defaultView.hidden;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:PZFont(13.5), NSParagraphStyleAttributeName:paragraphStyle};
    CGRect rect = [_receiveAddr.text boundingRectWithSize:CGSizeMake(SCREENWidth-110, MAXFLOAT)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attributes
                                       context:nil];
    NSInteger height = rect.size.height+5 >= 35 ? 35 : rect.size.height+5;
    [_receiveAddr mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

@end

@implementation JNQConfirmOrderSectionFooterView {
    UILabel *_mailFeeLabel;
    UILabel *_secTotalCountLabel;
    UIButton *_secTotalPriceBtn;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
//        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(-0.5, 0, SCREENWidth+1, 35)];
//        [self addSubview:topView];
//        topView.backgroundColor = [UIColor whiteColor];
//        topView.layer.borderColor = HBColor(231, 231, 231).CGColor;
//        topView.layer.borderWidth = 0.5;
//        
//        UILabel *atten = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, SCREENWidth/2-12, 35)];
//        [topView addSubview:atten];
//        atten.textColor = HBColor(119, 119, 119);
//        atten.font = PZFont(14);
//        atten.text = @"快递费用：";
//        
//        _mailFeeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWidth/2, 0, SCREENWidth/2-12, 35)];
//        [topView addSubview:_mailFeeLabel];
//        _mailFeeLabel.textColor = HBColor(119, 119, 119);
//        _mailFeeLabel.font = PZFont(14);
//        _mailFeeLabel.textAlignment = NSTextAlignmentRight;
        
        UIView *botView = [[UIView alloc] initWithFrame:CGRectMake(-0.5, 0, SCREENWidth+1, 35)];
        [self addSubview:botView];
        botView.backgroundColor = [UIColor whiteColor];
        botView.layer.borderColor = HBColor(231, 231, 231).CGColor;
        botView.layer.borderWidth = 0.5;
        
        _secTotalPriceBtn = [[UIButton alloc] init];
        [botView addSubview:_secTotalPriceBtn];
        [_secTotalPriceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(botView);
            make.right.mas_equalTo(botView).offset(-12);
        }];
        _secTotalPriceBtn.titleLabel.font = PZFont(14);
        [_secTotalPriceBtn setTitleColor:BasicRedColor forState:UIControlStateNormal];
        [_secTotalPriceBtn setImage:[UIImage imageNamed:@"icon_big"] forState:UIControlStateNormal];
        _secTotalPriceBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        UILabel *des = [[UILabel alloc] init];
        [botView addSubview:des];
        [des mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(botView);
            make.right.mas_equalTo(_secTotalPriceBtn.mas_left);
        }];
        des.font = PZFont(14);
        des.textColor = HBColor(119, 119, 119);
        des.text = @"合计：";
        
        _secTotalCountLabel = [[UILabel alloc] init];
        [botView addSubview:_secTotalCountLabel];
        [_secTotalCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(botView);
            make.right.mas_equalTo(des.mas_left).offset(-8);
        }];
        _secTotalCountLabel.textColor = HBColor(119, 119, 119);
        _secTotalCountLabel.textAlignment = NSTextAlignmentRight;
        _secTotalCountLabel.font = PZFont(14);
    }
    return self;
}

- (void)setMailFee:(CGFloat)mailFee {
    _mailFee = mailFee;
    _mailFeeLabel.text = [NSString stringWithFormat:@"+ %.1f", mailFee];
}

- (void)setSecTotalFee:(NSInteger)secTotalFee {
    _secTotalFee = secTotalFee;
    [_secTotalPriceBtn setTitle:[NSString stringWithFormat:@" %.0f", (float)secTotalFee/100] forState:UIControlStateNormal];
}

- (void)setSecTotalCount:(NSInteger)secTotalCount {
    _secTotalCount = secTotalCount;
    _secTotalCountLabel.text = [NSString stringWithFormat:@"共 %ld 件商品", (long)secTotalCount];
}

@end

@implementation JNQConfirmOrderBottomView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _comCount = [[UIButton alloc] init];
        [self addSubview:_comCount];
        [_comCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.left.mas_equalTo(self).offset(10);
            make.height.mas_equalTo(20);
        }];
        _comCount.titleLabel.font = PZFont(15);
        [_comCount setTitleColor:HBColor(51, 51, 51) forState:UIControlStateNormal];
        _comCount.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_comCount setTitle:@"共 0 件" forState:UIControlStateNormal];
        
        _payBtn = [[UIButton alloc] init];
        [self addSubview:_payBtn];
        [_payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_equalTo(self);
            make.width.mas_equalTo(SCREENWidth/3);
        }];
        [_payBtn setBackgroundColor:BasicGoldColor];
        [_payBtn setTitle:@"提交订单" forState:UIControlStateNormal];
        _payBtn.titleLabel.font = PZFont(17);
        
        
        UILabel *atten = [[UILabel alloc] init];
        [self addSubview:atten];
        [atten mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self);
            make.left.mas_equalTo(_comCount.mas_right);
        }];
        atten.font = PZFont(15);
        atten.textColor = HBColor(51, 51, 51);
        atten.text = @"合计： ";
        
        _totalPrice = [[UIButton alloc] init];
        [self addSubview:_totalPrice];
        [_totalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self);
            make.left.mas_equalTo(atten.mas_right);
        }];
        [_totalPrice setTitleColor:BasicRedColor forState:UIControlStateNormal];
        [_totalPrice setImage:[UIImage imageNamed:@"icon_big"] forState:UIControlStateNormal];
        _totalPrice.titleLabel.font = PZFont(15);
        _totalPrice.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
    }
    return self;
}

- (void)setTotalCount:(NSInteger)totalCount {
    _totalCount = totalCount;
    [_comCount setTitle:[NSString stringWithFormat:@"  共 %ld 件  ", totalCount] forState:UIControlStateNormal];
}

- (void)setTotalFee:(NSInteger)totalFee {
    _totalFee = totalFee;
    [_totalPrice setTitle:[NSString stringWithFormat:@" %.0f", (float)totalFee/100] forState:UIControlStateNormal];
}

@end
