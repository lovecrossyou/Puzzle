//
//  RRFResplyToResplyCell.m
//  Puzzle
//
//  Created by huibei on 16/9/21.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFResplyToResplyCell.h"
#import "RRFRespToRespListModel.h"
@interface RRFResplyToResplyCell()
@property(nonatomic,weak)UILabel* numLabel;
@property(nonatomic,weak)UILabel* nameLabel;
@property(nonatomic,weak)UILabel* detailLabel;

@end
@implementation RRFResplyToResplyCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

        self.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        UILabel* numLabel = [[UILabel alloc]init];
        numLabel.backgroundColor = [UIColor lightGrayColor];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.font = [UIFont systemFontOfSize:13];
        self.numLabel = numLabel;
        [self.contentView addSubview:numLabel];
        [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(12);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
        
        UILabel* nameLabel = [[UILabel alloc]init];
        nameLabel.backgroundColor = [UIColor redColor];
        nameLabel.textColor = [UIColor colorWithHexString:@"999999"];
        nameLabel.font = [UIFont systemFontOfSize:13];
        [nameLabel sizeToFit];
        self.nameLabel = nameLabel;
        [self.contentView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(numLabel.mas_right).offset(8);
            make.centerY.mas_equalTo(numLabel.mas_centerY);
        }];
        
        UILabel* detailLabel = [[UILabel alloc]init];
        detailLabel.backgroundColor = [UIColor yellowColor];
        detailLabel.textColor = [UIColor colorWithHexString:@"999999"];
        detailLabel.font = [UIFont systemFontOfSize:13];
        detailLabel.numberOfLines = 0;
        [detailLabel sizeToFit];
        self.detailLabel = detailLabel;
        [self.contentView addSubview:detailLabel];
        [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(numLabel.mas_bottom).offset(6);
            make.left.mas_equalTo(numLabel.mas_right).offset(8);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-12);
        }];

    }
    return self;
}
-(void)setListM:(RRFRespToRespListModel *)listM
{
    self.numLabel.text = listM.noStr;
    self.nameLabel.text = listM.respTorespUserName;
    self.detailLabel.text = listM.respTorespContent;
}
@end
