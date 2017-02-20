
//  Created by  on 16/5/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//
#define TotalCount 60
#import "RRFFindPwdView.h"
#import "PZTitleInputView.h"
#import "PZTimerCountView.h"
#import "PZVerticalButton.h"
#import "UIImageView+WebCache.h"
#import "WechatUserInfo.h"

@interface RRFFindPwdView ()
@property(nonatomic,weak)  UIImageView* headIconBtn ;
@property(nonatomic,weak)  UILabel *titleLabel;
@property(nonatomic,weak)  UIButton* protocolBtn ;
@property(nonatomic,weak)  PZVerticalButton* weixinBtn ;

@end
@implementation RRFFindPwdView
-(instancetype)initWithWechatUserInfo:(WechatUserInfo *)uesrInfo Reset:(BOOL)reset{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        WEAKSELF
        UIImageView* headIconBtn= [[UIImageView alloc]init];;
        headIconBtn.layer.masksToBounds = YES ;
        headIconBtn.layer.cornerRadius = 35 ;
        [headIconBtn sd_setImageWithURL:[NSURL URLWithString:uesrInfo.headimgurl] placeholderImage:[UIImage imageNamed:@"common_head_default-diagram"]];
        headIconBtn.hidden = reset;
        self.headIconBtn = headIconBtn;
        [self addSubview:headIconBtn];
        [headIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(70, 70));
        }];
        
        
        UILabel *titleLabel = [[UILabel alloc]init];
        NSString *nameStr ;
        if (reset == YES) {
            nameStr = @"请输入您注册的手机号";
            titleLabel.font = [UIFont systemFontOfSize:21];

        }else{
            nameStr = uesrInfo.nickname;
            titleLabel.font = [UIFont systemFontOfSize:15];

        }
        titleLabel.text = nameStr;
        titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [titleLabel sizeToFit];
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (reset == YES) {
                make.top.mas_equalTo(30);
            }else{
                make.top.mas_equalTo(self.headIconBtn.mas_bottom).offset(10);
            }
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        PZTitleInputView* guojia = [[PZTitleInputView alloc]initWithTitle:@"国家/地区  中国" placeHolder:@""];
        guojia.textEnable = NO;
        guojia.indicatorEnable = NO;
        [self addSubview:guojia];
        [guojia mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(20);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(44);
        }];
        
        PZTitleInputView* textFieldUser = [[PZTitleInputView alloc]initWithTitle:@"+86   |" placeHolder:@"请输入手机号"];
        textFieldUser.indicatorEnable = NO ;
        textFieldUser.phoneType = YES;
        [textFieldUser.singnal subscribeNext:^(id x) {
            weakSelf.userNameStr = x ;
        }];
        [self addSubview:textFieldUser];
        [textFieldUser mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(guojia.mas_bottom).offset(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(44);
        }];
       
        
        UIButton* btnSendVerifyCode= [UIButton buttonWithType:UIButtonTypeCustom];
        [btnSendVerifyCode setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btnSendVerifyCode.titleLabel.font = [UIFont systemFontOfSize:18];
        NSString *btnSendVerifyCodestr = reset==YES?@"下一步":@"注册";
        [btnSendVerifyCode setTitle:btnSendVerifyCodestr forState:UIControlStateNormal];
        [btnSendVerifyCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnSendVerifyCode setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [btnSendVerifyCode setBackgroundImage:[UIImage imageNamed:@"btn_blue_bg"] forState:UIControlStateNormal];
        [btnSendVerifyCode setBackgroundImage:[UIImage imageNamed:@"border_d"] forState:UIControlStateDisabled];
        btnSendVerifyCode.layer.masksToBounds = YES ;
        btnSendVerifyCode.layer.cornerRadius = 4 ;
        [self addSubview:btnSendVerifyCode];
        [[btnSendVerifyCode rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (weakSelf.getVerifyCodeBlock) {
                weakSelf.getVerifyCodeBlock(weakSelf.userNameStr);
            }
        }];
        [btnSendVerifyCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(textFieldUser.mas_bottom).with.offset(20);
            make.right.mas_equalTo(-12);
            make.left.mas_equalTo(12);
            make.height.mas_equalTo(44);
        }];
        
        UIButton* protocolBtn = [[UIButton alloc]init];
        protocolBtn.hidden = reset;
        NSMutableAttributedString *protocolStr = [[NSMutableAttributedString alloc]initWithString:@"点击上面的'注册'按钮即表示你同意\n《喜腾软件许可及服务协议》"];
        [protocolStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"777777"] range:NSMakeRange(0, protocolStr.length-13)];
        [protocolStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"4964ef"] range:NSMakeRange(protocolStr.length-13, 13)];
        [protocolBtn setAttributedTitle:protocolStr forState:UIControlStateNormal];
        protocolBtn.titleLabel.numberOfLines = 2;
        protocolBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        protocolBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.protocolBtn = protocolBtn;
        [self addSubview:protocolBtn];
        [[protocolBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (weakSelf.goProtocolBlock) {
                weakSelf.goProtocolBlock();
            }
        }];
        [protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-25);
            make.right.mas_equalTo(-12);
            make.left.mas_equalTo(12);
            make.height.mas_equalTo(44);
        }];
    }
    return self ;
}



@end
