//
//  CommentKeyboard.m
//  Puzzle
//
//  Created by huipay on 2016/9/22.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "CommentKeyboard.h"


@interface CommentKeyboard()<UITextFieldDelegate>
@property (nonatomic,weak)UITextField *inputView;
@property (strong, nonatomic) void (^pSendClicked)(NSString *);
@property (strong, nonatomic) void (^pShareHandle)();
@property (strong, nonatomic) void (^pCommentHandle)();

@end


@implementation CommentKeyboard
-(instancetype)initWithPlaceholder:(NSString *)placeholder commentCount:(NSString *)count
{
    if (self = [super init]) {
        self.backgroundColor = HBColor(243, 243, 243);
//        UIButton* shareBtn = [UIButton new];
//        [shareBtn setImage:[UIImage imageNamed:@"btn_share"] forState:UIControlStateNormal];
//        [self addSubview:shareBtn];
//        if (self.pShareHandle) {
//            self.pShareHandle();
//        }
//        [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(-4);
//            make.centerY.mas_equalTo(self.mas_centerY);
//            make.width.mas_equalTo(54);
//        }];
        
        UIButton* commentBtn = [UIButton new];
        [commentBtn setImage:[UIImage imageNamed:@"btn_comment_d"] forState:UIControlStateNormal];
        [commentBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        commentBtn.titleLabel.font = PZFont(12.0f);
        [commentBtn setTitle:count forState:UIControlStateNormal];
        [[commentBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.pCommentHandle) {
                self.pCommentHandle();
            }
        }];
        [self addSubview:commentBtn];
        [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-4);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(54);
        }];
        
        UITextField* inputView = [[UITextField alloc]init];
        inputView.layer.borderColor = [UIColor colorWithHexString:@"999999"].CGColor;
        inputView.delegate = self;
        inputView.returnKeyType = UIReturnKeySend;
        inputView.background = [UIImage imageNamed:@"input_assess"] ;
        inputView.backgroundColor = [UIColor whiteColor];
        inputView.font = PZFont(12.0f);
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:placeholder];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"999999"] range:NSMakeRange(0, attributedStr.length)];
        [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, attributedStr.length)];
        inputView.attributedPlaceholder = attributedStr;
        inputView.leftViewMode = UITextFieldViewModeAlways ;
        
        
        UIView* leftView = [[UIView alloc]init];
        leftView.bounds = CGRectMake(0, 0, 32, 44);
        UIImageView* leftImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_pen"]];
        [leftView addSubview:leftImage];
        [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(14, 14));
            make.centerY.mas_equalTo(leftView.mas_centerY);
            make.left.mas_equalTo(6);
        }];
        inputView.leftView = leftView;
        self.inputView = inputView;
        [self addSubview:inputView];
        [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.height.mas_equalTo(32);
            make.right.mas_equalTo(commentBtn.mas_left).offset(-12);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    return self ;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        if (self.pSendClicked) {
            self.pSendClicked(textField.text) ;
            textField.text = @"" ;
        }
        [self.inputView resignFirstResponder];
    }
    return YES ;
}

- (void)sendClicked:(void(^)(NSString *text))handler{
    _pSendClicked = handler;
}
- (void)shareHandle:(void(^)())handler{
    _pShareHandle = handler ;
}

- (void)commentHandle:(void(^)())handler{
    _pCommentHandle = handler ;
}
@end
