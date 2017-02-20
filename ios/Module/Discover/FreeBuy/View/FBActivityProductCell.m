//
//  FBActivityProductCell.m
//  Puzzle
//
//  Created by huibei on 16/12/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "FBActivityProductCell.h"
#import "FBProductListModel.h"
#import "UIImageView+WebCache.h"

@interface FBActivityProductCell()
{
    UIImageView* logoView ;
    UILabel* productTitle ;
    UILabel* progressStr ;
    UILabel* totalStr ;
    UIProgressView* progressView ;
    UILabel* remainStr ;
}

@end
@implementation FBActivityProductCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        WEAKSELF
        logoView = [[UIImageView alloc]init];
        logoView.contentMode = UIViewContentModeScaleAspectFit ;
        [self.contentView addSubview:logoView];
        [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(64, 64));
            make.bottom.mas_equalTo(-12);
        }];
        
        UIView* botView = [[UIView alloc]init];
        [self.contentView addSubview:botView];
        [botView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.left.mas_equalTo(logoView.mas_right);
            make.top.mas_equalTo(12);
            make.bottom.mas_equalTo(0);
        }];
        
        productTitle = [UILabel new];
        productTitle.font = PZFont(15.0f);
        productTitle.textColor = [UIColor colorWithHexString:@"333333"];
        [botView addSubview:productTitle];
        [productTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.left.mas_equalTo(12);
            make.height.mas_equalTo(24);
            make.top.mas_equalTo(0);
        }];
    
        progressView = [[UIProgressView alloc]init];
        progressView.progressTintColor = [UIColor redColor];
        progressView.trackTintColor = HBColor(243, 243, 243);
        [botView addSubview:progressView];
        [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12-70-20);
            make.left.mas_equalTo(12);
            make.height.mas_equalTo(4);
            make.top.mas_equalTo(productTitle.mas_bottom).offset(6);
        }];
        
        totalStr = [UILabel new];
        totalStr.font = PZFont(12.0f);
        totalStr.textColor = [UIColor colorWithHexString:@"777777"];
        [botView addSubview:totalStr];
        [totalStr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.left.mas_equalTo(12);
            make.height.mas_equalTo(24);
            make.top.mas_equalTo(progressView.mas_bottom).offset(12);
        }];
        
        remainStr = [UILabel new];
        remainStr.font = PZFont(12.0f);
        remainStr.textColor = [UIColor colorWithHexString:@"777777"];
        [remainStr sizeToFit];
        [botView addSubview:remainStr];
        [remainStr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12-70-12);
            make.height.mas_equalTo(24);
            make.centerY.mas_equalTo(totalStr.mas_centerY);
        }];
        
        UIButton* joinNow = [UIButton new];
        joinNow.layer.borderColor = [UIColor redColor].CGColor;
        joinNow.layer.borderWidth = 1 ;
        joinNow.layer.cornerRadius = 4 ;
        joinNow.titleLabel.font = PZFont(13.0f);
        [joinNow setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [joinNow setTitle:@"立即参与" forState:UIControlStateNormal];
        [botView addSubview:joinNow];
        [joinNow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.width.mas_equalTo(70);
            make.height.mas_equalTo(28);
            make.bottom.mas_equalTo(totalStr.mas_bottom);
        }];
        [[joinNow rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (weakSelf.clickBlock) {
                weakSelf.clickBlock();
            }
        }];
    }
    return self ;
}


-(void)configModel:(FBProductModel*)model{
    [logoView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:DefaultImage];
    productTitle.text = model.productName ;
    progressStr.text = [NSString stringWithFormat:@"揭晓进度 %@",model.rateOfProgress];
    totalStr.text = [NSString stringWithFormat:@"总需: %ld份",(long)model.targetPurchaseCount];
    progressView.progress = 1 - model.restPurchaseCount/model.targetPurchaseCount ;
    
}

@end
