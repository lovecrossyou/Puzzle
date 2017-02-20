//
//  RRFCommentsCell.m
//  Puzzle
//
//  Created by huibei on 16/8/16.
//  Copyright © 2016年 HuiBei. All rights reserved.
//
#define leftMargin 15
#define singImageHeight 120
#define maxContentStrHeight 180
#import "RRFCommentsCell.h"
#import "RRFCommentsCellModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "PZParamTool.h"
#import <XHImageViewer/XHImageViewer.h>
#import "PZDateUtil.h"
#import <HUPhotoBrowser/HUPhotoBrowser.h>
#import "InsetsLabel.h"
#import "NSString+TimeConvert.h"
#import "PZCache.h"
#import "RRFFriendCirclebetView.h"
#import "RRFFriendCircleModel.h"
#import "UIImage+Image.h"
#import "TimeLineCellOperationMenu.h"
#import "RRFAgreeContentView.h"
#import "NSString+Valid.h"
#import "ImageModel.h"
#import "RRFRedPaperView.h"
#import "BonusPaperModel.h"
#import "RRFShowOrderInfoView.h"

@interface RRFCommentsCell()

@property(nonatomic,weak)UIButton *headerIcon;
@property(nonatomic,weak)UIButton *sexBtn;
@property(nonatomic,weak)UILabel *nameLabel;
@property(nonatomic,weak)UIButton *userStatueIcon;
@property(nonatomic,weak)UILabel *timeLabel;
@property(nonatomic,weak)InsetsLabel *textContentLabel;
@property(nonatomic,weak)UIView *imageContentView;
@property(nonatomic,weak)UILabel *operationLabel;
@property(nonatomic,weak)UIButton *fullTextBtn;
@property(nonatomic,weak)UIButton *deletedBtn;
@property(nonatomic,strong)NSString *isPraise;
@property(nonatomic,assign)CGFloat maxHeight;
@property(nonatomic,weak)RRFFriendCirclebetView *betView ;
@property(nonatomic,weak)UIButton *operationButton ;
@property(weak,nonatomic)TimeLineCellOperationMenu* moreMenu  ;
// 评论view
@property(nonatomic,weak)RRFAgreeContentView *commentView;
// 红包的view
@property(nonatomic,weak)RRFRedPaperView *redPaperView;
// 订单的view
@property(nonatomic,weak)RRFShowOrderInfoView *showOrderView;

@property(nonatomic,strong)NSString *type;
@end



@implementation RRFCommentsCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        WEAKSELF
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        UIButton *headerIcon = [[UIButton alloc]init];
        headerIcon.userInteractionEnabled = NO;
        headerIcon.layer.masksToBounds = YES;
        headerIcon.layer.cornerRadius = 2;
        self.headerIcon = headerIcon;
        [self.contentView addSubview:headerIcon];
        [headerIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftMargin);
            make.top.mas_equalTo(12.5);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.textColor = [UIColor colorWithHexString:@"2b5490"];
        nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel = nameLabel;
        [self.contentView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headerIcon.mas_top).offset(4);
            make.left.mas_equalTo(headerIcon.mas_right).offset(10.5);
            make.right.mas_lessThanOrEqualTo(-60);
        }];
        
        UIButton *sexBtn = [[UIButton alloc]init];
        sexBtn.userInteractionEnabled = NO;
        self.sexBtn = sexBtn;
        [self.contentView addSubview:sexBtn];
        [sexBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameLabel.mas_right).offset(8);
            make.centerY.mas_equalTo(nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        UIButton *userStatueIcon = [[UIButton alloc]init];
        userStatueIcon.userInteractionEnabled = NO;
        [userStatueIcon sizeToFit];
        self.userStatueIcon = userStatueIcon;
        [self.contentView addSubview:userStatueIcon];
        [userStatueIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(sexBtn.mas_right).offset(4);
            make.centerY.mas_equalTo(nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
        UIControl *goUserInfo = [[UIControl alloc]init];
        [self.contentView addSubview:goUserInfo];
        [goUserInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth/3, 52.5));
        }];
        [[goUserInfo rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (weakSelf.goUserProfile) {
                weakSelf.goUserProfile();
            }
        }];
        
        
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
        timeLabel.font = [UIFont systemFontOfSize:11];
        self.timeLabel = timeLabel;
        [self.contentView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(headerIcon.mas_bottom).offset(-4);
            make.left.mas_equalTo(headerIcon.mas_right).offset(10.5);
        }];
        
        InsetsLabel *textContentLabel = [[InsetsLabel alloc]initWithInsets:UIEdgeInsetsZero];
        [textContentLabel setAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor],NSFontAttributeName:PZFont(14.0f)} forLinkType:KILinkTypeURL|KILinkTypeUserHandle|KILinkTypeHashtag];
        
        textContentLabel.textColor = [UIColor colorWithHexString:@"333333"];
        textContentLabel.numberOfLines = 0;
        textContentLabel.font = [UIFont systemFontOfSize:15];
        self.textContentLabel = textContentLabel;
        [self.contentView addSubview:textContentLabel];
        [textContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftMargin);
            make.top.mas_equalTo(headerIcon.mas_bottom).offset(12.5);
            make.right.mas_equalTo(-leftMargin);
            make.height.mas_lessThanOrEqualTo(maxContentStrHeight);
        }];
        
        RRFFriendCirclebetView *betView = [[RRFFriendCirclebetView alloc]init];
        self.betView = betView;
        [self.contentView addSubview:betView];
        [betView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(62.5);
            make.top.mas_equalTo(headerIcon.mas_bottom).offset(12.5);
            make.right.mas_equalTo(-25);
            make.height.mas_equalTo(80);
        }];
        betView.betViewCheckBlock = ^(){
            if (weakSelf.checkBlock) {
                weakSelf.checkBlock();
            }
        };
        
        
        RRFRedPaperView *redPaperView = [[RRFRedPaperView alloc]init];
        self.redPaperView = redPaperView;
        [self.contentView addSubview:redPaperView];
        [redPaperView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(62.5);
            make.top.mas_equalTo(headerIcon.mas_bottom).offset(12.5);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth*0.6, 85));
        }];
        [[redPaperView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (weakSelf.redPaperBlock) {
                weakSelf.redPaperBlock(@(weakSelf.friendModel.bonusPackageModel.bonusPackageId));
            }
        }];
        
        UIButton *fullTextBtn = [[UIButton alloc]init];
        fullTextBtn.userInteractionEnabled = NO;
        [fullTextBtn setTitle:@"全文" forState:UIControlStateNormal];
        [fullTextBtn setTitleColor:[UIColor colorWithHexString:@"2b5490"] forState:UIControlStateNormal];
        fullTextBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [fullTextBtn sizeToFit];
        self.fullTextBtn =fullTextBtn;
        [self.contentView addSubview:fullTextBtn];
        [fullTextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(textContentLabel.mas_bottom).offset(0);
            make.left.mas_equalTo(textContentLabel.mas_left);
        }];
        
        UIView *imageContentView = [[UIView alloc]init];
        self.imageContentView = imageContentView;
        [self.contentView addSubview:imageContentView];
        [imageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftMargin);
            make.right.mas_equalTo(-leftMargin);
            make.height.mas_equalTo(0);
            make.top.mas_equalTo(fullTextBtn.mas_bottom).offset(5);
        }];
        
        RRFShowOrderInfoView *showOrderView = [[RRFShowOrderInfoView alloc]init];
        self.showOrderView = showOrderView;
        [self.contentView addSubview:showOrderView];
        [showOrderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(imageContentView.mas_bottom).offset(6);
            make.left.mas_equalTo(leftMargin);
            make.right.mas_equalTo(-20);
            make.height.mas_equalTo(100);
        }];
        
        
        //AlbumOperateMore
        UIButton *operationButton = [[UIButton alloc]init];
        [operationButton setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
        [operationButton addTarget:self action:@selector(operationButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        self.operationButton = operationButton;
        [self.contentView addSubview:operationButton];
        [operationButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-leftMargin);
            make.top.mas_equalTo(showOrderView.mas_bottom).offset(8);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        UILabel *operationLabel = [[UILabel alloc]init];
        operationLabel.textColor = [UIColor colorWithHexString:@"777777"];
        operationLabel.font = [UIFont systemFontOfSize:12];
        self.operationLabel = operationLabel;
        [self.contentView addSubview:operationLabel];
        [operationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftMargin);
            make.centerY.mas_equalTo(operationButton.mas_centerY);
            make.height.mas_equalTo(40);
        }];
        
        UIButton *deletedBtn = [[UIButton alloc]init];
        deletedBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [deletedBtn setTitle:@"删除" forState:UIControlStateNormal];
        [deletedBtn setTitleColor:[UIColor colorWithHexString:@"2b5490"] forState:UIControlStateNormal];
        deletedBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [deletedBtn sizeToFit];
        self.deletedBtn = deletedBtn;
        [self.contentView addSubview:deletedBtn];
        [deletedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(operationButton.mas_centerY);
            make.left.mas_equalTo(operationLabel.mas_right).offset(6);
            make.size.mas_equalTo(CGSizeMake(60, 40));
        }];
        [[deletedBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (weakSelf.deleteBlock) {
                weakSelf.deleteBlock();
            }
        }];

        
        RRFAgreeContentView *commentView = [[RRFAgreeContentView alloc]init];
        commentView.userInteractionEnabled = YES;
        self.commentView = commentView;
        [self.contentView addSubview:commentView];
        [commentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftMargin);
            make.right.mas_equalTo(-18);
            make.bottom.mas_equalTo(-6);
            make.top.mas_equalTo(operationButton.mas_bottom).offset(6);
        }];
        
        TimeLineCellOperationMenu* moreMenu = [[TimeLineCellOperationMenu alloc] init];
        self.moreMenu = moreMenu ;
        moreMenu.likeButtonClickedOperation = ^(){
            if (weakSelf.menuClickedOperation) {
                weakSelf.menuClickedOperation(@(0));
            }
        };
        moreMenu.commentButtonClickedOperation = ^(){
            if (weakSelf.menuClickedOperation) {
                weakSelf.menuClickedOperation(@(1));
            }
        };
        moreMenu.awardButtonClickedOperation = ^(){
            if (weakSelf.menuClickedOperation) {
                weakSelf.menuClickedOperation(@(2));
            }
        };
        [self.contentView addSubview:moreMenu];
        [moreMenu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(operationButton.mas_centerY);
            make.right.mas_equalTo(operationButton.mas_left).offset(-6);
            make.width.mas_equalTo(80*3+2);
            make.height.mas_equalTo(40);
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOperationButtonClickedNotification:) name:kTimeLineCellOperationButtonClickedNotification object:nil];
 
    }
    return self;
}

- (void)receiveOperationButtonClickedNotification:(NSNotification *)notification
{
    UIButton *btn = [notification object];
    
    if (btn != _operationButton && _moreMenu.isShowing) {
        _moreMenu.show = NO;
    }
}
- (void)postOperationButtonClickedNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kTimeLineCellOperationButtonClickedNotification object:_operationButton];
}

-(void)setModel:(RRFCommentsCellModel *)model
{
    WEAKSELF
    _model = model;
    self.type = @"comment";
    self.commentView.hidden = YES;
    self.redPaperView.hidden = YES;
    self.showOrderView.hidden = YES;
    [self.operationButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
    }];
    self.textContentLabel.backgroundColor = [UIColor whiteColor];
    self.betView.hidden = YES;
    self.isPraise = model.isPraise;
    BOOL isShow = [model.isSelfComment isEqualToString:@"self"]?YES:NO;
    [self.moreMenu isShowAwardButton:isShow];
    self.deletedBtn.hidden = !isShow;
    if(isShow){
        [self.moreMenu mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(80*2+1);
        }];
    }else{
        [self.moreMenu mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(80*3+2);
        }];
    }
    BOOL isSelected = [model.isPraise isEqualToString:@"alreadyPraise"]?YES:NO;
    [self.moreMenu settingIsLikeSelected:isSelected];
    
    [self.headerIcon sd_setImageWithURL:[NSURL URLWithString:model.userIconUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"common_head_default-diagram"]];
    NSString *sexStr = [model.sex isEqualToString:@"女"]?@"woman":@"man";
    [self.sexBtn setImage:[UIImage imageNamed:sexStr] forState:UIControlStateNormal];
    NSString *userStatue = [model.userStatue isEqualToString:@"already_review"]?@"icon_v":@"";
    [self.userStatueIcon setImage:[UIImage imageNamed:userStatue] forState:UIControlStateNormal];
    
    self.nameLabel.text = model.userName;
    self.timeLabel.text = [model.time localizedTime] ;
    NSString *contentStr = model.content;
    self.textContentLabel.text = contentStr;

 
   NSString *operationStr =  [self setOperationStrWithPraiseAmount:model.praiseAmount responseAmount:model.responseAmount presentDiamondAmount:model.presentXtbAmount];
    self.operationLabel.text = operationStr;

    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGRect rect = [contentStr boundingRectWithSize:CGSizeMake(SCREENWidth-leftMargin*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    CGFloat height = CGRectGetHeight(rect);
    self.fullTextBtn.hidden = height > maxContentStrHeight ?  NO :  YES;
    if(self.fullTextBtn.hidden == NO){
        [self.fullTextBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
        }];
    }else{
        [self.fullTextBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    [self.showOrderView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];

    
    [self.imageContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger imagesCount = model.contentImages.count;
    if (imagesCount > 1) {
        CGFloat iconW = (SCREENWidth-leftMargin*2-(imageTotalCount - 1)*imageMargin)/imageTotalCount;
        CGFloat iconH = iconW;
        for (int i = 0; i < imagesCount ; i++) {
            ImageModel* imageUrlM = model.contentImages[i] ;
            int row = i/imageTotalCount;
            int loc = i%imageTotalCount;
            
            CGFloat iconX = (imageMargin + iconW)*loc;
            CGFloat iconY = (imageMargin + iconH)*row;

            UIImageView *iconView = [[UIImageView alloc]init];
            iconView.backgroundColor = HBColor(243, 243, 243);
            iconView.tag = i ;
            iconView.userInteractionEnabled = YES ;
            UITapGestureRecognizer *gesture =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(tapHandle:)];
            [iconView addGestureRecognizer:gesture];
//            iconView.contentMode = UIViewContentModeScaleAspectFill ;
            [iconView sd_setImageWithURL:[NSURL URLWithString:imageUrlM.head_img] placeholderImage:DefaultImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                UIImage* imgCliped = [UIImage cutImage:image];
                iconView.image = imgCliped ;
            }];
            
            
            iconView.frame = CGRectMake(iconX, iconY, iconW, iconH);
            [self.imageContentView addSubview:iconView];
        }
        NSInteger row = (imagesCount-1)/imageTotalCount ;
        CGFloat imageHeight = (iconH + imageMargin) * row + iconH ;
        [self.imageContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(imageHeight);
        }];
    }
    else if (imagesCount == 1){
        ImageModel* imageUrlM = model.contentImages[0] ;
        __block UIImageView *iconView = [[UIImageView alloc]init];
//        iconView.contentMode = UIViewContentModeScaleAspectFill ;
        [iconView sd_setImageWithURL:[NSURL URLWithString:imageUrlM.head_img] placeholderImage:DefaultImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            iconView.image = image ;
            CGSize imageSize = image.size ;
            CGFloat w = (singImageHeight*imageSize.width)/imageSize.height;
            CGFloat maxW = SCREENWidth-160;
            if (w >=maxW) {
                w = maxW ;
            }
            else if ( w <=80){
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
        [self.imageContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        
    }
    
}
-(NSString *)setOperationStrWithPraiseAmount:(int)praiseNumber responseAmount:(int)responseNumber presentDiamondAmount:(int)presentDiamondAmount
{
    NSString *praiseAmount = praiseNumber == 0 ?@"":[NSString stringWithFormat:@"%d点赞",praiseNumber];
    NSString *responseAmount = responseNumber == 0 ?@"":[NSString stringWithFormat:@"%d评论 ",responseNumber];
    if(praiseAmount.length != 0 && responseAmount.length != 0){
       responseAmount = [NSString stringWithFormat:@"%@ | %@",praiseAmount,responseAmount];
    }else if(praiseAmount.length != 0){
        responseAmount = praiseAmount;
    }else{
        responseAmount = responseAmount;
    }
    NSString *presentAmount = presentDiamondAmount == 0 ?@"":[NSString stringWithFormat:@"%d赞赏",presentDiamondAmount];
    if (responseAmount.length != 0 && presentAmount.length != 0 ) {
        presentAmount = [NSString stringWithFormat:@"%@ | %@",responseAmount,presentAmount];
    }else if(responseAmount.length != 0){
        presentAmount = responseAmount;
    }else{
        presentAmount = presentAmount;
    }
    return presentAmount;
}
-(void)setFriendModel:(RRFFriendCircleModel *)friendModel
{
    _friendModel = friendModel;
    self.type = @"friendCircle";
    self.operationLabel.hidden = YES;
    if ([friendModel.type isEqualToString:@"friendCircleComment"]) {
        self.betView.hidden = YES;
        self.redPaperView.hidden = YES;
        self.showOrderView.hidden = YES;
        self.deletedBtn.hidden = [friendModel.isSelfComment isEqualToString:@"self"]?NO:YES;
        self.fullTextBtn.hidden = NO;
        [self.deletedBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(62.5);
        }];
        [self.textContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(62.5);
        }];
        [self.imageContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(62.5);
        }];
        [self.operationLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.imageContentView.mas_bottom);
        }];
    }else if ([friendModel.type isEqualToString:@"bonusPackage"]){
        self.betView.hidden = YES;
        self.deletedBtn.hidden = YES;
        self.redPaperView.hidden = NO;
        self.showOrderView.hidden = YES;
        self.redPaperView.model = friendModel.bonusPackageModel;
        [self.operationButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-leftMargin);
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.top.mas_equalTo(self.redPaperView.mas_bottom).offset(10);
            
        }];
        
    }else if([friendModel.type isEqualToString:@"exchangeOrder"] ){
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
        self.deletedBtn.hidden = YES;
        self.redPaperView.hidden = YES;
        self.showOrderView.hidden = YES;
        self.betView.model = friendModel.guessWithStockModel;
        self.betView.hidden = NO;
        self.fullTextBtn.hidden = YES;
        [self.operationLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.betView.mas_bottom).offset(10);
        }];
    }
    self.textContentLabel.backgroundColor = [UIColor whiteColor];
    BOOL isShow = [friendModel.isSelfComment isEqualToString:@"self"]?YES:NO;
    [self.moreMenu isShowAwardButton:isShow];
    if(isShow){
        [self.moreMenu mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(80*2+1);
        }];
    }else{
        [self.moreMenu mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(80*3+2);
        }];
    }
    
    BOOL isSelected = [friendModel.isPraise isEqualToString:@"alreadyPraise"]?YES:NO;
    [self.moreMenu settingIsLikeSelected:isSelected];

  
    [self.headerIcon sd_setImageWithURL:[NSURL URLWithString:friendModel.iconUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"common_head_default-diagram"]];
    NSString *sexStr = [friendModel.sex isEqualToString:@"女"]?@"woman":@"man";
    [self.sexBtn setImage:[UIImage imageNamed:sexStr] forState:UIControlStateNormal];
    NSString *userStatue = [friendModel.userStatue isEqualToString:@"already_review"]?@"icon_v":@"";
    [self.userStatueIcon setImage:[UIImage imageNamed:userStatue] forState:UIControlStateNormal];
    
    self.nameLabel.text = friendModel.userName;
    self.timeLabel.text = [friendModel.time localizedTime];
    
    NSString *contentStr = friendModel.commentModel.content;
    self.textContentLabel.text = contentStr;
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGRect rect = [contentStr boundingRectWithSize:CGSizeMake(SCREENWidth-leftMargin*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    CGFloat height = CGRectGetHeight(rect);
    self.fullTextBtn.hidden = height > maxContentStrHeight ?  NO :  YES;
    if(self.fullTextBtn.hidden == NO){
        [self.fullTextBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
        }];
    }else{
        [self.fullTextBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    
    WEAKSELF
    [self.imageContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger imagesCount = friendModel.commentModel.contentImages.count;
    if (imagesCount > 1) {
        CGFloat iconW = (SCREENWidth-leftMargin-62.5-(imageTotalCount - 1)*imageMargin)/imageTotalCount;
        CGFloat iconH = iconW;
        for (int i = 0; i < imagesCount ; i++) {
            ImageModel* imageUrlM = friendModel.commentModel.contentImages[i] ;
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
            [self.imageContentView addSubview:iconView];
        }
        NSInteger row = (imagesCount-1)/imageTotalCount ;
        CGFloat imageHeight = (iconH + imageMargin) * row + iconH ;
        [self.imageContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(imageHeight);
        }];
    }else if (imagesCount == 1){
        ImageModel* imageM = friendModel.commentModel.contentImages[0] ;
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
        
        [self.imageContentView addSubview:iconView];
        [weakSelf.imageContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(singImageHeight);
        }];
    }
    else{
        [self.imageContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
    [self.commentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(32);
    }];

    CGFloat commentListHeight = [self.commentView contentHeightWithAgreeArray:friendModel.praiseUsers rewardArray:friendModel.presentUsers commentArray:friendModel.respModels type:RRFCommentDetailInfoTypeFriendCircle indexPath:friendModel.indexPath];
    [self.commentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(commentListHeight);
    }];
    
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_moreMenu.isShowing) {
        _moreMenu.show = NO;
    }
}
- (void)tapHandle:(UITapGestureRecognizer *)tap {
    UIImageView* sender = (UIImageView*)tap.view ;
    NSInteger index = sender.tag ;
    NSArray* imageModels = @[];
    if (_friendModel == nil) {
        imageModels = _model.contentImages ;
    }
    else{
        imageModels = _friendModel.commentModel.contentImages ;
    }
    NSMutableArray* _URLStrings = [NSMutableArray arrayWithCapacity:imageModels.count];
    for (ImageModel* imageM in imageModels) {
        [_URLStrings addObject:imageM.big_img];
    }
    [HUPhotoBrowser showFromImageView:sender withURLStrings:_URLStrings placeholderImage:[UIImage imageNamed:@"common_head_default-diagram"] atIndex:index dismiss:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self postOperationButtonClickedNotification];
    if (_moreMenu.isShowing) {
        _moreMenu.show = NO;
    }
}


- (void)operationButtonClicked
{
    [self postOperationButtonClickedNotification];
    BOOL isShowing = self.moreMenu.isShowing ;
    [self.moreMenu setShow:!isShowing];
}

-(void)hiddenPopMenu{
//    [self.moreMenu setShow:NO];
}
@end
