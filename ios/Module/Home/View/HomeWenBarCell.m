//
//  HomeWenBarCell.m
//  Puzzle
//
//  Created by huipay on 2016/8/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "HomeWenBarCell.h"
#import "QuestionBarListModel.h"
#import "UIImageView+WebCache.h"
#import "RRFPuzzleBarTool.h"
#import "PZParamTool.h"
@interface HomeWenBarCell()
@property(nonatomic,weak)UIImageView* avatar;
@property(nonatomic,weak)UIButton *sexBtn;
@property(nonatomic,weak)UILabel* nameLabel;
@property(nonatomic,weak)UIImageView* vView ;
@property(nonatomic,weak)UILabel* detailLabel;
@property(nonatomic,weak)UILabel* fansLabel;
@property(nonatomic,weak)UILabel* replyLabel;
@property(nonatomic,weak)UIButton* followBtn;


@end
@implementation HomeWenBarCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView* avatar = [[UIImageView alloc]init];
        avatar.layer.masksToBounds = YES ;
        avatar.layer.cornerRadius = 5;
        self.avatar = avatar;
        [self addSubview:avatar];
        [avatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.top.mas_equalTo(12);
            make.bottom.mas_equalTo(-12);
            make.left.mas_equalTo(12);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        
        UIButton *sexBtn = [[UIButton alloc]init];
        sexBtn.userInteractionEnabled = NO;
        sexBtn.layer.masksToBounds = YES;
        sexBtn.layer.cornerRadius = 10;
        self.sexBtn = sexBtn;
        [self addSubview:sexBtn];
        [sexBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(avatar.mas_right).offset(8);
            make.bottom.mas_equalTo(avatar.mas_bottom).offset(8);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        UILabel* nameLabel = [[UILabel alloc]init];
        nameLabel.textColor = [UIColor darkGrayColor];
        [nameLabel sizeToFit];
        nameLabel.font = PZFont(14.0f);
        self.nameLabel = nameLabel;
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(avatar.mas_right).offset(12);
            make.top.mas_equalTo(avatar.mas_top).offset(4);
        }];
        //+v
        UIImageView* vView = [[UIImageView alloc]init];
        vView.image = [UIImage imageNamed:@"icon_v"];
        self.vView = vView;
        [self addSubview:vView];
        [vView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(10, 10));
            make.left.mas_equalTo(nameLabel.mas_right).offset(6);
            make.centerY.mas_equalTo(nameLabel.mas_centerY);
        }];
        
        UILabel* detailLabel = [[UILabel alloc]init];
        detailLabel.textColor = [UIColor lightGrayColor];
        [detailLabel sizeToFit];
        detailLabel.font = PZFont(13.0f);
        self.detailLabel = detailLabel;
        [self addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(avatar.mas_right).offset(12);
            make.right.mas_equalTo(-12-44);
            make.centerY.mas_equalTo(avatar.mas_centerY);
        }];
        
        //粉丝  回答
        UILabel* fansLabel = [[UILabel alloc]init];
        fansLabel.textColor = [UIColor darkGrayColor];
        [fansLabel sizeToFit];
        fansLabel.font = PZFont(12.0f);
        self.fansLabel = fansLabel;
        [self addSubview:fansLabel];
        [fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(avatar.mas_right).offset(12);
            make.bottom.mas_equalTo(avatar.mas_bottom).offset(-2);
        }];
        
        UILabel* replyLabel = [[UILabel alloc]init];
        replyLabel.textColor = [UIColor darkGrayColor];
        [replyLabel sizeToFit];
        replyLabel.font = PZFont(12.0f);
        self.replyLabel = replyLabel;
        [self addSubview:replyLabel];
        [replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(fansLabel.mas_right).offset(6);
            make.bottom.mas_equalTo(avatar.mas_bottom).offset(-2);
        }];
        
        UIButton* followBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [followBtn setImage:[UIImage imageNamed:@"btn_follow"] forState:UIControlStateNormal];
        [followBtn setImage:[UIImage imageNamed:@"icon_concerned"] forState:UIControlStateSelected];
        [followBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.followBtn = followBtn;
        [self addSubview:followBtn];
        [followBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(44, 44));
            make.right.mas_equalTo(-12);
        }];
    }
    return self ;
}
-(void)setModel:(QuestionBarModel *)model{
    _model = model;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.userIconUrl] placeholderImage:DefaultImage];
    self.nameLabel.text = model.userName;
    self.detailLabel.text = model.userIntroduce;
    NSString *sexStr = [model.sex isEqualToString:@"女"]?@"woman":@"man";
    [self.sexBtn setImage:[UIImage imageNamed:sexStr] forState:UIControlStateNormal];
    self.vView.hidden = [model.statue isEqualToString:@"already_review"]?NO:YES;
    self.fansLabel.text = [NSString stringWithFormat:@"%ld粉丝",(long)model.fansAmount];
    self.replyLabel.text = [NSString stringWithFormat:@"%ld评论",(long)model.answerAmount];
    self.followBtn.selected = [model.isFollower isEqualToString:@"alreadyFollower"] ? YES :NO;
    [[self.followBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton* x) {
        [RRFPuzzleBarTool addFllowerWithUserId:model.userId Success:^(id json) {
            [MBProgressHUD dismiss];
            x.selected =  !x.selected ;
            model.isFollower = [model.isFollower isEqualToString:@"alreadyFollower"]?@"noFollower":@"alreadyFollower";
            NSString *message = [model.isFollower isEqualToString:@"alreadyFollower"]?@"已关注":@"取消关注";
            [MBProgressHUD showInfoWithStatus:message];
        } failBlock:^(id json) {
        }];
    }];
    self.followBtn.selected = [model.isFollower isEqualToString:@"alreadyFollower"] ;
}
@end
