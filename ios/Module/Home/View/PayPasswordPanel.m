//
//  PayPasswordPanel.m
//  Puzzle
//
//  Created by huipay on 2016/8/25.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#define margin 12
#define padding 6
#import "PayPasswordPanel.h"

@interface ToolBar:UIView
@property(strong,nonatomic)  UITextField* pwdLabel ;
@end


@implementation ToolBar
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorR:243 colorG:243 colorB:243];
        self.pwdLabel = [[UITextField alloc]init];
        _pwdLabel.font = PZFont(48.0f);
        _pwdLabel.secureTextEntry = YES ;
        _pwdLabel.enabled = NO ;
        _pwdLabel.textAlignment = NSTextAlignmentCenter ;
        _pwdLabel.backgroundColor = [UIColor redColor];
        [self addSubview:_pwdLabel];
        [_pwdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40);
            make.left.mas_equalTo(margin);
            make.right.mas_equalTo(-margin);
            make.centerY.mas_equalTo(self.mas_centerY).offset(20);
        }];
    }
    return self ;
}
@end


@interface PayPasswordPanel()
@property(strong,nonatomic)UITextField* pwdField ;
@property(weak,nonatomic)ToolBar* toolBar ;

@end

@implementation PayPasswordPanel
-(instancetype)initWithPwdCount:(int)count completeBlock:(ItemClickParamBlock)callBack{
    if (self = [super init]) {
        self.pwdField = [[UITextField alloc]init];
        self.pwdField.secureTextEntry = YES ;
        
        ToolBar* toolBar = [[ToolBar alloc]init];
        toolBar.frame = CGRectMake(0, 0, SCREENWidth, 88);
        self.pwdField.inputAccessoryView = toolBar ;
        self.pwdField.keyboardType = UIKeyboardTypeNumberPad ;
        [self addSubview:self.pwdField];
        [self.pwdField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(margin);
            make.right.mas_equalTo(-margin);
        }];
        self.toolBar = toolBar ;
        WEAKSELF
        [self.pwdField.rac_textSignal subscribeNext:^(NSString* str) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            [paragraphStyle setLineSpacing:12];
            paragraphStyle.alignment = NSTextAlignmentCenter ;
            NSMutableAttributedString *attributedString =  [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSKernAttributeName : @(20)}];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
            [weakSelf.toolBar.pwdLabel setAttributedText:attributedString] ;
            if (attributedString.length == count) {
                callBack(str);
                [weakSelf performSelector:@selector(keyboardDown) withObject:nil afterDelay:0.2];
            }
        }];
    }
    return self ;
}

-(void)keyboardDown{
    [self.pwdField resignFirstResponder];
}

-(void)keyboardUp{
    [self.pwdField becomeFirstResponder];
}
@end
