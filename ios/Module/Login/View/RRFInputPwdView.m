//
//  RRFInputPwdView.m
//  Puzzle
//
//  Created by huibei on 16/8/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFInputPwdView.h"
#import "PZTitleInputView.h"
@interface RRFInputPwdView ()
@property(nonatomic,weak)PZTitleInputView *pwdLabel;
@property(nonatomic,weak)UIButton *completeBtn;
@property(nonatomic,strong)NSString *pwd;
@property(nonatomic,weak)UILabel *nameLabel;

@end
@implementation RRFInputPwdView

-(instancetype)initWithRegiste:(BOOL)registe{
    if (self = [super init]) {
        WEAKSELF
        self.backgroundColor = [UIColor whiteColor];

        NSString *str;
        if(registe){
            str = @"请设置密码";
        }else{
            str = @"请设置新密码";
        }
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
        nameLabel.font = [UIFont systemFontOfSize:21];
        nameLabel.numberOfLines = 2;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [nameLabel sizeToFit];
        nameLabel.text = str;
        self.nameLabel = nameLabel;
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(20);
        }];
        
        PZTitleInputView *pwdLabel = [[PZTitleInputView alloc]initWithTitle:@"密码" placeHolder:@"请输入密码"];
        pwdLabel.indicatorEnable = NO ;
        pwdLabel.security = YES;
        self.pwdLabel = pwdLabel;
        [self addSubview:pwdLabel];
        [pwdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(20);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(44);
        }];
        [pwdLabel.singnal subscribeNext:^(id x) {
            weakSelf.pwd = x;
        }];
        
        UIButton* completeBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [completeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        completeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [completeBtn setTitle:@"确认" forState:UIControlStateNormal];
        [completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [completeBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue_bg"] forState:UIControlStateNormal];
        completeBtn.layer.masksToBounds = YES ;
        completeBtn.layer.cornerRadius = 4 ;
        self.completeBtn = completeBtn;
        [self addSubview:completeBtn];
        [[completeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.regiseBlock) {
                self.regiseBlock(weakSelf.pwd);
            }
        }];
        [completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.left.mas_equalTo(12);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(self.pwdLabel.mas_bottom).with.offset(30);
        }];
    }
    return self;
}

@end
