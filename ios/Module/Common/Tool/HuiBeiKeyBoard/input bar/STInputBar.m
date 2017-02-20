//
//  STInputBar.m
//  STEmojiKeyboard
//
//  Created by zhenlintie on 15/5/29.
//  Copyright (c) 2015年 sTeven. All rights reserved.
//

#import "STInputBar.h"
#import "STEmojiKeyboard.h"

#define kSTIBDefaultHeight 44
#define kSTLeftButtonWidth 50
#define kSTLeftButtonHeight 44
#define kSTRightButtonWidth 55
#define kSTTextviewDefaultHeight 34
#define kSTTextviewMaxHeight 80

@import ObjectiveC.message ;

@interface STInputBar () <UITextViewDelegate,UITextFieldDelegate>


@property (strong, nonatomic) UIButton *photoButton;
@property (strong, nonatomic) UIButton *keyboardTypeButton;
@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UIButton *sendButton;
@property (strong, nonatomic) STEmojiKeyboard *keyboard;
@property (strong, nonatomic) UILabel *placeHolderLabel;

@property (strong, nonatomic) void (^sendDidClickedHandler)(NSString *);
@property (strong, nonatomic) void (^sizeChangedHandler)();


@end

@implementation STInputBar{
    BOOL _isRegistedKeyboardNotif;
    BOOL _isDefaultKeyboard;
    NSArray *_switchKeyboardImages;
}

+(instancetype)inputBar{
    return [self new];
}

- (void)dealloc{
    if (_isRegistedKeyboardNotif){
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kSTIBDefaultHeight)]){
        _isRegistedKeyboardNotif = NO;
        _isDefaultKeyboard = YES;
        _switchKeyboardImages = @[@"face",@"keyboard"];
        [self loadUI];
    }
    return self;
}

-(void)setCommonMode:(BOOL)commonMode{
    _commonMode = commonMode ;
    if (commonMode) {
        //普通模式
        self.textView.hidden = commonMode ;
        self.sendButton.hidden = commonMode ;
        self.placeHolderLabel.hidden = commonMode ;
    }
    else{
        self.backgroundColor = [UIColor colorR:243 colorG:243 colorB:243];
        self.textView.textColor = [UIColor darkGrayColor];
        self.textView.backgroundColor = [UIColor whiteColor];
        self.textView.layer.cornerRadius = 2 ;
        self.textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.textView.layer.borderWidth = 0.5 ;
        self.textView.frame = CGRectMake(kSTLeftButtonWidth, (kSTIBDefaultHeight-kSTTextviewDefaultHeight)/2+2, CGRectGetWidth(self.frame)-kSTLeftButtonWidth-kSTRightButtonWidth, kSTTextviewDefaultHeight - 2) ;
    }
}

- (void)loadUI{
    self.backgroundColor = [UIColor colorR:243 colorG:243 colorB:243];
    _keyboard = [STEmojiKeyboard keyboard];
    //拍照按钮
    self.keyboardTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, (kSTIBDefaultHeight-kSTLeftButtonHeight)/2, kSTLeftButtonWidth, kSTLeftButtonHeight)];
    [_keyboardTypeButton addTarget:self action:@selector(keyboardTypeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _keyboardTypeButton.tag = 0;
    [_keyboardTypeButton setImage:[UIImage imageNamed:_switchKeyboardImages[_keyboardTypeButton.tag]] forState:UIControlStateNormal];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(2*kSTLeftButtonWidth, (kSTIBDefaultHeight-kSTTextviewDefaultHeight)/2, CGRectGetWidth(self.frame)-kSTLeftButtonWidth-kSTRightButtonWidth, kSTTextviewDefaultHeight)];
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.textColor = [UIColor whiteColor];
    self.textView.font = [UIFont systemFontOfSize:16];
    self.textView.delegate = self;
    self.textView.returnKeyType = UIReturnKeyDone;
    self.textView.tintColor = [UIColor lightGrayColor];
    self.textView.scrollEnabled = NO;
    self.textView.showsVerticalScrollIndicator = NO;
    
    _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(kSTLeftButtonWidth+5, CGRectGetMinY(_textView.frame), CGRectGetWidth(_textView.frame), kSTTextviewDefaultHeight)];
    _placeHolderLabel.adjustsFontSizeToFitWidth = YES;
    _placeHolderLabel.minimumScaleFactor = 0.9;
    _placeHolderLabel.textColor = [UIColor colorWithWhite:1 alpha:0.5];
    _placeHolderLabel.font = PZFont(12.0f);
    _placeHolderLabel.userInteractionEnabled = NO;
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.sendButton.frame = CGRectMake(self.frame.size.width-kSTRightButtonWidth, 0, kSTRightButtonWidth, kSTIBDefaultHeight);
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.sendButton setTitleEdgeInsets:UIEdgeInsetsMake(2.50f, 0.0f, 0.0f, 0.0f)];
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.sendButton addTarget:self action:@selector(sendTextCommentTaped:) forControlEvents:UIControlEventTouchUpInside];
    
    self.sendButton.enabled = NO;
    [self addSubview:_photoButton];
    [self addSubview:_keyboardTypeButton];
    [self addSubview:_textView];
    [self addSubview:_placeHolderLabel];
    [self addSubview:self.sendButton];
    
}

- (void)layout{
    if (self.commonMode) return ;
    self.sendButton.enabled = ![@"" isEqualToString:self.textView.text];
    _placeHolderLabel.hidden = self.sendButton.enabled;
    
    CGRect textViewFrame = self.textView.frame;
    CGSize textSize = [self.textView sizeThatFits:CGSizeMake(CGRectGetWidth(textViewFrame), 1000.0f)];
    
    CGFloat offset = 10;
    self.textView.scrollEnabled = (textSize.height > kSTTextviewMaxHeight-offset);
    textViewFrame.size.height = MAX(kSTTextviewDefaultHeight, MIN(kSTTextviewMaxHeight, textSize.height));
    self.textView.frame = textViewFrame;
    
    CGRect addBarFrame = self.frame;
    CGFloat maxY = CGRectGetMaxY(addBarFrame);
    addBarFrame.size.height = textViewFrame.size.height+offset;
    addBarFrame.origin.y = maxY-addBarFrame.size.height;
    self.frame = addBarFrame;
    
    self.photoButton.center = CGPointMake(CGRectGetMidX(self.photoButton.frame), CGRectGetHeight(addBarFrame)/2.0f);
    self.keyboardTypeButton.center = CGPointMake(CGRectGetMidX(self.keyboardTypeButton.frame), CGRectGetHeight(addBarFrame)/2.0f);
    self.sendButton.center = CGPointMake(CGRectGetMidX(self.sendButton.frame), CGRectGetHeight(addBarFrame)/2.0f);
    
    if (self.sizeChangedHandler){
        self.sizeChangedHandler();
    }
}

#pragma mark - public

- (void)setPlaceHolder:(NSString *)placeHolder{
    _placeHolderLabel.textColor = [UIColor lightGrayColor];
    _placeHolderLabel.text = placeHolder;
    _placeHolder = [placeHolder copy];
}

- (BOOL)resignFirstResponder{
    [super resignFirstResponder];
    if (self.commonMode) {
        if (self.inputSender != nil) {
            [self.inputSender resignFirstResponder];
        }
    }
    return [_textView resignFirstResponder];
}

-(BOOL)becomeFirstResponder{
    [super becomeFirstResponder];
    return [_textView becomeFirstResponder];

}

#pragma mark - 拍照点击
-(void)photoClick{
    if (self.takePhotoClickedHandler) {
        self.takePhotoClickedHandler();
    }
}

- (void)registerKeyboardNotif{
    _isRegistedKeyboardNotif = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)setDidSendClicked:(void (^)(NSString *))handler{
    _sendDidClickedHandler = handler;
}

- (void)setInputBarSizeChangedHandle:(void (^)())handler{
    _sizeChangedHandler = handler;
}

- (void)setFitWhenKeyboardShowOrHide:(BOOL)fitWhenKeyboardShowOrHide{
    if (fitWhenKeyboardShowOrHide){
        [self registerKeyboardNotif];
    }
    if (!fitWhenKeyboardShowOrHide && _fitWhenKeyboardShowOrHide){
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    _fitWhenKeyboardShowOrHide = fitWhenKeyboardShowOrHide;
}

#pragma mark - notif

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    [UIView animateWithDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0.5
                        options:([info[UIKeyboardAnimationCurveUserInfoKey] integerValue]<<16)
                     animations:^{
                         CGRect newInputBarFrame = self.frame;
                         [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                             make.left.right.mas_equalTo(0);
                             make.bottom.mas_equalTo(-kbSize.height);
                             make.height.mas_equalTo(newInputBarFrame.size.height);
                         }];
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)keyboardWillHidden:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    [UIView animateWithDuration:[info[UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                          delay:0
                        options:([info[UIKeyboardAnimationCurveUserInfoKey] integerValue]<<16)
                     animations:^{
                         if (self.floatBottom) {
                             CGRect newInputBarFrame = self.frame;
                              [UIView animateWithDuration:0.5 animations:^{
                                  [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                                      make.left.right.mas_equalTo(0);
                                      make.bottom.mas_equalTo(0);
                                      make.height.mas_equalTo(newInputBarFrame.size.height);
                                  }];
                              }];
                         }
                         else{
                             CGRect newInputBarFrame = self.frame;
                             [UIView animateWithDuration:0.5 animations:^{
                                 [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                                     make.left.right.mas_equalTo(0);
                                     make.bottom.mas_equalTo(newInputBarFrame.size.height);
                                     make.height.mas_equalTo(newInputBarFrame.size.height);
                                 }];
                             }];
                         }
                     }
                     completion:nil];
}

#pragma mark - action

- (void)sendTextCommentTaped:(UIButton *)button{
    if (self.sendDidClickedHandler){
        self.sendDidClickedHandler(self.textView.text);
        if (!self.commonMode) {
            self.textView.text = @"";
        }
        [self layout];
    }
}

- (void)keyboardTypeButtonClicked:(UIButton *)button{
    if (button.tag == 1){
        self.textView.inputView = nil;
        if (self.commonMode) {
            if ([self.inputSender isKindOfClass:[UITextView class]]) {
                UITextView* inputSender = (UITextView*)self.inputSender ;
                inputSender.inputView = nil ;
            }
            if ([self.inputSender isKindOfClass:[UITextField class]]) {
                UITextField* inputSender = (UITextField*)self.inputSender ;
                inputSender.inputView = nil ;
            }
        }
    }
    else{
        if (self.commonMode) {
            [_keyboard setTextView:self.inputSender];
        }
        else{
            [_keyboard setTextView:self.textView];
        }
    }
    
    button.tag = (button.tag+1)%2;
    [_keyboardTypeButton setImage:[UIImage imageNamed:_switchKeyboardImages[button.tag]] forState:UIControlStateNormal];
    if (self.commonMode) {
        [self.inputSender reloadInputViews];
        [self.inputSender becomeFirstResponder];
    }
    else{
        [self.textView reloadInputViews];
        [_textView becomeFirstResponder];
    }
}

-(void)hiddenPhoto{
    self.photoButton.hidden = YES ;
    self.sendButton.hidden = NO ;
    
    self.keyboardTypeButton.frame = CGRectMake(0, (kSTIBDefaultHeight-kSTLeftButtonHeight)/2, kSTLeftButtonWidth, kSTLeftButtonHeight) ;
    self.textView.frame = CGRectMake(kSTLeftButtonWidth, (kSTIBDefaultHeight-kSTTextviewDefaultHeight)/2, CGRectGetWidth(self.frame)-kSTLeftButtonWidth-kSTRightButtonWidth, kSTTextviewDefaultHeight) ;
    
    
}

#pragma mark - text view delegate
- (void)textViewDidChange:(UITextView *)textView{
    [self layout];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES ;
}

-(void)assignResponder{
    [self.textView becomeFirstResponder];

}

@end
