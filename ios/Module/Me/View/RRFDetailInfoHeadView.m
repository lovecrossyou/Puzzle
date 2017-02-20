//
//  RRFDetailInfoHeadView.m
//  Puzzle
//
//  Created by huibei on 16/11/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFDetailInfoHeadView.h"
#import "PZTitleInputView.h"
#import "RRFDetailInfoModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import <HUPhotoBrowser/HUPhotoBrowser.h>
#import "UIImageView+WebCache.h"
@interface RRFDetailInfoHeadView ()

@property(nonatomic,strong)NSArray *headerUrlArray;
@end
@implementation RRFDetailInfoHeadView
-(instancetype)initWithModel:(RRFDetailInfoModel *)model
{
    if (self = [super init]) {
        UIView *headView = [[UIView alloc]init];
        headView.backgroundColor = [UIColor whiteColor];
        [self addSubview:headView];
        [headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(80);
        }];
        
        WEAKSELF
        UIButton *headBtn = [[UIButton alloc] init];
        headBtn.contentMode = UIViewContentModeScaleAspectFit;
        [headView addSubview:headBtn];
        [headBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(12.5);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        headBtn.layer.masksToBounds = YES;
        headBtn.layer.cornerRadius = 3;
        [headBtn sd_setImageWithURL:[NSURL URLWithString:model.icon] forState:UIControlStateNormal placeholderImage:DefaultImage];
        if (model.icon.length != 0) {
            [[headBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                [HUPhotoBrowser showFromImageView:headBtn.imageView withURLStrings:weakSelf.headerUrlArray placeholderImage:DefaultImage atIndex:0 dismiss:nil];
            }];
            self.headerUrlArray = @[model.icon];
        }
        
        
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.text = model.cnName;
        nameLabel.textColor = [UIColor colorWithHexString:@"2b5490"];
        nameLabel.font = [UIFont systemFontOfSize:16];
        [headView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headBtn.mas_top).offset(6);
            make.left.mas_equalTo(headBtn.mas_right).offset(10.5);
            make.right.mas_lessThanOrEqualTo(-60);
        }];
        
        UIImageView *sexBtn = [[UIImageView alloc]init];
        NSString *sexStr = model.sex == 2?@"woman":@"man";
        sexBtn.image = [UIImage imageNamed:sexStr];
        sexBtn.userInteractionEnabled = NO;
        [headView addSubview:sexBtn];
        [sexBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        UILabel *noLabel = [[UILabel alloc]init];
        noLabel.text = [NSString stringWithFormat:@"喜腾号:%@",model.xtNumber];
        noLabel.textColor = [UIColor colorWithHexString:@"999999"];
        noLabel.font = [UIFont systemFontOfSize:11];
        [headView addSubview:noLabel];
        [noLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(4);
            make.left.mas_equalTo(headBtn.mas_right).offset(10.5);
        }];
        
//        UILabel *nickNameLabel = [[UILabel alloc]init];
//        nickNameLabel.text = model.cnName.length != 0?[NSString stringWithFormat:@"昵称:%@",model.cnName]:@"";
//        nickNameLabel.textColor = [UIColor colorWithHexString:@"999999"];
//        nickNameLabel.font = [UIFont systemFontOfSize:11];
//        [headView addSubview:nickNameLabel];
//        [nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(noLabel.mas_bottom).offset(4);
//            make.left.mas_equalTo(headBtn.mas_right).offset(10.5);
//        }];

        
        
        UIView *footView = [[UIView alloc]init];
        footView.backgroundColor = [UIColor whiteColor];
        [self addSubview:footView];
        [footView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headView.mas_bottom).offset(15);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(88);
        }];
        
        UILabel *signTitleLabel = [[UILabel alloc]init];
        signTitleLabel.text = @"个性签名:";
        signTitleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        signTitleLabel.font = [UIFont systemFontOfSize:15];
        [signTitleLabel sizeToFit];
        [footView addSubview:signTitleLabel];
        [signTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(12);
        }];
        
        NSString *signStr = model.selfSign;
        if(signStr.length == 0){
            signStr = @"未填写";
        };
        UILabel *signLabel = [[UILabel alloc]init];
        signLabel.text = signStr;
        signLabel.numberOfLines = 2;
        [signLabel sizeToFit];
        signLabel.textColor = [UIColor colorWithHexString:@"333333"];
        signLabel.font = [UIFont systemFontOfSize:14];
        [footView addSubview:signLabel];
        [signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(88);
            make.centerY.mas_equalTo(signTitleLabel.mas_centerY);
            make.right.mas_equalTo(-12);
        }];
        
        UIView *sepView = [[UIView alloc]init];
        sepView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [self addSubview:sepView];
        [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(signTitleLabel.mas_bottom).offset(12);
        }];
        
        UILabel *addrTitleLabel = [[UILabel alloc]init];
        addrTitleLabel.text = @"地区:";
        addrTitleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        addrTitleLabel.font = [UIFont systemFontOfSize:15];
        [footView addSubview:addrTitleLabel];
        [addrTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(sepView.mas_bottom).offset(12);
        }];
        
        NSString *addrStr = model.address;
        if(addrStr.length == 0){
            addrStr = @"未填写";
        };
        UILabel *addrLabel = [[UILabel alloc]init];
        addrLabel.text = addrStr;
        addrLabel.textColor = [UIColor colorWithHexString:@"333333"];
        addrLabel.font = [UIFont systemFontOfSize:14];
        [footView addSubview:addrLabel];
        [addrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(addrTitleLabel.mas_right).offset(10);
            make.centerY.mas_equalTo(addrTitleLabel.mas_centerY);
            make.right.mas_equalTo(-12);
            
        }];

        
    }
    return self;
}

//- (void)headerViewHandle:(UIButton *)button {
////    UIImageView* sender = (UIImageView*)tap.view ;
//    [HUPhotoBrowser showFromImageView:button.imageView withURLStrings:self.headerUrlArray placeholderImage:DefaultImage atIndex:0 dismiss:nil];
//}
@end


@implementation RRFDetailInfoFootView
-(instancetype)init{
    if (self = [super init]) {
        UIButton *titleBtn = [[UIButton alloc]init];
        [titleBtn setTitle:@"添加朋友圈" forState:UIControlStateDisabled];
        [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [titleBtn setBackgroundColor:[UIColor colorWithHexString:@"4964ef"]];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [titleBtn sizeToFit];
        titleBtn.userInteractionEnabled = NO;
        self.titleBtn = titleBtn;
        [self addSubview:titleBtn];
        [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(40);
        }];
    }
    return self;
}
@end
