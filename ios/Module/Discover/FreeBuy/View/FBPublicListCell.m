//
//  FBPublicListCell.m
//  Puzzle
//
//  Created by huibei on 16/12/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "FBPublicListCell.h"
#import "UIImageView+WebCache.h"
#import "FBPublicListModel.h"
#import "PZDateUtil.h"
@interface FBPublicListCell ()
@property (nonatomic, weak) UILabel     *m_timeLabel;
@property (nonatomic, weak)   id           m_data;
@property (nonatomic, weak)   NSIndexPath *m_tmpIndexPath;
@property (nonatomic,weak)  UIButton *underWay;
@property (nonatomic, weak) UIImageView* logo;
@property (nonatomic, weak) UILabel* titleLabel;
@property (nonatomic, weak) UILabel* noLabel;
@property (nonatomic, weak) UILabel* totalLabel;
@property (nonatomic, weak) UILabel* prizeWinnerLabel;
@property (nonatomic, weak) UILabel* totalParticipationLabel;
@property (nonatomic, weak) UILabel* luckNumLabel;
@property (nonatomic, weak) UILabel* timeLabel;
@property(nonatomic,weak)UIImageView* timeIcon;
@end

@implementation FBPublicListCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        UIImageView* logo = [[UIImageView alloc]init];
        logo.contentMode = UIViewContentModeScaleAspectFit ;
        self.logo = logo;
        [self.contentView addSubview:logo];
        [logo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(130, 130));
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
        }];
        
        UIButton *underWay = [[UIButton alloc]init];
        [underWay setImage:[UIImage imageNamed:@"jiexiao_lable_zhengzajiexiao"] forState:UIControlStateNormal];
        [underWay setImage:[UIImage imageNamed:@"jiexiao_lable_zhengzaikaijiang"] forState:UIControlStateSelected];
        self.underWay = underWay;
        [self addSubview:underWay];
        [underWay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(65, 65));
        }];
        
        UILabel* titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"银鹭花生牛奶350ml*15瓶整箱";
        titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        titleLabel.font = PZFont(15.0f);
        //titleLabel.numberOfLines = 2 ;
        [titleLabel sizeToFit];
        self.titleLabel = titleLabel;
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(logo.mas_top).offset(10);
            make.left.mas_equalTo(logo.mas_right).offset(14);
            make.right.mas_equalTo(-12);
        }];
        
        //no
        UILabel* noLabel = [[UILabel alloc]init];
        noLabel.text = @"期数：2016909090";
        noLabel.textColor = [UIColor colorWithHexString:@"666666"];
        noLabel.font = PZFont(14.0f);
        [noLabel sizeToFit];
        self.noLabel = noLabel;
        [self.contentView addSubview:noLabel];
        [noLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleLabel.mas_bottom).offset(6);
            make.left.mas_equalTo(logo.mas_right).offset(14);
        }];
        
        //no
        UILabel* totalLabel = [[UILabel alloc]init];
        totalLabel.text = @"总需：200份";
        totalLabel.textColor = [UIColor colorWithHexString:@"666666"];
        totalLabel.font = PZFont(14.0f);
        [totalLabel sizeToFit];
        self.totalLabel = totalLabel;
        [self.contentView addSubview:totalLabel];
        [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(noLabel.mas_bottom).offset(5);
            make.left.mas_equalTo(logo.mas_right).offset(14);
        }];
        
      
        UIImageView* timeIcon = [[UIImageView alloc]init];
        timeIcon.image = [UIImage imageNamed:@"jiexiao_icon_countdown"];
        timeIcon.contentMode = UIViewContentModeScaleAspectFit ;
        [self.contentView addSubview:timeIcon];
        self.timeIcon = timeIcon ;
        [timeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(logo.mas_right).offset(14);
            make.top.mas_equalTo(totalLabel.mas_bottom).offset(10);
            make.height.mas_equalTo(25);
        }];
        
        UILabel* timeCount = [[UILabel alloc]init];
        timeCount.textColor = [UIColor colorWithHexString:@"f23030"] ;
        timeCount.font = PZFont(20);
        [timeCount sizeToFit];
        [self.contentView addSubview:timeCount];
        [timeCount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(totalLabel.mas_bottom).offset(10);
            make.left.mas_equalTo(timeIcon.mas_right).offset(6);
            make.height.mas_equalTo(25);
        }];
        self.m_timeLabel = timeCount ;
        [self registerNSNotificationCenter];
        
        
        // 获奖用户
        UILabel* prizeWinnerLabel = [[UILabel alloc]init];
        prizeWinnerLabel.text = @"获奖用户:江湖股王";
        prizeWinnerLabel.textColor = [UIColor colorWithHexString:@"666666"];
        prizeWinnerLabel.font = PZFont(14.0f);
        [prizeWinnerLabel sizeToFit];
        self.prizeWinnerLabel = prizeWinnerLabel;
        [self.contentView addSubview:prizeWinnerLabel];
        [prizeWinnerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(noLabel.mas_bottom).offset(5);
            make.left.mas_equalTo(logo.mas_right).offset(14);
        }];
        
        //参与分数
        UILabel* totalParticipationLabel = [[UILabel alloc]init];
        totalParticipationLabel.text = @"参与份数：200份";
        totalParticipationLabel.textColor = [UIColor colorWithHexString:@"666666"];
        totalParticipationLabel.font = PZFont(14.0f);
        [totalParticipationLabel sizeToFit];
        self.totalParticipationLabel = totalParticipationLabel;
        [self.contentView addSubview:totalParticipationLabel];
        [totalParticipationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(prizeWinnerLabel.mas_bottom).offset(5);
            make.left.mas_equalTo(logo.mas_right).offset(14);
            make.right.mas_equalTo(-12);
        }];
        
    
        //幸运号码
        UILabel* luckNumLabel = [[UILabel alloc]init];
        luckNumLabel.text = @"幸运号码：8998989";
        luckNumLabel.textColor = [UIColor colorWithHexString:@"666666"];
        luckNumLabel.font = PZFont(14.0f);
        [luckNumLabel sizeToFit];
        self.luckNumLabel = luckNumLabel;
        [self.contentView addSubview:luckNumLabel];
        [luckNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(totalParticipationLabel.mas_bottom).offset(5);
            make.left.mas_equalTo(logo.mas_right).offset(14);
        }];

        //揭晓时间
        UILabel* timeLabel = [[UILabel alloc]init];
        timeLabel.text = @"揭晓时间：2016-12-19 15:30:00";
        timeLabel.textColor = [UIColor colorWithHexString:@"666666"];
        timeLabel.font = PZFont(14.0f);
        [timeLabel sizeToFit];
        self.timeLabel = timeLabel;
        [self.contentView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(luckNumLabel.mas_bottom).offset(5);
            make.left.mas_equalTo(logo.mas_right).offset(14);
        }];

        
    }
    return self ;
}

- (void)dealloc {
    
    [self removeNSNotificationCenter];
}

#pragma mark - 通知中心
- (void)registerNSNotificationCenter {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationCenterEvent:)
                                                 name:NOTIFICATION_TIME_CELL
                                               object:nil];
}

- (void)removeNSNotificationCenter {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_TIME_CELL object:nil];
}

- (void)notificationCenterEvent:(id)sender {
    
    if (self.m_isDisplayed) {
        [self loadData:self.m_data indexPath:self.m_tmpIndexPath];
    }
}

- (void)storeWeakValueWithData:(id)data indexPath:(NSIndexPath *)indexPath {
    
    self.m_data         = data;
    self.m_tmpIndexPath = indexPath;
}

- (void)loadData:(id)data indexPath:(NSIndexPath *)indexPath {
    if ([data isMemberOfClass:[FBPublicModel class]]) {
        FBPublicModel *model = (FBPublicModel*)data;
        [self.logo sd_setImageWithURL:[NSURL URLWithString:model.productUrl] placeholderImage:DefaultImage];
        [self storeWeakValueWithData:data indexPath:indexPath];
        NSString* remainStr = [PZDateUtil intervalSinceNowMillisecond:model.openResultTime];
        _m_timeLabel.text = [NSString stringWithFormat:@" %@",remainStr];
        self.titleLabel.text = model.productName;
        self.noLabel.text = [NSString stringWithFormat:@"期数:%ld",model.stage];
        self.totalLabel.text = [NSString stringWithFormat:@"总需:%ld份",model.targetCount];
        
        
        NSMutableAttributedString *prizeWinnerStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"获奖用户:%@",model.userName]];
        [prizeWinnerStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"666666"] range:NSMakeRange(0, 5)];
        [prizeWinnerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,prizeWinnerStr.length - 5)];
        self.prizeWinnerLabel.attributedText = prizeWinnerStr;
        
        
        
        self.totalParticipationLabel.text = [NSString stringWithFormat:@"参与份数:%ld",model.bidCount];
        
        NSMutableAttributedString *luckNumStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"幸运号码:%ld",model.luckCode]];
        [luckNumStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"666666"] range:NSMakeRange(0, 5)];
        [luckNumStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,luckNumStr.length - 5)];
        self.luckNumLabel.attributedText = luckNumStr;
        self.timeLabel.text = [NSString stringWithFormat:@"揭晓时间:%@",model.finishTime];
        
        if ([model.purchaseGameStatus isEqualToString:@"have_lottery"]) {
            self.luckNumLabel.font = PZFont(12.0f);
            self.timeLabel.font = PZFont(12.0f);
            self.prizeWinnerLabel.font = PZFont(12.0f);
            self.totalParticipationLabel.font = PZFont(12.0f);

            // 已经开奖
            self.underWay.hidden = YES;
            self.luckNumLabel.hidden = NO;
            self.timeLabel.hidden = NO;
            self.prizeWinnerLabel.hidden = NO;
            self.totalParticipationLabel.hidden = NO;
            self.totalLabel.hidden = YES;
            self.m_timeLabel.hidden = YES;
            self.timeIcon.hidden = YES ;
            [self.logo mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(10);
                make.bottom.mas_equalTo(-10);
            }];
            
        }else{// 正在开奖
            if ([remainStr isEqualToString:@"已结束"]) {
                self.underWay.selected = YES;
            }else{
                self.underWay.selected = NO;
            }
            self.underWay.hidden = NO;
            self.totalLabel.font = PZFont(14.0f);
            self.timeLabel.font = PZFont(20.0f);
            self.luckNumLabel.hidden = YES;
            self.timeLabel.hidden = YES;
            self.prizeWinnerLabel.hidden = YES;
            self.totalParticipationLabel.hidden = YES;
            
            self.totalLabel.hidden = NO;
            self.m_timeLabel.hidden = NO;
            self.timeIcon.hidden = NO ;

            [self.logo mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(0);
            }];
            [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(12);
            }];

        }
    }
}



@end
