//
//  RRFAgreeContentView.m
//  Puzzle
//
//  Created by huipay on 2016/12/7.
//  Copyright © 2016年 HuiBei. All rights reserved.
//
#define kColumn 8
#define kMargin 6
#define allPaddings  kMargin*kColumn
#define iconViewWidth  (SCREENWidth-36 - allPaddings)/(kColumn+1)
#define iconViewWidthFriend  (SCREENWidth-36-20- allPaddings)/(kColumn+1)
#define commentMaxWidthFriend SCREENWidth-32-18-kMargin-iconViewWidth-kMargin
#define commentMaxWidthReply SCREENWidth-15-18-kMargin-iconViewWidth-kMargin-12

#import "RRFAgreeContentView.h"
#import "PZVerticalButton.h"
#import "RRFCommentsCellModel.h"
#import "UIButton+WebCache.h"
#import "RRFFriendCircleModel.h"
#import "JNQFriendCircleModel.h"

@interface RRFCommentContentCell ()
@property(nonatomic,weak)PZVerticalButton *iconBtn;
@property(nonatomic,weak)UIView *commentView;
@property(nonatomic,copy)ItemClickParamBlock replyBlock;

@end
@implementation RRFCommentContentCell
-(instancetype)initWithIconStr:(NSString *)iconStr
{
    if (self = [super init]) {
        PZVerticalButton *iconBtn = [[PZVerticalButton alloc]init];
        [iconBtn setImage:[UIImage imageNamed:iconStr] forState:UIControlStateNormal];
        iconBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [iconBtn setTitleColor:[UIColor colorWithHexString:@"4964ef"] forState:UIControlStateNormal];
        iconBtn.titleLabel.font = [UIFont systemFontOfSize:9];
        iconBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        iconBtn.frame = CGRectMake(0, kMargin, iconViewWidth, iconViewWidth);
        self.iconBtn = iconBtn;
        [self addSubview:iconBtn];
        
        UIView *commentView = [[UIView alloc]init];
//        commentView.backgroundColor = [UIColor redColor];
        self.commentView = commentView;
        [self addSubview:commentView];
        [commentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconBtn.mas_right).offset(kMargin);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(0);
        }];
    }
    return self;
}
-(void)setCommentArray:(NSArray *)commentArray type:(RRFCommentDetailInfoType)type indexPath:(NSIndexPath *)indexPath
{
    [self.commentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSInteger count = commentArray.count;
    CGFloat totalHeight;
//    [self.iconBtn setTitle:[NSString stringWithFormat:@"(%ld)",(long)count] forState:UIControlStateNormal];
    UIView *temp;
    if (count) {
        for (int i = 0; i< count; i++) {
            UIButton *commentBtn = [[UIButton alloc]init];
//            commentBtn.backgroundColor = [UIColor yellowColor];
            commentBtn.titleLabel.numberOfLines = 0;
            [commentBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
            commentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            commentBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            RespModel *model = commentArray[i];
            model.indexPath = indexPath;
            NSString *contentStr;
            NSMutableAttributedString *attributedString;
            if ([model.respType isEqualToString:@"resp"]) {
                contentStr = [NSString stringWithFormat:@"%@:%@",model.fromUserName,model.respContent];
                attributedString = [[NSMutableAttributedString alloc]initWithString:contentStr];
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"2b5490"] range:NSMakeRange(0, model.fromUserName.length)];
                [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(0, model.fromUserName.length)];
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"333333"] range:NSMakeRange(model.fromUserName.length+1, attributedString.length-(model.fromUserName.length+1))];
            }else{
                contentStr = [NSString stringWithFormat:@"%@回复%@:%@",model.fromUserName,model.toUserName,model.respContent];
                
                attributedString = [[NSMutableAttributedString alloc]initWithString:contentStr];
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"2b5490"] range:NSMakeRange(0, model.fromUserName.length)];
                [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(0, model.fromUserName.length)];

                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"333333"] range:NSMakeRange(model.fromUserName.length, 2)];
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"2b5490"] range:NSMakeRange(model.fromUserName.length+2, model.toUserName.length)];
                [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(model.fromUserName.length+2, model.toUserName.length)];

                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"333333"] range:NSMakeRange(model.fromUserName.length+2+model.toUserName.length, model.respContent.length)];

            }
            [commentBtn setAttributedTitle:attributedString forState:UIControlStateNormal];
            NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
            CGFloat maxWidth;
            if (type == RRFCommentDetailInfoTypeComment) {
                maxWidth = SCREENWidth-30-iconViewWidth-kMargin;
            }else{
                maxWidth = commentMaxWidthFriend;
            }
            CGRect rect = [contentStr boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
            CGFloat height = CGRectGetHeight(rect);
            if (temp == nil) {
                commentBtn.frame = CGRectMake(0, 8,maxWidth, height);
            }else{
                commentBtn.frame = CGRectMake(0, CGRectGetMaxY(temp.frame)+8, maxWidth, height);
            }
            temp = commentBtn;
            WEAKSELF
            [[commentBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                if (weakSelf.replyBlock) {
                    weakSelf.replyBlock(model);
                }
            }];
            CGFloat cellHeight = height+8;
            totalHeight += cellHeight;
            [self.commentView addSubview:commentBtn];
        }
        [self.commentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(totalHeight+8);
        }];
        self.iconBtn.hidden = NO;

    }else if (count == 1){
        UIButton *commentBtn = [[UIButton alloc]init];
        [commentBtn setBackgroundImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@""]] forState:UIControlStateSelected];
        commentBtn.titleLabel.numberOfLines = 0;
        [commentBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        commentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        commentBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        RespModel *model = commentArray[0];
        model.indexPath = indexPath;
        NSString *contentStr;
        if ([model.respType isEqualToString:@"resp"]) {
            contentStr = [NSString stringWithFormat:@"%@:%@",model.fromUserName,model.respContent];
        }else{
            contentStr = [NSString stringWithFormat:@"%@回复%@:%@",model.fromUserName,model.toUserName,model.respContent];
        }
        [commentBtn setTitle:contentStr forState:UIControlStateNormal];
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
        CGFloat maxWidth;
        if (type == RRFCommentDetailInfoTypeComment) {
            maxWidth = SCREENWidth-30-iconViewWidth-kMargin;
        }else{
            maxWidth = commentMaxWidthFriend;
        }
        CGRect rect = [contentStr boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
        CGFloat height = CGRectGetHeight(rect);
        commentBtn.frame = CGRectMake(0, 28, maxWidth, height);
        
        WEAKSELF
        [[commentBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (weakSelf.replyBlock) {
                weakSelf.replyBlock(model);
            }
        }];
        [self.commentView addSubview:commentBtn];
        CGFloat cellHeight = CGRectGetHeight(rect)+8;
        if (cellHeight < iconViewWidth) {
            cellHeight = iconViewWidth+kMargin*2;
        }else{
            cellHeight = cellHeight;
        }
        [self.commentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(cellHeight);
        }];
        self.iconBtn.hidden = NO;
    }else{
        self.iconBtn.hidden = YES;
        [self.commentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
}
-(CGFloat)commentViewHeight:(NSArray *)commentArray type:(RRFCommentDetailInfoType)type
{
    if (commentArray.count > 1) {
        CGFloat totalHeight;
        for (int i = 0; i<commentArray.count; i++) {
            RespModel *model = commentArray[i];
            NSString *contentStr;
            if ([model.respType isEqualToString:@"resp"]) {
                contentStr = [NSString stringWithFormat:@"%@:%@",model.fromUserName,model.respContent];
            }else{
                contentStr = [NSString stringWithFormat:@"%@回复%@:%@",model.fromUserName,model.toUserName,model.respContent];
            }
            NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
            CGFloat maxWidth;
            if (type == RRFCommentDetailInfoTypeComment) {
                maxWidth = SCREENWidth-32-iconViewWidth-kMargin-33;
            }else{
                maxWidth = commentMaxWidthFriend;
            }
            CGRect rect = [contentStr boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
            CGFloat cellHeight = CGRectGetHeight(rect)+8;
            totalHeight += cellHeight;
        }
        return totalHeight+8;
    }else if (commentArray.count == 1){
        RespModel *model = commentArray[0];
        NSString *contentStr;
        if ([model.respType isEqualToString:@"resp"]) {
            contentStr = [NSString stringWithFormat:@"%@:%@",model.fromUserName,model.respContent];
        }else{
            contentStr = [NSString stringWithFormat:@"%@回复%@:%@",model.fromUserName,model.toUserName,model.respContent];
        }
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
        CGFloat maxWidth;
        if (type == RRFCommentDetailInfoTypeComment) {
            maxWidth = SCREENWidth-32-iconViewWidth-kMargin-33;
        }else{
            maxWidth = commentMaxWidthFriend;
        }
        CGRect rect = [contentStr boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
        CGFloat cellHeight = CGRectGetHeight(rect)+8;
        if (cellHeight < iconViewWidth) {
            return iconViewWidth+kMargin*2;
        }else{
            return cellHeight;
        }
    }else{
        return 0;
    }
}
@end

@interface RRFAgreeContentCell ()
@property(nonatomic,weak)PZVerticalButton *iconBtn;
@property(nonatomic,weak)UIView *imageContentView;
@property(nonatomic,copy)ItemClickParamBlock goUserDetailInfo;
-(void)setSubViewIconArray:(NSArray *)subViewIconArray type:(RRFCommentDetailInfoType)type;

@end
@implementation RRFAgreeContentCell
-(instancetype)initWithIcon:(NSString *)iconStr
{
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        PZVerticalButton *iconBtn = [[PZVerticalButton alloc]init];
        [iconBtn setImage:[UIImage imageNamed:iconStr] forState:UIControlStateNormal];
        iconBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [iconBtn setTitleColor:[UIColor colorWithHexString:@"4964ef"] forState:UIControlStateNormal];
        iconBtn.titleLabel.font = [UIFont systemFontOfSize:9];
        iconBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        iconBtn.frame = CGRectMake(0, kMargin, iconViewWidth, iconViewWidth);
        self.iconBtn = iconBtn;
        [self addSubview:iconBtn];
        
        UIControl *imageContentView = [[UIControl alloc]init];
        imageContentView.userInteractionEnabled = YES;
        self.imageContentView = imageContentView;
        [self addSubview:imageContentView];
        [imageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconBtn.mas_right);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(0);
        }];
        
        
        
       
    }
    return self;
}
-(void)setSubViewIconArray:(NSArray *)subViewIconArray type:(RRFCommentDetailInfoType)type
{
    WEAKSELF
    NSInteger count = subViewIconArray.count;
    if (count != 0) {
        self.iconBtn.hidden = NO;
        [self.imageContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        CGFloat iconBtnWith = type== RRFCommentDetailInfoTypeComment?iconViewWidth:iconViewWidthFriend;
        for (int i = 0; i < count; i++) {
            CGFloat row = i/kColumn;
            CGFloat loc = i%kColumn;
            CGFloat iconViewX = (kMargin+iconBtnWith)*loc+kMargin;
            CGFloat iconViewY = (kMargin+iconBtnWith)*row + kMargin;
            UIButton *iconView = [[UIButton alloc]init];
            PraiseUsersModel *userM = subViewIconArray[i];
            [[iconView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                if (weakSelf.goUserDetailInfo) {
                    weakSelf.goUserDetailInfo(userM);
                }
            }];
            NSString *iconStr = userM.userIconUrl;
            [iconView sd_setImageWithURL:[NSURL URLWithString:iconStr] forState:UIControlStateNormal placeholderImage:DefaultImage];
            iconView.frame = CGRectMake(iconViewX, iconViewY, iconBtnWith, iconBtnWith);
            [self.imageContentView addSubview:iconView];
        }
//        NSString *countStr = [NSString stringWithFormat:@"(%ld)",(long)count];
//        [self.iconBtn setTitle:countStr forState:UIControlStateNormal];
        
        
        CGFloat totlaRow = (count+kColumn-1)/kColumn;
        CGFloat contentViewHeight = totlaRow*(iconBtnWith+kMargin)+kMargin;
        [self.imageContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(contentViewHeight);
        }];
    }else{
        self.iconBtn.hidden = YES;
        [self.imageContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }

}
@end
@interface RRFAgreeContentView ()
@property(nonatomic,weak)UIImageView *bgView;
@property(nonatomic,weak)RRFAgreeContentCell *agreeCell;
@property(nonatomic,weak)RRFAgreeContentCell *rewardCell;
@property(nonatomic,weak)RRFCommentContentCell *commentCell;
@property(nonatomic,weak)UIView *sepView;
@property(nonatomic,weak)UIView *sepView1;

@end
@implementation RRFAgreeContentView
-(instancetype)init
{
    if (self = [super init]) {
        UIImageView *bgView = [[UIImageView alloc]init];
        bgView.userInteractionEnabled = YES;
        bgView.image = [UIImage imageNamed:@"agreecontentview_bg"];
        self.bgView = bgView;
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.right.mas_equalTo(6);
        }];
        
        RRFAgreeContentCell *agreeCell = [[RRFAgreeContentCell alloc]initWithIcon:@"icon_like_blue"];
        agreeCell.goUserDetailInfo = ^(id model){
            [[NSNotificationCenter defaultCenter] postNotificationName:HeaderClickNotificate object:model];
        };
        self.agreeCell = agreeCell;
        [self addSubview:agreeCell];
        [agreeCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
        }];
        
        UIView *sepView = [[UIView alloc]init];
        sepView.alpha = 0.6;
        sepView.backgroundColor = [UIColor colorWithHexString:@"c9c8c8"];
        self.sepView = sepView;
        [self addSubview:sepView];
        [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(agreeCell.mas_bottom).offset(4);
            make.right.mas_equalTo(-2);
        }];
        
        RRFAgreeContentCell *rewardCell = [[RRFAgreeContentCell alloc]
                                           initWithIcon:@"btn_reward_blue"];
        rewardCell.goUserDetailInfo = ^(id model){
            [[NSNotificationCenter defaultCenter] postNotificationName:HeaderClickNotificate object:model];
        };
        self.rewardCell = rewardCell;
        [self addSubview:rewardCell];
        [rewardCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(sepView.mas_bottom).offset(4);
            make.left.right.mas_equalTo(0);
        }];
        
        UIView *sepView1 = [[UIView alloc]init];
        sepView1.alpha = 0.6;
        sepView1.backgroundColor = [UIColor colorWithHexString:@"c9c8c8"];
        self.sepView1 = sepView1;
        [self addSubview:sepView1];
        [sepView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.height.mas_equalTo(1);
            make.top.mas_equalTo(rewardCell.mas_bottom).offset(4);
            make.right.mas_equalTo(-2);
        }];
        
        RRFCommentContentCell *commentCell = [[RRFCommentContentCell alloc]initWithIconStr:@"dynamic_icon_comment"];
        commentCell.replyBlock = ^(RespModel *model){
            [[NSNotificationCenter defaultCenter] postNotificationName:FriendCircleReplyNotificate object:model];
        };
        self.commentCell = commentCell;
        [self addSubview:commentCell];
        [commentCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(sepView1.mas_bottom).offset(4);
            make.left.right.mas_equalTo(0);
        }];
     
    }
    return self;
}
-(CGFloat)cellHeighWithArray:(NSArray *)array type:(RRFCommentDetailInfoType)type
{
    if (array.count != 0) {
        NSInteger column = (array.count +kColumn- 1)/kColumn;
        CGFloat height;
        if(type == RRFCommentDetailInfoTypeComment){
            height = (kMargin+iconViewWidth)*column + kMargin;
        }else{
            height = (kMargin+iconViewWidthFriend)*column + kMargin;
        }
        return height;
    }else{
        return 0;
    }
}

-(CGFloat)contentHeightWithAgreeArray:(NSArray *)agreeArray rewardArray:(NSArray *)rewardArray commentArray:(NSArray *)commentArray type:(RRFCommentDetailInfoType )type indexPath:(NSIndexPath *)indexPath
{
    [self sepHiddenWithAgreeArray:agreeArray rewardArray:rewardArray commentArray:commentArray];
//    点赞
    CGFloat agreeHeight = [self cellHeighWithArray:agreeArray type:type];
    [self.agreeCell mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_offset(0);
        make.height.mas_equalTo(agreeHeight);
    }];
    if(agreeHeight != 0){
        agreeHeight += 8;
    };
    [self.agreeCell setSubViewIconArray:agreeArray type:type];

//    赞赏
    CGFloat rewardHeight =  [self cellHeighWithArray:rewardArray type:type];
    [self.rewardCell mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        if(agreeArray.count == 0){
            make.top.mas_equalTo(0);
        }else{
            make.top.mas_equalTo(self.sepView.mas_bottom).offset(4);
        }
        make.height.mas_equalTo(rewardHeight);
    }];
    if(rewardHeight != 0){
        rewardHeight += 8;
    };
    [self.rewardCell setSubViewIconArray:rewardArray type:type];
    
    CGFloat commentHeight =  [self.commentCell commentViewHeight:commentArray type:type];
    [self.commentCell mas_remakeConstraints:^(MASConstraintMaker *make) {
        if(agreeArray.count == 0 && rewardArray.count == 0){
            make.top.mas_equalTo(0);
        }else if(rewardArray.count == 0) {
            make.top.mas_equalTo(self.sepView.mas_bottom).offset(4);
        }else{
            make.top.mas_equalTo(self.sepView1.mas_bottom).offset(4);
        }
        make.height.mas_equalTo(commentHeight);
        make.left.right.mas_equalTo(0);
    }];
    if(commentHeight != 0){
        commentHeight += 6;
    };
    [self.commentCell setCommentArray:commentArray type:type indexPath:indexPath];
    
    if (agreeArray.count == 0 && rewardArray.count == 0 && commentArray.count == 0) {
        self.bgView.hidden = YES;
        return 0;
    }else{
        self.bgView.hidden = NO;
        CGFloat total = agreeHeight+rewardHeight+commentHeight ;
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(total);
            make.bottom.mas_equalTo(0);
            make.top.mas_equalTo(-10);
        }];
        return total;
    }

}
-(void)sepHiddenWithAgreeArray:(NSArray *)agreeArray rewardArray:(NSArray *)rewardArray commentArray:(NSArray *)commentArray
{
    if(agreeArray.count == 0 && rewardArray.count == 0 &&commentArray.count == 0){
        self.sepView.hidden = YES;
        self.sepView1.hidden = YES;
    }else if (rewardArray.count == 0 && agreeArray.count == 0 && commentArray.count != 0) {
        self.sepView.hidden = YES;
        self.sepView1.hidden = YES;
    }else if(agreeArray.count != 0 && rewardArray.count != 0 && commentArray.count == 0){
        self.sepView.hidden = NO;
        self.sepView1.hidden = YES;
    }else if (agreeArray.count == 0 && rewardArray.count != 0 && commentArray.count != 0){
        self.sepView.hidden = YES;
        self.sepView1.hidden = NO;
    }else if (agreeArray.count != 0 && rewardArray.count == 0 && commentArray.count != 0){
        self.sepView.hidden = NO;
        self.sepView1.hidden = YES;
    }else if (agreeArray.count != 0 && rewardArray.count != 0 && commentArray.count != 0){
        self.sepView.hidden = NO;
        self.sepView1.hidden = NO;
    }else if (agreeArray.count != 0 && rewardArray.count == 0 && commentArray.count == 0){
        self.sepView.hidden = YES;
        self.sepView1.hidden = YES;
    }else if (agreeArray.count == 0 && rewardArray.count == 0 && commentArray.count != 0){
        self.sepView.hidden = YES;
        self.sepView1.hidden = YES;
    }
    else if (agreeArray.count == 0 && rewardArray.count != 0 && commentArray.count == 0){
        self.sepView.hidden = YES;
        self.sepView1.hidden = YES;
    }
    else{
        self.sepView.hidden = NO;
        self.sepView1.hidden = NO;
    }

}
@end

