//
//  RRFCommentDetailView.m
//  Puzzle
//
//  Created by huibei on 16/8/22.
//  Copyright © 2016年 HuiBei. All rights reserved.
//
#define singImageHeight 120
#define leftMargin 15
#import "RRFCommentDetailView.h"
#import "RRFCommentsCellModel.h"
#import "PZParamTool.h"
#import "UIImageView+WebCache.h"
#import <XHImageViewer/XHImageViewer.h>
#import "UIButton+WebCache.h"
#import <HUPhotoBrowser/HUPhotoBrowser.h>
#import "NSString+TimeConvert.h"
#import "PZParamTool.h"
#import "PZCache.h"
#import "JNQFriendCircleModel.h"
#import "RRFFriendCirclebetView.h"
#import "RRFAgreeContentView.h"
#import "InsetsLabel.h"
#import "ImageModel.h"
@interface RRFCommentDetailView()

@property(nonatomic,weak)UIButton *headIcon;
@property(nonatomic,weak)UIButton *sexBtn;
@property(nonatomic,weak)UILabel *nameLabel;
@property(nonatomic,weak)UILabel *timeLabel;
@property(nonatomic,weak)UILabel *textContentLabel;
@property(nonatomic,weak)UIView *imageContentView;
@property(nonatomic,weak)UIButton *rewardBtn;
@property(nonatomic,weak)UIButton *replyBtn;
@property(nonatomic,weak)UIButton *agreeBtn;
@property(nonatomic,strong)NSString *isPraise;
@property(nonatomic,weak) RRFAgreeContentView *headerBottomView;
@property(nonatomic,weak)NSArray *praiseUsers;
@end
@implementation RRFCommentDetailView

-(instancetype)init
{
    if (self = [super init]) {
      
        self.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        
        UIView *bgView =[[UIView alloc]init];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-15);
            make.top.mas_equalTo(0);
        }];
        UIButton *headIcon = [[UIButton alloc]init];
        [headIcon sizeToFit];
        headIcon.layer.masksToBounds = YES;
        headIcon.layer.cornerRadius = 3;
        self.headIcon = headIcon;
        [self addSubview:headIcon];
        [headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftMargin);
            make.top.mas_equalTo(12.5);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
      
       
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.textColor = [UIColor colorWithHexString:@"2b5490"];
        nameLabel.font = [UIFont systemFontOfSize:16];
        [nameLabel sizeToFit];
        self.nameLabel = nameLabel;
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headIcon.mas_right).offset(8);
            make.top.mas_equalTo(headIcon.mas_top).offset(4);
            make.right.mas_lessThanOrEqualTo(-60);
        }];
        
        UIButton *sexBtn = [[UIButton alloc]init];
        sexBtn.userInteractionEnabled = NO;
        self.sexBtn = sexBtn;
        [self addSubview:sexBtn];
        [sexBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameLabel.mas_right).offset(8);
            make.centerY.mas_equalTo(nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
        timeLabel.font = [UIFont systemFontOfSize:11];
        [timeLabel sizeToFit];
        self.timeLabel = timeLabel;
        [self addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headIcon.mas_right).offset(8);
            make.bottom.mas_equalTo(headIcon.mas_bottom).offset(-4);
        }];
        
        RRFFriendCirclebetView *betView = [[RRFFriendCirclebetView alloc]init];
        self.betView = betView;
        [self addSubview:betView];
        [betView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftMargin);
            make.top.mas_equalTo(headIcon.mas_bottom).offset(12.5);
            make.right.mas_equalTo(-leftMargin);
            make.height.mas_equalTo(100);
        }];
        
        InsetsLabel *textContentLabel = [[InsetsLabel  alloc]initWithInsets:UIEdgeInsetsZero];
        textContentLabel.numberOfLines = 0;
        textContentLabel.textColor = [UIColor colorWithHexString:@"333333"];
        textContentLabel.font = [UIFont systemFontOfSize:15];
        [textContentLabel sizeToFit];
        self.textContentLabel = textContentLabel;
        [self addSubview:textContentLabel];
        [textContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftMargin);
            make.right.mas_equalTo(-leftMargin);
            make.top.mas_equalTo(headIcon.mas_bottom).offset(12.5);
        }];
        
        UIView *imageContentView = [[UIView alloc]init];
        self.imageContentView = imageContentView;
        [self addSubview:imageContentView];
        [imageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(textContentLabel.mas_bottom).offset(8);
            make.left.mas_equalTo(leftMargin);
            make.right.mas_equalTo(-leftMargin);
        }];
        
        UIButton *rewardBtn = [[UIButton alloc]init];
        [rewardBtn setTitle:@" 赞赏" forState:UIControlStateNormal];
        [rewardBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [rewardBtn setTitleColor:[UIColor colorWithHexString:@"777777"] forState:UIControlStateSelected];
        rewardBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [rewardBtn setImage:[UIImage imageNamed:@"btn_reward_solid"] forState:UIControlStateNormal];
        [rewardBtn setImage:[UIImage imageNamed:@"btn_reward_disenable"] forState:UIControlStateSelected];
        [rewardBtn sizeToFit];
        self.rewardBtn = rewardBtn;
        [self addSubview:rewardBtn];
        [rewardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREENWidth/3, 25));
            make.top.mas_equalTo(imageContentView.mas_bottom).offset(8);
            make.right.mas_equalTo(0);
        }];
        [[rewardBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.detailBlock) {
                self.detailBlock(@(0));
            }
        }];
        
        UIButton *replyBtn = [[UIButton alloc]init];
        [replyBtn setTitle:@" 评论" forState:UIControlStateNormal];
        [replyBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [replyBtn setImage:[UIImage imageNamed:@"btn_comment_solid"] forState:UIControlStateNormal];
        replyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [replyBtn sizeToFit];
        self.replyBtn = replyBtn;
        [self addSubview:replyBtn];
        [replyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREENWidth/3, 25));
            make.centerY.mas_equalTo(rewardBtn.mas_centerY);
            make.right.mas_equalTo(rewardBtn.mas_left);
        }];
        [[replyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.detailBlock) {
                self.detailBlock(@(1));
            }
        }];
        
        UIButton *agreeBtn = [[UIButton alloc]init];
        [agreeBtn setTitle:@" 点赞" forState:UIControlStateNormal];
        [agreeBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [agreeBtn setImage:[UIImage imageNamed:@"btn_like_solid_d"] forState:UIControlStateNormal];
        [agreeBtn setImage:[UIImage imageNamed:@"btn_like_solid_s"] forState:UIControlStateSelected];
        agreeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [agreeBtn sizeToFit];
        self.agreeBtn = agreeBtn;
        [self addSubview:agreeBtn];
        [agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(SCREENWidth/3, 25));
            make.centerY.mas_equalTo(rewardBtn.mas_centerY);
            make.right.mas_equalTo(replyBtn.mas_left);
        }];
        [[agreeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.detailBlock) {
                self.detailBlock(@(2));
            }
        }];
      
        
        UIView *sepView = [[UIView alloc]init];
        sepView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [self addSubview:sepView];
        [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(rewardBtn.mas_bottom).offset(8);
        }];
        
        RRFAgreeContentView *headerBottomView = [[RRFAgreeContentView alloc]init];
        self.headerBottomView = headerBottomView;
        [self addSubview:headerBottomView];
        [headerBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftMargin);
            make.right.mas_equalTo(-(leftMargin+6));
            make.top.mas_equalTo(sepView.mas_bottom).offset(13);
        }];
        
    }
    return self;
}
-(void)setCommentM:(RRFCommentsCellModel *)commentM
{
    _commentM = commentM;
    self.praiseUsers = commentM.praiseUsers;
    self.betView.hidden = YES;
    self.isPraise = commentM.isPraise;
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:commentM.userIconUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"common_head_default-diagram"]];
    NSString *sexStr = [commentM.sex isEqualToString:@"女"]?@"woman":@"man";
    [self.sexBtn setImage:[UIImage imageNamed:sexStr] forState:UIControlStateNormal];
    self.nameLabel.text = commentM.userName;
    self.timeLabel.text = [commentM.time localizedTime];
    self.agreeBtn.selected = [commentM.isPraise isEqualToString:@"alreadyPraise"]?YES:NO;
    self.textContentLabel.text = commentM.content;
    
    BOOL isSelf = [commentM.isSelfComment isEqualToString:@"self"] ;
    self.rewardBtn.selected = isSelf;
    BOOL appInvalid = ![PZCache sharedInstance].versionRelease ;
    if (appInvalid) {
        self.rewardBtn.hidden = YES ;
    }
    WEAKSELF
    NSInteger imagesCount = commentM.contentImages.count;
    if (imagesCount > 1) {
        CGFloat iconW = (SCREENWidth - leftMargin*2 - (imageTotalCount - 1)*imageMargin)/imageTotalCount;
        CGFloat iconH = iconW;
        for (int i = 0; i < imagesCount; i++) {
            ImageModel* imageUrlM = commentM.contentImages[i] ;

            int row = i/imageTotalCount;
            int loc = i%imageTotalCount;
            CGFloat iconX = (imageMargin + iconW)*loc;
            CGFloat iconY = (imageMargin + iconH)*row;
            
            UIImageView *iconView = [[UIImageView alloc]init];
            iconView.userInteractionEnabled = YES ;
            iconView.tag = i ;
            UITapGestureRecognizer *gesture =
            [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(tapHandle:)];
            [iconView addGestureRecognizer:gesture];
            [iconView sd_setImageWithURL:[NSURL URLWithString:imageUrlM.head_img] placeholderImage:[UIImage imageNamed:@"common_head_default-diagram"]];
            iconView.frame = CGRectMake(iconX, iconY, iconW, iconH);
            [self.imageContentView addSubview:iconView];
//            NSLog(@"%@", NSStringFromCGRect(iconView.frame));
        }
        
        NSInteger row = (imagesCount-1)/imageTotalCount;
        CGFloat imageHeight = (iconH + imageMargin) * row + iconH;
        [self.imageContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(imageHeight);
        }];
    } else if (imagesCount == 1){
        ImageModel* imageUrlM = commentM.contentImages[0] ;
        __block UIImageView *iconView = [[UIImageView alloc]init];
        iconView.contentMode = UIViewContentModeRedraw ;
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
}

- (void)tapHandle:(UITapGestureRecognizer *)tap {
    UIImageView* sender = (UIImageView*)tap.view ;
    NSInteger index = sender.tag ;
    NSArray* imageModels = _commentM.contentImages ;
    NSMutableArray* _URLStrings = [NSMutableArray arrayWithCapacity:imageModels.count];
    for (ImageModel* imageM in imageModels) {
        [_URLStrings addObject:imageM.big_img];
    }
    [HUPhotoBrowser showFromImageView:sender withURLStrings:_URLStrings placeholderImage:[UIImage imageNamed:@"common_head_default-diagram"] atIndex:index dismiss:nil];
}

-(CGFloat)viewHeightWithModel:(RRFCommentsCellModel *)model
{
    NSString *contentStr = model.content;
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
    CGRect rect = [contentStr boundingRectWithSize:CGSizeMake(SCREENWidth-leftMargin*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    CGFloat height = CGRectGetHeight(rect);
    
    CGFloat iconH = (SCREENWidth - leftMargin*2 - (imageTotalCount - 1)*imageMargin)/imageTotalCount;
    NSInteger imageCount = model.contentImages.count;
    CGFloat imageContentHeight = 0.0f;
    if (imageCount > 1) {
        NSInteger row = (imageCount+imageTotalCount-1)/imageTotalCount;
        imageContentHeight = (iconH + imageMargin) * row ;
    }else if (imageCount == 1){
        imageContentHeight = singImageHeight;
    }
    CGFloat headerBottomHeigt = [self.headerBottomView contentHeightWithAgreeArray:model.praiseUsers rewardArray:model.presentUsers commentArray:@[] type:RRFCommentDetailInfoTypeComment indexPath:nil];
    if (headerBottomHeigt != 0) {
        headerBottomHeigt += 20;
    }
    CGFloat totalHeight;
    if(contentStr.length == 0){
        totalHeight = height + imageContentHeight + 40 + 12.5 + 59 + headerBottomHeigt;
    }else{
        totalHeight = height + imageContentHeight + 12.5 + 40 + 12.5 + 55 + headerBottomHeigt;
    }
    return totalHeight ;
}

-(CGFloat)betViewHeightWithFriendCircleModel:(JNQFriendCircleModel *)model
{
    CGFloat headerBottomHeigt = [self.headerBottomView contentHeightWithAgreeArray:model.praiseUsers rewardArray:model.presentUsers commentArray:@[] type:RRFCommentDetailInfoTypeComment indexPath:nil];
    if(headerBottomHeigt > 0){
        headerBottomHeigt += 10;
    }
    
    CGFloat totalHeight = 224+ headerBottomHeigt;
    return totalHeight ;
}

-(void)setFrienfCircleM:(JNQFriendCircleModel *)frienfCircleM
{
    _frienfCircleM = frienfCircleM;
    
    GuessWithStockModel *model = [[GuessWithStockModel alloc]init];
    model.finalResult = frienfCircleM.finalResult;
    model.stage = frienfCircleM.stage;
    model.guessTime = frienfCircleM.guessTime;
    model.guessType = frienfCircleM.guessType;
    model.stockName = frienfCircleM.stockName;
    model.stockResultType = frienfCircleM.stockResultType;
    model.guessAmount = frienfCircleM.guessAmount;
    model.status = frienfCircleM.status;
    model.winMount = frienfCircleM.winMount;

    self.betView.hidden = NO;
    self.betView.model = model;
    self.isPraise = frienfCircleM.isPraise;
    self.textContentLabel.hidden = YES;
    self.imageContentView.hidden = YES;
    [self.rewardBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.betView.mas_bottom).offset(10);
    }];

    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:frienfCircleM.userIconUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"common_head_default-diagram"]];
    NSString *sexStr = [frienfCircleM.sex isEqualToString:@"女"]?@"woman":@"man";
    [self.sexBtn setImage:[UIImage imageNamed:sexStr] forState:UIControlStateNormal];
    self.nameLabel.text = frienfCircleM.userName;
    self.timeLabel.text = [frienfCircleM.guessTime localizedTime];
    BOOL isSelf = [frienfCircleM.isSelfComment isEqualToString:@"self"] ;
    self.rewardBtn.selected = isSelf;
    BOOL appInvalid = ![PZCache sharedInstance].versionRelease ;
    if (appInvalid) {
        self.rewardBtn.hidden = YES ;
    }
    self.agreeBtn.selected = [frienfCircleM.isPraise isEqualToString:@"alreadyPraise"]?YES:NO;
}

@end



@implementation RRFCommentDetailBottmoView

-(instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        UITextField *inputView = [[UITextField alloc]init];
        inputView.userInteractionEnabled = NO;
        [self addSubview:inputView];
        [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(44);
            make.height.mas_equalTo(32);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        UIImageView *iconView = [[UIImageView alloc]init];
        iconView.image = [UIImage imageNamed:@"face"];
        [self addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    return self;
}
@end
