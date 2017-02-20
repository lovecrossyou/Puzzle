//
//  RRFOrderDetailView.m
//  Puzzle
//
//  Created by huibei on 16/8/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFOrderDetailView.h"
#import "RRFOrderListModel.h"
#import "RRFAddressModel.h"
@implementation RRFOrderDetailHeadView
{
    UILabel *_orderNumberLabel;
    UILabel *_timeLabel;
    UILabel *_orderStateLabel;
    UILabel *_nameLabel;
    UILabel *_phoneLabel;
    UILabel *_addressLabel;
}
-(instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        UIView *orderInfoView = [[UIView alloc]init];
        orderInfoView.backgroundColor = [UIColor whiteColor];
        [self addSubview:orderInfoView];
        [orderInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(105);
        }];
        
        
        _orderNumberLabel = [[UILabel alloc]init];
        _orderNumberLabel.text = @"订单编号:3223233";
        _orderNumberLabel.textColor = [UIColor colorWithHexString:@"777777"];
        _orderNumberLabel.font = [UIFont systemFontOfSize:13];
        [_orderNumberLabel sizeToFit];
        [orderInfoView addSubview:_orderNumberLabel];
        [_orderNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(12);
            make.right.mas_lessThanOrEqualTo(-12);
        }];
        
        
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.text = @"下单时间:2016-08-09 12：33：00";
        _timeLabel.textColor = [UIColor colorWithHexString:@"777777"];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        [_timeLabel sizeToFit];
        [orderInfoView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_lessThanOrEqualTo(-12);
            make.top.mas_equalTo(_orderNumberLabel.mas_bottom).offset(8);
        }];
        
        
        _orderStateLabel = [[UILabel alloc]init];
        _orderStateLabel.text = @"订单状态:待付款";
        _orderStateLabel.textColor = [UIColor colorWithHexString:@"777777"];
        _orderStateLabel.font = [UIFont systemFontOfSize:13];
        [_orderStateLabel sizeToFit];
        [orderInfoView addSubview:_orderStateLabel];
        [_orderStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_lessThanOrEqualTo(-12);
            make.top.mas_equalTo(_timeLabel.mas_bottom).offset(8);
        }];
        
        UIView *addrInfoView = [[UIView alloc]init];
        addrInfoView.backgroundColor = [UIColor whiteColor];
        [self addSubview:addrInfoView];
        [addrInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(orderInfoView.mas_bottom).offset(15);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(80);
            make.bottom.mas_equalTo(-15);
        }];
        
        UIImageView *nameIcon = [[UIImageView alloc]init];
        nameIcon.image = [UIImage imageNamed:@"icon_people"];
        [addrInfoView addSubview:nameIcon];
        [nameIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(12);
            make.size.mas_equalTo(CGSizeMake(13, 13));
        }];
        
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor colorWithHexString:@"777777"];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        [_nameLabel sizeToFit];
        [addrInfoView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameIcon.mas_right).offset(8);
            make.centerY.mas_equalTo(nameIcon.mas_centerY);
        }];
        
        
        _phoneLabel = [[UILabel alloc]init];
        _phoneLabel.textColor = [UIColor colorWithHexString:@"777777"];
        _phoneLabel.font = [UIFont systemFontOfSize:13];
        [_phoneLabel sizeToFit];
        [addrInfoView addSubview:_phoneLabel];
        [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nameLabel.mas_right).offset(8);
            make.centerY.mas_equalTo(nameIcon.mas_centerY);
        }];

        
        UIImageView *addrIcon = [[UIImageView alloc]init];
        addrIcon.image = [UIImage imageNamed:@"icon_address"];
        [addrInfoView addSubview:addrIcon];
        [addrIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.size.mas_equalTo(CGSizeMake(11, 14));
            make.top.mas_equalTo(nameIcon.mas_bottom).offset(12);
        }];
        
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.textColor = [UIColor colorWithHexString:@"777777"];
        _addressLabel.font = [UIFont systemFontOfSize:13];
        [_addressLabel sizeToFit];
        _addressLabel.numberOfLines = 2;
        [addrInfoView addSubview:_addressLabel];
        [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(addrIcon.mas_right).offset(8);
            make.centerY.mas_equalTo(addrIcon.mas_centerY);
            make.right.mas_equalTo(-12);
        }];

    }
    return self;
}
-(void)setAddrM:(RRFAddressModel *)addrM
{
    _addrM = addrM;
    _nameLabel.text = addrM.recievName;
    _phoneLabel.text = addrM.phoneNumber;
    _addressLabel.text = addrM.fullAddress;
}
-(void)setListM:(RRFOrderListModel *)listM
{
    NSMutableAttributedString *orderNum = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"订单编号: %@",listM.orderId]];
    [orderNum addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"333333"] range:NSMakeRange(0, 4)];
    [orderNum addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 5)];
    _orderNumberLabel.attributedText = orderNum;
    
    
    NSMutableAttributedString *orderStatus = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"订单状态: %@",listM.status]];
    [orderStatus addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"333333"] range:NSMakeRange(0, 4)];
    [orderStatus addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 5)];
    _orderStateLabel.attributedText = orderStatus;
    
    
    NSMutableAttributedString *ordertime = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"下单时间: %@",listM.createTime]];
    [ordertime addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"333333"] range:NSMakeRange(0, 4)];
    [ordertime addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 5)];
    _timeLabel.attributedText = ordertime;
    
}

@end

@implementation RRFOrderDetailFooterView
{
    UIButton *_totalPrice;
    UILabel *_courierFees;
    UILabel *_realPaymentTitleLabel;
    UIButton *_realPaymentLabel;
}
-(instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        UIView *content = [[UIView alloc]init];
        content.backgroundColor = [UIColor whiteColor];
        [self addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(130);
            make.top.mas_equalTo(0.8);
            make.bottom.mas_equalTo(-15);
        }];
        
        
        UILabel *totalPriceLabel = [[UILabel alloc]init];
        totalPriceLabel.text = @"订单金额:";
        totalPriceLabel.textColor = [UIColor colorWithHexString:@"777777"];
        totalPriceLabel.font = [UIFont systemFontOfSize:15];
        [totalPriceLabel sizeToFit];
        [content addSubview:totalPriceLabel];
        [totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(12);
        }];
        
        
        _totalPrice = [[UIButton alloc]init];
        [_totalPrice setImage:[UIImage imageNamed:@"icon_big"] forState:UIControlStateNormal];
        _totalPrice.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 0);
        [_totalPrice setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _totalPrice.titleLabel.font = [UIFont systemFontOfSize:15];
        [_totalPrice sizeToFit];
        [content addSubview:_totalPrice];
        [_totalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(totalPriceLabel.mas_centerY);
            make.right.mas_equalTo(-12);
        }];
        
        UILabel *courierFeesLabel = [[UILabel alloc]init];
        courierFeesLabel.text = @"快递费用:";
        courierFeesLabel.textColor = [UIColor colorWithHexString:@"777777"];
        courierFeesLabel.font = [UIFont systemFontOfSize:15];
        [courierFeesLabel sizeToFit];
        [content addSubview:courierFeesLabel];
        [courierFeesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(totalPriceLabel.mas_bottom).offset(12);
        }];
        
        _courierFees = [[UILabel alloc]init];
        _courierFees.text = @"+￥0.00";
        _courierFees.textColor = [UIColor redColor];
        _courierFees.font = [UIFont systemFontOfSize:14];
        [_courierFees sizeToFit];
        [content addSubview:_courierFees];
        [_courierFees mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(courierFeesLabel.mas_centerY);
            make.right.mas_equalTo(-12);
        }];
        
        UIView *leverView = [[UIView alloc]init];
        leverView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [content addSubview:leverView];
        [leverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(courierFeesLabel.mas_bottom).offset(12);
            make.height.mas_equalTo(0.8);
        }];
        
        _realPaymentLabel = [[UIButton alloc]init];
        [_realPaymentLabel setImage:[UIImage imageNamed:@"icon_big"] forState:UIControlStateNormal];
        _realPaymentLabel.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 0);
        [_realPaymentLabel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _realPaymentLabel.titleLabel.font = [UIFont systemFontOfSize:15];
        [_realPaymentLabel sizeToFit];
        [content addSubview:_realPaymentLabel];
        [_realPaymentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(leverView.mas_bottom).offset(12);

        }];
        
        _realPaymentTitleLabel = [[UILabel alloc]init];
        _realPaymentTitleLabel.text = @"实付款:";
        _realPaymentTitleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _realPaymentTitleLabel.font = [UIFont systemFontOfSize:12];
        [_realPaymentTitleLabel sizeToFit];
        [content addSubview:_realPaymentTitleLabel];
        [_realPaymentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_realPaymentLabel.mas_left).offset(-4);
            make.centerY.mas_equalTo(_realPaymentLabel.mas_centerY);
        }];
    }
    return self;
}

-(void)setListM:(RRFOrderListModel *)listM
{
    _listM = listM;
    [_totalPrice setTitle:[NSString stringWithFormat:@" %.0f",listM.xtbPrice] forState:UIControlStateNormal];
    _courierFees.text = [NSString stringWithFormat:@"+￥%.2f",listM.expressFee/100];
    [_realPaymentLabel setTitle:[NSString stringWithFormat:@" %.0f",listM.xtbPrice] forState:UIControlStateNormal];
    
}
@end

@implementation RRFOrderDetailFooterBarView
-(instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        UIButton *serviceBtn = [[UIButton alloc]init];
        [serviceBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [serviceBtn setImage:[UIImage imageNamed:@"order_btn_call"] forState:UIControlStateNormal];
        [serviceBtn setTitle:@"  客服" forState:UIControlStateNormal];
        serviceBtn.titleLabel.font = PZFont(15);
        [self addSubview:serviceBtn];
        [serviceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(60, 44));
        }];
        [[serviceBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.footBarBlock) {
                self.footBarBlock(@(1));
            }
        }];
        
        UIButton *clickBtn = [[UIButton alloc]init];
        [clickBtn setTitleColor:[UIColor colorWithHexString:@"f23030"] forState:UIControlStateNormal];
        [clickBtn setTitleEdgeInsets:UIEdgeInsetsMake(2, 4, 2, 4)];
        [clickBtn setBackgroundImage:[UIImage imageNamed:@"0yuan_home_btn_joinborder"] forState:UIControlStateNormal];
        [clickBtn setTitle:@"签收" forState:UIControlStateNormal];
        clickBtn.titleLabel.font = PZFont(14);
        self.clickBtn = clickBtn;
        [self addSubview:clickBtn];
        [clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(28);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        [[clickBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.footBarBlock) {
                self.footBarBlock(@(2));
            }
        }];
        
    }
    return self;
}


@end

@implementation RRFOrderDetailView



@end
