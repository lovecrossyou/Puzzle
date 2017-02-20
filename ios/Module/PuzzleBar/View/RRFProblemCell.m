//
//  RRFProblemCell.m
//  Puzzle
//
//  Created by huibei on 16/8/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//
#define maxContentStrHeight 200

#import "RRFProblemCell.h"
#import "RRFWenBarCellModel.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "PZParamTool.h"
@interface RRFProblemCell ()
{
    UILabel *_hotLabel;
    UIButton *_askQuestionsBtn;
    UILabel *_askQuestionsNameLabel;
    UIButton *_askQuestionsTextBtn;
    UIButton *_answerBtn;
    UILabel *_answerNameLabel;
    UILabel *_answerTextLabel;
    UILabel *_timeLabel;
    UIButton *_rewardBtn;
    UIButton *_agreeBtn;
    UIButton *_fullTextBtn;
    UIView *_imageContentView;
    NSString *_isPraise;
    
}
@end
@implementation RRFProblemCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //        _hotLabel = [[UILabel alloc]init];
        //        _hotLabel.text = @"热门 ";
        //        _hotLabel.textAlignment = NSTextAlignmentRight;
        //        _hotLabel.font = [UIFont systemFontOfSize:13];
        //        _hotLabel.textColor = [UIColor whiteColor];
        //        _hotLabel.backgroundColor = [UIColor redColor];
        //        [self.contentView addSubview:_hotLabel];
        //        [_hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.mas_offset(12);
        //            make.left.mas_offset(0);
        //            make.size.mas_equalTo(CGSizeMake(30, 20));
        //        }];
        //
        _askQuestionsBtn = [[UIButton alloc]init];
        [_askQuestionsBtn sizeToFit];
        _askQuestionsBtn.layer.masksToBounds = YES;
        _askQuestionsBtn.layer.cornerRadius = 5;
        [self.contentView addSubview:_askQuestionsBtn];
        [_askQuestionsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(20);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        _askQuestionsNameLabel = [[UILabel alloc]init];
        _askQuestionsNameLabel.textAlignment = NSTextAlignmentRight;
        _askQuestionsNameLabel.font = [UIFont systemFontOfSize:13];
        _askQuestionsNameLabel.textColor = [UIColor colorWithHexString:@"999999"];
        [self.contentView addSubview:_askQuestionsNameLabel];
        [_askQuestionsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_askQuestionsBtn.mas_top).offset(4);
            make.right.mas_equalTo(_askQuestionsBtn.mas_left).offset(-6);
        }];
        
        _askQuestionsTextBtn = [[UIButton alloc]init];
        [_askQuestionsTextBtn sizeToFit];
        _askQuestionsTextBtn.titleLabel.numberOfLines = 0;
        [_askQuestionsTextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _askQuestionsTextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _askQuestionsTextBtn.layer.masksToBounds = YES;
        _askQuestionsTextBtn.layer.cornerRadius = 5;
        _askQuestionsTextBtn.userInteractionEnabled = NO;
        //创建图片
        UIImage *norImage = [UIImage imageNamed:@"chat_send_nor"];
        // 设置图片的拉伸方法
        norImage = [norImage stretchableImageWithLeftCapWidth:norImage.size.width * 0.5 topCapHeight:norImage.size.height * 0.5];
        // 设置按钮背景图
        [_askQuestionsTextBtn setBackgroundImage:norImage forState:UIControlStateNormal];
        // 设置按钮内边距
        _askQuestionsTextBtn.contentEdgeInsets = UIEdgeInsetsMake(15, 20, 15, 20);
        [self.contentView addSubview:_askQuestionsTextBtn];
        [_askQuestionsTextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_greaterThanOrEqualTo(44);
            make.top.mas_equalTo(_askQuestionsNameLabel.mas_bottom).offset(4);
            make.right.mas_equalTo(_askQuestionsBtn.mas_left).offset(-6);
        }];
        
        
        _answerBtn = [[UIButton alloc]init];
        [_answerBtn sizeToFit];
        _answerBtn.layer.masksToBounds = YES;
        _answerBtn.layer.cornerRadius = 5;
        [self.contentView addSubview:_answerBtn];
        [_answerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(_askQuestionsTextBtn.mas_bottom).offset(8);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        _answerNameLabel = [[UILabel alloc]init];
        _answerNameLabel.textAlignment = NSTextAlignmentRight;
        _answerNameLabel.font = [UIFont systemFontOfSize:15];
        _answerNameLabel.textColor = [UIColor colorWithHexString:@"999999"];
        [self.contentView addSubview:_answerNameLabel];
        [_answerNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_answerBtn.mas_top).offset(4);
            make.left.mas_equalTo(_answerBtn.mas_right).offset(6);
        }];
        
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.text = @"2017-08-08 15:37";
        _timeLabel.textColor = [UIColor colorWithHexString:@"777777"];
        _timeLabel.numberOfLines = 0;
        _timeLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_answerBtn.mas_bottom).offset(-4);
            make.left.mas_equalTo(_answerBtn.mas_right).offset(6);
        }];
        
        _answerTextLabel = [[UILabel alloc]init];
        _answerTextLabel.textColor = [UIColor colorWithHexString:@"777777"];
        _answerTextLabel.numberOfLines = 0;
        _answerTextLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_answerTextLabel];
        [_answerTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-58);
            make.top.mas_equalTo(_answerBtn.mas_bottom).offset(4);
            make.left.mas_equalTo(_answerNameLabel.mas_left);
        }];
        
        _fullTextBtn = [[UIButton alloc]init];
        _fullTextBtn.hidden = YES;
        [_fullTextBtn setTitle:@"全文(PDF原文)" forState:UIControlStateNormal];
        [_fullTextBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        _fullTextBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_fullTextBtn sizeToFit];
        [self.contentView addSubview:_fullTextBtn];
        [_fullTextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_answerTextLabel.mas_bottom).offset(0);
            make.left.mas_equalTo(_answerNameLabel.mas_left);
        }];
        
        _imageContentView = [[UIView alloc]init];
        [self.contentView addSubview:_imageContentView];
        [_imageContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_answerTextLabel.mas_left);
            make.right.mas_equalTo(-24);
            make.top.mas_equalTo(_answerTextLabel.mas_bottom).offset(8);
        }];
        for (int i = 0; i < 9; i++) {
            int row = i/imageTotalCount;
            int loc = i%imageTotalCount;
            CGFloat iconW = (SCREENWidth - 12-44-6-24-(imageTotalCount-1)*imageMargin)/imageTotalCount;
            CGFloat iconH = iconW;
            CGFloat iconX = (imageMargin + iconW)*loc;
            CGFloat iconY = (imageMargin + iconH)*row;
            
            UIImageView *iconView = [[UIImageView alloc]init];
            iconView.tag = i;
            iconView.frame = CGRectMake(iconX, iconY, iconW, iconH);
            iconView.hidden = YES;
            [_imageContentView addSubview:iconView];
            NSLog(@"%@", NSStringFromCGRect(iconView.frame));
        }
        
        _agreeBtn = [[UIButton alloc]init];
        [_agreeBtn setTitle:@"点赞" forState:UIControlStateNormal];
        [_agreeBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [_agreeBtn setImage:[UIImage imageNamed:@"icon_likes_d"] forState:UIControlStateNormal];
        [_agreeBtn setImage:[UIImage imageNamed:@"icon_likes_s"] forState:UIControlStateSelected];
        _agreeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_agreeBtn sizeToFit];
        [_agreeBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_agreeBtn];
        [_agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.mas_equalTo(-20);
            make.top.mas_equalTo(_imageContentView.mas_bottom).offset(20);
        }];
        
        _rewardBtn = [[UIButton alloc]init];
        [_rewardBtn setTitle:@"打赏" forState:UIControlStateNormal];
        [_rewardBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        [_rewardBtn setImage:[UIImage imageNamed:@"icon_reward_d"] forState:UIControlStateNormal];
        [_rewardBtn setImage:[UIImage imageNamed:@"icon_reward_s"] forState:UIControlStateSelected];
        _rewardBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_rewardBtn sizeToFit];
        [self.contentView addSubview:_rewardBtn];
        [_rewardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_agreeBtn.mas_centerY);
            make.right.mas_equalTo(_agreeBtn.mas_left).offset(-20);
        }];
        [[_rewardBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.rewardBlock) {
                self.rewardBlock();
            }
        }];
        
        
    }
    return self;
}
-(void)setModel:(RRFWenBarCellModel *)cellM{
    _model = cellM ;
    
    RRFAnswerModel* answerModel = cellM.answerModels.firstObject ;
    _isPraise = answerModel.isPraise;
    RRFQuestionModel *questModel = cellM.questionModel;
    if (questModel != nil) {
        [_askQuestionsBtn sd_setImageWithURL:[NSURL URLWithString:questModel.questionUserIconUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"common_head_default-diagram"]];
        _askQuestionsNameLabel.text = cellM.questionModel.questionUserName;
        NSString *askQuestionsTextStr = cellM.questionModel.questionContent;
        NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGRect askRect = [askQuestionsTextStr boundingRectWithSize:CGSizeMake(SCREENWidth-156, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attr context:nil];
        CGFloat maxAskHeight = CGRectGetHeight(askRect);
        CGFloat askHeight = maxAskHeight + 40;
        [_askQuestionsTextBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(askHeight);
        }];
        [_askQuestionsTextBtn setTitle:cellM.questionModel.questionContent forState:UIControlStateNormal];
    }
    
    if (answerModel != nil) {
        _fullTextBtn.hidden = NO;
        _agreeBtn.hidden = NO;
        _rewardBtn.hidden = NO;
        _timeLabel.text = answerModel.answerTime;
        [_answerBtn sd_setImageWithURL:[NSURL URLWithString:answerModel.answerUserIconUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"common_head_default-diagram"]];
        _answerNameLabel.text = answerModel.answerUserName;
        _answerTextLabel.text = answerModel.answerContent;
        NSString *answerStr = answerModel.answerContent;
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        CGRect answerRect = [answerStr boundingRectWithSize:CGSizeMake(SCREENWidth-116, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
        CGFloat answerHeight = CGRectGetHeight(answerRect);
        _fullTextBtn.hidden  = answerHeight > maxContentStrHeight ?  NO :  YES;
        
        
        [_agreeBtn setTitle:[NSString stringWithFormat:@" %ld",(long)answerModel.praiseAmount] forState:UIControlStateNormal];
        _agreeBtn.selected = [answerModel.isPraise isEqualToString:@"alreadyPraise"]?YES:NO;
        _rewardBtn.selected = [answerModel.isPresentDiamonds isEqualToString:@"aleradyPesent"]?YES:NO;
        
        NSInteger answerImagesCount = answerModel.answerImages.count;
        if (answerImagesCount > 0) {
            for (UIImageView *imageVC in _imageContentView.subviews) {
                if (imageVC.tag<answerImagesCount) {
                    [imageVC sd_setImageWithURL:[NSURL URLWithString:answerModel.answerImages[imageVC.tag]]];
                    imageVC.hidden = NO;
                } else {
                    imageVC.hidden = YES;
                }
            }
            int row = (answerImagesCount-1)/imageTotalCount;
            CGFloat iconH = (SCREENWidth - 12-44-6-24-(imageTotalCount-1)*imageMargin)/imageTotalCount;
            CGFloat imageHeight = (iconH + imageMargin) * row + iconH ;
            CGFloat topimageMargin = answerHeight > maxContentStrHeight  ? 30 : 8;
            [_imageContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(imageHeight);
                make.top.mas_equalTo(_answerTextLabel.mas_bottom).offset(topimageMargin);
            }];
        }
    }else{
        _fullTextBtn.hidden = YES;
        _timeLabel.hidden = YES;
        _agreeBtn.hidden = YES;
        _rewardBtn.hidden = YES;
        [_askQuestionsTextBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-12);
        }];
    }
    
    
}
-(void)agreeBtnClick:(UIButton*)sender
{
    RRFAnswerModel* answerModel = _model.answerModels.firstObject ;
    
    if (![PZParamTool hasLogin]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"goLogin" object:nil];
        return;
    }
    NSMutableDictionary *prame = [[NSMutableDictionary alloc]init];
    [prame setObject:@(answerModel.answerId) forKey:@"answerId"];
    [PZParamTool agreedToWithUrl:@"addAnswerPraise" param:prame Success:^(id json) {
        [MBProgressHUD dismiss];
        CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        k.values = @[@(0.1),@(1.0),@(1.5)];
        k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
        k.calculationMode = kCAAnimationLinear;
        [sender.imageView.layer addAnimation:k forKey:@"SHOW"];
        
        if ([_isPraise isEqualToString:@"alreadyPraise"]) {
            _isPraise = @"aise";
            NSString *str = [NSString stringWithFormat:@" %ld",(long)answerModel.praiseAmount];
            [_agreeBtn setTitle:str forState:UIControlStateNormal];
            _agreeBtn.selected = [_isPraise isEqualToString:@"alreadyPraise"]?YES:NO;
        }else{
            _isPraise = @"alreadyPraise";
            NSString *str = [NSString stringWithFormat:@" %ld",answerModel.praiseAmount + 1];
            [_agreeBtn setTitle:str forState:UIControlStateNormal];
            _agreeBtn.selected = [_isPraise isEqualToString:@"alreadyPraise"]?YES:NO;
        }
    } failBlock:^(id json) {
        
    }];
    
    
}
@end
