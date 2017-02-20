//
//  InsetsLabel.m
//  Puzzle
//
//  Created by huipay on 2016/8/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "InsetsLabel.h"

@interface InsetsLabel()
@property(strong,nonatomic) UIColor* previousColor ;
@end

@implementation InsetsLabel

-(id) initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets)insets {
    self = [super initWithFrame:frame];
    if(self){
        self.insets = insets;
        self.systemURLStyle = YES ;
        self.automaticLinkDetectionEnabled= YES;
        self.urlLinkTapHandler = ^(KILabel *label, NSString *string, NSRange range) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[string getUrl]]];
        };
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self pressAction];
        self.urlLinkTapHandler = ^(KILabel *label, NSString *string, NSRange range) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[string getUrl]]];
        };
    }
    return self;
}
// 初始化设置
- (void)pressAction {
    self.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longPress.minimumPressDuration = 1;
    [self addGestureRecognizer:longPress];
}

#pragma mark - 恢复背景色
-(void)resumeBgColor{
    self.backgroundColor = self.previousColor;
}

#pragma mark - 改变背景色
-(void)changeBgColor{
    self.previousColor = self.backgroundColor ;
    [self setBackgroundColor:HBColor(243, 243, 243)];
}

// 使label能够成为响应事件
- (BOOL)canBecomeFirstResponder {
    return YES;
}
// 控制响应的方法
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return action == @selector(customCopy:);
}

- (void)customCopy:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.text;
    [self resumeBgColor];
}

- (void)longPressAction:(UIGestureRecognizer *)recognizer {
    if ([self canBecomeFirstResponder]) {
        [self becomeFirstResponder];
        UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"拷贝" action:@selector(customCopy:)];
        [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyItem, nil]];
        [[UIMenuController sharedMenuController] setTargetRect:self.frame inView:self.superview];
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
        [self changeBgColor];        
    }
}

-(id) initWithInsets:(UIEdgeInsets)insets {
    self = [super init];
    if(self){
        self.insets = insets;
        self.urlLinkTapHandler = ^(KILabel *label, NSString *string, NSRange range) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[string getUrl]]];
        };
    }
    return self;
}
-(void) drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.insets)];
}

- (void)dealloc
{
    
}

@end
