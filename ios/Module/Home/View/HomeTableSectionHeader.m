//
//  HomeTableSectionHeader.m
//  Puzzle
//
//  Created by huipay on 2016/9/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "HomeTableSectionHeader.h"
#import "UIImageView+WebCache.h"
#import "HomeTool.h"
#import "JNQAwardModel.h"

@interface HomeSecHeader()
@property(weak,nonatomic)UILabel* titleLabel ;
@property(weak,nonatomic)UIButton *yearBtn;
@property(weak,nonatomic)UIButton *monthlyBtn;
@property(weak,nonatomic)UIButton *weeklyBtn;


@property(weak,nonatomic)UIButton *selectedBtn;
@end

@implementation HomeSecHeader

-(instancetype)init{
    if (self = [super init]) {
        UILabel* titleLabel = [[UILabel alloc]init];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = PZFont(16.0f);
        titleLabel.text = @"股神争霸" ;
        [titleLabel sizeToFit];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(2);
            make.height.mas_equalTo(32.0);
        }];
        self.titleLabel = titleLabel ;
        
        UIButton *weeklyBtn = [[UIButton alloc]init];
        [weeklyBtn setTitle:@"本周排行" forState:UIControlStateNormal];
        [weeklyBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [weeklyBtn setTitleColor:StockRed forState:UIControlStateSelected];
        weeklyBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [weeklyBtn sizeToFit];
        self.weeklyBtn = weeklyBtn;
        [self addSubview:weeklyBtn];
        [weeklyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12-12);
            make.bottom.mas_equalTo(titleLabel.mas_bottom);
            make.centerY.mas_equalTo(titleLabel.mas_centerY);
        }];
        WEAKSELF
        [[weeklyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton* sender) {
            weakSelf.selectedBtn.selected = NO ;
            sender.selected = YES ;
            weakSelf.selectedBtn = sender ;
            weakSelf.rankTypeBlock(1);            
        }];
        
        UIView *sep = [[UIView alloc]init];
        sep.backgroundColor =[ UIColor colorWithHexString:@"999999"];
        [self addSubview:sep];
        [sep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weeklyBtn.mas_left).offset(-12);
            make.centerY.mas_equalTo(titleLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(1, 10));
        }];
        
        UIButton *monthBtn = [[UIButton alloc]init];
        [monthBtn setTitle:@"本月排行" forState:UIControlStateNormal];
        [monthBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [monthBtn setTitleColor:StockRed forState:UIControlStateSelected];
        monthBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [monthBtn sizeToFit];
        self.monthlyBtn = monthBtn;
        [self addSubview:monthBtn];
        [monthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(sep.mas_left).offset(-8);
            make.bottom.mas_equalTo(titleLabel.mas_bottom);
            make.centerY.mas_equalTo(titleLabel.mas_centerY);
        }];
        
        [[monthBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton* sender) {
            weakSelf.selectedBtn.selected = NO ;
            sender.selected = YES ;
            weakSelf.selectedBtn = sender ;
            weakSelf.rankTypeBlock(2);
            [weakSelf getChampionAward:2];
            
        }];
        
        UIView *sep1 = [[UIView alloc]init];
        sep1.backgroundColor =[ UIColor colorWithHexString:@"999999"];
        [self addSubview:sep1];
        [sep1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(monthBtn.mas_left).offset(-12);
            make.size.mas_equalTo(CGSizeMake(1, 10));
            make.centerY.mas_equalTo(titleLabel.mas_centerY);
            
        }];
        
        UIButton *yearBtn = [[UIButton alloc]init];
        [yearBtn setTitle:@"本年排行" forState:UIControlStateNormal];
        [yearBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [yearBtn setTitleColor:StockRed forState:UIControlStateSelected];
        yearBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [yearBtn sizeToFit];
        self.yearBtn = yearBtn;
        [self addSubview:yearBtn];
        [yearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(sep1.mas_left).offset(-8);
            make.bottom.mas_equalTo(titleLabel.mas_bottom);
            make.centerY.mas_equalTo(titleLabel.mas_centerY);
        }];
        [[yearBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton* sender) {
            weakSelf.selectedBtn.selected = NO ;
            sender.selected = YES ;
            weakSelf.selectedBtn = sender ;
            weakSelf.rankTypeBlock(3);
            [weakSelf getChampionAward:3];
        }];
    }
    return self ;
}

-(void)getChampionAward:(int)awardType{
}

@end

@interface HomeTableSectionOne()
{
}

@property(weak,nonatomic)UIImageView* bannerView ;

@end

@implementation HomeTableSectionOne
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView* sepLine = [[UIImageView alloc]init];
        UIImage* image = [UIImage imageNamed:@"home_line"];
        CGSize size = image.size ;
        image = [image stretchableImageWithLeftCapWidth:size.width*0.5 topCapHeight:size.height*0.5];
        sepLine.image = image ;
        [self addSubview:sepLine];
        [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(16);
            make.right.mas_equalTo(-16);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(0);
        }];
        
        UIImageView* bannerView = [[UIImageView alloc]init];
        bannerView.layer.masksToBounds = YES ;
        bannerView.layer.cornerRadius = 3 ;
        bannerView.contentMode = UIViewContentModeScaleAspectFill ;
        [self addSubview:bannerView];
        [bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(130.0f);
        }];
        self.bannerView = bannerView ;
        [self getChampionAward:1];
    }
    return self ;
}


#pragma mark - 依据时间类型 获取冠军奖品 1周2月3年champion
-(void)getChampionAward:(int)awardType{
    [HomeTool getChampionAwardByType:awardType successBlock:^(id json) {
        JNQAwardModel* awardModel = [JNQAwardModel yy_modelWithJSON:json[@"info"]];
        [self.bannerView sd_setImageWithURL:[NSURL URLWithString:awardModel.presentModel.picUrl] placeholderImage:[UIImage imageNamed:@"homepage_ranking_default-diagram"]];
    } fail:^(id json) {
        
    }];
}


@end


@interface HomeTableSectionTwo()

@property(weak,nonatomic)UILabel* titleLabel ;

@end

@implementation HomeTableSectionTwo
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel* titleLabel = [[UILabel alloc]init];
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.font = PZFont(13.0f);
        titleLabel.text = @"  热门问吧" ;
        titleLabel.layer.masksToBounds = YES ;
        titleLabel.layer.borderColor = [UIColor colorR:243 colorG:243 colorB:243].CGColor;
        titleLabel.layer.borderWidth = 1 ;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(-2);
            make.right.mas_equalTo(2);
            make.top.bottom.mas_equalTo(0);
        }];
        self.titleLabel = titleLabel ;
    }
    return self ;
}

@end
