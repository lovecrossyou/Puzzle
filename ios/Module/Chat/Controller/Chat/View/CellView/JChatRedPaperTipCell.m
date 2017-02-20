//
//  JChatRedPaperTipCell.m
//  Puzzle
//
//  Created by huibei on 17/1/20.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "JChatRedPaperTipCell.h"
#import "JCHATChatModel.h"
#import <JMessage/JMessage.h>
@interface JChatRedPaperTipCell()
{
    UILabel* tipLabel ;
}
@end
@implementation JChatRedPaperTipCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];

        
        UIView* bgView = [[UIView alloc]init];
        bgView.backgroundColor = [UIColor lightGrayColor];
        bgView.layer.masksToBounds = YES ;
        bgView.layer.cornerRadius = 6 ;
        [self.contentView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(4);
            make.bottom.mas_equalTo(-4);
            make.width.mas_equalTo(SCREENWidth*0.45);
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
        }];
        
        UIImageView* iconView = [[UIImageView alloc]init];
        iconView.image = [UIImage imageNamed:@"chat_icon_red-paket_small"];
        [bgView addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.size.mas_equalTo(CGSizeMake(12, 15));
            make.centerY.mas_equalTo(bgView.mas_centerY);
        }];
        
        tipLabel = [[UILabel alloc]init];
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.font = PZFont(10.0f);
        [bgView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(4);
            make.right.mas_equalTo(-4);
            make.centerY.mas_equalTo(bgView.mas_centerY);
        }];

    }
    return self ;
}

-(void)setCellData:(JCHATChatModel *)model delegate:(id<RedPaperTipDelegate>)delegate{
    JMSGUser* fromUser = model.message.fromUser ;
    if (fromUser != nil) {
        tipLabel.text = [NSString stringWithFormat:@"%@领取了红包",fromUser.nickname] ;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutAllView{
    
}


@end
