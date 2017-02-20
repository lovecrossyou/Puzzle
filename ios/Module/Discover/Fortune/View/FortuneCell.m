//
//  FortuneCell.m
//  Puzzle
//
//  Created by 朱理哲 on 2016/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "FortuneCell.h"
#import "UIButton+EdgeInsets.h"


@interface FortuneCell()
{
    UIButton* leftBtn ;
    UIButton* rightBtn ;
    UILabel* dataLabel ;
}
@end

@implementation FortuneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
        leftBtn = [UIButton new];
        leftBtn.titleLabel.font = PZFont(14.0f);
        [leftBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.contentView addSubview:leftBtn];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(12);
            make.top.bottom.mas_equalTo(0);
        }];
        [leftBtn layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageLeft imageTitlespace:6 imageWidth:20];
        
        dataLabel = [[UILabel alloc]init];
        [dataLabel setTextColor:[UIColor darkGrayColor]];
        dataLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        [self.contentView addSubview:dataLabel];
        [dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.left.mas_equalTo(120-12-6);
        }];
    }
    return self ;
}

-(void)configTitle:(NSString *)title icon:(NSString *)icon data:(NSString*)data{
    [leftBtn setTitle:title forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    dataLabel.text = data ;

}
@end
