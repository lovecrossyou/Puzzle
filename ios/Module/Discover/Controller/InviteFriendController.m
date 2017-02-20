//
//  InviteFriendController.m
//  Puzzle
//
//  Created by huipay on 2016/9/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "InviteFriendController.h"

#import "LoginModel.h"

#import "PZTextView.h"
#import "HBVerticalBtn.h"
#import "JNQInviteAwardView.h"

#import "HomeTool.h"
#import "HBShareTool.h"
#import "PZParamTool.h"
#import "UIImageView+WebCache.h"
#import <LGAlertView/LGAlertView.h>
#import "WXApi.h"
#import <UMSocialSnsPlatformManager.h>

typedef void(^ShareBlock)(HBVerticalBtn *shareBtn);

@interface InviteFriendHead : UIView

@property (nonatomic, strong) PZTextView* noteView;
@property (nonatomic, strong) UIButton* shareBtn;
@property (nonatomic, strong) UIView *shareView;
@property (nonatomic, strong) ShareBlock shareBlock;


@end


@implementation InviteFriendHead

-(instancetype)initWithSender:(UIViewController*)sender{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *atten = [[UILabel alloc] init];
        [self addSubview:atten];
        [atten mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(27.5);
            make.centerX.mas_equalTo(self);
            make.height.mas_equalTo(17);
        }];
        atten.font = PZFont(16);
        atten.textColor = HBColor(255, 66, 67);
        atten.textAlignment = NSTextAlignmentCenter;
        atten.text = @"红包";
        
        UIButton *hbBtn = [[UIButton alloc] init];
        [self addSubview:hbBtn];
        [hbBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(atten.mas_bottom).offset(16);
            make.centerX.mas_equalTo(self);
            make.height.mas_equalTo(30);
        }];
//        hbBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        hbBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        [hbBtn setImage:[UIImage imageNamed:@"icon_big"] forState:UIControlStateNormal];
        [hbBtn setTitle:@" 100" forState:UIControlStateNormal];
        [hbBtn setTitleColor:HBColor(255, 66, 67) forState:UIControlStateNormal];
        hbBtn.titleLabel.font = PZFont(30);
        [hbBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 8, 0)];
        
        UILabel *atten2 = [[UILabel alloc] init];
        [self addSubview:atten2];
        [atten2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(hbBtn.mas_bottom).offset(10);
            make.centerX.mas_equalTo(self);
            make.height.mas_equalTo(13);
        }];
        atten2.font = PZFont(13);
        atten2.textColor = HBColor(51, 51, 51);
        atten2.textAlignment = NSTextAlignmentCenter;
        atten2.text = @"(本红包由喜腾免费提供)";
        
        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(atten2.mas_bottom).offset(20);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(53);
        }];
        view.backgroundColor = HBColor(245, 245, 245);
        
        NSString* placeHolderString = @"恭喜发财，大吉大利，喜腾投注，鸿运当头！";
        _noteView = [[PZTextView alloc]initWithPlaceHolder:placeHolderString];
        _noteView.textView.returnKeyType = UIReturnKeyDone ;
        [self addSubview:_noteView];
        [_noteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(view);
            make.left.right.mas_equalTo(view);
            make.height.mas_equalTo(30);
        }];
        _noteView.textView.backgroundColor = HBColor(245, 245, 245);
        [_noteView.placeHolderView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_noteView);
        }];
        _noteView.placeHolderView.textColor = HBColor(51, 51, 51);
        _noteView.placeHolderView.font = PZFont(13.5);
        
        UIImageView* icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jnq_invitation_illustration"]];
        [self addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_noteView.mas_bottom).offset(25);
            make.centerX.mas_equalTo(self.mas_centerX);
//            make.size.mas_equalTo(CGSizeMake(225, 130));
            make.height.mas_equalTo(223);
        }];
        icon.contentMode = UIViewContentModeScaleAspectFill;
        
        UILabel* contentView = [[UILabel alloc]init];
        [self addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(icon.mas_bottom).offset(20);
            make.centerX.mas_equalTo(self.mas_centerX);
//            make.height.mas_equalTo(223);
            make.width.mas_equalTo(SCREENWidth-40);
        }];
        [contentView sizeToFit];
        contentView.font = PZFont(13.0f);
        contentView.textColor = HBColor(119, 119, 119);
        contentView.numberOfLines = 0 ;
        contentView.text = @"你邀请1个朋友投注奖励100喜腾币，你的朋友邀请5个朋友投注再奖励100喜腾币！邀请越多，奖励越多！" ;
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:contentView.text];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6];
        [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [contentView.text length])];
        contentView.attributedText = string;
    
        _shareBtn = [[UIButton alloc] init];
        [self addSubview:_shareBtn];
        [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self).offset(-45);
            make.centerX.mas_equalTo(self);
            make.width.mas_equalTo(SCREENWidth-30);
            make.height.mas_equalTo(40);
        }];
        _shareBtn.backgroundColor = BasicBlueColor;
        [_shareBtn setTitle:@"立即邀请" forState:UIControlStateNormal];
//        [shareBtn setTitleColor:HBColor(51, 51, 51) forState:UIControlStateNormal];
        _shareBtn.titleLabel.font = PZFont(16);
    }
    return self ;
}
@end

@interface InviteFriendController ()<LGAlertViewDelegate>{
    LGAlertView* actionSheet ;
}
@property (nonatomic, strong) JNQShareView *shareView;
@property (nonatomic, strong) InviteFriendHead* headView;

@property(strong,nonatomic)UIButton *backBtn ;
@end

@implementation InviteFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitInviteVC) name:@"quitInviteVC" object:nil];
    _headView = [[InviteFriendHead alloc]initWithSender:self];
    CGFloat height = SCREENHeight>=667 ? SCREENHeight-64 : SCREENHeight-64+130;
    _headView.frame = CGRectMake(0, 0, SCREENWidth, height);
    self.tableView.tableHeaderView = _headView ;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.keyboardDismissMode =  UIScrollViewKeyboardDismissModeOnDrag ;
    WEAKSELF
    [[_headView.shareBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        JNQShareView* shareView = [[JNQShareView alloc] init];
        weakSelf.shareView = shareView ;
        shareView.frame = CGRectMake(0, 0, SCREENWidth, 140);
        actionSheet = [[LGAlertView alloc]initWithViewAndTitle:nil message:nil style:LGAlertViewStyleActionSheet view:shareView buttonTitles:nil cancelButtonTitle:nil destructiveButtonTitle:nil delegate:self];
        actionSheet.dismissOnAction = YES ;
        [actionSheet showAnimated:YES completionHandler:^{
            
        }];
        [weakSelf.shareView.quitBtn addTarget:self action:@selector(hiddenShareView:) forControlEvents:UIControlEventTouchUpInside];
        shareView.shareBlock = ^(HBVerticalBtn *shareBtn) {
            if (![WXApi isWXAppInstalled]) {
                [MBProgressHUD showInfoWithStatus:@"您没有安装微信应用"];
                return ;
            }
            NSString* placeHolderString = @"亲，我送你100喜腾币，免费参加股市猜涨跌游戏，祝你好运！";
            NSString* content = [weakSelf.headView.noteView getText];
            if (content == nil || content.length == 0) {
                content = placeHolderString ;
            }
            NSString* title = @"领取红包100喜腾币，参与股市猜涨跌，猜对即可盈利！" ;
            __block NSString* desc = @"下载喜腾客户端，免费参加股市猜涨跌游戏，赢取喜腾币任性兑换礼品！" ;
            [HomeTool inviteWithContent:content successBlock:^(id json) {
                NSString *fullUrlStr = [NSString stringWithFormat:@"%@%@",Base_url,json[@"url"]];
                NSArray* platForms = @[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ];
                if (shareBtn.tag==0 || shareBtn.tag==3) {
                    desc = [NSString stringWithFormat:@"一起来参加股市猜涨跌，猜对即可盈利，祝你好运！ %@", fullUrlStr];
                }
                [weakSelf requestUserAvatar:^(UIImage* image) {
                    [actionSheet dismissAnimated:YES completionHandler:nil];
                    [[HBShareTool sharedInstance] shareSingleSNSWithType:platForms[shareBtn.tag] title:title image:image url:fullUrlStr msg:desc presentedController:weakSelf];
                }];
            } fail:^(id json) {
                
            }];
        };
    }];
    if (self.showCancel) {
        UIBarButtonItem* cancelItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelController)];
        self.navigationItem.rightBarButtonItem = cancelItem ;
    }
    [self settingNavItem];
}




-(void)settingNavItem
{
    UIButton *leftItem = [[UIButton alloc]init];
    leftItem.titleLabel.font = PZFont(15.0f);
    [leftItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftItem setTitle:@"取消" forState:UIControlStateNormal];
    leftItem.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [leftItem addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    leftItem.frame = CGRectMake(0, 0, 80, 44);
    [leftItem setTitleEdgeInsets:UIEdgeInsetsMake(0, -44, 0, 44)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:leftItem];
    self.navigationItem.leftBarButtonItem = item;
    
}
#pragma mark - 分享
-(void)backClick
{
    if (self.showCancel) {
        [self cancelController];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)requestUserAvatar:(ItemClickParamBlock)completeBlock{
    dispatch_async(dispatch_get_main_queue(), ^{
        LoginModel* loginModel = [PZParamTool currentUser];
        UIImage* defaultIcon = [UIImage imageNamed:@"share_logo"] ;
        if (loginModel != nil) {
            NSString* avatarUrl = loginModel.icon ;
            if (avatarUrl!=nil) {
                UIImageView* imageView = [[UIImageView alloc]init];
                [imageView sd_setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:defaultIcon options:SDWebImageContinueInBackground completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if (error != nil) {
                        completeBlock(defaultIcon);
                    }
                    else{
                        completeBlock(image);
                    }
                }];
            } else {
                completeBlock(defaultIcon);
            }
        } else {
            completeBlock(defaultIcon);
        }        
    });
}

-(void)cancelController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)quitInviteVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hiddenShareView:(UIButton *)button {
    [actionSheet dismissAnimated:YES completionHandler:nil];

}

@end
