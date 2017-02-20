//
//  PZCommentPanel.m
//  Puzzle
//
//  Created by huipay on 2016/10/12.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZCommentPanel.h"

@interface PZCommentPanel()<UITextViewDelegate>

@property(weak,nonatomic)UITextView* textView ;

@property(weak,nonatomic)UIView* targetView ;

@end

@implementation PZCommentPanel

-(instancetype)initWithTitle:(NSString*)title targetView:(UIView *)target{
    if (self = [super init]) {
        self.backgroundColor = HBColor(243, 243, 243);
        self.targetView = target ;
        UIButton* cancelBtn = [UIButton new];
        [cancelBtn sizeToFit];
        cancelBtn.titleLabel.font = PZFont(15.0f);
        [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.left.mas_equalTo(6);
            make.width.mas_equalTo(60);
        }];
        
        
        UILabel* titleView = [[UILabel alloc]init];
        titleView.textColor = [UIColor blackColor];
        titleView.font = PZFont(17.0f);
        titleView.text = title ;
        [titleView sizeToFit];
        [self addSubview:titleView];
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(16);
        }];
    
        UIButton* sendBtn = [UIButton new];
        sendBtn.enabled = NO ;
        [sendBtn sizeToFit];
        sendBtn.titleLabel.font = PZFont(15.0f);
        [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [self addSubview:sendBtn];

        [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(60);
        }];
        
        UITextView* textView = [[UITextView alloc]init];
        textView.layer.masksToBounds = YES ;
        textView.delegate = self ;
        textView.layer.cornerRadius = 2 ;
        textView.font = PZFont(14.0f);
        textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:textView];
        self.textView = textView ;
        
        
        [textView.rac_textSignal subscribeNext:^(NSString* content) {
            NSInteger length = content.length ;
            sendBtn.enabled = length > 0 ? YES : NO ;
        }];
        
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cancelBtn.mas_bottom).offset(12);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.bottom.mas_equalTo(-20);
        }];
        
        WEAKSELF
        [[cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [weakSelf keyboardDown];
        }];
        
        [[sendBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            NSString* content = textView.text ;
            weakSelf.sendMsgBlock(content);
        }];
        
    }
    return self ;
}

-(void)keyboardUp{
//    show gray window
    UIView* bgView = [[UIView alloc]init];
    bgView.tag = 1000 ;
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.8 ;
    [self.targetView insertSubview:bgView belowSubview:self];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(-66, 0, 0, 0));
    }];
    [self.textView becomeFirstResponder];

}

-(void)keyboardDown{
    //    hide gray window
    [self.textView resignFirstResponder];
    self.textView.text = @"" ;
    UIView* bgView = [self.targetView viewWithTag:1000];
    [bgView removeFromSuperview];

}
@end
