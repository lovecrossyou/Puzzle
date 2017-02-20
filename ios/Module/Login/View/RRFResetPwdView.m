
//  Created by huibei on 16/7/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFResetPwdView.h"
#import "PZTitleInputView.h"
#import "PZTimerCountView.h"
@interface RRFResetPwdView ()
@property(nonatomic,weak)PZTitleInputView *phoneLabel;
@property(nonatomic,weak)PZTitleInputView *codeLabel;
@property(nonatomic,weak)UIButton *completeBtn;
@property(nonatomic,strong)NSString* checkCode;
@end
@implementation RRFResetPwdView
-(instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        WEAKSELF
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.text = @"短信验证码已发送到您的手机\n请填写验证码";
        nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
        nameLabel.font = [UIFont systemFontOfSize:21];
        nameLabel.numberOfLines = 2;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [nameLabel sizeToFit];
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(20);
        }];
        
        PZTitleInputView *phoneLabel = [[PZTitleInputView alloc]initWithTitle:@"手机号" placeHolder:@""];
        phoneLabel.textEnable = NO;
        phoneLabel.indicatorEnable = NO;
        self.phoneLabel = phoneLabel;
        [self addSubview:phoneLabel];
        [phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(30);
            make.height.mas_equalTo(44);
        }];
        
        PZTitleInputView *codeLabel = [[PZTitleInputView alloc]initWithTitle:@"验证码" placeHolder:@"请输入验证码"];
        codeLabel.indicatorEnable = NO;
        codeLabel.numberType = YES;
        self.codeLabel = codeLabel;
        [self addSubview:codeLabel];
        [codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(self.phoneLabel.mas_bottom).offset(1);
            make.right.mas_equalTo(-100);
            make.height.mas_equalTo(44);
        }];
        [codeLabel.singnal subscribeNext:^(id x) {
            weakSelf.checkCode = x;
        }];
        
        PZTimerCountView* btnSendVerifyCode =[[PZTimerCountView alloc]initWithWaitMsg:@"发送验证码" ];
        self.btnSendVerifyCode = btnSendVerifyCode;
        [self addSubview:btnSendVerifyCode];
        [btnSendVerifyCode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.phoneLabel.mas_bottom).with.offset(1);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(44);
            make.width.mas_equalTo(99);
        }];
        
        UIButton* completeBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [completeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        completeBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [completeBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [completeBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue_bg"] forState:UIControlStateNormal];
        completeBtn.layer.masksToBounds = YES ;
        completeBtn.layer.cornerRadius = 4 ;
        self.completeBtn = completeBtn;
        [self addSubview:completeBtn];
        [[completeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.regiseBlock) {
                self.regiseBlock(weakSelf.checkCode);
            }
        }];
        [completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.left.mas_equalTo(12);
            make.height.mas_equalTo(40);
            make.top.mas_equalTo(self.btnSendVerifyCode.mas_bottom).with.offset(30);
        }];

    }
    return self;
}
-(void)setPwdViewHidden:(BOOL)hidden
{
    if(hidden){
        [self.completeBtn setTitle:@"确认" forState:UIControlStateNormal];
    }
}
-(void)settingPhoneNum:(NSString *)phoneNum
{
    self.phoneLabel.placeHolder = phoneNum;
    [self.phoneLabel phoneFormat];

}
@end
