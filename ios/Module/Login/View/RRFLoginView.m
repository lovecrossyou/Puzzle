
//  Created by on 16/5/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFLoginView.h"
#import "PZTitleInputView.h"
#import "PZVerticalButton.h"
#import "LoginModel.h"
#import "UIImageView+WebCache.h"
#import "WXApi.h"
@interface RRFLoginView ()<UITextFieldDelegate>
@property(nonatomic,weak)PZTitleInputView* textFieldUser;
@property(nonatomic,weak)UIImageView *headerIcon;
@property(nonatomic,weak)PZVerticalButton *weixinBtn;
@property(nonatomic,weak)UILabel *nicknameLable;
@property(nonatomic,weak)UIButton *protocolBtn;

@end
@implementation RRFLoginView


-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *headerIcon = [[UIImageView alloc]init];
        headerIcon.layer.masksToBounds = YES;
        headerIcon.layer.cornerRadius = 35;
        self.headerIcon = headerIcon;
        [self addSubview:headerIcon];
        [headerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(70, 70));
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        UILabel *nicknameLable = [[UILabel alloc]init];
        nicknameLable.textColor = [UIColor colorWithHexString:@"333333"];
        nicknameLable.font = [UIFont systemFontOfSize:15];
        [nicknameLable sizeToFit];
        self.nicknameLable = nicknameLable;
        [self addSubview:nicknameLable];
        [nicknameLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headerIcon.mas_bottom).offset(6);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        PZTitleInputView* textFieldUser = [[PZTitleInputView alloc]initWithTitle:@"帐号" placeHolder:@"请输入手机号"];
        textFieldUser.phoneType = YES ;
        textFieldUser.indicatorEnable = NO ;
        [textFieldUser.singnal subscribeNext:^(NSString* x) {
            self.userName = x ;
        }];
        self.textFieldUser = textFieldUser;
        [self addSubview:textFieldUser];
        [textFieldUser mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headerIcon.mas_bottom).offset(30);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(44);
        }];
        
        PZTitleInputView* textfieldPwd = [[PZTitleInputView alloc]initWithTitle:@"密码" placeHolder:@"请输入密码"];
        textfieldPwd.indicatorEnable = NO ;
        textfieldPwd.security = YES;
        textfieldPwd.textFieldUser.returnKeyType = UIReturnKeyGo;
        textfieldPwd.textFieldUser.delegate = self ;
        [self addSubview:textfieldPwd];
        [textfieldPwd.singnal subscribeNext:^(NSString* textString) {
            self.pwd = textString ;
        }];
        
        [textfieldPwd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(textFieldUser.mas_bottom).with.offset(12);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(44);
        }];
        
        UIButton* btnLogin= [UIButton buttonWithType:UIButtonTypeCustom];
        [btnLogin setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btnLogin.titleLabel.font = [UIFont systemFontOfSize:18];
        [btnLogin setTitle:@"登录" forState:UIControlStateNormal];
        [btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnLogin setBackgroundImage:[UIImage imageNamed:@"btn_blue_bg"] forState:UIControlStateNormal];
        btnLogin.layer.masksToBounds = YES ;
        btnLogin.layer.cornerRadius = 4 ;
        [self addSubview:btnLogin];
        [[btnLogin rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.loginBlock) {
                self.loginBlock(2);
            }
        }];
        [btnLogin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.left.mas_equalTo(12);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(textfieldPwd.mas_bottom).with.offset(20);
        }];
        
        
        
        UIButton* btnProblem = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnProblem setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        btnProblem.titleLabel.font = [UIFont systemFontOfSize:14];
        [btnProblem setTitle:@"忘记密码？" forState:UIControlStateNormal];
        [[btnProblem rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.loginBlock) {
                self.loginBlock(1);
            }
        }];
        [self addSubview:btnProblem];
        [btnProblem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(btnLogin.mas_bottom).offset(6);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
        }];
        
        UIButton *protocolBtn = [[UIButton alloc]init];
        protocolBtn.tag = 55;
        [protocolBtn setTitle:@"喜腾软件许可及服务协议" forState:UIControlStateNormal];
        [protocolBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        protocolBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        self.protocolBtn = protocolBtn;
        [self addSubview:protocolBtn];
        [protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.bottom.mas_equalTo(-12);
        }];
        [protocolBtn addTarget:self action:@selector(protocolBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
       
        
        PZVerticalButton *weixinBtn = [[PZVerticalButton alloc]init];
        [weixinBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        weixinBtn.imageView.contentMode = UIViewContentModeTop ;
        weixinBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [weixinBtn setTitle:@"微信安全登录" forState:UIControlStateNormal];
        [weixinBtn setTitleColor:[UIColor colorWithHexString:@"4964ef"] forState:UIControlStateNormal];
        [weixinBtn setImage:[UIImage imageNamed:@"icon_weixin_login"] forState:UIControlStateNormal];
        weixinBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        weixinBtn.titleLabel.font = PZFont(13);
        [self addSubview:weixinBtn];
        [[weixinBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.loginBlock) {
                self.loginBlock(3);
            }
        }];
        [weixinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(protocolBtn.mas_top).offset(-20);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.mas_equalTo(80);
        }];
        
        weixinBtn.hidden = ![WXApi isWXAppInstalled] ;
        
        UIView *sepView = [[UIView alloc]init];
        sepView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [self addSubview:sepView];
        [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(weixinBtn.mas_top).offset(-40);
        }];
        
        UILabel *andLabel = [[UILabel alloc]init];
        andLabel.text = @"或";
        andLabel.textAlignment = NSTextAlignmentCenter;
        andLabel.backgroundColor = [UIColor whiteColor];
        andLabel.font = [UIFont systemFontOfSize:14];
        andLabel.textColor = [UIColor colorWithHexString:@""];
        [self addSubview:andLabel];
        [andLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(sepView.mas_centerY);
            make.width.mas_equalTo(40);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        sepView.hidden = ![WXApi isWXAppInstalled];
        andLabel.hidden = ![WXApi isWXAppInstalled];

    }
    return self ;
}
-(void)protocolBtnClick
{
    if (self.protocolBlock) {
        self.protocolBlock();
    }
}
-(void)setAccount:(NSString *)accountNum
{
    self.textFieldUser.textFieldUser.text = accountNum;
    self.userName = accountNum;
}
-(void)setLoginM:(LoginModel *)loginM
{
    NSString *headIcon = loginM.headimgurl;
    if (headIcon.length == 0) {
        headIcon = loginM.icon;
    }
    [self.headerIcon sd_setImageWithURL:[NSURL URLWithString:headIcon] placeholderImage:[UIImage imageNamed:@"logo"]];
    
    NSString *name = loginM.cnName;
    if (name.length == 0) {
        name = loginM.nickname;
    }
    self.nicknameLable.text = name;
    
    NSString *phoneNumber = loginM.phone_num;
    if (phoneNumber.length == 0) {
        phoneNumber = loginM.phoneNumber;
    }
    self.textFieldUser.textFieldUser.text = phoneNumber;
    [self.textFieldUser phoneFormat];
    self.userName = phoneNumber;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.loginBlock) {
        self.loginBlock(2);
    }
    return YES ;
}


@end
