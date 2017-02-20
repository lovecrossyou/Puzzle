//
//  JNQPresentStoreCell.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQPresentStoreCell.h"
#import "UIImageView+WebCache.h"

@interface JNQPresentStoreCell () {
    UIImageView *_comImg;
    UILabel *_comName;
    UIButton *_comPrice;
}

@end

@implementation JNQPresentStoreCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = HBColor(245, 245, 245);
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(-0.5, 0, SCREENWidth+1, 215)];
        [self.contentView addSubview:backView];
        backView.backgroundColor = [UIColor whiteColor];
        backView.layer.borderWidth = 0.5;
        backView.layer.borderColor = HBColor(231, 231, 231).CGColor;
        
        
        _comImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 170)];
        [backView addSubview:_comImg];
        
//        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_comImg.frame), SCREENWidth, 0.5)];
//        [backView addSubview:line];
//        line.backgroundColor = HBColor(231, 231, 231);
        
        _comName = [[UILabel alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(_comImg.frame), SCREENWidth/2-12, 45)];
        [backView addSubview:_comName];
        _comName.textColor = HBColor(51, 51, 51);
        _comName.font = PZFont(16);
        
        _comPrice = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWidth/2, CGRectGetMaxY(_comImg.frame), SCREENWidth/2-12, 45)];
        [backView addSubview:_comPrice];
        [_comPrice setTitleColor:BasicRedColor forState:UIControlStateNormal];
        [_comPrice setImage:[UIImage imageNamed:@"icon_big"] forState:UIControlStateNormal];
        _comPrice.titleLabel.font = PZFont(14);
        _comPrice.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return self;
}

- (void)setPresentModel:(JNQPresentModel *)presentModel {
    _presentModel = presentModel;
    [_comImg sd_setImageWithURL:[NSURL URLWithString:presentModel.picUrl] placeholderImage:[UIImage imageNamed:@""]];
    _comName.text = presentModel.productName;
    [_comPrice setTitle:[NSString stringWithFormat:@" %ld", presentModel.price/100] forState:UIControlStateNormal];
}

- (void)setAwardModel:(JNQAwardModel *)awardModel {
    _awardModel = awardModel;
    _comName.textColor = HBColor(51, 51, 51);
    _comName.text = [NSString stringWithFormat:@"%@：%@", imgArr[awardModel.rank-1], awardModel.name];
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:_comName.text];
    [nameString addAttribute:NSForegroundColorAttributeName value:BasicRedColor range:NSMakeRange(0, 4)];
    _comName.attributedText = nameString;
}

@end
