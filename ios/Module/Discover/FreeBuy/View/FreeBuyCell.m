//
//  FreeBuyCell.m
//  Puzzle
//
//  Created by huibei on 16/12/9.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "FreeBuyCell.h"
#import "UIImageView+WebCache.h"
#import "FBProductListModel.h"
@interface FreeBuyCell()
{
    UIImageView* logoView ;
    UILabel* productTitle ;
    UILabel* progressStr ;
    UILabel* totalStr ;
    UILabel* remainStr ;
    UIProgressView* progressView ;
}
@end

@implementation FreeBuyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        WEAKSELF
        logoView = [[UIImageView alloc]init];
        logoView.contentMode = UIViewContentModeScaleAspectFit ;
        [self.contentView addSubview:logoView];
        [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(210);
        }];
        
        UIView* botView = [[UIView alloc]init];
        [self.contentView addSubview:botView];
        [botView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(logoView.mas_bottom);
            make.height.mas_equalTo(110);
            make.bottom.mas_equalTo(0);
        }];
        
        productTitle = [UILabel new];
        productTitle.font = PZFont(15.0f);
        productTitle.textColor = [UIColor colorWithHexString:@"333333"];
        [botView addSubview:productTitle];
        [productTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.left.mas_equalTo(12);
            make.height.mas_equalTo(24);
            make.top.mas_equalTo(0);
        }];
        
        progressStr = [UILabel new];
        progressStr.font = PZFont(12.0f);
        progressStr.textColor = [UIColor colorWithHexString:@"777777"];
        [botView addSubview:progressStr];
        [progressStr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.left.mas_equalTo(12);
            make.height.mas_equalTo(24);
            make.top.mas_equalTo(productTitle.mas_bottom);
        }];
        
        progressView = [[UIProgressView alloc]init];
        progressView.progressTintColor = [UIColor colorWithHexString:@"f23030"];
        progressView.trackTintColor = [UIColor colorWithHexString:@"efedee"];
        [botView addSubview:progressView];
        [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12-70-20);
            make.left.mas_equalTo(12);
            make.height.mas_equalTo(5);
            make.top.mas_equalTo(progressStr.mas_bottom).offset(6);
        }];
        
        totalStr = [UILabel new];
        totalStr.font = PZFont(12.0f);
        totalStr.textAlignment  = NSTextAlignmentLeft;
        [totalStr sizeToFit];
        totalStr.textColor = [UIColor colorWithHexString:@"666666"];
        [botView addSubview:totalStr];
        [totalStr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.height.mas_equalTo(28);
            make.width.mas_equalTo(120);
            make.top.mas_equalTo(progressView.mas_bottom).offset(6);
        }];
        
        remainStr = [[UILabel alloc]init];
        remainStr.textAlignment  = NSTextAlignmentRight;
        remainStr.font = PZFont(12.0f);
        remainStr.textColor = [UIColor colorWithHexString:@"666666"];
        [remainStr sizeToFit];
        [botView addSubview:remainStr];
        [remainStr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12-70-12);
            make.height.mas_equalTo(28);
            make.width.mas_equalTo(120);
            make.centerY.mas_equalTo(totalStr.mas_centerY);
        }];
        
    
        UIButton* joinNow = [UIButton new];
        joinNow.layer.borderColor = [UIColor colorWithHexString:@"f23030"].CGColor;
        joinNow.layer.borderWidth = 1 ;
        joinNow.layer.cornerRadius = 4 ;
        joinNow.titleLabel.font = PZFont(13.0f);
        [joinNow setTitleColor:[UIColor colorWithHexString:@"f23030"] forState:UIControlStateNormal];
        [joinNow setTitle:@"立即参与" forState:UIControlStateNormal];
        [botView addSubview:joinNow];
        [joinNow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-9-10-9);
            make.right.mas_equalTo(-15);
            make.width.mas_equalTo(69);
            make.height.mas_equalTo(27);
        }];
        [[joinNow rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (weakSelf.clickBlock) {
                weakSelf.clickBlock();
            }
        }];
        
        UIView* botLine = [[UIView alloc]init];
        botLine.backgroundColor = [UIColor colorWithHexString:@"efedee"];
        [self addSubview:botLine];
        [botLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(10);
        }];
    }
    return self ;
}

-(void)configModel:(FBProductModel*)model{
    [logoView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"prize_default-diagram"]];
    productTitle.text = model.productName ;
    
    NSMutableAttributedString *progressString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"揭晓进度 %@",model.rateOfProgress]];
    [progressString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"666666"] range:NSMakeRange(0, 5)];
    
    [progressString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5,progressString.length - 5)];
    progressStr.attributedText = progressString;


    totalStr.text = [NSString stringWithFormat:@"总需: %ld份",(long)model.targetPurchaseCount];
    progressView.progress = 1 - model.restPurchaseCount/model.targetPurchaseCount ;
    
    NSMutableAttributedString *remainString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"剩余: %ld份",(long)model.restPurchaseCount]];
    [remainString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"666666"] range:NSMakeRange(0, remainString.length)];
    [remainString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4,remainString.length - 5)];
    remainStr.attributedText = remainString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
