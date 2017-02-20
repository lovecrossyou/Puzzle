//
//  RRFPersonalHomePageCell.m
//  Puzzle
//
//  Created by huibei on 16/9/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//
#define singImageHeight 120
#import "RRFPersonalHomePageCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import <XHImageViewer/XHImageViewer.h>
#import "PZDateUtil.h"
#import <HUPhotoBrowser/HUPhotoBrowser.h>
#import "RRFCommentsCellModel.h"
#import "PZParamTool.h"
#import "PZCache.h"
#import "RRFFriendCircleModel.h"
#import "RRFFriendCirclebetView.h"
#import "InsetsLabel.h"
#import "ImageModel.h"
#import "RRFRedPaperView.h"
#import "BonusPaperModel.h"
#import "RRFShowOrderInfoView.h"
@interface RRFPersonalHomePageCell()
@property(nonatomic,weak)UILabel *timeLabel;
@property(nonatomic,weak)InsetsLabel *textContentLabel;
@property(nonatomic,weak)UIView *imageContentView;
@property(nonatomic,weak)UIButton *deletedBtn;
// 投注view
@property(nonatomic,strong)RRFFriendCirclebetView *betView;
// 红包的view
@property(weak,nonatomic)RRFRedPaperView *redPaperView ;
// 晒单的view
@property(nonatomic,weak)RRFShowOrderInfoView *showOrderView;

@end
@implementation RRFPersonalHomePageCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.textColor = [UIColor colorWithHexString:@"333333"];
        self.timeLabel = timeLabel;
        [self.contentView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(17.5);
            make.left.mas_equalTo(15);
        }];
        
        RRFFriendCirclebetView *betView = [[RRFFriendCirclebetView alloc]init];
        self.betView = betView;
        [self.contentView addSubview:betView];
        [betView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(90);
            make.top.mas_equalTo(17.5);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(90);
        }];
        WEAKSELF
        betView.betViewCheckBlock = ^(){
            if (weakSelf.checkBlock) {
                weakSelf.checkBlock();
            }
        };
        
        RRFRedPaperView *redPaperView = [[RRFRedPaperView alloc]init];
        redPaperView.hidden = YES ;
        self.redPaperView = redPaperView;
        [self.contentView addSubview:redPaperView];
        [redPaperView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(90);
            make.top.mas_equalTo(17.5);
            make.height.mas_equalTo(90);
            make.width.mas_equalTo(SCREENWidth*0.6);
        }];
        [[redPaperView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (weakSelf.redPaperBlock) {
                weakSelf.redPaperBlock(weakSelf.friendModel.bonusPackageModel.bonusPackageId);
            }
        }];

        
        InsetsLabel *textContentLabel = [[InsetsLabel  alloc]initWithInsets:UIEdgeInsetsZero];
        textContentLabel.textColor = [UIColor colorWithHexString:@"333333"];
        textContentLabel.numberOfLines = 0;
        textContentLabel.font = [UIFont systemFontOfSize:15];
        self.textContentLabel = textContentLabel;
        [self.contentView addSubview:textContentLabel];
        [textContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(90);
            make.top.mas_equalTo(17.5);
            make.right.mas_equalTo(-15);
        }];
        
        UIView *imageContentView = [[UIView alloc]init];
        self.imageContentView = imageContentView;
        [self.contentView addSubview:imageContentView];
        [imageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(90);
            make.right.mas_equalTo(-54);
            make.top.mas_equalTo(textContentLabel.mas_bottom).offset(8);
        }];
        
        
        RRFShowOrderInfoView *showOrderView = [[RRFShowOrderInfoView alloc]init];
        showOrderView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        self.showOrderView = showOrderView;
        [self.contentView addSubview:showOrderView];
        [showOrderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageContentView.mas_bottom).offset(10);
            make.left.mas_equalTo(90);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(100);
        }];

        UIButton *deletedBtn = [[UIButton alloc]init];
        deletedBtn.tag = 3;
        deletedBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [deletedBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deletedBtn setTitleColor:[UIColor colorWithHexString:@"2b5490"] forState:UIControlStateNormal];
        deletedBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [deletedBtn sizeToFit];
        [deletedBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.deletedBtn = deletedBtn;
        [self.contentView addSubview:deletedBtn];
        [deletedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(showOrderView.mas_bottom);
            make.left.mas_equalTo(90);
            make.size.mas_equalTo(CGSizeMake(50, 40));
            make.bottom.mas_equalTo(0);
        }];
    }
    return self;
}
-(void)setModel:(RRFCommentsCellModel *)model
{
    _model = model;
    self.betView.hidden = YES;
    self.redPaperView.hidden = YES;
    self.showOrderView.hidden = YES;
    [self.showOrderView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    
    self.deletedBtn.hidden = [model.isSelfComment isEqualToString:@"self"]?NO:YES;
    NSString *dayStr = [model.time substringWithRange:NSMakeRange(8, 2)];
    NSString *monthStr = [model.time substringWithRange:NSMakeRange(5, 2)];
    NSString *timeStr = [NSString stringWithFormat:@"%@%@月",dayStr,monthStr];
    NSMutableAttributedString *attrTimeStr = [[NSMutableAttributedString alloc]initWithString:timeStr];
    [attrTimeStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:25] range:NSMakeRange(0, 2)];
    [attrTimeStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:NSMakeRange(2, 3)];
    self.timeLabel.attributedText = attrTimeStr;
    self.textContentLabel.text = model.content;
    if (model.content.length == 0) {
        [self.textContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.imageContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(17.5);
        }];
    }else{
        [self.imageContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.textContentLabel.mas_bottom).offset(8);
        }];
    }
    
    WEAKSELF
    [self.imageContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger imagesCount = model.contentImages.count;

    if (imagesCount > 1) {
        CGFloat iconW = (SCREENWidth-90-54-(imageTotalCount - 1)*imageMargin)/imageTotalCount;
        CGFloat iconH = iconW;
        for (int i = 0; i < imagesCount ; i++) {
            ImageModel* imageUrlM = model.contentImages[i] ;
            int row = i/imageTotalCount;
            int loc = i%imageTotalCount;
            CGFloat iconX = (imageMargin + iconW)*loc;
            CGFloat iconY = (imageMargin + iconH)*row;
            UIImageView *iconView = [[UIImageView alloc]init];
            iconView.contentMode = UIViewContentModeScaleAspectFit;
            iconView.tag = i ;
            iconView.userInteractionEnabled = YES ;
            UITapGestureRecognizer *gesture =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(tapHandle:)];
            [iconView addGestureRecognizer:gesture];
            [iconView sd_setImageWithURL:[NSURL URLWithString:imageUrlM.head_img] placeholderImage:[UIImage imageNamed:@"common_head_default-diagram"]];
            iconView.frame = CGRectMake(iconX, iconY, iconW, iconH);
            [self.imageContentView addSubview:iconView];
        }
        NSInteger row = (imagesCount-1)/imageTotalCount ;
        CGFloat imageHeight = (iconH + imageMargin) * row + iconH ;
        [weakSelf.imageContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(imageHeight);
        }];
        
    }else if (imagesCount == 1){
        ImageModel* imageUrlM = model.contentImages[0] ;
        __block UIImageView *iconView = [[UIImageView alloc]init];
        iconView.contentMode = UIViewContentModeScaleAspectFit ;
        [iconView sd_setImageWithURL:[NSURL URLWithString:imageUrlM.head_img] placeholderImage:DefaultImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
        [self.imageContentView addSubview:iconView];
        [weakSelf.imageContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(singImageHeight);
        }];
    }

    else{
        [weakSelf.imageContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    
    
}

-(void)setFriendModel:(RRFFriendCircleModel *)friendModel
{
    _friendModel = friendModel;
    if ([friendModel.type isEqualToString:@"friendCircleComment"]) {
        self.betView.hidden = YES;
        self.showOrderView.hidden = YES;
        self.redPaperView.hidden = YES;
        self.deletedBtn.hidden = [friendModel.isSelfComment isEqualToString:@"self"]?NO:YES;
        [self.showOrderView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    else if ([friendModel.type isEqualToString:@"bonusPackage"]){
        self.betView.hidden = YES;
        self.deletedBtn.hidden = YES;
        self.redPaperView.hidden = NO;
        self.showOrderView.hidden = YES;
        self.redPaperView.model = friendModel.bonusPackageModel ;
        [self.redPaperView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-10);
        }];
        
    }
    else if([friendModel.type isEqualToString:@"exchangeOrder"] ){
        self.showOrderView.hidden = NO;
        self.showOrderView.exchangeOrderModel = friendModel.exchangeOrderModel;
        self.redPaperView.hidden = YES;
        self.betView.hidden = YES;
        self.deletedBtn.hidden = [friendModel.isSelfComment isEqualToString:@"self"]?NO:YES;
        [self.showOrderView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(80);
        }];
        
    }
    else if([friendModel.type isEqualToString:@"bidOrder"]){
        self.showOrderView.hidden = NO;
        self.showOrderView.bidOrderModel = friendModel.bidOrderModel;
        self.redPaperView.hidden = YES;
        self.betView.hidden = YES;
        self.deletedBtn.hidden = [friendModel.isSelfComment isEqualToString:@"self"]?NO:YES;
        [self.showOrderView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(130);
        }];
        
    }
    else if([friendModel.type isEqualToString:@"awardOrder"]){
        self.showOrderView.hidden = NO;
        self.showOrderView.awardOrderModel = friendModel.awardOrderModel;
        self.redPaperView.hidden = YES;
        self.betView.hidden = YES;
        self.deletedBtn.hidden = [friendModel.isSelfComment isEqualToString:@"self"]?NO:YES;
        [self.showOrderView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(100);
        }];
    }
    else{
        self.betView.hidden = NO;
        self.redPaperView.hidden = YES;
        self.showOrderView.hidden = YES;
        self.betView.model = friendModel.guessWithStockModel;
        [self.betView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-20);
        } ];
        self.deletedBtn.hidden = YES;
        

    }
    NSString *dayStr = [friendModel.time substringWithRange:NSMakeRange(8, 2)];
    NSString *monthStr = [friendModel.time substringWithRange:NSMakeRange(5, 2)];
    NSString *timeStr = [NSString stringWithFormat:@"%@%@月",dayStr,monthStr];
    NSMutableAttributedString *attrTimeStr = [[NSMutableAttributedString alloc]initWithString:timeStr];
    [attrTimeStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:25] range:NSMakeRange(0, 2)];
    [attrTimeStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:NSMakeRange(2, 3)];
    self.timeLabel.attributedText = attrTimeStr;
    self.textContentLabel.text = friendModel.commentModel.content;
    
    WEAKSELF
    [self.imageContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray *imageList = friendModel.commentModel.contentImages;
    NSInteger imagesCount = imageList.count;
    if (imagesCount > 1) {
        CGFloat iconW = (SCREENWidth-90-54-(imageTotalCount - 1)*imageMargin)/imageTotalCount;
        CGFloat iconH = iconW;
        for (int i = 0; i < imagesCount ; i++) {
            ImageModel* imageUrlM = imageList[i] ;
            int row = i/imageTotalCount;
            int loc = i%imageTotalCount;
            
            CGFloat iconX = (imageMargin + iconW)*loc;
            CGFloat iconY = (imageMargin + iconH)*row;
            
            UIImageView *iconView = [[UIImageView alloc]init];
            iconView.tag = i ;
            iconView.userInteractionEnabled = YES ;
            UITapGestureRecognizer *gesture =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(tapHandle:)];
            [iconView addGestureRecognizer:gesture];
            [iconView sd_setImageWithURL:[NSURL URLWithString:imageUrlM.head_img] placeholderImage:[UIImage imageNamed:@"common_head_default-diagram"]];
            iconView.frame = CGRectMake(iconX, iconY, iconW, iconH);
            [self.imageContentView addSubview:iconView];
        }
        NSInteger row = (imagesCount-1)/imageTotalCount ;
        CGFloat imageHeight = (iconH + imageMargin) * row + iconH ;
        [weakSelf.imageContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(90);
            make.right.mas_equalTo(-54);
            make.height.mas_equalTo(imageHeight);
            make.top.mas_equalTo(self.textContentLabel.mas_bottom).offset(8);
        }];
    }else if (imagesCount == 1){
        ImageModel* imageUrlM = imageList[0] ;
        __block UIImageView *iconView = [[UIImageView alloc]init];
        [iconView sd_setImageWithURL:[NSURL URLWithString:imageUrlM.head_img] placeholderImage:DefaultImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
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
        
        [self.imageContentView addSubview:iconView];
        [weakSelf.imageContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(90);
            make.right.mas_equalTo(-54);
            make.height.mas_equalTo(singImageHeight);
            make.top.mas_equalTo(self.textContentLabel.mas_bottom).offset(8);
        }];
    }
    
    else{
        [weakSelf.imageContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(90);
            make.right.mas_equalTo(-54);
            make.height.mas_equalTo(0);
            make.top.mas_equalTo(self.textContentLabel.mas_bottom).offset(8);
        }];
    }

}
-(void)btnClick:(UIButton *)button
{
    if (self.cellClick) {
        self.cellClick(@(button.tag));
    }
}
- (void)tapHandle:(UITapGestureRecognizer *)tap {
    UIImageView* sender = (UIImageView*)tap.view ;
    NSInteger index = sender.tag ;
    NSArray* imageModels = @[] ;
    if (_friendModel != nil) {
        imageModels = _friendModel.commentModel.contentImages ;
    }
    else{
        imageModels = _model.contentImages ;
    }
    NSMutableArray* _URLStrings = [NSMutableArray arrayWithCapacity:imageModels.count];
    for (ImageModel* imageM in imageModels) {
        [_URLStrings addObject:imageM.big_img];
    }
    [HUPhotoBrowser showFromImageView:sender withURLStrings:_URLStrings placeholderImage:[UIImage imageNamed:@"common_head_default-diagram"] atIndex:index dismiss:nil];
}


@end

