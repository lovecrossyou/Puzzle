//
//  RRFRewardView.m
//  Puzzle
//
//  Created by huibei on 16/8/18.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFRewardView.h"
#import "RRFCustomNumBtn.h"

@interface RRFRewardView()<UITextFieldDelegate>
{
    UIButton *_tempBtn;
    int _selectedInt;
}
@property(nonatomic,weak)UILabel *titleLabel;
@property(nonatomic,weak)UIView *contentView;
@property(nonatomic,weak)UIButton *rewardBtn;

@property(nonatomic,weak)RRFCustomNumBtn *inputBtn;

@end
@implementation RRFRewardView
-(instancetype)initWithJSONData:(id)json
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"选择赞赏的喜腾币数额";
        titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel = titleLabel;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(12);
        }];
        
        UIView *contentView = [[UIView alloc]init];
        contentView.backgroundColor = [UIColor whiteColor];
        self.contentView = contentView;
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(4);
        }];
        
        
        UILabel* descLabel = [[UILabel alloc]init];
        descLabel.numberOfLines = 0 ;
        descLabel.textColor = [UIColor lightGrayColor];
        NSString* descri = json[@"descri"];
        if (descri != nil) {
            descLabel.text = descri ;
        }
        descLabel.font = PZFont(12.0f);
        [descLabel sizeToFit];
        [self addSubview:descLabel];
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(contentView.mas_bottom).offset(12);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
        }];
        
        
        UIButton *rewardBtn = [[UIButton alloc]init];
        [rewardBtn setTitle:@"确认赞赏" forState:UIControlStateNormal];
        [rewardBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rewardBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue_bg"] forState:UIControlStateNormal];
        rewardBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [rewardBtn sizeToFit];
        [rewardBtn addTarget:self action:@selector(reward) forControlEvents:UIControlEventTouchUpInside];
        self.rewardBtn = rewardBtn;
        [self addSubview:rewardBtn];
        [rewardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(descLabel.mas_bottom).offset(40);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(44);
        }];
        
        NSArray* rewardArray = json[@"content"];
        [self setRewardArray:rewardArray];
    }
    return self;
}
-(void)setRewardArray:(NSArray *)rewardArray
{
    _rewardArray = rewardArray;
    int count = (int)rewardArray.count;
    CGFloat ceontentViewH = 0;
    int total = 3;
    CGFloat btnW = (SCREENWidth-30-22)/3;
    CGFloat marget = 11;
    for (int i = 0; i<= count; i++) {
        int row = i/total;
        int loc = i%total;
        CGFloat btnX = marget + (marget + btnW) * loc;
        CGFloat btnY = 20 + (20 + btnW) * row;

        if (i != count ) {
            UIButton *amountBtn = [[UIButton alloc]init];
            [amountBtn setBackgroundImage:[UIImage imageNamed:@"appreciate_img"] forState:UIControlStateNormal];
            [amountBtn setBackgroundImage:[UIImage imageNamed:@"appreciate_img_s"] forState:UIControlStateSelected];
            NSDictionary* amountJson = rewardArray[i];
            NSString *amountStr = [NSString stringWithFormat:@"%.0f",[amountJson[@"amount"] floatValue]];
            amountBtn.tag = i;
            [amountBtn setTitle:amountStr forState:UIControlStateNormal];
            [amountBtn setTitleColor:StockRed forState:UIControlStateSelected];
            [amountBtn setTitleColor:[UIColor colorWithHexString:@"ff7800"] forState:UIControlStateNormal];
            [amountBtn setImage:[UIImage imageNamed:@"reward_normal"] forState:UIControlStateNormal];
            [amountBtn setImage:[UIImage imageNamed:@"reward_sel"] forState:UIControlStateSelected];
            amountBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 18, 0);
            amountBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 12.5, 0);
            amountBtn.titleLabel.font = [UIFont systemFontOfSize:18];
            amountBtn.frame = CGRectMake(btnX, btnY, btnW, btnW);
            amountBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
            [amountBtn addTarget:self action:@selector(selectedBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:amountBtn];
            if (i == 1) {
                [self selectedBtn:amountBtn];
            }
        }else{

            RRFCustomNumBtn *inputBtn = [[RRFCustomNumBtn alloc]init];
            [inputBtn setBackgroundImage:[UIImage imageNamed:@"appreciate_img_null_n"] forState:UIControlStateNormal];
            [inputBtn setBackgroundImage:[UIImage imageNamed:@"appreciate_img_null_s"] forState:UIControlStateSelected];
            NSMutableAttributedString* placeHolder = [[NSMutableAttributedString alloc]initWithString:@"自定义数额"];
            NSRange range = NSMakeRange(0, placeHolder.length);
            [placeHolder addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"ff7800"]} range:range];
            [placeHolder addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:range];
            inputBtn.inputNumLabel.attributedPlaceholder = placeHolder ;
            [[inputBtn.inputNumLabel rac_signalForControlEvents:UIControlEventEditingDidBegin] subscribeNext:^(id x) {
                inputBtn.inputNumLabel.placeholder = @"" ;
            }];
            [[inputBtn.inputNumLabel rac_signalForControlEvents:UIControlEventEditingDidEnd] subscribeNext:^(id x) {
                inputBtn.inputNumLabel.attributedPlaceholder = placeHolder ;
            }];
            inputBtn.tag = count;
            inputBtn.inputNumLabel.delegate = self ;
            
            [inputBtn.inputNumLabel.rac_textSignal subscribeNext:^(id x) {
                int inputInt = [x intValue];
                if (inputInt != 0) {
                    _selectedInt = inputInt;
                }
            }];
            
            [inputBtn addTarget:self action:@selector(inputInt:) forControlEvents:UIControlEventTouchUpInside];
            inputBtn.frame = CGRectMake(btnX, btnY, btnW, btnW);
            self.inputBtn = inputBtn;
            [self.contentView addSubview:inputBtn];
            int maxRow = count/3 + 1;
            ceontentViewH =  20 + (20 + btnW) * maxRow;
        }
    }
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ceontentViewH);
    }];
    
   
}

-(void)inputInt:(RRFCustomNumBtn *)sender
{
    [sender.inputNumLabel becomeFirstResponder];
    
}

-(void)setInputNum:(NSString*)num
{
    self.inputBtn.inputNumLabel.text = num;
}

-(void)reward
{
    if (self.rewardBlock) {
        self.rewardBlock(_selectedInt);
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.inputBtn.selected = YES ;
    _tempBtn.selected = NO ;
    _tempBtn = self.inputBtn ;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    _selectedInt = [textField.text intValue];
    return YES ;
}

-(void)selectedBtn:(UIButton *)button
{
    button.selected = YES ;
    if (_tempBtn!=nil) {
        _tempBtn.selected = NO ;
    }
    self.inputBtn.selected = NO ;
    _selectedInt = [button.titleLabel.text intValue];
    [self.inputBtn.inputNumLabel resignFirstResponder];
    _tempBtn = button ;
}
@end
