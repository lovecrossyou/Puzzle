//
//  RRFBettingRecordController.m
//  Puzzle
//
//  Created by huibei on 16/8/24.
//  Copyright © 2016年 HuiBei. All rights reserved.
//  投注记录

#import "RRFBettingRecordController.h"
#import "RRFMeTool.h"
#import "MJRefresh.h"
#import "JNQFriendCircleModel.h"
#import "RRFBettingStatisticalModel.h"
#import "RRFRecordView.h"
#import "RRFBettingCell.h"
#import "RRFExceptionalListController.h"
#import "JNQFailFooterView.h"
#import "HBLoadingView.h"
#import "WXApi.h"
#import "JNQInviteAwardView.h"
#import "HMScanner.h"
#import <UMSocialSnsPlatformManager.h>
#import "HBShareTool.h"
#import "HBVerticalBtn.h"
#import "HomeTool.h"
@interface RRFBettingRecordController ()<UITableViewDelegate,UITableViewDataSource>
{
    int _pageNo;
    NSMutableArray *_allData;
}
@property(nonatomic,strong)JNQFailFooterView *failFootView;
@property(nonatomic,weak)UIButton *cencelBtn;
@property(nonatomic,weak)JNQShareView *shareView;
@property(nonatomic,strong)NSString *QRcodeUrl;

@property(assign,nonatomic) BOOL editModel ;

@property(strong,nonatomic)NSMutableDictionary* selectedCells ;
@end

@implementation RRFBettingRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF
    self.tableView.dataSource = self ;
    self.tableView.delegate = self ;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _pageNo = 0;
    if (_allData == nil) {
        _allData = [[NSMutableArray alloc]init];
    }
    if (self.failFootView == nil) {
        self.failFootView = [[JNQFailFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64)];
        self.failFootView.reloadBlock = ^(){
            [weakSelf getGuessWithStockStatistics];
        };
    }
    
    [self getGuessWithStockStatistics];
    if (self.showCancel) {
        UIBarButtonItem* cancelItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelController)];
        self.navigationItem.rightBarButtonItem = cancelItem ;
    }
    [self setNavItem];
}

-(NSMutableDictionary *)selectedCells{
    if (_selectedCells == nil) {
        _selectedCells = [NSMutableDictionary dictionary];
    }
    return _selectedCells ;
}

-(void)cancelController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)getGuessWithStockStatistics
{
    [RRFMeTool getGuessWithStockStatisticSuccess:^(id json) {
        if (json != nil) {
            RRFBettingStatisticalModel *model = [RRFBettingStatisticalModel yy_modelWithJSON:json];
            [self settingUIViewWithModel:model];
        }
        [MBProgressHUD dismiss];
    } failBlock:^(id json) {
        [self.tableView setTableFooterView:self.failFootView];
    }];
}
-(void)requestRecordList:(UIView *)sender
{
    WEAKSELF
    if ([sender isKindOfClass:[MJRefreshHeader class]]) {
        _pageNo = 0;
    }
    
    [RRFMeTool requestRewoardListWithPageNo:_pageNo direction:@"DESC" Success:^(id json) {
        BOOL last = [[json objectForKey:@"last"] boolValue];
        NSArray *listArray = [json objectForKey:@"content"];
        NSMutableArray *temp = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in listArray) {
            JNQFriendCircleModel *model = [JNQFriendCircleModel yy_modelWithJSON:dic];
            [temp addObject:model];
        }
        if (_pageNo == 0) {
            _allData = temp;
        }else{
            [_allData addObjectsFromArray:temp];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (_allData.count == 0) {
            [weakSelf settingNoDataView];
        }else{
            [weakSelf.tableView setTableFooterView:[UIView new]];
        }
        [weakSelf.tableView reloadData];
        if (last) {
            [weakSelf.tableView.mj_footer setHidden:YES];
        }else{
            [weakSelf.tableView.mj_footer setHidden:NO];
        }
        _pageNo ++;
    } failBlock:^(id json) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.tableView.mj_footer.hidden = YES;
        [weakSelf.tableView setTableFooterView:weakSelf.failFootView];
    }];
}
- (void)settingUIViewWithModel:(RRFBettingStatisticalModel *)model {
   
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[RRFBettingCell class] forCellReuseIdentifier:@"RRFBettingRecordController"];
    
    MJRefreshNormalHeader *tabheader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestRecordList:)];
    tabheader.lastUpdatedTimeLabel.hidden = YES;
    tabheader.stateLabel.textColor = HBColor(135, 135, 135);
    tabheader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.tableView.mj_header = tabheader;
    
    MJRefreshAutoNormalFooter *tabfooter = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestRecordList:)];
    tabfooter.triggerAutomaticallyRefreshPercent = 1;
    tabfooter.automaticallyRefresh = YES;
    tabfooter.stateLabel.textColor = HBColor(135, 135, 135);
    self.tableView.mj_footer = tabfooter;
    
    RRFRecordView *headerView = [[RRFRecordView alloc]initWithModel:model];
    headerView.frame = CGRectMake(0, 0, SCREENWidth, 220);
    self.tableView.tableHeaderView = headerView;
    [self.tableView.mj_footer beginRefreshing];

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allData.count;
}

// 这个回调决定了在当前indexPath的Cell是否可以编辑。
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES ;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JNQFriendCircleModel *model = _allData[indexPath.row];
    RRFBettingCell *cell = [[RRFBettingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RRFBettingRecordController"];
    cell.model = model;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
    return headView;
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 6;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.editModel) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else{
        RRFBettingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self updateSelectedCells:indexPath cell:cell];
        [cell setEditing:YES animated:YES];
    }
}

-(void)updateSelectedCells:(NSIndexPath*)indexPath cell:(RRFBettingCell*)cell{
    NSArray* allKeys = [self.selectedCells allKeys];
    BOOL existCell = NO ;
    for (NSNumber* row in allKeys) {
        NSInteger index = [row integerValue];
        if (index == indexPath.row) {
            [self.selectedCells removeObjectForKey:row];
            existCell = YES ;
            break ;
        }
    }
    if (!existCell) {
        [self.selectedCells setObject:cell forKey:@(indexPath.row)];
    }
}

-(void)settingNoDataView
{
    NSString *titleStr = @"您还没有投注过，赶快去尝试一下吧!";
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64-220)];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 50, SCREENWidth-30, 40)];
    titleLabel.text = titleStr;
    titleLabel.numberOfLines=2;
    titleLabel.textColor = [UIColor colorWithHexString:@"999999"];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:titleLabel];
    self.tableView.tableFooterView = footerView;
}

-(void)setNavItem
{
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back_btn"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem ;
    
    
    
    UIButton *right = [[UIButton alloc]init];
    right.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [right setImage:[UIImage imageNamed:@"home_btn_share"] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(changeToShareModel) forControlEvents:UIControlEventTouchUpInside];
    right.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = item;
    
}

-(void)goBack{
    if (self.showCancel) {
        [self cancelController];
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)switchEditMode{
    if (!self.editModel) {
        //进入编辑模式
        self.editModel = YES ;
        [self.tableView setEditing:YES animated:YES];
        UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(switchEditMode)];
        self.navigationItem.leftBarButtonItem = leftItem ;
        
        UIBarButtonItem* rightItem = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(share:)];
        self.navigationItem.rightBarButtonItem = rightItem ;
    }
    else{
        //取消编辑模式
        self.editModel = NO ;
        [self.tableView setEditing:NO animated:YES];
        UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_back_btn"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
        self.navigationItem.leftBarButtonItem = leftItem ;
        
        UIButton *right = [[UIButton alloc]init];
        right.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [right setImage:[UIImage imageNamed:@"home_btn_share"] forState:UIControlStateNormal];
        [right addTarget:self action:@selector(changeToShareModel) forControlEvents:UIControlEventTouchUpInside];
        right.frame = CGRectMake(0, 0, 44, 44);
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:right];
        self.navigationItem.rightBarButtonItem = item;
    }
}

-(void)changeToShareModel{
    [self switchEditMode];
}


#pragma mark - 分享
-(void)share:(UIBarButtonItem*)sender
{
    [self switchEditMode];
    NSArray* selectedCells = [self.selectedCells allValues];
    if (selectedCells.count == 0 && !self.editModel){
        [MBProgressHUD showInfoWithStatus:@"请选择要分享的记录！"];
//        return;
    };
    WEAKSELF
    if (![WXApi isWXAppInstalled]) {
        [MBProgressHUD showInfoWithStatus:@"您没有安装微信应用"];
//        return ;
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
            [MBProgressHUD dismiss];
            [weakSelf.tableView setEditing:NO animated:YES];
            NSArray* platForms = @[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToQQ];
            NSString* platForm = platForms[shareBtn.tag];
            NSArray* cells = [weakSelf.selectedCells allValues];
            UIImage* allSecImage = [weakSelf makeImageWithView:weakSelf.tableView.tableHeaderView] ;
            NSInteger index = 0 ;
            for (RRFBettingCell* cell in cells) {
                cell.editing = NO ;
                UIImage* sectionImage = [weakSelf makeImageWithView:cell] ;
                allSecImage = [weakSelf drawCanvasFromExistImage:allSecImage currntImage:sectionImage];
                index++ ;
            }
            UIImage* fullImage = allSecImage ;
            CGSize reSize = fullImage.size ;
            
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(reSize.width, reSize.height+12+80+12), NO, 0.0);
            [fullImage drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
            [qrImage drawInRect:CGRectMake(12, reSize.height+12, 76, 76)];
//            文字 1
            NSString* infoString = @"长按二维码识别 获取100喜腾币";
            CGRect infoRect = CGRectMake(12+76+12, reSize.height+12+6+20, 220, 24);
            [infoString drawInRect:infoRect withAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:14.0f]}];

            
//            logo alerthead_icon
            UIImage* appLogo = [UIImage imageNamed:@"alerthead_icon"];
            CGRect logoRect = CGRectMake(12+76+12, reSize.height+12+24+12+16, 16, 16);
            [appLogo drawInRect:logoRect];
            
//            文字2
            NSString* info = @"由 喜腾 发送 via www.xiteng.com";
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:info];
            [attributedStr addAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"F75000"],NSFontAttributeName:PZFont(12.0f)} range:NSMakeRange(0, info.length)];
            [attributedStr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"F75000"],NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0f]} range:NSMakeRange(2, 2)];
            //F75000
            infoRect = CGRectMake(12+76+12 + 16+6, reSize.height+12+24+12+16, 220, 24);
            [attributedStr drawInRect:infoRect];
            UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [[HBShareTool sharedInstance] shareImage:reSizeImage imageUrl:self.QRcodeUrl platForm:platForm];
            [weakSelf hiddenShareView:weakSelf.cencelBtn];
            [weakSelf.tableView setEditing:NO animated:YES];
            [weakSelf.selectedCells removeAllObjects];
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
-(UIImage*)drawCanvasFromExistImage:(UIImage*)existImage currntImage:(UIImage*)currentImg{
    CGFloat currntImageHeight = currentImg.size.height ;
    if (existImage == nil) {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(SCREENWidth, currntImageHeight + 12), NO, 0.0);
        [currentImg drawInRect:CGRectMake(0, 0, SCREENWidth, currntImageHeight)];
    }
    else{
        CGFloat existImageHeight = existImage.size.height ;
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(SCREENWidth,existImageHeight+ currntImageHeight), NO, 0.0);
        [existImage drawInRect:CGRectMake(0, 0, SCREENWidth, existImageHeight)];
        [currentImg drawInRect:CGRectMake(0, existImageHeight, SCREENWidth, currntImageHeight)];
    }
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalImage ;
}


- (UIImage *)makeImageWithView:(UIView *)view
{
    CGSize s = view.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数。
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (void)hiddenShareView:(UIButton *)button {
    WEAKSELF
    [UIView animateWithDuration:0.2 animations:^{
    } completion:^(BOOL finished) {
        [weakSelf.shareView removeFromSuperview];
        [button removeFromSuperview];
    }];
}

@end
