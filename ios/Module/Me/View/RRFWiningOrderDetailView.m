//
//  RRFWiningOrderDetailView.m
//  Puzzle
//
//  Created by huipay on 2017/2/7.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "RRFWiningOrderDetailView.h"
#import "RRFWiningOrderDetailModel.h"

@interface RRFWiningOrderInfo:UIView
@property(nonatomic,weak)UILabel *orderNum;
@property(nonatomic,weak)UILabel *orderTime;
@property(nonatomic,weak)UILabel *orderStatus;
@property(nonatomic,strong)RRFWiningOrderInfoModel *infoModel;
@end
@implementation RRFWiningOrderInfo
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *orderNumLabel = [[UILabel alloc]init];
        orderNumLabel.text = @"订单编号:";
        orderNumLabel.textColor = [UIColor colorWithHexString:@"333333"];
        orderNumLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:orderNumLabel];
        [orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(10);
        }];
        
        UILabel *orderNum = [[UILabel alloc]init];
        orderNum.textColor = [UIColor colorWithHexString:@"666666"];
        orderNum.font = [UIFont systemFontOfSize:13];
        self.orderNum = orderNum;
        [self addSubview:orderNum];
        [orderNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(orderNumLabel.mas_right).offset(10);
            make.centerY.mas_equalTo(orderNumLabel.mas_centerY);
            make.right.mas_equalTo(-12);
        }];
        
        
        UILabel *orderTimeLabel = [[UILabel alloc]init];
        orderTimeLabel.text = @"下单时间:";
        orderTimeLabel.textColor = [UIColor colorWithHexString:@"333333"];
        orderTimeLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:orderTimeLabel];
        [orderTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(orderNumLabel.mas_bottom).offset(10);
        }];
        
        UILabel *orderTime = [[UILabel alloc]init];
        orderTime.textColor = [UIColor colorWithHexString:@"666666"];
        orderTime.font = [UIFont systemFontOfSize:13];
        self.orderTime = orderTime;
        [self addSubview:orderTime];
        [orderTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(orderTimeLabel.mas_right).offset(10);
            make.centerY.mas_equalTo(orderTimeLabel.mas_centerY);
            make.right.mas_equalTo(-12);
        }];

        
        
        UILabel *orderStatusLabel = [[UILabel alloc]init];
        orderStatusLabel.text = @"订单状态:";
        orderStatusLabel.textColor = [UIColor colorWithHexString:@"333333"];
        orderStatusLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:orderStatusLabel];
        [orderStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(orderTimeLabel.mas_bottom).offset(10);
        }];
        
        UILabel *orderStatus = [[UILabel alloc]init];
        orderStatus.textColor = [UIColor redColor];
        orderStatus.font = [UIFont systemFontOfSize:13];
        self.orderStatus = orderStatus;
        [self addSubview:orderStatus];
        [orderStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(orderStatusLabel.mas_right).offset(10);
            make.centerY.mas_equalTo(orderStatusLabel.mas_centerY);
            make.right.mas_equalTo(-12);
        }];
    }
    return self;
}
-(void)setInfoModel:(RRFWiningOrderInfoModel *)infoModel
{
    self.orderNum.text = [NSString stringWithFormat:@"%ld",(long)infoModel.orderId];
    self.orderTime.text = infoModel.createTime;
    self.orderStatus.text = infoModel.status;
}
@end



@interface RRFWiningOrderAddressView:UIView
@property(nonatomic,weak)UILabel *name;
@property(nonatomic,weak)UILabel *phoneNum;
@property(nonatomic,weak)UILabel *address;
@property(nonatomic,strong)RRFWiningOrderAddressModel *addressModel;
@end
@implementation RRFWiningOrderAddressView
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];

        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.text = @"收 货 人 :";
        nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
        nameLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(10);
        }];
        
        UILabel *name = [[UILabel alloc]init];
        name.textColor = [UIColor colorWithHexString:@"666666"];
        name.font = [UIFont systemFontOfSize:13];
        self.name = name;
        [self addSubview:name];
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameLabel.mas_right).offset(10);
            make.centerY.mas_equalTo(nameLabel.mas_centerY);
        }];
        
        UILabel *phoneNum = [[UILabel alloc]init];
        phoneNum.textColor = [UIColor colorWithHexString:@"666666"];
        phoneNum.font = [UIFont systemFontOfSize:13];
        self.phoneNum = phoneNum;
        [self addSubview:phoneNum];
        [phoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(nameLabel.mas_centerY);
            make.right.mas_equalTo(-12);
        }];
        
        
        UILabel *addressLabel = [[UILabel alloc]init];
        addressLabel.text = @"收货地址:";
        addressLabel.textColor = [UIColor colorWithHexString:@"333333"];
        addressLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:addressLabel];
        [addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(10);
        }];
        
        UILabel *address = [[UILabel alloc]init];
        address.numberOfLines = 2;
        address.textColor = [UIColor colorWithHexString:@"666666"];
        address.font = [UIFont systemFontOfSize:13];
        self.address = address;
        [self addSubview:address];
        [address mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(addressLabel.mas_right).offset(10);
            make.centerY.mas_equalTo(addressLabel.mas_centerY);
            make.right.mas_equalTo(-12);
        }];
        
    }
    return self;
}
-(void)setAddressModel:(RRFWiningOrderAddressModel *)addressModel
{
    self.name.text = addressModel.recievName;
    self.phoneNum.text = addressModel.phoneNumber;
    self.address.text = addressModel.fullAddress;
}


@end




@interface RRFWiningOrderDetailView ()
@property(nonatomic,weak)RRFWiningOrderInfo *infoView ;
@property(nonatomic,weak)RRFWiningOrderAddressView *addressView ;

@end
@implementation RRFWiningOrderDetailView
-(instancetype)init{
    if (self = [super init]) {
        RRFWiningOrderInfo *infoView = [[RRFWiningOrderInfo alloc]init];
        self.infoView = infoView;
        [self addSubview:infoView];
        [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(90);
        }];
        
        RRFWiningOrderAddressView *addressView = [[RRFWiningOrderAddressView alloc]init];
        self.addressView = addressView;
        [self addSubview:addressView];
        [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(70);
            make.top.mas_equalTo(infoView.mas_bottom).offset(12);
            make.bottom.mas_equalTo(-12);
        }];
    }
    return self;
}
-(void)setModel:(RRFWiningOrderDetailModel *)model
{
    self.infoView.infoModel = model.orderInfo;
    self.addressView.addressModel = model.deliveryAddress;
}

@end
