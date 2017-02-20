//
//  FreeBuyHeader.m
//  Puzzle
//
//  Created by huibei on 16/12/9.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "FreeBuyHeader.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "PZVerticalButton.h"
#import "UIButton+EdgeInsets.h"
#import "PurchaseGameActivity.h"
#import "FBNewWinnerModel.h"
@interface FreeBuyHeader()<SDCycleScrollViewDelegate>
{
    SDCycleScrollView *cycleScrollView ;
    SDCycleScrollView *botCycleScrollView ;
    NSMutableArray* imagesURLStrings ;
    NSArray* models;
    NSArray* winnerModels ;
}
@end

@implementation FreeBuyHeader
-(instancetype)init{
    if (self = [super init]) {
        WEAKSELF
        self.backgroundColor = [UIColor whiteColor];
        imagesURLStrings = [NSMutableArray array];
//        banner
        cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREENWidth, FreeBuyBannerHeight) delegate:self placeholderImage:[UIImage imageNamed:@"homepage_ranking_default-diagram"]];
        cycleScrollView.infiniteLoop = YES ;
        cycleScrollView.backgroundColor = HBColor(243, 243, 243);
        cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];
        cycleScrollView.titleLabelTextColor = [UIColor colorWithHexString:@"ffba26"] ;
        cycleScrollView.titleLabelTextFont = PZFont(12.0f);
        cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill ;
        cycleScrollView.delegate = self ;
        cycleScrollView.autoScrollTimeInterval = 6.0 ;
        [self addSubview:cycleScrollView];
        
        UIView* sepLine = [[UIView alloc]init];
        sepLine.backgroundColor = HBColor(243, 243, 243);
        [self addSubview:sepLine];
        [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(FreeBuyBannerHeight);
            make.height.mas_equalTo(1);
            make.left.right.mas_equalTo(0);
        }];
        
        UIView* midView = [[UIView alloc]init];
        [self addSubview:midView];
        [midView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(sepLine.mas_bottom);
            make.height.mas_equalTo(80);
            make.left.right.mas_equalTo(0);
        }];
//        开奖  晒单  帮助
        UIButton* Lottery = [UIButton new];
        [Lottery setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
        Lottery.titleLabel.font  = PZFont(11.0f);
        [Lottery setTitle:@"揭晓" forState:UIControlStateNormal];
        [Lottery setImage:[UIImage imageNamed:@"home_announced_btn"] forState:UIControlStateNormal];
        [midView addSubview:Lottery];
        [Lottery mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(SCREENWidth/4);
            make.centerY.mas_equalTo(midView.mas_centerY);
        }];
        [Lottery layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageTop imageTitlespace:4 imageWidth:36];
        [[Lottery rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (weakSelf.itemClickBlock) {
                weakSelf.itemClickBlock(0);
            }
        }];
        
        UIButton* Show = [UIButton new];
        Show.titleLabel.font  = PZFont(11.0f);
        Show.imageView.contentMode = UIViewContentModeScaleAspectFit ;
        [Show setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
        [Show setTitle:@"晒单" forState:UIControlStateNormal];
        [Show setImage:[UIImage imageNamed:@"home_the_sun_btn"] forState:UIControlStateNormal];
        [midView addSubview:Show];
        [Show mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCREENWidth/4);
            make.left.mas_equalTo(Lottery.mas_right);
            make.centerY.mas_equalTo(midView.mas_centerY);
        }];
        [Show layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageTop imageTitlespace:4 imageWidth:36];
        [[Show rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (weakSelf.itemClickBlock) {
                weakSelf.itemClickBlock(1);
            }
        }];
        
        UIButton* Order = [UIButton new];
        Order.titleLabel.font  = PZFont(11.0f);
        [Order setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
        [Order setTitle:@"订单" forState:UIControlStateNormal];
        [Order setImage:[UIImage imageNamed:@"btn_0yuanduobao_order"] forState:UIControlStateNormal];
        [midView addSubview:Order];
        [Order mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCREENWidth/4);
            make.left.mas_equalTo(Show.mas_right);
            make.centerY.mas_equalTo(midView.mas_centerY);
        }];
        [Order layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageTop imageTitlespace:4 imageWidth:36];
        [[Order rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (weakSelf.itemClickBlock) {
                weakSelf.itemClickBlock(2);
            }
        }];

        
        UIButton* Help = [UIButton new];
        Help.titleLabel.font  = PZFont(11.0f);
        [Help setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateNormal];
        [Help setTitle:@"帮助" forState:UIControlStateNormal];
        [Help setImage:[UIImage imageNamed:@"home_help_btn"] forState:UIControlStateNormal];
        [midView addSubview:Help];
        [Help mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCREENWidth/4);
            make.left.mas_equalTo(Order.mas_right);
            make.centerY.mas_equalTo(midView.mas_centerY);
        }];
        [[Help rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (weakSelf.itemClickBlock) {
                weakSelf.itemClickBlock(3);
            }
        }];
        [Help layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageTop imageTitlespace:4 imageWidth:36];

        
        UIView* sepLine2 = [[UIView alloc]init];
        sepLine2.backgroundColor = HBColor(243, 243, 243);
        [self addSubview:sepLine2];
        [sepLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-44);
            make.height.mas_equalTo(1);
            make.left.right.mas_equalTo(0);
        }];
        
        UIImageView *iconView = [[UIImageView alloc]init];
        iconView.image = [UIImage imageNamed:@"0yuan_home_icon_jmessage"];
        [self addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(sepLine2.mas_bottom).offset(12-5);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        
        botCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(50-12, FreeBuyBannerHeight+76, SCREENWidth, 44) delegate:self placeholderImage:nil];
        botCycleScrollView.tag = 1 ;
        botCycleScrollView.infiniteLoop = YES ;
        botCycleScrollView.backgroundColor = [UIColor whiteColor];
        botCycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];
        botCycleScrollView.titleLabelTextColor = [UIColor colorWithHexString:@"ffba26"] ;
        botCycleScrollView.titleLabelTextFont = PZFont(12.0f);
        botCycleScrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
        botCycleScrollView.onlyDisplayText = YES;
        botCycleScrollView.autoScrollTimeInterval = 3.0 ;
        [self addSubview:botCycleScrollView];
        
        UIView* botView = [[UIView alloc]init];
        botView.backgroundColor = HBColor(243, 243, 243);
        [self addSubview:botView];
        [botView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(10);
        }];
    }
    return self ;
}

-(void)configModel:(NSArray *)activities{
    models = activities ;
    for ( PurchaseGameActivity* model in activities) {
        [imagesURLStrings addObject:model.picUrl];
    }
    cycleScrollView.imageURLStringsGroup = imagesURLStrings;
}

-(void)configWinners:(NSArray *)winners{
    winnerModels = winners ;
    NSMutableArray *titlesArray = [NSMutableArray new];
    for ( FBNewWinnerModel* model in winners) {
        NSString* phone = [NSString stringWithFormat:@"%ld",(long)model.phoneNumber];
        phone = [self secPhoneStr:phone];
        NSString* desc = [NSString stringWithFormat:@"恭喜 %@ 抢到 %@",phone,model.productName];
        [titlesArray addObject:desc];
    }
    botCycleScrollView.titlesGroup = [titlesArray copy];
    
}

-(NSString*)secPhoneStr:(NSString*)phone{
    if (phone.length != 11) {
        return phone;
    }
    NSString* temp = [phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    return temp ;
}


-(void)cycleScrollView:(SDCycleScrollView *)cycleView didSelectItemAtIndex:(NSInteger)index{
    if (cycleView.tag == 1) {
        FBNewWinnerModel* model = winnerModels[index];
        self.messageClickBlock(model);
    }
    else if(self.activityClickBlock) {
        PurchaseGameActivity* model = models[index];
        self.activityClickBlock(model);
    }
}

@end
