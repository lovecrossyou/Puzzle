//
//  RRFBillListCell.m
//  Puzzle
//
//  Created by huibei on 16/8/24.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFBillListCell.h"
#import "RRFBillCellModel.h"
@interface RRFBillListCell()
{
    UILabel *_dateLabel;
    UILabel *_timeLabel;
    UILabel *_totalLabel;
    UILabel *_projectLabel;
    
}
@end
@implementation RRFBillListCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);

        _dateLabel = [[UILabel alloc]init];
        _dateLabel.text = @"今天";
        _dateLabel.textColor = [UIColor colorWithHexString:@"999999"];
        _dateLabel.font = [UIFont systemFontOfSize:14];
        [_dateLabel sizeToFit];
        [self.contentView addSubview:_dateLabel];
        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(12);
        }];
        
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.text = @"09:34";
        _timeLabel.textColor = [UIColor colorWithHexString:@"999999"];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        [_timeLabel sizeToFit];
        [self.contentView addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(_dateLabel.mas_bottom).offset(4);
        }];
        
        _totalLabel = [[UILabel alloc]init];
        _totalLabel.text = @"+2300XT币";
        _totalLabel.textColor = [UIColor redColor];
        _totalLabel.font = [UIFont systemFontOfSize:16];
        [_totalLabel sizeToFit];
        [self.contentView addSubview:_totalLabel];
        [_totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.right.mas_equalTo(-12);
        }];
        
        _projectLabel = [[UILabel alloc]init];
        _projectLabel.text = @"买钻石";
        _projectLabel.textColor = [UIColor colorWithHexString:@"999999"];
        _projectLabel.font = [UIFont systemFontOfSize:13];
        [_projectLabel sizeToFit];
        [self.contentView addSubview:_projectLabel];
        [_projectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(_totalLabel.mas_bottom).offset(4);
        }];
    }
    return self;
}
-(void)setModel:(RRFBillCellModel *)model
{
    _model = model;
    _dateLabel.text = model.date;
    _timeLabel.text = model.time;
    _projectLabel.text = model.descriptionStr;
    NSString *currencyTypeStr = [model.currencyType isEqualToString:@"xtb"]?@"喜腾币":@"钻石";
    NSMutableAttributedString *totalStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",model.amount,currencyTypeStr]];
    [totalStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:NSMakeRange(totalStr.length-currencyTypeStr.length, currencyTypeStr.length)];
    _totalLabel.attributedText = totalStr;
    if([model.amount hasPrefix:@"-"]){
        _totalLabel.textColor = StockGreen;
    }else{
        _totalLabel.textColor = StockRed;
    }
    
    
    
}
@end
