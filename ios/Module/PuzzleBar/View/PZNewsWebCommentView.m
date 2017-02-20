//
//  PZNewsWebCommentView.m
//  Puzzle
//
//  Created by huipay on 2017/1/16.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "PZNewsWebCommentView.h"
#import "NewsCommentModel.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "UIButton+EdgeInsets.h"

@interface PZNewsCommentView()
@property(nonatomic,weak)UIButton *headIcon;
@property(nonatomic,weak)UILabel *nameLabel;
@property(nonatomic,weak)UIImageView *sexIcon;
@property(nonatomic,weak)UILabel *timeLabel;
@property(nonatomic,weak)UILabel *commentTextLabel;
@property(nonatomic,weak)UIButton *grantBtn;
@property(nonatomic,strong)NewsCommentModel *model;

@end

@implementation PZNewsCommentView
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        UIButton *headIcon = [[UIButton alloc]init];
        headIcon.layer.masksToBounds = YES;
        headIcon.layer.cornerRadius = 3;
        [headIcon setImage:DefaultImage forState:UIControlStateNormal];
        self.headIcon = headIcon;
        [self addSubview:headIcon];
        [headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.textColor = [UIColor colorWithHexString:@"2b5490"];
        nameLabel.font = [UIFont systemFontOfSize:14];
        self.nameLabel = nameLabel;
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headIcon.mas_right).offset(10);
            make.top.mas_equalTo(headIcon.mas_top);
            make.right.mas_lessThanOrEqualTo(-100);
        }];
        
        UIImageView *sexIcon = [[UIImageView alloc]init];
        self.sexIcon = sexIcon;
        [self addSubview:sexIcon];
        [sexIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(nameLabel.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
        
        UILabel *timeLabel = [[UILabel alloc]init];
        timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
        timeLabel.font = [UIFont systemFontOfSize:12];
        self.timeLabel = timeLabel;
        [self addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headIcon.mas_right).offset(10);
            make.top.mas_equalTo(nameLabel.mas_bottom).offset(2);
        }];
        
        
        UILabel *commentTextLabel = [[UILabel alloc]init];
        commentTextLabel.numberOfLines = 0;
        commentTextLabel.textColor = [UIColor colorWithHexString:@"333333"];
        commentTextLabel.font = [UIFont systemFontOfSize:12];
        [commentTextLabel sizeToFit];
        self.commentTextLabel = commentTextLabel;
        [self addSubview:commentTextLabel];
        [commentTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(52);
            make.top.mas_equalTo(headIcon.mas_bottom).offset(10);
            make.right.mas_equalTo(-12);
            make.bottom.mas_equalTo(-12);
        }];
        
        UIView *sep = [[UIView alloc]init];
        sep.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [self addSubview:sep];
        [sep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(1);
        }];
        
        
    }
    return self;
}
-(void)setModel:(NewsCommentModel *)model
{
    [self.headIcon sd_setImageWithURL:[NSURL URLWithString:model.userIconUrl] forState:UIControlStateNormal placeholderImage:DefaultImage];
    self.nameLabel.text = model.userName;
    self.sexIcon.image = [UIImage imageNamed:[model.sex isEqualToString:@"woman"]?@"woman":@"man"];
    self.timeLabel.text = model.time;
    self.commentTextLabel.text = model.content;
}
-(CGFloat)getCellHeightWithModel:(NewsCommentModel *)model
{
    NSString *commentText = model.content;
    NSDictionary *attribut = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    CGRect rect = [commentText boundingRectWithSize:CGSizeMake(SCREENWidth-52-12, MAXFLOAT) options:NSStringDrawingUsesDeviceMetrics attributes:attribut context:nil];
    CGFloat height = CGRectGetMaxY(rect);
    return height;
}
@end
@interface PZNewsWebCommentView ()
@property(nonatomic,weak)UIButton *moreBtn;
@property(nonatomic,weak)UIView *commentListView;
@end
@implementation PZNewsWebCommentView
-(instancetype)init{
    if (self = [super init]) {
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.text = @"    热门评论";
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(34);
            make.top.mas_equalTo(12);
        }];
        
        UIView *commentListView = [[UIView alloc]init];
        self.commentListView = commentListView;
        [self addSubview:commentListView];
        [commentListView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(1);
            make.left.right.mas_equalTo(0);
        }];
        
        UIButton *moreBtn = [[UIButton alloc]init];
        [moreBtn setBackgroundColor:[UIColor whiteColor]];
        [moreBtn setTitle:@"查看更多评论" forState:UIControlStateNormal];
        [moreBtn setTitleColor:[UIColor colorWithHexString:@"0165f8"] forState:UIControlStateNormal];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        self.moreBtn = moreBtn;
        [self addSubview:moreBtn];
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(commentListView.mas_bottom).offset(1);
            make.height.mas_equalTo(44);
        }];
        [[moreBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.moreBlock) {
                self.moreBlock();
            }
        }];
        
        
    }
    return self;
}

-(CGFloat)getHeightWtihCommentList:(NSArray *)commentList
{
    CGFloat totalHeight = 0;
    NSInteger count = commentList.count;
    UIView *temp = nil;
    for (int i = 0; i < count; i++) {
        
        PZNewsCommentView *commentCell = [[PZNewsCommentView alloc]init];
        NewsCommentModel *commentM = commentList[i];
        commentCell.model = commentM;
        CGFloat cellHeight =  [commentCell getCellHeightWithModel:commentM];
        cellHeight += (10+30+10+12);
        if (temp == nil) {
            commentCell.frame = CGRectMake(0, 0, SCREENWidth, cellHeight);
        }else{
            commentCell.frame = CGRectMake(0, totalHeight, SCREENWidth, cellHeight);
        }
        temp = commentCell;
        [self.commentListView addSubview:commentCell];
        totalHeight += cellHeight;
    }
    [self.commentListView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(totalHeight);
    }];
    if (count > 2) {
        self.moreBtn.hidden = NO;
        return totalHeight + 12 + 34 + 44;
    }else{
        self.moreBtn.hidden = YES;
        return totalHeight + 12 + 34;
    }
}
@end

@interface PZNewsShareView()
@end

@implementation PZNewsShareView

-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *sepView =[[UIView alloc]init];
        sepView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [self addSubview:sepView];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.text = @"分享";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [titleLabel sizeToFit];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.size.mas_equalTo(50);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.centerY.mas_equalTo(titleLabel.mas_centerY);
            make.height.mas_equalTo(1);
        }];
        
        UIButton *wechat = [[UIButton alloc]init];
        wechat.tag = 0;
        [wechat addTarget:self action:@selector(btnClcik:) forControlEvents:UIControlEventTouchUpInside];
        [wechat setImage:[UIImage imageNamed:@"jnq_icon_wechat"] forState:UIControlStateNormal];
        [wechat setTitle:@"微信好友" forState:UIControlStateNormal];
        [wechat setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        wechat.titleLabel.font = [UIFont systemFontOfSize:11];
               [self addSubview:wechat];
        [wechat mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(10);
            make.left.bottom.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth/4, 80));
        }];
         [wechat layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageTop imageTitlespace:4 imageWidth:36];
        
        UIButton *friendCircle = [[UIButton alloc]init];
        friendCircle.tag = 1;
        [friendCircle addTarget:self action:@selector(btnClcik:) forControlEvents:UIControlEventTouchUpInside];
        [friendCircle setImage:[UIImage imageNamed:@"jnq_friend-circle"] forState:UIControlStateNormal];
        [friendCircle setTitle:@"微信朋友圈" forState:UIControlStateNormal];
        [friendCircle setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        friendCircle.titleLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:friendCircle];
        [friendCircle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(10);
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(wechat.mas_right);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth/4, 80));
        }];
         [friendCircle layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageTop imageTitlespace:4 imageWidth:36];
        
        UIButton *sina = [[UIButton alloc]init];
        sina.tag = 2;
        [sina addTarget:self action:@selector(btnClcik:) forControlEvents:UIControlEventTouchUpInside];
        [sina setImage:[UIImage imageNamed:@"share_btn_weibo"] forState:UIControlStateNormal];
        [sina setTitle:@"新浪微博" forState:UIControlStateNormal];
        [sina setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        sina.titleLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:sina];
        [sina mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(10);
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(friendCircle.mas_right);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth/4, 80));
        }];
        [sina layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageTop imageTitlespace:4 imageWidth:36];
        
        UIButton *qq = [[UIButton alloc]init];
        qq.tag = 3;
        [qq addTarget:self action:@selector(btnClcik:) forControlEvents:UIControlEventTouchUpInside];
        [qq setImage:[UIImage imageNamed:@"share_btn_qq"] forState:UIControlStateNormal];
        [qq setTitle:@"QQ好友" forState:UIControlStateNormal];
        [qq setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        qq.titleLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:qq];
        [qq mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(10);
            make.bottom.mas_equalTo(0);
            make.left.mas_equalTo(sina.mas_right);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth/4, 80));
        }];
        
        [qq layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageTop imageTitlespace:4 imageWidth:36];

    }
    
    return self;
}
-(void)btnClcik:(UIButton *)sender
{
    if (self.shareBlock) {
        self.shareBlock(@(sender.tag));
    }
}
@end
