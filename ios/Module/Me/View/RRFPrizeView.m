//
//  RRFPrizeView.m
//  Puzzle
//
//  Created by huibei on 16/9/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFPrizeView.h"
#import "JNQAddressOperateView.h"
#import "RRFNoticeModel.h"
#import "RRFDrawModel.h"
#import "RRFPrizeInfoModel.h"
#import "UIImageView+WebCache.h"
@interface RRFPrizeView ()
@property(nonatomic,weak)UIImageView *headBgView;
@property(nonatomic,weak)UIImageView *headIconBtn;
@property(nonatomic,weak)UIButton *rankingBtn;
@property(nonatomic,weak)UIImageView *bodyBgView;
@property(nonatomic,weak)UILabel *prizeNameLabel;
@property(nonatomic,weak)UIImageView *prizeIconBtn;
@property(nonatomic,weak)UILabel *descriptionStrLabel;
@property(nonatomic,weak)UIButton *determineBtn;
@end
@implementation RRFPrizeView
-(instancetype)init{
    if (self = [super init]) {
        RRFDrawModel *drawModel = [[RRFDrawModel alloc]init];
        drawModel.positionX = 0.0f;
        drawModel.positionY = 0.0f;
        drawModel.isDefault = 0;
        self.drawModel = drawModel;
        
        self.backgroundColor = [UIColor colorWithHexString:@"ffedcd"];
        UIImageView *headBgView = [[UIImageView alloc]init];
        headBgView.image = [UIImage imageNamed:@"medal"];
        self.headBgView = headBgView;
        [self addSubview:headBgView];
        [headBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(228, 167));
        }];
        
        UIImageView *headIconBtn = [[UIImageView alloc]init];
        [headIconBtn sizeToFit];
        headIconBtn.layer.cornerRadius = 50;
        headIconBtn.layer.masksToBounds = YES;
        self.headIconBtn = headIconBtn;
        [headBgView addSubview:headIconBtn];
        [headIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(headBgView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(100, 100));
            make.top.mas_equalTo(headBgView.mas_top).offset(54);
        }];
        
        UIButton *rankingBtn = [[UIButton alloc]init];
        rankingBtn.backgroundColor = [UIColor colorWithHexString:@"ffde00"];
        [rankingBtn sizeToFit];
        [rankingBtn.layer setBorderWidth:3];
        CGColorSpaceRef colorSpaceRefss = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorss = CGColorCreate(colorSpaceRefss, (CGFloat[]){240/255.0,172/255.0,60/255.0,1});
        [rankingBtn.layer setBorderColor:colorss];
        rankingBtn.layer.cornerRadius = 13;
        rankingBtn.layer.masksToBounds = YES;
        rankingBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [rankingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rankingBtn.titleLabel.font = [UIFont boldSystemFontOfSize:21];
        self.rankingBtn = rankingBtn;
        [headBgView addSubview:rankingBtn];
        [rankingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(headIconBtn.mas_centerX);
            make.bottom.mas_equalTo(headIconBtn.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(26, 26));
        }];
        
        
        UIImageView *bodyBgView = [[UIImageView alloc]init];
        bodyBgView.image = [UIImage imageNamed:@"prize_lg"];
        self.bodyBgView = bodyBgView;
        [self addSubview:bodyBgView];
        [bodyBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(233);
            make.top.mas_equalTo(self.headBgView.mas_bottom).offset(15);
        }];
        
    
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"奖品";
        titleLabel.textColor = [UIColor colorWithHexString:@"fff3e0"];
        titleLabel.font = [UIFont boldSystemFontOfSize:23];
        [titleLabel sizeToFit];
        [bodyBgView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bodyBgView.mas_centerX);
            make.top.mas_equalTo(10);
        }];
        
        UILabel *prizeNameLabel = [[UILabel alloc]init];
        prizeNameLabel.numberOfLines = 2;
        prizeNameLabel.textColor = [UIColor colorWithHexString:@"fff3e0"];
        prizeNameLabel.font = [UIFont systemFontOfSize:15];
        [prizeNameLabel sizeToFit];
        self.prizeNameLabel = prizeNameLabel;
        [bodyBgView addSubview:prizeNameLabel];
        [prizeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(bodyBgView.mas_centerX);
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(12);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
        }];
        
        UIImageView *prizeIconBtn = [[UIImageView alloc]init];
        [prizeIconBtn.layer setBorderWidth:2];
        CGColorSpaceRef prizeIconBtnColorSpaceRefss = CGColorSpaceCreateDeviceRGB();
        CGColorRef prizeIconBtnColorss = CGColorCreate(prizeIconBtnColorSpaceRefss, (CGFloat[]){250/255.0,250/255.0,248/255.0,1});
        [prizeIconBtn.layer setBorderColor:prizeIconBtnColorss];
        prizeIconBtn.layer.cornerRadius = 5;
        prizeIconBtn.layer.masksToBounds = YES;
        prizeIconBtn.contentMode = UIViewContentModeScaleAspectFit;
        [prizeIconBtn sizeToFit];
        self.prizeIconBtn = prizeIconBtn;
        [bodyBgView addSubview:prizeIconBtn];
        [prizeIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(prizeNameLabel.mas_bottom).offset(12);
            make.centerX.mas_equalTo(bodyBgView.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(125, 125));
        }];
        
        
        UILabel *descriptionStrLabel = [[UILabel alloc]init];
        descriptionStrLabel.textColor = [UIColor colorWithHexString:@"777777"];
        descriptionStrLabel.font = [UIFont systemFontOfSize:15];
        [descriptionStrLabel sizeToFit];
        descriptionStrLabel.numberOfLines = 0;
        [self addSubview:descriptionStrLabel];
        [descriptionStrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bodyBgView.mas_bottom).offset(20);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
        }];
        self.descriptionStrLabel = descriptionStrLabel ;
        WEAKSELF
        JNQAddressOperateHeaderView *addView = [[JNQAddressOperateHeaderView alloc]init];
        addView.showTitle = NO;
        addView.hiddenDefault = YES;
        [addView.nameView.singnal subscribeNext:^(id x) {
            weakSelf.drawModel.recievName = x ;
        }];
        [addView.phoneView.singnal subscribeNext:^(id x) {
            weakSelf.drawModel.phoneNum = x ;
        }];
        [addView.addressView.singnal subscribeNext:^(id x) {
            weakSelf.drawModel.districtAddress = x ;
        }];
        [addView.detailInfoView.singnal subscribeNext:^(id x) {
            weakSelf.drawModel.detailAddress = x ;
            weakSelf.drawModel.fullAddress = [NSString stringWithFormat:@"%@%@",weakSelf.drawModel.districtAddress,x];
        }];
        self.addView = addView;
        [self addSubview:addView];
        [addView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.top.mas_equalTo(descriptionStrLabel.mas_bottom).offset(30);
            make.height.mas_equalTo(176);
        }];
        addView.chooseContactBlock = ^(){
            if (self.chooseContactBlock) {
                self.chooseContactBlock();
            }
        };
        addView.chooseAddressBlcok = ^(){
            if (self.chooseAddressBlcok) {
                self.chooseAddressBlcok();
            }
        };
        
        
        UIButton *determineBtn = [[UIButton alloc]init];
        [determineBtn setTitle:@"立即领取" forState:UIControlStateNormal];
        [determineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        determineBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [determineBtn setBackgroundImage:[UIImage imageNamed:@"btn_rosecolor"] forState:UIControlStateNormal];
        [determineBtn sizeToFit];
        determineBtn.layer.cornerRadius = 5;
        determineBtn.layer.masksToBounds = YES;
        self.determineBtn = determineBtn;
        [self addSubview:determineBtn];
        [determineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(addView.mas_bottom).offset(30);
            make.left.mas_equalTo(20);
            make.height.mas_equalTo(44);
            make.right.mas_equalTo(-20);
        }];
        [[determineBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.determineBlock) {
                self.determineBlock();
            }
        }];
        
    }
    return self;
}
-(void)setModel:(RRFNoticeModel *)model
{
    _model = model;
    RRFPrizeInfoModel *infoM = model.award;
    self.drawModel.awardRecordId = infoM.awardRecordId;
    [self.self.headIconBtn sd_setImageWithURL:[NSURL URLWithString:infoM.userIcon] placeholderImage:[UIImage imageNamed:@"common_head_default-diagram"]];
    [self.rankingBtn setTitle:[NSString stringWithFormat:@"%ld",(long)infoM.rank] forState:UIControlStateNormal];
    self.prizeNameLabel.text = infoM.awardName;
    [self.prizeIconBtn sd_setImageWithURL:[NSURL URLWithString:infoM.pic] placeholderImage:[UIImage imageNamed:@"common_head_default-diagram"]];
    NSString *infoStr = [model.award.content substringToIndex:model.award.content.length-9];
    self.descriptionStrLabel.text = [NSString stringWithFormat:@"%@请填写详细信息领取奖品，领取之后，在'我'- '礼品订单'中查看您的奖品",infoStr];

}
@end
