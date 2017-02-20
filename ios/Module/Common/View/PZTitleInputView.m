
//
//  HBTitleInputView.m
//  HuiBeiWaterMerchant
//
//  Created by 朱理哲 on 16/5/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZTitleInputView.h"

@interface PZTitleInputView()<UITextFieldDelegate>
{
    NSString    *previousTextFieldContent;
    UITextRange *previousSelection;
}
@property(weak,nonatomic)UIImageView* imageView ;
@end

@implementation PZTitleInputView
-(instancetype)initWithTitle:(NSString*)title placeHolder:(NSString*)placeHolderString
{
    if (self = [self initWithTitle:title]) {
        UIColor* placeholderColor = HBColor(153, 153, 153);
        [self.textFieldUser setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:placeHolderString attributes:@{NSForegroundColorAttributeName: placeholderColor}]];
        self.textFieldUser.textColor = [UIColor colorWithHexString:@"333333"];
        self.singnal = self.textFieldUser.rac_textSignal ;
        
        UIView *sepLine = [[UIView alloc]init];
        sepLine.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [self addSubview:sepLine];
        [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(4);
            make.right.mas_equalTo(-4);
            make.height.mas_equalTo(0.8);
        }];
    }
    return self ;
}

-(instancetype)initWithTitle:(NSString *)title leftIcon:(NSString *)icon rightTitle:(NSString *)rightTitle{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        UIImageView* leftIcon = [[UIImageView alloc]init];
        leftIcon.contentMode = UIViewContentModeScaleAspectFit;
        leftIcon.image= [UIImage imageNamed:icon];
        [leftIcon sizeToFit];
        [self addSubview:leftIcon];
        [leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(32, 32));
        }];
        if (icon == nil) {
            [leftIcon mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(0);
            }];
        }
    
        UILabel* titleLabel = [[UILabel alloc]init];
        titleLabel.font = PZFont(15.0f);
        titleLabel.text = title ;
        [titleLabel sizeToFit];
        titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftIcon.mas_right).offset(6);
            make.top.bottom.mas_equalTo(0);
        }];
        self.titleLabel = titleLabel ;
        
        UIImageView* imageView = [[UIImageView alloc]init];
        imageView.image =[UIImage imageNamed:@"btn_right_arrow"];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-14);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(8, 14));
        }];
        self.imageView = imageView ;
        
        UILabel* rightTitleLabel = [[UILabel alloc]init];
        rightTitleLabel.font = PZFont(12.0f);
        rightTitleLabel.text = rightTitle ;
        [rightTitleLabel sizeToFit];
        rightTitleLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:rightTitleLabel];
        [rightTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(imageView.mas_left).offset(-6);
            make.top.bottom.mas_equalTo(0);
        }];
    }
    return self ;
}


-(instancetype)initWithTitle:(NSString*)title{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        UILabel* titleLabel = [[UILabel alloc]init];
        titleLabel.font = PZFont(15.0f);
        titleLabel.text = title ;
        [titleLabel sizeToFit];
        titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [self addSubview:titleLabel];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:PZFont(15), NSParagraphStyleAttributeName:paragraphStyle};
        CGRect rect = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(rect.size.width+12);
        }];
        self.titleLabel = titleLabel ;
    
        
        _textFieldUser = [[UITextField alloc]init];
        _textFieldUser.font = PZFont(15.0f);
        _textFieldUser.textColor = [UIColor colorWithHexString:@"333333"];
        _textFieldUser.delegate = self ;
        self.singnal = _textFieldUser.rac_textSignal ;
        [_textFieldUser addTarget:self action:@selector(formatPhoneNumber:) forControlEvents:UIControlEventEditingChanged];

        
        UIView* paddingUserView = [[UIView alloc]init];
        paddingUserView.frame = CGRectMake(0, 0, 0, 1);
        _textFieldUser.leftView = paddingUserView ;
        _textFieldUser.leftViewMode = UITextFieldViewModeAlways;
        
        [self addSubview:_textFieldUser];
        [_textFieldUser mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.left.mas_equalTo(titleLabel.mas_right).offset(4);
            make.bottom.mas_equalTo(0);
        }];
        
        UIImageView* imageView = [[UIImageView alloc]init];
        imageView.image =[UIImage imageNamed:@"arrow-right"];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-14);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(8, 14));
        }];
        self.imageView = imageView ;
        
//        UIView* sepLine = [[UIView alloc]init];
//        sepLine.backgroundColor = HBColor(26, 26, 26);
//        [self addSubview:sepLine];
//        [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(1);
//            make.left.right.mas_equalTo(0);
//            make.bottom.mas_equalTo(0);
//        }];
    }
    return self ;
}

-(instancetype)initWithLeftIcon:(NSString*)icon placeHolder:(NSString*)placeHolder
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        
        UIImageView *iconView = [[UIImageView alloc]init];
        iconView.image = [UIImage imageNamed:icon];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        UITextField *textFieldUser= [[UITextField alloc]init];
        UIColor* placeholderColor = HBColor(153, 153, 153);
        [textFieldUser setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:placeHolder attributes:@{NSForegroundColorAttributeName: placeholderColor}]];
        textFieldUser.placeholder = placeHolder;
        textFieldUser.textColor = [UIColor colorWithHexString:@"333333"];
        textFieldUser.font = [UIFont systemFontOfSize:14];
        textFieldUser.delegate = self ;
        [textFieldUser sizeToFit];
        self.textFieldUser = textFieldUser ;
        self.singnal = textFieldUser.rac_textSignal ;
        [self addSubview:textFieldUser];
        [textFieldUser mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(50);
            make.right.mas_equalTo(-12);
            make.top.bottom.mas_equalTo(0);
        }];
        
    }
    return self;
}

-(instancetype)initWithTitle:(NSString*)title placeHolder:(NSString*)placeHolder rightTitle:(NSString*)rightTitle{
    if (self = [self initWithTitle:title placeHolder:placeHolder]) {
        UILabel* rightTitleLabel = [[UILabel alloc]init];
        rightTitleLabel.font = PZFont(12.0f);
        rightTitleLabel.text = rightTitle ;
        [rightTitleLabel sizeToFit];
        rightTitleLabel.textColor = [UIColor darkGrayColor];
        [self addSubview:rightTitleLabel];
        [rightTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.top.bottom.mas_equalTo(0);
        }];
    }
    return self ;
}

-(void)setInputAccessor:(UIView *)inputAccessor{
    self.textFieldUser.inputView = inputAccessor ;
}

-(void)setTextValue:(NSString *)textValue{
    _textValue = textValue ;
    self.textFieldUser.text = textValue ;
}

-(void)setSecurity:(BOOL)security{
    _security = security ;
    self.textFieldUser.secureTextEntry = security ;
}

-(void)setNumberType:(BOOL)numberType{
    _numberType = numberType ;
    if (numberType) {
        self.textFieldUser.keyboardType = UIKeyboardTypeNumberPad ;
    }
}

-(void)setPhoneType:(BOOL)phoneType{
    _phoneType = phoneType ;
    if (phoneType) {
        self.textFieldUser.keyboardType = UIKeyboardTypePhonePad ;
    }
}
-(void)setIndicatorEnable:(BOOL)indicatorEnable{
    _indicatorEnable = indicatorEnable;
    self.imageView.hidden = !indicatorEnable ;
}

-(void)setTextEnable:(BOOL)textEnable{
    _textEnable = textEnable ;
    self.textFieldUser.enabled = textEnable ;
}
-(void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    self.textFieldUser.placeholder = placeHolder;
}

- (void)setVc:(id<UITextFieldDelegate>)vc {
    _vc = vc;
    _textFieldUser.delegate = vc;
    _textFieldUser.returnKeyType = UIReturnKeyDone;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [_textFieldUser resignFirstResponder];
    }
    if (self.phoneType) {
        previousTextFieldContent = textField.text;
        previousSelection = textField.selectedTextRange;
    }
    return YES;
}

-(void)phoneFormat{
    [self formatPhoneNumber:self.textFieldUser];
}


- (void)formatPhoneNumber:(UITextField*)textField
{
    if (!self.phoneType) return;
    NSUInteger targetCursorPosition =
    [textField offsetFromPosition:textField.beginningOfDocument
                       toPosition:textField.selectedTextRange.start];
    // nStr表示不带空格的号码
    NSString* nStr = [textField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString* preTxt = [previousTextFieldContent stringByReplacingOccurrencesOfString:@" "
                                                                           withString:@""];
    
    char editFlag = 0;// 正在执行删除操作时为0，否则为1
    
    if (nStr.length <= preTxt.length) {
        editFlag = 0;
    }
    else {
        editFlag = 1;
    }
    
    // textField设置text
    if (nStr.length > 11)
    {
        textField.text = previousTextFieldContent;
        textField.selectedTextRange = previousSelection;
        return;
    }
    
    // 空格
    NSString* spaceStr = @" ";
    
    NSMutableString* mStrTemp = [NSMutableString new];
    int spaceCount = 0;
    if (nStr.length < 3 && nStr.length > -1)
    {
        spaceCount = 0;
    }else if (nStr.length < 7 && nStr.length >2)
    {
        spaceCount = 1;
        
    }else if (nStr.length < 12 && nStr.length > 6)
    {
        spaceCount = 2;
    }
    
    for (int i = 0; i < spaceCount; i++)
    {
        if (i == 0) {
            [mStrTemp appendFormat:@"%@%@", [nStr substringWithRange:NSMakeRange(0, 3)], spaceStr];
        }else if (i == 1)
        {
            [mStrTemp appendFormat:@"%@%@", [nStr substringWithRange:NSMakeRange(3, 4)], spaceStr];
        }else if (i == 2)
        {
            [mStrTemp appendFormat:@"%@%@", [nStr substringWithRange:NSMakeRange(7, 4)], spaceStr];
        }
    }
    
    if (nStr.length == 11)
    {
        [mStrTemp appendFormat:@"%@%@", [nStr substringWithRange:NSMakeRange(7, 4)], spaceStr];
    }
    
    if (nStr.length < 4)
    {
        [mStrTemp appendString:[nStr substringWithRange:NSMakeRange(nStr.length-nStr.length % 3,
                                                                    nStr.length % 3)]];
    }else if(nStr.length > 3)
    {
        NSString *str = [nStr substringFromIndex:3];
        [mStrTemp appendString:[str substringWithRange:NSMakeRange(str.length-str.length % 4,
                                                                   str.length % 4)]];
        if (nStr.length == 11)
        {
            [mStrTemp deleteCharactersInRange:NSMakeRange(13, 1)];
        }
    }
    
    textField.text = mStrTemp;
    // textField设置selectedTextRange
    NSUInteger curTargetCursorPosition = targetCursorPosition;// 当前光标的偏移位置
    if (editFlag == 0)
    {
        //删除
        if (targetCursorPosition == 9 || targetCursorPosition == 4)
        {
            curTargetCursorPosition = targetCursorPosition - 1;
        }
    }
    else {
        //添加
        if (nStr.length == 8 || nStr.length == 3)
        {
            curTargetCursorPosition = targetCursorPosition + 1;
        }
    }
    
    UITextPosition *targetPosition = [textField positionFromPosition:[textField beginningOfDocument]
                                                              offset:curTargetCursorPosition];
    [textField setSelectedTextRange:[textField textRangeFromPosition:targetPosition
                                                         toPosition :targetPosition]];
}

@end
