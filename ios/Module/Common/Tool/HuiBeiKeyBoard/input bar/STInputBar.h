//
//  STInputBar.h
//  STEmojiKeyboard
//
//  Created by zhenlintie on 15/5/29.
//  Copyright (c) 2015年 sTeven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STInputBar : UIView

+ (instancetype)inputBar;


@property (assign, nonatomic) BOOL fitWhenKeyboardShowOrHide;

//评论模式
@property(assign,nonatomic) BOOL commonMode ;

@property(assign,nonatomic) BOOL floatBottom ;

@property (copy, nonatomic) NSString *placeHolder;
@property(weak,nonatomic) UIView<UITextInput>* inputSender ;
@property (strong, nonatomic) void (^takePhotoClickedHandler)();


- (void)setDidSendClicked:(void(^)(NSString *text))handler;


- (void)setInputBarSizeChangedHandle:(void(^)())handler;

- (void)hiddenPhoto;

-(void)assignResponder;

- (BOOL)resignFirstResponder;

@end
