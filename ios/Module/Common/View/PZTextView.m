//
//  PZTextView.m
//  Puzzle
//
//  Created by huipay on 2016/8/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZTextView.h"

@interface PZTextView()<UITextViewDelegate>
//@property(weak,nonatomic)UILabel* placeHolderView ;
@property(copy,nonatomic)NSString* textValue ;
@end
@implementation PZTextView
-(instancetype)initWithFrame:(CGRect)frame placeHolder:(NSString *)placeHolder
{
    if (self = [super initWithFrame:frame]) {
        WEAKSELF
        UITextView* textView = [[UITextView alloc]init];
        textView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        textView.textColor = [UIColor darkGrayColor];
        textView.font = PZFont(14.0f);
        textView.returnKeyType = UIReturnKeyDefault;
        textView.delegate = self ;
        self.textView = textView;
        [self addSubview:textView];
        [textView.rac_textSignal subscribeNext:^(NSString* content) {
            NSInteger length =  content.length ;
            BOOL hidden = length > 0 ? YES : NO ;
            if (weakSelf.placeHolderView != nil) {
                weakSelf.placeHolderView.hidden = hidden;
            }
        }];

        
        
        UILabel* placeHolderView = [[UILabel alloc]init];
        placeHolderView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        placeHolderView.textColor = [UIColor colorWithHexString:@"aaaaaa"];
        placeHolderView.font = PZFont(13.0f);
        placeHolderView.text = placeHolder ;
        [placeHolderView sizeToFit];
        placeHolderView.numberOfLines = 0 ;
        [self addSubview:placeHolderView];
    }
    return self ;
}
-(instancetype)initWithPlaceHolder:(NSString *)placeHolder{
    if (self = [super init]) {
        WEAKSELF
        UITextView* textView = [[UITextView alloc]init];
        textView.textColor = [UIColor darkGrayColor];
        textView.font = PZFont(14.0f);
        textView.returnKeyType = UIReturnKeyNext;
        textView.delegate = self ;
        self.textView = textView;
        [self addSubview:textView];
        [textView.rac_textSignal subscribeNext:^(NSString* content) {
            NSInteger length =  content.length ;
            BOOL hidden = length > 0 ? YES : NO ;
            if (weakSelf.placeHolderView != nil) {
                weakSelf.placeHolderView.hidden = hidden;
            }
        }];
        
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        UILabel* placeHolderView = [[UILabel alloc]init];
        placeHolderView.textColor = [UIColor colorWithHexString:@"aaaaaa"];
        placeHolderView.font = PZFont(13.0f);
        placeHolderView.text = placeHolder ;
        [placeHolderView sizeToFit];
        placeHolderView.numberOfLines = 0 ;
        [self addSubview:placeHolderView];
        [placeHolderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-6);
        }];
        self.placeHolderView = placeHolderView ;
        
    }
    return self ;
}
-(void)setText:(NSString *)text{
    if (text.length > 0) {
        self.placeHolderView.text = @"" ;
    }
    _textValue = text ;
    self.textView.text = text ;
}
//-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
//    }
//    return YES ;
//}

-(NSString *)getText{
    return self.textView.text ;
}

-(void)setPlaceHolder:(NSString*)placeHolder
{
    self.placeHolderView.text = placeHolder;
}

@end
