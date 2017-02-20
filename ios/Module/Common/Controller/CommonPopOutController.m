//
//  CommonPopOutController.m
//  Puzzle
//
//  Created by huipay on 2016/11/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "CommonPopOutController.h"
#import <STPopup/STPopup.h>


@interface ResultView : UIView
@property(nonatomic,copy)ItemClickBlock closeClick;
@property(nonatomic,weak)UIImageView *bgView;
@property(nonatomic,weak)UIButton *closeBtn;
@property(nonatomic,weak)UILabel *resultLabel;

@end


@implementation ResultView
-(instancetype)initWithTitle:(NSString *)title descInfo:(NSAttributedString*)descInfo{
    if (self = [super init]) {
        UIImageView *bgView = [[UIImageView alloc]init];
        self.bgView = bgView;
        bgView.image = [UIImage imageNamed:@"betsuccess_lg"];
        [self addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.mas_equalTo(0);
        }];
        
        UIButton *closeBtn = [[UIButton alloc]init];
        self.closeBtn = closeBtn;
        [closeBtn setImage:[UIImage imageNamed:@"btn_close_x"] forState:UIControlStateNormal];
        [self addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.right.top.mas_equalTo(0);
        }];
        [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.closeClick) {
                self.closeClick();
            }
        }];
        
        UILabel *resultLabel = [[UILabel alloc]init];
        self.resultLabel = resultLabel;
        resultLabel.text = title;
        resultLabel.textColor = [UIColor whiteColor];
        resultLabel.font = [UIFont boldSystemFontOfSize:20];
        [resultLabel sizeToFit];
        [self addSubview:resultLabel];
        [resultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(34-12);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        UILabel *descInfoLabel = [[UILabel alloc]init];
        descInfoLabel.textColor = [UIColor whiteColor];
        descInfoLabel.textAlignment = NSTextAlignmentCenter ;
        self.resultLabel = descInfoLabel;
        descInfoLabel.numberOfLines = 4 ;
        [descInfoLabel setAttributedText:descInfo];
        descInfoLabel.font = [UIFont boldSystemFontOfSize:16];
        [descInfoLabel sizeToFit];
        [self addSubview:descInfoLabel];
        [descInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(resultLabel.mas_bottom).offset(16);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
    }
    return self ;
}
@end

@interface CommonPopOutController ()
@property(weak,nonatomic)ResultView *customView ;
@end

@implementation CommonPopOutController


-(instancetype)init{
    if (self = [super init]) {
        self.contentSizeInPopup = CGSizeMake(SCREENWidth - 70, 160.0f);
    }
    return self ;
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)setTitle:(NSString *)title descInfo:(NSAttributedString*)descInfo{
    WEAKSELF
    ResultView *customView = [[ResultView alloc] initWithTitle:title descInfo:descInfo];
    customView.backgroundColor = [UIColor redColor];
    self.customView = customView;
    customView.frame = CGRectMake(0, 0, SCREENWidth - 70, 160.0f) ;
    [self.view addSubview:customView];
    customView.closeClick = ^(){
        if (weakSelf.popViewBlock) {
            weakSelf.popViewBlock();
        }
    };
}

@end
