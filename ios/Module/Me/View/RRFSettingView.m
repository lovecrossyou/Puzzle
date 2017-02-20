//
//  RRFSettingView.m
//  Puzzle
//
//  Created by huibei on 16/8/3.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFSettingView.h"
#import "PZTitleInputView.h"
#import "PZParamTool.h"
#import "XTChatUtil.h"
@interface RRFModifyPwdView ()
{
    PZTitleInputView *_originalPwd;
    PZTitleInputView *_firstPwd;
    PZTitleInputView *_secondPwd;
}
@property (nonatomic, weak) UIButton *confirmBtn;
@end



@implementation RRFModifyPwdView

-(instancetype)init
{
    if (self = [super init]) {
        _originalPwd = [[PZTitleInputView alloc]initWithTitle:@"原密码" placeHolder:@"请输入原密码"];
        _originalPwd.security = YES;
        [self addSubview:_originalPwd];
        [_originalPwd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(15);
            make.height.mas_equalTo(44);
        }];
        [_originalPwd.singnal subscribeNext:^(id x) {
            self.oldPwdStr = x;
        }];
        
        _firstPwd = [[PZTitleInputView alloc]initWithTitle:@"新密码" placeHolder:@"请输入新密码"];
        _firstPwd.security = YES;

        [self addSubview:_firstPwd];
        [_firstPwd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(_originalPwd.mas_bottom).offset(1);
            make.height.mas_equalTo(44);
        }];
        [_firstPwd.singnal subscribeNext:^(id x) {
            self.firshPwdStr = x;
        }];
        
        _secondPwd = [[PZTitleInputView alloc]initWithTitle:@"确认密码" placeHolder:@"请再次输入新密码"];
        _secondPwd.security = YES;

        [self addSubview:_secondPwd];
        [_secondPwd mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(_firstPwd.mas_bottom).offset(1);
            make.height.mas_equalTo(44);
        }];
        [_secondPwd.singnal subscribeNext:^(id x) {
            self.secondPwdStr = x;
        }];
        
        UIButton *confirmBtn = [[UIButton alloc]init];
        [confirmBtn setBackgroundColor:[UIColor whiteColor]];
        [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [confirmBtn sizeToFit];
        self.confirmBtn = confirmBtn;
        [self addSubview:confirmBtn];
        [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(_secondPwd.mas_bottom).offset(20);
            make.height.mas_equalTo(44);
        }];
        [[confirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.updatePwdBlock) {
                self.updatePwdBlock();
            }
        }];
        
    }
    return self;
}


@end


@implementation RRFSettingFootView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        UIButton *editBtn = [[UIButton alloc]init];
        editBtn.backgroundColor = [UIColor whiteColor];
        [editBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [editBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        editBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [editBtn sizeToFit];
        [editBtn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
        self.editBtn = editBtn;
        [self addSubview:editBtn];
        [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(15);
        }];
    }
    return self;
}
-(void)loginOut
{
    [XTChatUtil logout];
    [PZParamTool loginOut];
}

@end
@implementation RRFSettingView



@end
