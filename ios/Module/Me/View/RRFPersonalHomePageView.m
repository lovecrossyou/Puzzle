//
//  RRFPersonalHomePageView.m
//  Puzzle
//
//  Created by huibei on 16/9/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFPersonalHomePageView.h"
#import "RRFQuestionBarMsgModel.h"
#import "UIButton+WebCache.h"
#import "InsetsLabel.h"
#import "UIImageView+WebCache.h"
#import "RRFPuzzleBarTool.h"
#import "LoginModel.h"
#import "PZParamTool.h"
@interface RRFPersonalHomePageView ()
@property(nonatomic,weak)UIImageView *headIconView;
@property(nonatomic,weak)UILabel *titleLable;
@property(nonatomic,weak)UILabel *nameLabel;
@property(nonatomic,weak)UIButton *sexBtn;
// 关注
@property(nonatomic,weak)UIButton *focusBtn;

@property(nonatomic,weak)UIButton *userStatueIcon;
 // 签名
@property(nonatomic,weak)UILabel *signatureLabel;
@property(nonatomic,weak)UIImageView *bgImageView;
@property(nonatomic,weak)UIView *sepLine;
@property(nonatomic,strong)NSString *isFollower;
@end

@implementation RRFPersonalHomePageView
-(instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *bgImageView = [[UIImageView alloc]init];
        bgImageView.image = [UIImage imageNamed:@"shalong_bg"];
        self.bgImageView = bgImageView;
        [self addSubview:bgImageView];
        [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(255);
        }];
        
        UILabel *titleLable = [[UILabel alloc]init];
        titleLable.font = [UIFont systemFontOfSize:15];
        titleLable.textColor = [UIColor whiteColor];
        [titleLable sizeToFit];
        self.titleLable = titleLable;
        [self addSubview:titleLable];
        [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(95);
            make.centerX.mas_equalTo(bgImageView.mas_centerX);
        }];
        
        UIButton *attestationBtn = [[UIButton alloc]init];
        attestationBtn.hidden = YES;
        [attestationBtn setImage:[UIImage imageNamed:@"btn_V_authentication"] forState:UIControlStateNormal];
        self.attestationBtn = attestationBtn;
        [self addSubview:attestationBtn];
        [attestationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLable.mas_bottom).offset(16);
            make.centerX.mas_equalTo(bgImageView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(72, 25));
        }];
        
        UIButton *focusBtn = [[UIButton alloc]init];
        focusBtn.hidden = YES;
        [focusBtn setImage:[UIImage imageNamed:@"noFollower"] forState:UIControlStateNormal];
        [focusBtn setImage:[UIImage imageNamed:@"alreadyFollower"] forState:UIControlStateSelected];
        [focusBtn addTarget:self action:@selector(focusBtnClick) forControlEvents:UIControlEventTouchUpInside];
        self.focusBtn = focusBtn;
        [self addSubview:focusBtn];
        [focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLable.mas_bottom).offset(16);
            make.centerX.mas_equalTo(bgImageView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(72, 25));
        }];
    
        UIImageView *headIconView = [[UIImageView alloc]init];
        headIconView.layer.borderColor = [UIColor whiteColor].CGColor;
        headIconView.layer.borderWidth = 2.0f;
        headIconView.layer.masksToBounds = YES;
        headIconView.layer.cornerRadius = 3;
        [headIconView sizeToFit];
        self.headIconView = headIconView;
        [self addSubview:headIconView];
        [headIconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bgImageView.mas_bottom).offset(-40);
            make.left.mas_equalTo(12);
            make.size.mas_equalTo(CGSizeMake(65, 65));
        }];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.textColor = [UIColor colorWithHexString:@"ffffff"];
        nameLabel.font = [UIFont systemFontOfSize:17];
        [nameLabel sizeToFit];
        self.nameLabel = nameLabel;
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headIconView.mas_right).offset(12.5);
            make.top.mas_equalTo(headIconView.mas_top).offset(15);
        }];
        
        UIButton *sexBtn = [[UIButton alloc]init];
        sexBtn.userInteractionEnabled = NO;
        self.sexBtn = sexBtn;
        [self addSubview:sexBtn];
        [sexBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameLabel.mas_right).offset(4);
            make.centerY.mas_equalTo(nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        UIButton *userStatueIcon = [[UIButton alloc]init];
        [userStatueIcon sizeToFit];
        self.userStatueIcon = userStatueIcon;
        [self addSubview:userStatueIcon];
        [userStatueIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(sexBtn.mas_right).offset(4);
            make.centerY.mas_equalTo(nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        UILabel *signatureLabel = [[UILabel alloc]init];
        signatureLabel.numberOfLines = 1;
        signatureLabel.textColor  = [UIColor colorWithHexString:@"999999"];
        signatureLabel.font = [UIFont systemFontOfSize:11];
        self.signatureLabel = signatureLabel;
        [self addSubview:signatureLabel];
        [signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headIconView.mas_right).offset(12);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(bgImageView.mas_bottom).offset(8);
        }];
        
        UILabel *introduceLabel = [[UILabel alloc]init];
        self.introduceLabel = introduceLabel;
        introduceLabel.textColor = [UIColor colorWithHexString:@"999999"];
        introduceLabel.font = [UIFont systemFontOfSize:13];
        introduceLabel.numberOfLines = 0;
        [introduceLabel sizeToFit];
        [self addSubview:introduceLabel];
        [introduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(headIconView.mas_bottom).offset(10);
            make.height.mas_equalTo(40);
            make.right.mas_equalTo(-12);
        }];
        
        UIView *sepLine = [[UIView alloc]init];
        self.sepLine = sepLine;
        sepLine.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [self addSubview:sepLine];
        [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(12);
            make.bottom.mas_equalTo(0);
        }];
        
        UIButton *fanningBtn = [[UIButton alloc]init];
        self.fanningBtn = fanningBtn;
        fanningBtn.contentMode = UIViewContentModeScaleAspectFit;
        [fanningBtn setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
        [fanningBtn setImage:[UIImage imageNamed:@"fanning_up"] forState:UIControlStateSelected];
        [self addSubview:fanningBtn];
        [fanningBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(sepLine.mas_top).offset(-8);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(44, 10));
        }];
        
        
    }
    return self;
}
-(void)setType:(NSString *)type
{
    if ([type isEqualToString:@"RRFPersonalAskBarController"]) {
        self.attestationBtn.hidden = YES;
        self.focusBtn.hidden = NO;
        [self.attestationBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }else{
        self.attestationBtn.hidden = NO;
        self.focusBtn.hidden = YES;
        [self.attestationBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(25);
        }];
    }
}
-(CGFloat)HeadViewHeightWithModel:(RRFQuestionBarMsgModel *)model
{
    NSString *introduceStr = self.userM.userIntroduce;
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGRect rect = [introduceStr boundingRectWithSize:CGSizeMake(SCREENWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    CGFloat height ;
    if ([model.statue isEqualToString:@"already_review"]) {
        if (model.isFanning) {
            height = rect.size.height+290+12+10+10+8;
            [self.introduceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(rect.size.height);
            }];
            self.introduceLabel.text = model.userIntroduce;

        }else{
            if (rect.size.height > 40) {
                height = 290+12+10+40+10+8;
                [self.introduceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(40);
                }];
            }else{
                height = 290+12+10+rect.size.height;
                [self.introduceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(rect.size.height);
                }];
            }
            self.introduceLabel.text = model.userIntroduce;
        }
    }else{
        height = 290+12;
    }
    return height;
}
-(void)setUserM:(RRFQuestionBarMsgModel *)userM
{
    _userM = userM;
    LoginModel *infoM = [PZParamTool currentUser];
    BOOL isSelf = NO ;
    if (infoM != nil) {
        NSInteger userID = [infoM.userId intValue];
        if (userM.userId == userID) {
            isSelf = YES ;
        }
    }
    self.isFollower = userM.isFollower;
    [self.headIconView sd_setImageWithURL:[NSURL URLWithString:userM.userIconUrl]];
    self.attestationBtn.hidden = [userM.statue isEqualToString:@"already_review"];
    self.focusBtn.hidden = isSelf;
    self.focusBtn.selected = [userM.isFollower isEqualToString:@"alreadyFollower"];
    NSString *sexStr = [userM.sex isEqualToString:@"女"]?@"woman":@"man";
    [self.sexBtn setImage:[UIImage imageNamed:sexStr] forState:UIControlStateNormal];
    self.titleLable.text = [NSString stringWithFormat:@" %ld粉丝 | %ld评论",userM.fansAmount,userM.commentAmount];
    self.nameLabel.text = userM.userName;
    NSString *userStatue = [userM.statue isEqualToString:@"already_review"]?@"icon_v":@"";
    [self.userStatueIcon setImage:[UIImage imageNamed:userStatue] forState:UIControlStateNormal];
    self.signatureLabel.text = userM.selfSign;
    if ([userM.statue isEqualToString:@"already_review"]) {
        NSString *introduceStr = userM.userIntroduce;
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
        CGRect rect = [introduceStr boundingRectWithSize:CGSizeMake(SCREENWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
        self.fanningBtn.hidden = rect.size.height > 40?NO:YES;
        self.introduceLabel.hidden = NO;
        
    }else{
        self.fanningBtn.hidden = YES;
        self.introduceLabel.hidden = YES;

    }
    self.introduceLabel.text = userM.userIntroduce;
}

-(void)focusBtnClick
{
    [RRFPuzzleBarTool addFllowerWithUserId:self.userM.userId Success:^(id json) {
        NSInteger fanceCount = self.userM.fansAmount;
        if ([self.isFollower isEqualToString:@"alreadyFollower"]) {
            self.isFollower = @"noFollower";
            [MBProgressHUD showInfoWithStatus:@"取消关注"];
            fanceCount -= 1;
            self.userM.fansAmount = fanceCount;
        }else{
            fanceCount += 1;
            self.userM.fansAmount = fanceCount;
            self.isFollower = @"alreadyFollower";
            [MBProgressHUD showInfoWithStatus:@"已关注"];
        }
        self.titleLable.text = [NSString stringWithFormat:@"%ld粉丝 | %ld评论",fanceCount,self.userM.commentAmount];
        self.focusBtn.selected = [self.isFollower isEqualToString:@"alreadyFollower"];
    } failBlock:^(id json) {
        
    }];
    
}



@end
