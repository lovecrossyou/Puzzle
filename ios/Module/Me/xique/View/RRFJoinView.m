//
//  RRFJoinView.m
//  Puzzle
//
//  Created by huibei on 16/9/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFJoinView.h"
#import "PZTitleInputView.h"
#import "RRFApplyDelegaterModel.h"
#import "LoginModel.h"
#import "PZParamTool.h"
#import "RRFPhoneListModel.h"
#import "Singleton.h"
@interface RRFJoinView ()
@property(nonatomic,weak)UIButton *applyForBtn;
// 南区
@property(nonatomic,weak)UIButton *phoneBtn;

// 协议
@property(nonatomic,weak)UIButton *protocolBtn;

@property(nonatomic,weak)PZTitleInputView *nameLabel ;
@end
@implementation RRFJoinView
-(instancetype)init{
    if (self = [super init]) {
        RRFApplyDelegaterModel *delegaterModel = [[RRFApplyDelegaterModel alloc]init];
        self.delegaterModel = delegaterModel;
        
        LoginModel *userModel = [PZParamTool currentUser];
        PZTitleInputView *phoneLabel = [[PZTitleInputView alloc]initWithTitle:@"手机号:"];
        phoneLabel.textValue = userModel.phone_num.length == 11 ? userModel.phone_num:userModel.phoneNumber;
        self.delegaterModel.phoneNumber = userModel.phone_num.length == 11 ? userModel.phone_num:userModel.phoneNumber;
        phoneLabel.indicatorEnable = NO;
        phoneLabel.phoneType = YES;
        [self addSubview:phoneLabel];
        [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(20);
        }];
        [phoneLabel.singnal subscribeNext:^(id x) {
            self.delegaterModel.phoneNumber = x ;
        }];
        
        PZTitleInputView *nameLabel = [[PZTitleInputView alloc]initWithTitle:@"姓名:"];
        nameLabel.indicatorEnable = NO;
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(phoneLabel.mas_bottom).offset(1);
        }];
        [nameLabel.singnal subscribeNext:^(id x) {
            self.delegaterModel.realName = x ;
        }];
        
        self.nameLabel = nameLabel ;
        PZTitleInputView *areaLabel = [[PZTitleInputView alloc]initWithTitle:@"地区:"];
        areaLabel.textEnable = NO;
        self.areaLabel = areaLabel;
        [self addSubview:areaLabel];
        [areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(1);
        }];
        [[areaLabel rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.applyForBlock) {
                self.applyForBlock(@(1));
            }
        }];
        
        UIButton *applyForBtn = [[UIButton alloc]init];
        applyForBtn.tag = 0;
        applyForBtn.backgroundColor = [UIColor colorWithHexString:@"44a4ef"];
        [applyForBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [applyForBtn setTitle:@"立即申请" forState:UIControlStateNormal];
        [applyForBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [applyForBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue_bg"] forState:UIControlStateNormal];
        applyForBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        applyForBtn.layer.masksToBounds = YES;
        applyForBtn.layer.cornerRadius = 5;
        [applyForBtn sizeToFit];
        self.applyForBtn = applyForBtn;
        [self addSubview:applyForBtn];
        [applyForBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(areaLabel.mas_bottom).offset(30);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(44);
            
        }];

        UIButton *protocolBtn = [[UIButton alloc]init];
        protocolBtn.tag = 2;
        [protocolBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"点击上面的立即申请按钮,即表示你同意\n《喜鹊业务代理协议》"];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"4964ef"] range:NSMakeRange(str.length -10, 10)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"777777"] range:NSMakeRange(0, str.length -10)];
        [protocolBtn setAttributedTitle:str forState:UIControlStateNormal];
        protocolBtn.titleLabel.numberOfLines = 2;
        protocolBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        protocolBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        protocolBtn.layer.masksToBounds = YES;
        protocolBtn.layer.cornerRadius = 5;
        [protocolBtn sizeToFit];
        self.protocolBtn = protocolBtn;
        [self addSubview:protocolBtn];
        [protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(-20);
        }];
        
        RRFPhoneListModel *model = [Singleton sharedInstance].phoneListM;
        NSString *northPhoneNum = model.tel;
        if (northPhoneNum.length == 0) {
            northPhoneNum = @"";
        }
        UIButton *phoneBtn = [[UIButton alloc]init];
        phoneBtn.tag = 3;
        [phoneBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        phoneBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [phoneBtn setTitle:[NSString stringWithFormat:@"%@",northPhoneNum ] forState:UIControlStateNormal];
        [phoneBtn setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
        phoneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [phoneBtn sizeToFit];
        self.phoneBtn = phoneBtn;
        [self addSubview:phoneBtn];
        [phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(protocolBtn.mas_top).offset(-4);
        }];
        
        UILabel *subTitleLabel = [[UILabel alloc]init];
        subTitleLabel.textAlignment = NSTextAlignmentCenter;
        subTitleLabel.text = @"全国统一咨询热线";
        subTitleLabel.textColor = [UIColor colorWithHexString:@"777777"];
        subTitleLabel.font = [UIFont systemFontOfSize:15];
        [subTitleLabel sizeToFit];
        [self addSubview:subTitleLabel];
        [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(phoneBtn.mas_top).offset(0);
        }];
        
       
        
    }
    return self;
}

-(void)keyboardUp{
    [self.nameLabel becomeFirstResponder];
}
-(void)btnClick:(UIButton *)sender
{
    if (self.applyForBlock) {
        self.applyForBlock(@(sender.tag));
    }
}

@end
