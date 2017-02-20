//
//  JChatRedPaperCell.m
//  Puzzle
//
//  Created by huibei on 17/1/13.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "JChatRedPaperCell.h"
#import "JCHATChatModel.h"
#import "UIButton+WebCache.h"
@interface JChatRedPaperCell(){
    UIImage* maskImage ;
    UIButton* bgView ;
    UIButton* avatarIcon ;
    UILabel* botLabel;
    UILabel* tipsLabel;
    UILabel* descLabel;
    //    UIControl* botView;
}

@property(weak,nonatomic) id<RedPaperDelegate> delegate ;
@property(strong,nonatomic)JCHATChatModel* model ;
@end

@implementation JChatRedPaperCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        bgView = [[UIButton alloc]init];
        [self.contentView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(SCREENWidth*0.6);
            make.bottom.mas_equalTo(-20);
            make.top.mas_equalTo(10);
        }];
        
        descLabel = [[UILabel alloc]init];
        descLabel.textColor = [UIColor whiteColor];
        descLabel.font = PZFont(14);
        descLabel.text = @"恭喜发财，财源滚滚！" ;
        descLabel.backgroundColor = [UIColor clearColor];
        [descLabel sizeToFit];
        [bgView addSubview:descLabel];
        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(40+12);
            make.width.mas_equalTo(SCREENWidth*0.6-60);
            make.top.mas_equalTo(10+4);
        }];
        
        //tipsLabel
        tipsLabel = [[UILabel alloc]init];
        tipsLabel.textColor = [UIColor whiteColor];
        tipsLabel.font = PZFont(11);
        tipsLabel.text = @"领取红包" ;
        tipsLabel.backgroundColor = [UIColor clearColor];
        [tipsLabel sizeToFit];
        [bgView addSubview:tipsLabel];
        [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(descLabel.mas_left);
            make.top.mas_equalTo(descLabel.mas_bottom).offset(4);
            make.right.mas_equalTo(-4);
        }];
        
        botLabel = [[UILabel alloc]init];
        botLabel.textColor = [UIColor lightGrayColor];
        botLabel.font = PZFont(11);
        botLabel.backgroundColor = [UIColor clearColor];
        botLabel.text = @"喜腾红包" ;
        [bgView addSubview:botLabel];
        [botLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(6);
            make.bottom.mas_equalTo(-4);
        }];
        
        avatarIcon = [UIButton new];
        avatarIcon.layer.masksToBounds = YES ;
        avatarIcon.layer.cornerRadius = 4 ;
        [self.contentView addSubview:avatarIcon];
        [avatarIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(44, 44));
            make.top.mas_equalTo(6);
        }];
        
        WEAKSELF
        [[bgView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [weakSelf.delegate didClickRedPaper:weakSelf.model];
        }];
        
        [[avatarIcon rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [weakSelf.delegate clickAvatar:weakSelf.model];
        }];
    }
    return self;
}

-(void)setCellData:(JCHATChatModel *)model delegate:(id<RedPaperDelegate>)delegate{
    self.delegate = delegate ;
    self.model = model ;
    
    JMSGMessage* message = model.message ;
    JMSGCustomContent* contentM = (JMSGCustomContent*)message.content ;
    NSDictionary* d = contentM.customDictionary ;
    NSString* desInfo = d[@"desInfo"];
    if (desInfo == nil) {
        descLabel.text = @"恭喜发财，财源滚滚！" ;
    }
    else{
        descLabel.text = desInfo ;
    }
    BOOL isRecive = [model.message isReceived];
    [model.message.fromUser thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
        [avatarIcon setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
    }];
    if (isRecive) { //notice_bg otherChatBg
        [bgView setBackgroundImage:[UIImage imageNamed:@"chat_red-paket_left"] forState:UIControlStateNormal];
        [bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(44 + 12+6);
        }];
        [avatarIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(6);
        }];
        [botLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(6+4);
        }];
        
        //恭喜发财
        [descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(40+12+4);
        }];
        //领取红包
        
    } else {
        //mychat_bg
        [bgView setBackgroundImage:[UIImage imageNamed:@"chat_red-paket_right"] forState:UIControlStateNormal];
        [bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-44 - 12-6);
        }];
        [avatarIcon mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-6);
        }];
    }
    
}

-(void)layoutAllView{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
