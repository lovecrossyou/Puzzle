//
//  RRFInviteView.m
//  Puzzle
//
//  Created by huibei on 16/10/24.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFInviteView.h"
#import "LoginModel.h"
#import "PZParamTool.h"
#import "UIImageView+WebCache.h"
#import "HomeTool.h"
#import "HBShareTool.h"
#import "HMScanner.h"
@interface RRFInviteView ()
@property(nonatomic,weak)UILabel *nameLabel;
@property(nonatomic,weak)UILabel *numLabel;
@property(nonatomic,weak)UIImageView *QRHeadView;

@end
@implementation RRFInviteView
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        LoginModel *user = [PZParamTool currentUser];
        NSString *iconStr = user.icon;
        if (iconStr.length == 0) {
            iconStr = user.headimgurl;
        }
        UIImageView *hearView = [[UIImageView alloc]init];
        [hearView sd_setImageWithURL:[NSURL URLWithString:iconStr]];
        hearView.layer.masksToBounds = YES;
        hearView.layer.cornerRadius = 3;
        self.hearView = hearView;
        [self addSubview:hearView];
        [hearView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(65, 65));
            make.left.top.mas_equalTo(20);
        }];

        NSString *name = user.cnName;
        if (name.length == 0) {
            name = user.nickname;
        }
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.text = name;
        nameLabel.textColor = [UIColor colorWithHexString:@"333333"];
        nameLabel.font = [UIFont systemFontOfSize:14];
        [nameLabel sizeToFit];
        self.nameLabel = nameLabel;
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(hearView.mas_right).offset(10);
            make.top.mas_equalTo(hearView.mas_top).offset(12.5);
        }];
        
        NSString *xtNum = user.xtNumber;
        if ([xtNum isKindOfClass:[NSNull class]] || xtNum == nil) {
           xtNum = @"---";
        }
        UILabel *numLabel = [[UILabel alloc]init];
        self.numLabel = numLabel;
        numLabel.text = [NSString stringWithFormat:@"喜腾号:%@",xtNum];
        numLabel.textColor = [UIColor colorWithHexString:@"999999"];
        numLabel.font = [UIFont systemFontOfSize:12];
        [numLabel sizeToFit];
        [self addSubview:numLabel];
        [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(hearView.mas_right).offset(10);
            make.bottom.mas_equalTo(hearView.mas_bottom).offset(-12.5);
        }];
        

        UIImageView *QRCodeView = [[UIImageView alloc]init];
        self.QRCodeView = QRCodeView;
        QRCodeView.layer.masksToBounds = YES;
        QRCodeView.layer.cornerRadius = 3;
        QRCodeView.image = [UIImage imageNamed:@"comment_default-diagram"];
        [self addSubview:QRCodeView];
        CGFloat qrSize = SCREENWidth*0.65 ;
        [QRCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(qrSize, qrSize));
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(hearView.mas_bottom).offset(35);
        }];
        UIImageView *QRHeadView = [[UIImageView alloc]init];
        self.QRHeadView = QRHeadView;
        [QRHeadView.layer setBorderWidth:3];
        CGColorSpaceRef colorSpaceRefss = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorss = CGColorCreate(colorSpaceRefss, (CGFloat[]){255/255.0,255/255.0,255/255.0,1});
        [QRHeadView.layer setBorderColor:colorss];
        [QRHeadView sd_setImageWithURL:[NSURL URLWithString:iconStr]];
        QRHeadView.layer.masksToBounds = YES;
        QRHeadView.layer.cornerRadius = 10;
        [QRCodeView addSubview:QRHeadView];
        [QRHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.centerX.mas_equalTo(QRCodeView.mas_centerX);
            make.centerY.mas_equalTo(QRCodeView.mas_centerY);
        }];
        
        
        UIView *footView = [[UIView alloc]init];
        [footView sizeToFit];
        [self addSubview:footView];
        [footView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(QRCodeView.mas_bottom).offset(6);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(180, 12));
        }];
        
        UILabel *explainLabel = [[UILabel alloc]init];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"扫一扫我的二维码,领取"];
        explainLabel.attributedText = str;
        explainLabel.textColor = [UIColor colorWithHexString:@"777777"];
        explainLabel.font = [UIFont systemFontOfSize:12];
        [explainLabel sizeToFit];
        [footView addSubview:explainLabel];
        [explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(footView.mas_centerY);
            make.left.mas_equalTo(0);
        }];
        
        UIButton *redBtn = [[UIButton alloc]init];
        [redBtn setTitle:@"100红包" forState:UIControlStateNormal];
        [redBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [redBtn setImage:[UIImage imageNamed:@"icon_maddle_red"] forState:UIControlStateNormal];
        redBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [redBtn sizeToFit];
        [footView addSubview:redBtn];
        [redBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(explainLabel.mas_right).offset(0);
            make.centerY.mas_equalTo(footView.mas_centerY);
        }];
//        [self createQR];
    }
    return self;
}



@end
