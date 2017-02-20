//
//  RRFBillDetailView.m
//  Puzzle
//
//  Created by huibei on 16/9/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFBillDetailView.h"
#import "RRFBillCellModel.h"
@interface RRFBillDetailView ()
@property(nonatomic,weak)UILabel *genreLabel;
@property(nonatomic,weak)UILabel *noLabel;
@property(nonatomic,weak)UILabel *timeLabel;
@property(nonatomic,weak)UILabel *priceLabel;
@property(nonatomic,weak)UILabel *wayLabel;

@end
@implementation RRFBillDetailView

-(instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *genreLabel = [[UILabel alloc]init];
        genreLabel.text = @"购买钻石:  200颗钻";
        genreLabel.textColor = [UIColor colorWithHexString:@"333333"];
        genreLabel.font = [UIFont systemFontOfSize:15];
        [genreLabel sizeToFit];
        self.genreLabel = genreLabel;
        [self addSubview:genreLabel];
        [genreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
        }];
        
        UIView *sepLine = [[UIView alloc]init];
        sepLine.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [self addSubview:sepLine];
        [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(0.9);
            make.top.mas_equalTo(genreLabel.mas_bottom).offset(20);
        }];
        
        
        UILabel *noLabel = [[UILabel alloc]init];
        noLabel.text = @"订单编号:  23232323";
        noLabel.textColor = [UIColor colorWithHexString:@"333333"];
        noLabel.font = [UIFont systemFontOfSize:15];
        [noLabel sizeToFit];
        self.noLabel = noLabel;
        [self addSubview:noLabel];
        [noLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(sepLine.mas_bottom).offset(12);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
        }];
        
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.text = @"下单时间:  102-202-22";
        timeLabel.textColor = [UIColor colorWithHexString:@"333333"];
        timeLabel.font = [UIFont systemFontOfSize:15];
        [timeLabel sizeToFit];
        self.timeLabel = timeLabel;
        [self addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(noLabel.mas_bottom).offset(12);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
        }];
        
        UILabel *priceLabel = [[UILabel alloc]init];
        priceLabel.text = @"支付总额:  ￥20:00";
        priceLabel.textColor = [UIColor colorWithHexString:@"333333"];
        priceLabel.font = [UIFont systemFontOfSize:15];
        [priceLabel sizeToFit];
        self.priceLabel = priceLabel;
        [self addSubview:priceLabel];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(timeLabel.mas_bottom).offset(12);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
        }];
        
        UILabel *wayLabel = [[UILabel alloc]init];
        wayLabel.text = @"支付方式:   微信支付";
        wayLabel.textColor = [UIColor colorWithHexString:@"333333"];
        wayLabel.font = [UIFont systemFontOfSize:15];
        [wayLabel sizeToFit];
        self.wayLabel = wayLabel;
        [self addSubview:wayLabel];
        [wayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(priceLabel.mas_bottom).offset(12);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.bottom.mas_equalTo(-12);
        }];
    }
    return self;
}
-(void)setModel:(RRFBillCellModel *)model
{
    _model = model;
    self.genreLabel.text = [NSString stringWithFormat:@"%@%@",model.descriptionStr,model.price];
    self.noLabel.text = [NSString stringWithFormat:@"订单编号:  %@",model.orderId];
    self.timeLabel.text = [NSString stringWithFormat:@"下单时间:  %@",model.createTime];
    self.priceLabel.text = [NSString stringWithFormat:@"%@  %@",model.price];
    
    
}
@end
