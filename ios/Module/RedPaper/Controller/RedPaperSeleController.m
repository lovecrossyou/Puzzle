//
//  RedPaperSeleController.m
//  Puzzle
//
//  Created by huibei on 17/1/11.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "RedPaperSeleController.h"
#import "RedPaperHeader.h"
#import "BonusPackage.h"
#import "BonusPaperTool.h"
#import "PZCache.h"
#import "JNQDiamondViewController.h"
#import "InviteFriendController.h"
#import "NSData+JsonData.h"

typedef void(^AlertAction)();

@interface RedPaperSeleController () <UITextFieldDelegate>

@end

@implementation RedPaperSeleController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF
    self.tableView.backgroundColor = HBColor(254,250,247);
    BOOL singleBonusPaper = self.singleBonusPaper ;
    RedPaperHeader* header = [[RedPaperHeader alloc]initWithSingle:singleBonusPaper count:self.menbers];
    header.vc = self;
    header.sendRedPaperBlock = ^(NSInteger count,NSInteger singleAmount,NSInteger totalAmount,NSString* type,NSString* desInfo,NSString* place){
        NSString* placeType = weakSelf.friendCircle ? @"friendCircle" : place ;
        BonusPackage* redPaper = nil ;
        if ([type isEqualToString:@"single"]) {
            redPaper = [[BonusPackage alloc]initWithBonusType:type count:1 averageMount:singleAmount totalMount:totalAmount desc:desInfo place:place];
        }
        else{
            redPaper = [[BonusPackage alloc]initWithBonusType:type count:count averageMount:singleAmount totalMount:totalAmount desc:desInfo place:placeType];
        }
        [weakSelf requestBonusPaper:redPaper];
    };
    header.frame = CGRectMake(0,0,SCREENWidth,300+60);
    self.tableView.tableHeaderView = header ;
    [self setNavItem];
}

-(void)requestBonusPaper:(BonusPackage*) redPaper{
    WEAKSELF
    [MBProgressHUD show];
    [BonusPaperTool sendBonusPaper:redPaper Success:^(id json) {
        [MBProgressHUD dismiss];
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            if (weakSelf.sendRedPaperBlock) {
                weakSelf.sendRedPaperBlock(json,redPaper);
            }
        }];
    } failBlock:^(NSError* error) {
        [MBProgressHUD dismiss];
        NSData* data = error.userInfo[@"com.alamofire.serialization.response.error.data"] ;
        NSDictionary* jsonD = [data toJsonData];
        if (jsonD != nil) {
            NSString* message = jsonD[@"message"];
            if ([message containsString:@"打赏金额"]) {
                [MBProgressHUD showInfoWithStatus:message];
                return ;
            }
            [weakSelf goExchangeXT];
        }
    }];
}

-(void)goExchangeXT{
    BOOL appOpen = [PZCache sharedInstance].versionRelease ;
    NSString* message = appOpen?@"您的喜腾币余额不足，需购买钻石兑换喜腾币" : @"分享获取喜腾币" ;
    NSString* titleVC = appOpen?@"购买钻石" : @"邀请朋友获取喜腾币" ;
    NSString* confirmTitle = appOpen?@"立即购买" : @"立即邀请" ;
    WEAKSELF
    [self showActionWithTitle:nil message:message cancelAction:nil confirmAction:^{
        if (appOpen) {
            JNQDiamondViewController* exchangeVC = [[JNQDiamondViewController alloc]init];
            exchangeVC.title = titleVC ;
            [self.navigationController pushViewController:exchangeVC animated:YES];
        }
        else{
            [weakSelf shareFriend];
        }
        
    } confirmTitle:confirmTitle];
}

-(void)showActionWithTitle:(NSString*)title message:(NSString*)msg cancelAction:(AlertAction)cancelAct confirmAction:(AlertAction)confirm confirmTitle:(NSString*)confirmTitle{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:cancelAct];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:confirm];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self.navigationController presentViewController:alertController animated:YES completion:^{
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *textString = [NSString stringWithFormat:@"%@%@",textField.text, string];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [textString dataUsingEncoding:enc];
    if (da.length >32) {
        [MBProgressHUD showInfoWithStatus:@"字数不可超过16字"];
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - 分享
-(void)shareFriend{
    InviteFriendController* invite = [[InviteFriendController alloc]init];
    invite.title = @"邀请朋友" ;
    [self.navigationController pushViewController:invite animated:YES];
}


-(void)setNavItem{
    UIBarButtonItem* closeItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeController)];
    self.navigationItem.leftBarButtonItem = closeItem ;
}

#pragma mark - 取消
-(void)closeController{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
