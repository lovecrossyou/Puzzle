//
//  FBShareOrderCell.m
//  Puzzle
//
//  Created by huibei on 16/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//
#define singImageHeight 60
//#define imageMargin 6
#import "FBShareOrderCell.h"
#import "UIImageView+WebCache.h"
#import "FBShareOrderListModel.h"
#import "ImageModel.h"
#import <XHImageViewer/XHImageViewer.h>
#import <HUPhotoBrowser/HUPhotoBrowser.h>
#import "UIButton+WebCache.h"
@interface FBShareOrderCell(){
    UIButton* logo ;
    UILabel* nameLabel ;
    UIImageView* sexIcon;
    UILabel* timeLabel ;
    UILabel* noLabel ;
    UILabel* productNameLabel ;
    UILabel* contentLabel ;
}
@property(nonatomic,weak)UIView *imageContent;
@end
@implementation FBShareOrderCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        WEAKSELF
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
        logo = [[UIButton alloc]init];
        logo.layer.masksToBounds = YES ;
        logo.layer.cornerRadius = 4 ;
        [self.contentView addSubview:logo];
        [logo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(42.5, 42.5));
            make.top.left.mas_equalTo(12);
        }];
        [[logo rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (weakSelf.goInfoBlock) {
                weakSelf.goInfoBlock();
            }
        }];
        
        nameLabel = [[UILabel alloc]init];
        nameLabel.textColor = [UIColor colorWithHexString:@"2b5490"];
        nameLabel.font = PZFont(15.0f);
        [nameLabel sizeToFit];
        [self.contentView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(logo.mas_top).offset(6);
            make.left.mas_equalTo(logo.mas_right).offset(10);
        }];
        
        sexIcon = [[UIImageView alloc]init];
        [self.contentView addSubview:sexIcon];
        [sexIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameLabel.mas_right).offset(10);
            make.centerY.mas_equalTo(nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        timeLabel = [[UILabel alloc]init];
        timeLabel.font = PZFont(12.0f);
        timeLabel.textColor = [UIColor colorWithHexString:@"666666"];
        [timeLabel sizeToFit];
        [self.contentView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(logo.mas_bottom).offset(4);
            make.left.mas_equalTo(logo.mas_right).offset(10);
        }];
        
        //no
        noLabel = [[UILabel alloc]init];
        [noLabel sizeToFit];
        noLabel.textColor = [UIColor colorWithHexString:@"666666"];
        noLabel.font = PZFont(12.0f);
        [self.contentView addSubview:noLabel];
        [noLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(timeLabel.mas_bottom).offset(15);
            make.left.mas_equalTo(logo.mas_right).offset(10);
        }];
        
        //no
        productNameLabel = [[UILabel alloc]init];
        [productNameLabel sizeToFit];
        productNameLabel.font = PZFont(12.0f);
        productNameLabel.textColor = [UIColor colorWithHexString:@"666666"];
        [self.contentView addSubview:productNameLabel];
        [productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(noLabel.mas_bottom).offset(8);
            make.left.mas_equalTo(logo.mas_right).offset(10);
            make.right.mas_equalTo(-12);
        }];
        
        //line
        UIView* sepLine = [[UIView alloc]init];
        sepLine.backgroundColor = HBColor(243, 243, 243);
        [self.contentView addSubview:sepLine];
        [sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(productNameLabel.mas_bottom).offset(10);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        
        contentLabel = [[UILabel alloc]init];
        [contentLabel sizeToFit];
        contentLabel.textColor = [UIColor colorWithHexString:@"333333"];
        contentLabel.font = PZFont(14.0f);
        contentLabel.numberOfLines = 6 ;
        [self.contentView addSubview:contentLabel];
        [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(sepLine.mas_bottom).offset(10);
            make.left.mas_equalTo(logo.mas_right).offset(10);
            make.right.mas_equalTo(-12);
        }];
        
        
        UIView* imageContent = [[UIView alloc]init];
        self.imageContent = imageContent;
        [self.contentView addSubview:imageContent];
        [imageContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(contentLabel.mas_bottom).offset(6);
            make.left.mas_equalTo(logo.mas_right).offset(10);
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(120);
            make.bottom.mas_equalTo(-12);
        }];
    }
    return self ;
}
-(void)setModel:(FBShareOrderModel *)model
{
    _model = model;
    [logo sd_setImageWithURL:[NSURL URLWithString:model.userIcon] forState:UIControlStateNormal placeholderImage:DefaultImage];
    nameLabel.text = model.userName;
    sexIcon.image = [UIImage imageNamed:model.userSex];
    timeLabel.text = model.time;
    noLabel.text = [NSString stringWithFormat:@"期数：%ld",(long)model.purchaseGameInfo.stage];
    productNameLabel.text = model.purchaseGameInfo.productName;
    contentLabel.text = model.content;
    WEAKSELF
    [self.imageContent.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger imagesCount = model.pictures.count;
    if (imagesCount > 1) {
        CGFloat iconW = (SCREENWidth-62.5-12-(imageTotalCount - 1)*imageMargin)/imageTotalCount;
        CGFloat iconH = iconW;
        for (int i = 0; i < imagesCount ; i++) {
            ImageModel* imageUrlM = model.pictures[i] ;
            int row = i/imageTotalCount;
            int loc = i%imageTotalCount;
            
            CGFloat iconX = (imageMargin + iconW)*loc;
            CGFloat iconY = (imageMargin + iconH)*row;
            
            UIImageView *iconView = [[UIImageView alloc]init];
            iconView.contentMode = UIViewContentModeScaleAspectFit ;
            iconView.tag = i ;
            iconView.userInteractionEnabled = YES ;
            UITapGestureRecognizer *gesture =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(tapHandle:)];
            [iconView addGestureRecognizer:gesture];
            [iconView sd_setImageWithURL:[NSURL URLWithString:imageUrlM.head_img] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                UIImage* imgCliped = [UIImage cutImage:image];
                iconView.image = imgCliped ;
            }];
            iconView.frame = CGRectMake(iconX, iconY, iconW, iconH);
            [self.imageContent addSubview:iconView];
        }
        NSInteger row = (imagesCount-1)/imageTotalCount ;
        CGFloat imageHeight = (iconH + imageMargin) * row + iconH ;
        [self.imageContent mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(imageHeight);
        }];
    }else if (imagesCount == 1){
        ImageModel* imageM = model.pictures[0] ;
        __block UIImageView *iconView = [[UIImageView alloc]init];
        iconView.contentMode = UIViewContentModeScaleAspectFit ;
        [iconView sd_setImageWithURL:[NSURL URLWithString:imageM.head_img] placeholderImage:DefaultImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            iconView.image = image ;
            CGSize imageSize = image.size ;
            CGFloat w = (singImageHeight*imageSize.width)/imageSize.height;
            CGFloat maxW = SCREENWidth-160;
            if (w >=maxW) {
                w = maxW ;
            }else if ( w <=80){
                w = 80;
            }
            iconView.frame = CGRectMake(0, 0, w, singImageHeight);
        }];
        iconView.tag = 0 ;
        iconView.userInteractionEnabled = YES ;
        UITapGestureRecognizer *gesture =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(tapHandle:)];
        [iconView addGestureRecognizer:gesture];
        
        [self.imageContent addSubview:iconView];
        [weakSelf.imageContent mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(singImageHeight);
        }];
    }
    else{
        [self.imageContent mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }

}
- (void)tapHandle:(UITapGestureRecognizer *)tap {
    UIImageView* sender = (UIImageView*)tap.view ;
    NSInteger index = sender.tag ;
    NSArray* imageModels = @[];
    if (_model == nil) {
        imageModels = _model.pictures ;
    }
    else{
        imageModels = _model.pictures ;
    }
    NSMutableArray* _URLStrings = [NSMutableArray arrayWithCapacity:imageModels.count];
    for (ImageModel* imageM in imageModels) {
        [_URLStrings addObject:imageM.big_img];
    }
    [HUPhotoBrowser showFromImageView:sender withURLStrings:_URLStrings placeholderImage:[UIImage imageNamed:@"common_head_default-diagram"] atIndex:index dismiss:nil];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
