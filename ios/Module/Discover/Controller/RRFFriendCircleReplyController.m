//
//  RRFFriendCircleReplyController.m
//  Puzzle
//
//  Created by huipay on 2016/12/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFFriendCircleReplyController.h"
#import "PZTextView.h"
#import "PZParamTool.h"
#import "HomePostCommentContent.h"
#import "UIViewController+ResignFirstResponser.h"

@interface RRFFriendCircleReplyController ()
@property(nonatomic,weak)HomePostCommentContent *textView;
@property(nonatomic,strong)NSString *content;
@end

@implementation RRFFriendCircleReplyController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF
    self.tableView.backgroundColor = [UIColor whiteColor];
    HomePostCommentContent *textView = [[HomePostCommentContent alloc]init];
    textView.frame = CGRectMake(0, 0, SCREENWidth, 180);
    textView.placeHolder = @"请输入你的评论";
    textView.hiddenPhoto = YES;
    self.textView = textView;
    self.tableView.tableFooterView = textView;
    [textView.textView.rac_textSignal subscribeNext:^(id x) {
        weakSelf.content = x ;
    }];
    
    UIButton *left = [[UIButton alloc]init];
    left.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [left setTitle:@"取消" forState:UIControlStateNormal];
    [left setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    left.titleLabel.font = [UIFont systemFontOfSize:15];
    left.frame = CGRectMake(0, 0, 44, 44);
    [left addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *right = [[UIButton alloc]init];
    right.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [right setTitle:@"发送" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    right.titleLabel.font = [UIFont systemFontOfSize:15];
    [right addTarget:self action:@selector(updateMessage) forControlEvents:UIControlEventTouchUpInside];
    right.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightItem;
}


-(void)cancelClick
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
- (void)updateMessage{
    
    if (self.content.length == 0) {
        [MBProgressHUD showInfoWithStatus:@"请输入内容"];
        return;
    }
    self.content = [self.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *url;
    NSMutableDictionary *prame = [[NSMutableDictionary alloc]init];
    [prame setObject:self.content forKey:@"content"];
    if (self.replyType == ReplyTypeReplyToReply ) {
        // 回复的回复
        url = @"client/friendCircle/addDynamicActionResponseToResponse";
        [prame setObject:@(self.responseId) forKey:@"responseId"];
    }else{
        // 回复
        url = @"client/friendCircle/addDynamicActionResponse";
        [prame setObject:@(self.responseId) forKey:@"commentId"];
    }
    [MBProgressHUD show];
    [PZParamTool replyCommentWithUrl:url param:prame Success:^(id json) {
        [MBProgressHUD dismiss];
        [MBProgressHUD showInfoWithStatus:@"评论成功!"];
        [[NSNotificationCenter defaultCenter] postNotificationName:RRFFriendCircleRefre object:nil];
        [self dismissViewControllerAnimated:YES completion:^{
            [self.textView resignFirstResponder];
        }];
    } failBlock:^(id json) {
        [MBProgressHUD dismiss];
    }];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self resignAll];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.textView.textView resignFirstResponder];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.textView.textView becomeFirstResponder];

}
@end
