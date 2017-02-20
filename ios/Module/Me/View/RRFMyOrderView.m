//
//  RRFMyOrderView.m
//  Puzzle
//
//  Created by huipay on 2016/12/14.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFMyOrderView.h"
@interface RRFMyOrderButton ()
@property(nonatomic,weak)UIButton *numBtn;
@end
@implementation RRFMyOrderButton
-(instancetype)initWithTitle:(NSString *)title iconStr:(NSString *)iconStr{
    if (self = [super init]) {
       
        
        
        UIImageView *iconView = [[UIImageView alloc]init];
        iconView.userInteractionEnabled = NO;
        iconView.image = [UIImage imageNamed:iconStr];
        iconView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:iconView];
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(4);
            make.right.left.mas_equalTo(0);
            make.height.mas_equalTo(20);
        }];
        
        UIButton *numBtn = [[UIButton alloc]init];
        numBtn.hidden = YES;
        numBtn.userInteractionEnabled = NO;
        [numBtn setBackgroundColor:[UIColor redColor]];
        [numBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        numBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        numBtn.layer.masksToBounds = YES;
        numBtn.layer.cornerRadius = 9;
        self.numBtn = numBtn;
        [self addSubview:numBtn];
        [numBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(iconView.mas_right).offset(-50);
            make.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.userInteractionEnabled = NO;
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(iconView.mas_bottom).offset(4);
        }];
    }
    return self;
}
-(void)hiddenNumBtn:(BOOL)hidden
{
    self.numBtn.hidden = YES;
}
-(void)setNumber:(int)number
{
    if (number == 0) {
        self.numBtn.hidden = YES;
    }else{
        self.numBtn.hidden = NO;
        [self.numBtn setTitle:[NSString stringWithFormat:@"%d",number] forState:UIControlStateNormal];
    }
}
@end

@interface RRFGiftOrderView ()
@property(nonatomic,weak)RRFMyOrderButton *btn1;
@property(nonatomic,weak)RRFMyOrderButton *btn2;
@property(nonatomic,weak)RRFMyOrderButton *btn3;

@end
@implementation RRFGiftOrderView
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        UIButton *titleBtn = [[UIButton alloc]init];
        [titleBtn setTitle:@" 礼品订单" forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor colorWithHexString:@"4964ef"] forState:UIControlStateNormal];
        [titleBtn setImage:[UIImage imageNamed:@"me_indent-gift"] forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:titleBtn];
        [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(12);
        }];
        
        
        UIImageView *arrowIcon = [[UIImageView alloc]init];
        arrowIcon.image = [UIImage imageNamed:@"arrow-right"];
        [self addSubview:arrowIcon];
        [arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.size.mas_equalTo(CGSizeMake(8, 12));
            make.centerY.mas_equalTo(titleBtn.mas_centerY);
        }];
        
        UIButton *allOrderBtn = [[UIButton alloc]init];
        allOrderBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [allOrderBtn setTitle:@"查看全部" forState:UIControlStateNormal];
        [allOrderBtn setTitleColor:[UIColor colorWithHexString:@"aaaaaa"] forState:UIControlStateNormal];
        allOrderBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:allOrderBtn];
        [allOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(arrowIcon.mas_left).offset(-8);
            make.centerY.mas_equalTo(titleBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(100, 40));
        }];
        [[allOrderBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.giftOrderBlock) {
                self.giftOrderBlock(@(10));
            }
        }];
        
        UIView *sepView = [[UIView alloc]init];
        sepView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [self addSubview:sepView];
        [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(titleBtn.mas_bottom).offset(12);
            make.height.mas_equalTo(1);
        }];
        
        
        RRFMyOrderButton *btn1 = [[RRFMyOrderButton alloc]initWithTitle:@"待发货" iconStr:@"me_indent-gift_daifahuo"];
        self.btn1 = btn1;
        [self addSubview:btn1];
        [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth/3, 80));
            make.top.mas_equalTo(sepView.mas_bottom).offset(12);
        }];
        [[btn1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.giftOrderBlock) {
                self.giftOrderBlock(@(0));
            }
        }];
        
        RRFMyOrderButton *btn2 = [[RRFMyOrderButton alloc]initWithTitle:@"待收货" iconStr:@"me_indent-gift_daishouhuo"];
        self.btn2 = btn2;
        [self addSubview:btn2];
        [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(btn1.mas_right);
            make.top.mas_equalTo(sepView.mas_bottom).offset(12);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth/3, 80));
        }];
        [[btn2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.giftOrderBlock) {
                self.giftOrderBlock(@(1));
            }
        }];
        
        RRFMyOrderButton *btn3 = [[RRFMyOrderButton alloc]initWithTitle:@"待晒单" iconStr:@"me_indent-gift_dapingjia"];
        self.btn3 = btn3;
        [self addSubview:btn3];
        [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(btn2.mas_right);
            make.top.mas_equalTo(sepView.mas_bottom).offset(12);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth/3, 80));
            make.right.mas_equalTo(0);
        }];
        [[btn3 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.giftOrderBlock) {
                self.giftOrderBlock(@(2));
            }
        }];
        
        UIView *sep = [[UIView alloc]init];
        sep.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [self addSubview:sep];
        [sep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(12);
        }];
    
    }
    return self;
}
-(void)setPresentWaitEvaluateCount:(int)presentWaitEvaluateCount presentWaitReceiveCount:(int)presentWaitReceiveCount presentWaitSendCount:(int)presentWaitSendCount
{
    [self.btn1 setNumber:presentWaitSendCount];
    [self.btn2 setNumber:presentWaitReceiveCount];
    [self.btn3 setNumber:presentWaitEvaluateCount];

}
@end

@interface RRFBidOrderView ()
@property(nonatomic,weak) RRFMyOrderButton *btn1;
@property(nonatomic,weak) RRFMyOrderButton *btn2;
@property(nonatomic,weak) RRFMyOrderButton *btn3;

@end
@implementation RRFBidOrderView
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];

        UIButton *titleBtn = [[UIButton alloc]init];
        [titleBtn setTitle:@" 夺宝订单" forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor colorWithHexString:@"4964ef"] forState:UIControlStateNormal];
        [titleBtn setImage:[UIImage imageNamed:@"me_indent-duobao"] forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:titleBtn];
        [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(12);
        }];
        
        UIImageView *arrowIcon = [[UIImageView alloc]init];
        arrowIcon.image = [UIImage imageNamed:@"arrow-right"];
        [self addSubview:arrowIcon];
        [arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.size.mas_equalTo(CGSizeMake(8, 12));
            make.centerY.mas_equalTo(titleBtn.mas_centerY);
        }];
        
        UIButton *allOrderBtn = [[UIButton alloc]init];
        allOrderBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [allOrderBtn setTitle:@"查看全部" forState:UIControlStateNormal];
        [allOrderBtn setTitleColor:[UIColor colorWithHexString:@"aaaaaa"] forState:UIControlStateNormal];
        allOrderBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:allOrderBtn];
        [allOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(arrowIcon.mas_left).offset(-8);
            make.centerY.mas_equalTo(titleBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(100, 40));
        }];
        [[allOrderBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.bidOrderBlock) {
                self.bidOrderBlock(@(10));
            }
        }];
        
        UIView *sepView = [[UIView alloc]init];
        sepView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [self addSubview:sepView];
        [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(titleBtn.mas_bottom).offset(12);
            make.height.mas_equalTo(1);
        }];
        
        
        RRFMyOrderButton *btn1 = [[RRFMyOrderButton alloc]initWithTitle:@"待揭晓" iconStr:@"me_indent-duobao_jinixngzhong"];
        self.btn1 = btn1;
        [self addSubview:btn1];
        [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(sepView.mas_bottom).offset(12);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth/3, 80));
        }];
        [[btn1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.bidOrderBlock) {
                self.bidOrderBlock(@(1));
            }
        }];
        
        RRFMyOrderButton *btn2 = [[RRFMyOrderButton alloc]initWithTitle:@"待领奖" iconStr:@"me_indent-duobao_yijiexiao"];
        self.btn2 = btn2;
        [self addSubview:btn2];
        [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(btn1.mas_right);
            make.top.mas_equalTo(sepView.mas_bottom).offset(12);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth/3, 80));
        }];
        [[btn2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.bidOrderBlock) {
                self.bidOrderBlock(@(2));
            }
        }];
        
        RRFMyOrderButton *btn3 = [[RRFMyOrderButton alloc]initWithTitle:@"待晒单" iconStr:@"me_indent-duobao_daishaidan"];
        self.btn3 = btn3;
        [self addSubview:btn3];
        [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(btn2.mas_right);
            make.top.mas_equalTo(sepView.mas_bottom).offset(12);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth/3, 80));
            make.right.mas_equalTo(0);
        }];
        [[btn3 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.bidOrderBlock) {
                self.bidOrderBlock(@(3));
            }
        }];
    }
    return self;
}
-(void)setBidOrderWaitAcceptCount:(int)bidOrderWaitAcceptCount bidOrderWaitEvaluateCount:(int)bidOrderWaitEvaluateCount bidOrderWaitLotteryCount:(int)bidOrderWaitLotteryCount;
{
    [self.btn1 setNumber:bidOrderWaitLotteryCount];
    [self.btn2 setNumber:bidOrderWaitAcceptCount];
    [self.btn3 setNumber:bidOrderWaitEvaluateCount];

}
@end

@interface RRFWinningOrderView ()
@property(nonatomic,weak) RRFMyOrderButton *btn1;
@property(nonatomic,weak) RRFMyOrderButton *btn2;
@property(nonatomic,weak) RRFMyOrderButton *btn3;

@end
@implementation RRFWinningOrderView
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIButton *titleBtn = [[UIButton alloc]init];
        [titleBtn setTitle:@" 中奖订单" forState:UIControlStateNormal];
        [titleBtn setTitleColor:[UIColor colorWithHexString:@"4964ef"] forState:UIControlStateNormal];
        [titleBtn setImage:[UIImage imageNamed:@"zhongjiangorder"] forState:UIControlStateNormal];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:titleBtn];
        [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(12);
        }];
        
        UIImageView *arrowIcon = [[UIImageView alloc]init];
        arrowIcon.image = [UIImage imageNamed:@"arrow-right"];
        [self addSubview:arrowIcon];
        [arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-12);
            make.size.mas_equalTo(CGSizeMake(8, 12));
            make.centerY.mas_equalTo(titleBtn.mas_centerY);
        }];
        
        UIButton *allOrderBtn = [[UIButton alloc]init];
        allOrderBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [allOrderBtn setTitle:@"查看全部" forState:UIControlStateNormal];
        [allOrderBtn setTitleColor:[UIColor colorWithHexString:@"aaaaaa"] forState:UIControlStateNormal];
        allOrderBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:allOrderBtn];
        [allOrderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(arrowIcon.mas_left).offset(-8);
            make.centerY.mas_equalTo(titleBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(100, 40));
        }];
        [[allOrderBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.winningOrderBlock) {
                self.winningOrderBlock(@(10));
            }
        }];
        
        UIView *sepView = [[UIView alloc]init];
        sepView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        [self addSubview:sepView];
        [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(titleBtn.mas_bottom).offset(12);
            make.height.mas_equalTo(1);
        }];
        
        
        RRFMyOrderButton *btn1 = [[RRFMyOrderButton alloc]initWithTitle:@"待领奖" iconStr:@"me_indent-duobao_jinixngzhong"];
        self.btn1 = btn1;
        [self addSubview:btn1];
        [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(sepView.mas_bottom).offset(12);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth/3, 80));
        }];
        [[btn1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.winningOrderBlock) {
                self.winningOrderBlock(@(1));
            }
        }];
        
        RRFMyOrderButton *btn2 = [[RRFMyOrderButton alloc]initWithTitle:@"待收货" iconStr:@"me_indent-duobao_yijiexiao"];
        self.btn2 = btn2;
        [self addSubview:btn2];
        [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(btn1.mas_right);
            make.top.mas_equalTo(sepView.mas_bottom).offset(12);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth/3, 80));
        }];
        [[btn2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.winningOrderBlock) {
                self.winningOrderBlock(@(2));
            }
        }];
        
        RRFMyOrderButton *btn3 = [[RRFMyOrderButton alloc]initWithTitle:@"待晒单" iconStr:@"me_indent-duobao_daishaidan"];
        self.btn3 = btn3;
        [self addSubview:btn3];
        [btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(btn2.mas_right);
            make.top.mas_equalTo(sepView.mas_bottom).offset(12);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth/3, 80));
            make.right.mas_equalTo(0);
        }];
        [[btn3 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.winningOrderBlock) {
                self.winningOrderBlock(@(3));
            }
        }];
    }
    return self;
}
-(void)setWiningOrderWaitAcceptCount:(int)winingOrderWaitAcceptCount WiningOrderWaitEvaluateCount:(int)winingOrderWaitSendCount WiningOrderWaitLotteryCount:(int)winingOrderWaitEvaluateCount
{
    [self.btn1 setNumber:winingOrderWaitAcceptCount];
    [self.btn2 setNumber:winingOrderWaitSendCount];
    [self.btn3 setNumber:winingOrderWaitEvaluateCount];
    
}
@end
@interface RRFMyOrderView ()

@end
@implementation RRFMyOrderView
-(instancetype)init
{
    if (self = [super init]) {
        RRFGiftOrderView *giftOrder = [[RRFGiftOrderView alloc]init];
        self.giftOrder = giftOrder;
        [self addSubview:giftOrder];
        [giftOrder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(120);
        }];
        
        RRFBidOrderView *bidOrder = [[RRFBidOrderView alloc]init];
        self.bidOrder = bidOrder;
        [self addSubview:bidOrder];
        [bidOrder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(120);
            make.top.mas_equalTo(giftOrder.mas_bottom).offset(12);
        }];
        
        RRFWinningOrderView *WinningOrder = [[RRFWinningOrderView alloc]init];
        self.WinningOrder = WinningOrder;
        [self addSubview:WinningOrder];
        [WinningOrder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(120);
            make.top.mas_equalTo(bidOrder.mas_bottom).offset(12);
        }];
    }
    return self;
}
@end
