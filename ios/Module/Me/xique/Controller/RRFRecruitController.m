//
//  RRFRecruitController.m
//  Puzzle
//
//  Created by huibei on 16/9/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFRecruitController.h"
#import "RRFRecruitView.h"
#import "HBShareTool.h"
#import "HomeTool.h"
#import "JNQInviteAwardView.h"
#import "WXApi.h"
#import <UMSocialSnsPlatformManager.h>
#import "HBVerticalBtn.h"
//#import "JNQShareView.h"
@interface RRFRecruitController ()
@property(nonatomic,weak)RRFRecruitView *headView;
@property(nonatomic,strong)JNQShareView *shareView;
@property(nonatomic,weak)UIButton *backBtn;

@end

@implementation RRFRecruitController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF
    self.tableView.backgroundColor = [UIColor whiteColor];
    RRFRecruitView *headView = [[RRFRecruitView alloc]init];
    headView.frame = CGRectMake(0, 0, SCREENWidth, SCREENHeight);
    [[headView.clickBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
        backBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.backBtn = backBtn ;
        [self.view.window addSubview:backBtn];
        
        JNQShareView *shareView = [[JNQShareView alloc]init];
        shareView.atten.text = @"邀请朋友加入喜鹊计划";
        self.shareView = shareView;
        [self.view.window addSubview:shareView];
        [shareView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.view.window);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth-80, 225));
        }];
        
        _shareView.shareBlock = ^(HBVerticalBtn *shareBtn) {
            NSString* content = [headView.messageView getText];
            if (content == nil || content.length == 0) {
                content = @"亲，一起加入喜鹊计划吧！成为喜鹊代理商，零风险，高盈利！" ;
            }
            NSString* title = @"加入喜鹊计划成为喜腾代理商，零风险，高盈利!" ;
            __block NSString* desc = @"喜腾是一款猜股市涨跌的投资社交类游戏，无论股市涨跌均可盈利，上线后风靡全国！" ;
            [HomeTool recruitWithContent:content successBlock:^(id json) {
                [weakSelf hiddenShareView:backBtn];
                NSString* fullUrl = [NSString stringWithFormat:@"%@%@",Base_url,json[@"url"]];
                NSArray* platForms = @[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ];
                if (!shareBtn.tag) {
                    desc = [NSString stringWithFormat:@"喜腾是一款猜股市涨跌的投资社交类游戏，无论股市涨跌均可盈利，上线后风靡全国！%@", fullUrl];
                }
                [[HBShareTool sharedInstance] shareSingleSNSWithType:platForms[shareBtn.tag] title:title image:[UIImage imageNamed:@"share_logo"] url:fullUrl msg:desc presentedController:weakSelf];
            } fail:^(id json) {
                
            }];
        };
        [[_shareView.quitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self hiddenShareView:backBtn];
        }];
        [[backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self hiddenShareView:backBtn];
        }];

    }];
    self.headView = headView;
    self.tableView.tableHeaderView = headView;
}
- (void)hiddenShareView:(UIButton *)button {
    [UIView animateWithDuration:0.2 animations:^{
    } completion:^(BOOL finished) {
        [_shareView removeFromSuperview];
        [button removeFromSuperview];
    }];
}

@end
