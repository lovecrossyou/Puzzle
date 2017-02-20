//
//  ShoppingCartPlusMinusView.m
//  PrivateTeaStall
//
//  Created by huibei on 16/6/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZShoppingCartPlusMinusView.h"
@interface PZShoppingCartPlusMinusView ()

@end
@implementation PZShoppingCartPlusMinusView
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        UIButton* btnMinus = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnMinus setBackgroundColor:[UIColor whiteColor]];
        btnMinus.contentEdgeInsets = UIEdgeInsetsMake(0,0, 6, 0);
        [btnMinus sizeToFit];
        [btnMinus setTitle:@"-" forState:UIControlStateNormal];
        [btnMinus setTitleColor:[UIColor colorWithHexString:@"ffc800"] forState:UIControlStateNormal];
        btnMinus.titleLabel.font = PZFont(36.0f);
        [self addSubview:btnMinus];
        [btnMinus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(1);
            make.top.mas_equalTo(1);
            make.bottom.mas_equalTo(-1);
            make.width.mas_equalTo(32);
        }];
        self.btnMinus = btnMinus ;
        
        UIButton* btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnAdd sizeToFit];
        btnAdd.contentEdgeInsets = UIEdgeInsetsMake(0,0, 6, 0);
        btnAdd.contentMode = UIViewContentModeCenter ;
        [btnAdd setBackgroundColor:[UIColor whiteColor]];
        [btnAdd setTitle:@"+" forState:UIControlStateNormal];
        [btnAdd setTitleColor:[UIColor colorWithHexString:@"ffc800"] forState:UIControlStateNormal];
        btnAdd.titleLabel.font = PZFont(36.0f);
        [self addSubview:btnAdd];
        [btnAdd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-1);
            make.top.mas_equalTo(1);
            make.bottom.mas_equalTo(-1);
            make.width.mas_equalTo(32);
        }];
        self.btnAdd = btnAdd ;
        
        UITextField* numField = [[UITextField alloc]init];
        [numField setBackgroundColor:[UIColor whiteColor]];
        numField.keyboardType = UIKeyboardTypeNumberPad ;
        numField.textAlignment = NSTextAlignmentCenter;
        numField.textColor = [UIColor colorWithHexString:@"777777"];
        numField.font = PZFont(16.0f);
        [self addSubview:numField];
        [numField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(btnMinus.mas_right).offset(1);
            make.right.mas_equalTo(btnAdd.mas_left).offset(-1);
            make.top.mas_equalTo(1);
            make.bottom.mas_equalTo(-1);
        }];
        self.numField = numField ;
        [numField.rac_textSignal subscribeNext:^(NSString* countString) {

        }];
    }
    return self ;
}


@end
