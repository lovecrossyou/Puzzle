//
//  JNQAwardListViewController.m
//  Puzzle
//
//  Created by HuHuiPay on 16/9/9.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQAwardListViewController.h"
#import "RRFDetailInfoController.h"
#import "JNQProductDetailViewController.h"

#import "JNQAwardModel.h"
#import "JNQAwardListCell.h"
#import "JNQHttpTool.h"

#import <UMSocialSnsPlatformManager.h>
#import "WXApi.h"
#import "JNQInviteAwardView.h"
#import "HBShareTool.h"
#import "HBVerticalBtn.h"
#import "HomeTool.h"
#import "HMScanner.h"
@interface JNQAwardListViewController () {
    NSMutableArray *_dataArray;
    UIView *_headerView;
    UILabel *_headAttenL;
}
@property(nonatomic,weak)JNQShareView *shareView;
@property(nonatomic,weak)UIButton *cencelBtn;
@property(nonatomic,strong)NSString *QRcodeUrl;
@end

@implementation JNQAwardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString* content = @"亲，我送你100喜腾币，免费参加股市猜涨跌游戏，祝你好运！";
    [HomeTool inviteWithContent:content successBlock:^(id json) {
        NSString *fullUrlStr = [NSString stringWithFormat:@"%@%@",Base_url,json[@"url"]];
        self.QRcodeUrl =  fullUrlStr;
    } fail:^(id json) {
        
    }];
    self.tableView.backgroundColor = HBColor(245, 245, 245);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dataArray = [NSMutableArray array];
    [self buildUI];
    [self loadDesData];
    [self loadData];
    [self setNavItem];
}

- (void)buildUI {
    UIImageView *backImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64)];
    [backImgView setImage:[UIImage imageNamed:@"ranking_lg"]];
    self.tableView.backgroundView = backImgView;
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 100)];
    _headerView.backgroundColor = [UIColor clearColor];
    
    _headAttenL = [[UILabel alloc] init];
    [_headerView addSubview:_headAttenL];
    [_headAttenL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_headerView).offset(15);
        make.width.mas_equalTo(SCREENWidth-24);
        make.centerX.mas_equalTo(_headerView);
    }];
    _headAttenL.font = PZFont(13);
    _headAttenL.textColor = [UIColor whiteColor];
    _headAttenL.numberOfLines = 0;
    
    
    UILabel *label = [[UILabel alloc] init];
    [_headerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_headerView).offset(12);
        make.top.mas_equalTo(_headAttenL.mas_bottom).mas_offset(3);
        make.height.mas_equalTo(15);
    }];
    label.font = PZFont(12.5);
    label.textColor = BasicRedColor;
    label.text = DeclarationInfo;
}

- (void)refreshTableView {
    if (_dataArray.count) {
        [self loadDesData];
    } else {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64)];
        headerView.backgroundColor = [UIColor clearColor];
        
        UILabel *atten = [[UILabel alloc] init];
        [headerView addSubview:atten];
        [atten mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(headerView.mas_centerX);
            make.centerY.mas_equalTo(headerView.mas_centerY).offset(-70);
            make.height.mas_equalTo(20);
        }];
        atten.font = PZFont(15);
        atten.textColor = BasicGoldColor;
        atten.textAlignment = NSTextAlignmentCenter;
        atten.text = @"获奖名单即将揭晓";
        
        UILabel *des = [[UILabel alloc] init];
        [headerView addSubview:des];
        [des mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(atten.mas_bottom);
            make.centerX.mas_equalTo(atten);
            make.height.mas_equalTo(18);
        }];
        des.font = PZFont(13);
        des.textColor = [UIColor whiteColor];
        des.textAlignment = NSTextAlignmentCenter;
        des.text = @"你还有机会，赶快去投注吧！";
        [self.tableView setTableHeaderView:headerView];
    }
}

- (void)loadDesData {
    [JNQHttpTool JNQHttpRequestWithURL:@"award/desc"  requestType:@"post" showSVProgressHUD:NO parameters:@{} successBlock:^(id json) {
        NSString *attenStr = json[@"awardDesc"];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:PZFont(13), NSParagraphStyleAttributeName:paragraphStyle};
        CGRect rect = [attenStr boundingRectWithSize:CGSizeMake(SCREENWidth-24, 80)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:attributes
                                             context:nil];
        _headAttenL.text = attenStr;
        _headerView.frame = CGRectMake(0, 0, SCREENWidth, rect.size.height+40);
        _headerView.backgroundColor = [UIColor clearColor];
        NSMutableAttributedString *attenString = [[NSMutableAttributedString alloc] initWithString:attenStr];
        [attenString addAttribute:NSForegroundColorAttributeName value:BasicGoldColor range:NSMakeRange(0, 5)];
        _headAttenL.attributedText = attenString;
        [self.tableView setTableHeaderView:_headerView];
    } failureBlock:^(id json) {
        
    }];
}

- (void)loadData {
    NSString *urlStr;
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    if (_rankType <=3 || _rankType == 7) {
        urlStr = @"award/records";
        NSInteger rankType = _rankType == 7 ? 3 : _rankType;
        [param setObject:@(rankType) forKey:@"rankType"];
    } else {
        urlStr = @"award/list";
        [param setObject:@(_rankType-3) forKey:@"awardType"];
    }
    [JNQHttpTool JNQHttpRequestWithURL:urlStr requestType:@"post" showSVProgressHUD:NO parameters:param successBlock:^(id json) {
        NSArray *data = [NSArray array];
        if (_rankType <=3 || _rankType == 7) {
            data = json[@"content"];
        } else {
            data = json[@"awards"];
        }
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in data) {
            JNQAwardModel *model = [JNQAwardModel yy_modelWithJSON:dict];
            [array addObject:model];
        }
        _dataArray = array;
        [self refreshTableView];
        [self.tableView reloadData];
    } failureBlock:^(id json) {
        
    }];
}
-(void)setNavItem
{
    UIButton *right = [[UIButton alloc]init];
    right.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [right setImage:[UIImage imageNamed:@"home_btn_share"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    right.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = item;

}
#pragma mark - 分享
-(void)share:(UIButton*)sender
{
    WEAKSELF
    if (![WXApi isWXAppInstalled]) {
        [MBProgressHUD showInfoWithStatus:@"您没有安装微信应用"];
        return ;
    }
    UIButton *cencelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight)];
    self.cencelBtn = cencelBtn ;
    [self.view.window addSubview:cencelBtn];
    cencelBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    JNQShareView *shareView = [[JNQShareView alloc] init];
    shareView.atten.text = @"分享朋友,发喜腾红包";
    self.shareView = shareView;
    [self.view.window addSubview:shareView];
    shareView.frame = CGRectMake(0, SCREENHeight, SCREENWidth, 140);
    [UIView animateWithDuration:0.15 animations:^{
        weakSelf.shareView.frame = CGRectMake(0, SCREENHeight-140, SCREENWidth, 140);
    }];
    
    shareView.shareBlock = ^(HBVerticalBtn *shareBtn) {
        [MBProgressHUD show];
        [weakSelf requestQRCodeUrlCompeleteBlock:^(UIImage* qrImage) {
            UIImage* QRImage = [self getTableViewimage] ;
            
            CGSize reSize = QRImage.size;
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(reSize.width, reSize.height+12+80+12), NO, 0.0);
            [QRImage drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
            [qrImage drawInRect:CGRectMake(12, reSize.height+12, 76, 76)];
            
            // 文字 1
            NSString* infoString = @"长按二维码识别 获取100喜腾币";
            CGRect infoRect = CGRectMake(12+76+12, QRImage.size.height+12+6+20, 220, 24);
            [infoString drawInRect:infoRect withAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0f]}];
            
            // logo alerthead_icon
            UIImage* appLogo = [UIImage imageNamed:@"alerthead_icon"];
            CGRect logoRect = CGRectMake(12+76+12, QRImage.size.height+12+24+12+16, 16, 16);
            [appLogo drawInRect:logoRect];
            
            // 文字2
            NSString* info = @"由 喜腾 发送 via www.xiteng.com";
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:info];
            [attributedStr addAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"F75000"],NSFontAttributeName:PZFont(12.0f)} range:NSMakeRange(0, info.length)];
            [attributedStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"F75000"],NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0f]} range:NSMakeRange(2, 2)];
            //F75000
            infoRect = CGRectMake(12+76+12 + 16+6, QRImage.size.height+12+24+12+16, 220, 24);
            [attributedStr drawInRect:infoRect];
            UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            NSArray* platForms = @[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ];
            NSString* platForm = platForms[shareBtn.tag];
            
            [[HBShareTool sharedInstance] shareImage:reSizeImage imageUrl:self.QRcodeUrl platForm:platForm];
            [weakSelf hiddenShareView:weakSelf.cencelBtn];
            [MBProgressHUD dismiss];
        }];
    };
    
    [[shareView.quitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self hiddenShareView:cencelBtn];
    }];
    [[cencelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self hiddenShareView:cencelBtn];
    }];
    

}

#pragma mark - 获取分享二维码
-(void)requestQRCodeUrlCompeleteBlock:(ItemClickParamBlock)complete{
    NSString* content = @"亲，我送你100喜腾币，免费参加股市猜涨跌游戏，祝你好运！";
    [HomeTool inviteWithContent:content successBlock:^(id json) {
        NSString *fullUrlStr = [NSString stringWithFormat:@"%@%@",Base_url,json[@"url"]];
        self.QRcodeUrl =  fullUrlStr;
        [HMScanner qrImageWithString:fullUrlStr avatar:nil completion:^(UIImage *image) {
            complete(image);
        }];
    } fail:^(id json) {
        
    }];
}

-(UIImage *)getTableViewimage{
    UIImage* viewImage = nil;
    UITableView *scrollView = self.tableView;
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, scrollView.opaque, 0.0);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        viewImage = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    return viewImage;
}


- (void)hiddenShareView:(UIButton *)button {
    [UIView animateWithDuration:0.2 animations:^{
    } completion:^(BOOL finished) {
        [_shareView removeFromSuperview];
        [button removeFromSuperview];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_rankType <=3 || _rankType == 7) {
        return 275;
    } else {
        return 235;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF
    JNQAwardListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JNQAwardListCell"];
    if (!cell) {
        cell = [[JNQAwardListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JNQAwardListCell"];
    }
    JNQAwardModel *awardModel = _dataArray[indexPath.row];
    cell.awardModel = awardModel;
    cell.rankType = _rankType;
    if (_rankType <=3 || _rankType == 7) {//获奖名单
        cell.btnBlock = ^() {
            if (!awardModel.userId) {
                return;
            }
            RRFDetailInfoController *desc = [[RRFDetailInfoController alloc]init];
            desc.title = @"详细资料";
            desc.userId = awardModel.userId;
            desc.verityInfo = NO;
            desc.detailInfoComeInType =  RRFDetailInfoComeInTypeOther;
            [weakSelf.navigationController pushViewController:desc animated:YES];
        };
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_rankType <=3 || _rankType == 7) {
    } else {
        JNQAwardModel *awardModel = _dataArray[indexPath.row];
        JNQProductDetailViewController *detailVC = [[JNQProductDetailViewController alloc] init];
        detailVC.productId = awardModel.awardId;
        detailVC.viewType = ProductDetailViewTypeAward;
        detailVC.navigationItem.title = @"奖品详情";
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

@end
