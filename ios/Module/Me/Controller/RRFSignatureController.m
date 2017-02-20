//
//  RRFSignatureController.m
//  Puzzle
//
//  Created by huibei on 16/9/28.
//  Copyright © 2016年 HuiBei. All rights reserved.
//
#define kMaxLength 20
#import "RRFSignatureController.h"
#import "RRFSignatureView.h"
#import "RRFMeTool.h"
#import "PZTextView.h"
@interface RRFSignatureController ()<UITextFieldDelegate>
@property(nonatomic,weak)RRFSignatureView *headView;
@end

@implementation RRFSignatureController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    [self settingNavItem];
    RRFSignatureView *headView = [[RRFSignatureView alloc]init];
    headView.frame = CGRectMake(12, 64, SCREENWidth, 90);
    headView.messageView.delegate = self;
    headView.messageView.text = self.signStr;
    NSInteger count = 20 - self.signStr.length;
    if (count<0) {
        count = 0;
    }
    headView.numLabel.text = [NSString stringWithFormat:@"%ld",count];
    self.headView = headView;
    self.tableView.tableHeaderView = headView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:self.headView.messageView];
}
-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > kMaxLength) {
                textField.text = [toBeString substringToIndex:kMaxLength];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > kMaxLength) {
            textField.text = [toBeString substringToIndex:kMaxLength];
        }
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [self.headView.messageView resignFirstResponder];
    }
    NSString *contentStr = self.headView.messageView.text;
    NSInteger count;
    if([string isEqualToString:@""]){
        count = 20 - range.location;
    }else{
        count = 20 - (contentStr.length+1);
        if (count < 0) {
            count = 0;
        }
    }
    self.headView.numLabel.text = [NSString stringWithFormat:@"%ld",count];
    if (range.location == 21 || [string isEqualToString:@""]) {
        return YES;
    }else if (range.location == 19){
        return NO;
    }
    return YES;

}
-(void)settingNavItem
{
    UIButton *right = [[UIButton alloc]init];
    right.titleLabel.textAlignment = NSTextAlignmentRight;
    [right setTitle:@"完成" forState:UIControlStateNormal];
    right.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [right setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont systemFontOfSize:16];
    [right addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    right.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = item;
}
-(void)save
{
    NSString *str = self.headView.messageView.text ;
    if(str.length != 0){
        [MBProgressHUD show];
    }
    [RRFMeTool modifySelfSignWithText:str Success:^(id json) {
        [MBProgressHUD dismiss];
        [self.navigationController popViewControllerAnimated:YES];
    } failBlock:^(id json) {
        
    }];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self keyboardUp];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}
-(void)keyboardUp
{
    [self.headView.messageView becomeFirstResponder];
}
@end
