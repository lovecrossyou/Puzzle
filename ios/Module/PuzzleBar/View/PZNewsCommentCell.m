//
//  PZNewsCommentCell.m
//  Puzzle
//
//  Created by 朱理哲 on 2016/12/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZNewsCommentCell.h"

@interface PZNewsCommentCellContentView:UIView
@property(weak,nonatomic) UIView* topView;
@property(weak,nonatomic) UILabel* label;

@end

@implementation PZNewsCommentCellContentView
-(instancetype)initWithContent:(NSString*)content{
    if (self = [super init]) {
        self.layer.borderColor = [UIColor lightGrayColor].CGColor ;
        self.layer.borderWidth = 1 ;
        UIView* topView = [[UIView alloc]init];
        [self addSubview:topView];
        self.topView = topView ;
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];

        UILabel* label = [[UILabel alloc]init];
        label.numberOfLines = 0 ;
        label.text = content ;
        label.font = PZFont(12.0f);
        [label sizeToFit];
        label.textColor = [UIColor darkGrayColor];
        [self addSubview:label];
        self.label = label ;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.top.mas_equalTo(topView.mas_bottom);
        }];
    }
    return self ;
}
@end


@interface PZNewsCommentCell(){
    UIImageView* logoView ;
    UILabel* titleLabel ;
    UILabel* cateLabel ;
    UILabel* timeLabel ;
}
@end


@implementation PZNewsCommentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
//        UIView* bgView = [[UIView alloc]init];
//        bgView.backgroundColor = [UIColor lightGrayColor];
//        [self.contentView addSubview:bgView];
//        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
//        }];
    }
    return self;
}

-(void)configModel:(NSArray*)comments{
    PZNewsCommentCellContentView* lastComment;
    for (NSString* content in comments) {
        PZNewsCommentCellContentView* textView = [[PZNewsCommentCellContentView alloc]initWithContent:content];
        
        if (lastComment) {
            UIView* topView =lastComment.topView ;
            UILabel* label = lastComment.label ;
            [topView addSubview:textView];
            [textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(topView.mas_bottom);
                make.left.mas_equalTo(topView.mas_left).offset(2);
                make.right.mas_equalTo(topView.mas_right).offset(-2);
            }];
            [topView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lastComment.mas_top);
                make.bottom.mas_equalTo(label.mas_top);
            }];
        }
        else{
            [self.contentView addSubview:textView];
            [textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(-12);
                make.left.mas_equalTo(20);
                make.right.mas_equalTo(-20);
            }];
        }
        lastComment = textView ;
    }
    [lastComment mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
    }];
}

@end
