//
//  HBTitleInputView.h
//  HuiBeiWaterMerchant
//
//  Created by 朱理哲 on 16/5/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PZTitleInputView : UIControl
@property(strong ,nonatomic)UITextField* textFieldUser ;
@property(strong ,nonatomic)UILabel* titleLabel ;
@property(weak,nonatomic)UIView* inputAccessor ;

@property(assign,nonatomic)BOOL textEnable ;
@property(assign,nonatomic)BOOL indicatorEnable ;
@property(assign,nonatomic)BOOL security ;
@property(assign,nonatomic)BOOL numberType ;
@property(assign,nonatomic)BOOL phoneType ;
@property (nonatomic, strong) id<UITextFieldDelegate> vc;
@property(strong,nonatomic)NSString *placeHolder ;

@property(strong,nonatomic)RACSignal* singnal;

@property(copy,nonatomic) NSString* textValue ;


-(instancetype)initWithTitle:(NSString*)title ;
-(instancetype)initWithTitle:(NSString*)title placeHolder:(NSString*)placeHolderString;
-(instancetype)initWithTitle:(NSString*)title leftIcon:(NSString*)icon rightTitle:(NSString*)rightTitle;
-(instancetype)initWithLeftIcon:(NSString*)icon placeHolder:(NSString*)placeHolder;
-(instancetype)initWithTitle:(NSString*)title placeHolder:(NSString*)placeHolder rightTitle:(NSString*)rightTitle;

-(void)phoneFormat;

@end
