//
//  RRFAboutController.m
//  Puzzle
//
//  Created by huibei on 16/10/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFAboutController.h"
#import "InsetsLabel.h"
#import "RRFPhoneListModel.h"
#import "Singleton.h"
@interface RRFAboutView:UIView
@property(nonatomic,weak)UIButton *callBtn;
@end
@implementation RRFAboutView
-(instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *logoView = [[UIImageView alloc]init];
        logoView.image = [UIImage imageNamed:@"alerthead_icon"];
        [self addSubview:logoView];
        [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(55);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.size.mas_equalTo(CGSizeMake(71, 71));
        }];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"喜腾";
        titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        titleLabel.font = [UIFont systemFontOfSize:15];
        [titleLabel sizeToFit];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(logoView.mas_bottom).offset(10);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        InsetsLabel *descriptionLabel = [[InsetsLabel alloc]initWithInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
        [descriptionLabel.layer setBorderWidth:1];
        CGColorSpaceRef colorSpaceRefss = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorss = CGColorCreate(colorSpaceRefss, (CGFloat[]){153/255.0,153/255.0,153/255.0,1});
        [descriptionLabel.layer setBorderColor:colorss];
        descriptionLabel.text = @"喜腾APP是股市竞猜和社交为一体的应用。用户以上证综指、创业板指涨跌方向为标，竞猜下一个交易日大盘的涨跌方向，赢取喜腾币兑换礼品。还可参与竞猜盈利排行榜赢取大奖、邀请朋友竞猜PK、加入股市沙龙分享投资心得。";
        descriptionLabel.textColor = [UIColor colorWithHexString:@"333333"];
        descriptionLabel.font = [UIFont systemFontOfSize:15];
        descriptionLabel.layer.masksToBounds = YES;
        descriptionLabel.layer.cornerRadius = 3;
        descriptionLabel.numberOfLines = 0;
        [descriptionLabel sizeToFit];
        [self addSubview:descriptionLabel];
        NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
        CGRect rect = [descriptionLabel.text boundingRectWithSize:CGSizeMake(SCREENWidth-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
        [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(190);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(rect.size.height+20);
        }];
        
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.text = @"copyright@2012-2016\n北京喜腾网商务有限公司";
        nameLabel.numberOfLines = 2 ;
        nameLabel.textColor = [UIColor colorWithHexString:@"999999"];
        nameLabel.font = [UIFont systemFontOfSize:12];
        [nameLabel sizeToFit];
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-16);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        RRFPhoneListModel *model = [Singleton sharedInstance].phoneListM;
        NSString *phone = model.tel;
        if (phone.length == 0) {
            phone = @"";
        }
        UIButton *callBtn = [[UIButton alloc]init];
        NSMutableAttributedString *callStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"客服电话: %@",phone]];
        [callStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"4964ef"] range:NSMakeRange(6, callStr.length - 6)];
        [callBtn setAttributedTitle:callStr forState:UIControlStateNormal];
        [callBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        callBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [callBtn sizeToFit];
        self.callBtn = callBtn;
        [self addSubview:callBtn];
        [callBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-145);
            make.height.mas_equalTo(44);
        }];
        
    }
    return self;
}

@end
@interface RRFAboutController ()
@property(nonatomic,weak)RRFAboutView *headView;
@end

@implementation RRFAboutController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    RRFAboutView *headView = [[RRFAboutView alloc]init];
    [headView.callBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
    self.headView = headView;
    headView.frame = CGRectMake(0, 0, SCREENWidth, SCREENHeight-64);
    self.tableView.tableHeaderView = headView;
}
-(void)call
{
    NSLog(@"call");
    RRFPhoneListModel *model = [Singleton sharedInstance].phoneListM;
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",model.tel];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

@end
