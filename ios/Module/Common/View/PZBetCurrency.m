//
//  PZBetCurrency.m
//  Puzzle
//
//  Created by huipay on 2016/10/11.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZBetCurrency.h"

@implementation PZBetCurrency


-(instancetype)initWithMidImageTitle:(NSString*)title  subtitle:(NSString*)subtitle{
    if (self = [super init]) {
        self.textLabel = [[InsetsLabel alloc]initWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        self.textLabel.font = PZFont(12.0f);
        self.textLabel.text = title ;
        self.textLabel.textColor = [UIColor whiteColor];
        [self.textLabel sizeToFit];
        [self addSubview:self.textLabel];
        
        self.imageCurrency = [[UIImageView alloc]init];
        self.imageCurrency.image = [UIImage imageNamed:@"cai2-S-currency-black"];
        [self addSubview:self.imageCurrency];
        
        
        self.subLabel = [[UILabel alloc]init];
        self.subLabel.font = PZFont(12.0f);
        self.subLabel.text = subtitle ;
        [self.subLabel sizeToFit];
        [self addSubview:self.subLabel];
        

        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        [self.imageCurrency mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.textLabel.mas_right).offset(4);
            make.centerY.mas_equalTo(self.mas_centerY).offset(.5);
        }];
        
        [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imageCurrency.mas_right).offset(4);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    return self ;
}

-(instancetype)initWithTitle:(NSString*)title  imageLeft:(BOOL)left{
    if (self = [super init]) {
        self.textLabel = [[InsetsLabel alloc]initWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = PZFont(12.0f);
        self.textLabel.text = title ;
        [self.textLabel sizeToFit];
        [self addSubview:self.textLabel];
        
        UIImageView* imageCurrency = [[UIImageView alloc]init];
        imageCurrency.image = [UIImage imageNamed:@"home-S-currency"];
        [self addSubview:imageCurrency];
        if (left) {
            [imageCurrency mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.centerY.mas_equalTo(self.mas_centerY).offset(.5);
            }];
            [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(imageCurrency.mas_right).offset(4);
                make.centerY.mas_equalTo(self.mas_centerY);
                make.right.mas_equalTo(0);
            }];
        }
        else{
            [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.centerY.mas_equalTo(self.mas_centerY);
            }];
            [imageCurrency mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.textLabel.mas_right).offset(4);
                make.centerY.mas_equalTo(self.mas_centerY).offset(.5);
                make.right.mas_equalTo(0);
            }];
        }
    }
    return self ;
}
@end
