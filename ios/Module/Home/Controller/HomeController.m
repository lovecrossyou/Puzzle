//
//  HomeController.m
//  Puzzle
//
//  Created by 朱理哲 on 16/7/21.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "HomeController.h"
#import "HomeHeadView.h"
#import "PZMenuView.h"
#import "InsetsLabel.h"
#import "HomeWenBarCell.h"
#import "FMViewController.h"
#import "StockGameList.h"
#import "HomeTool.h"
#import "GameModel.h"
#import "PayPasswordPanel.h"
#import "RankDetailController.h"
#import "QuestionBarListModel.h"
#import "RRFPuzzleBarTool.h"
#import "RRFPersonalAskBarController.h"
#import "RRFLoginTool.h"
#import "MJRefresh.h"
#import "HomeRankListModel.h"
#import "JNQHttpTool.h"
#import "HomeTableSectionHeader.h"
#import "HomeRankCell.h"
#import "HomeRankModel.h"
#import "JNQAwardListViewController.h"
#import "RRFActivityCanonController.h"
#import "JNQRankViewController.h"
#import "InviteFriendController.h"
#import "JNQAwardModel.h"
#import "HomeRankTableView.h"
#import "JNQPageViewController.h"
#import "ContactListController.h"
#import "CirclePopMenuController.h"
#import "CommonPopOutController.h"
#import "FriendCircleSendController.h"
#import <STPopup/STPopup.h>
#import "GuessPageController.h"
#import "FBTool.h"
#import "PurchaseGameActivity.h"
#import "PZWebController.h"
#import "FBActivityProductController.h"
#import "FreeBuyController.h"
#import "FortuneController.h"
#import "JNQPresentAwardViewController.h"
#import "RecentBetController.h"
//本周收益数据条数
#define kIncomeCount 20

@interface HomeController ()
@property(strong,nonatomic) GameModel* indexM ;
@property(strong,nonatomic) NSArray* hotQuestionBarList ;
@property(weak,nonatomic) UITableView* tableView ;
@property(assign,nonatomic) int pageNo ;
@property(weak,nonatomic)HomeHeadView* headView ;
@property(weak,nonatomic)HomeRankTableView* footerView ;
@property(strong,nonatomic)HomeTableSectionOne* sectionOneView ;

//定时器
@property(strong,nonatomic) NSTimer* timer60 ;
@property(strong,nonatomic) NSTimer* timer1 ;
@property(strong,nonatomic)StockGameList* gameList  ;

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone ;
    self.pageNo = 0 ;

    UITableView* tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
    UIView* tableClearView = [[UIView alloc]init];
    tableClearView.backgroundColor = [UIColor colorWithHexString:@"2d343e"];
    tableView.backgroundView = tableClearView ;
    tableView.backgroundColor = [UIColor clearColor];
    self.tableView = tableView ;

    [self.tableView registerClass:[HomeRankCell class] forCellReuseIdentifier:@"HomeRankCell"];

    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    WEAKSELF
    //footerView
    HomeRankTableView* footerView = [[HomeRankTableView alloc]init];
    footerView.rankBlock = ^(NSNumber* rankType){
        int rank = [rankType intValue] + 3;
        [weakSelf goRankList:rank];
    };
    footerView.prizeBlock = ^(){
        JNQAwardListViewController* awardController = [[JNQAwardListViewController alloc]init];
        awardController.title = @"年度奖品" ;
        awardController.rankType = RankTypeCurrentYear ;
        [weakSelf.navigationController pushViewController:awardController animated:YES];
    };
    footerView.frame = CGRectMake(0, 0, SCREENWidth, (44 +12) + 40*3 + 130 + 20);
    tableView.tableFooterView = footerView ;
    self.footerView = footerView ;
    
    MJRefreshNormalHeader* refreshHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadAllData)];
    refreshHeader.stateLabel.textColor = HBColor(243, 243, 243);
    refreshHeader.lastUpdatedTimeLabel.textColor = HBColor(243, 243, 243);
    self.tableView.mj_header = refreshHeader ;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAllData) name:@"RELOADHOME" object:nil];
    self.timer60 = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(reloadAllData) userInfo:nil repeats:YES];
    self.timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateDate) userInfo:nil repeats:YES];
    
    //开启定时器
    [self.timer60 setFireDate:[NSDate distantPast]];
    [self.timer1 setFireDate:[NSDate distantPast]];
    [self.tableView.mj_header beginRefreshing];
    
    [self settingNavItem];
    NSString *isFirst =  [[NSUserDefaults standardUserDefaults] objectForKey:FirstInstall];
    if (!isFirst) {
        [self showTipView];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeForFirstRegister) name:@"noticeForFirstRegister" object:nil];
}


#pragma mark - 请求轮播数据
-(void)requestBannerData{
    //轮播图
    WEAKSELF
    [FBTool getPurchaseGameActivity:@"home" successBlock:^(id json) {
        PurchaseGameActivityList* listM = [PurchaseGameActivityList yy_modelWithJSON:json];
        [weakSelf.headView.banner configModel:listM.content];
    } fail:^(id json) {
        
    }];
}

-(void)goRecentBet{
    RecentBetController* betController = [[RecentBetController alloc]init];
    betController.title = @"最新投注" ;
    [self.navigationController pushViewController:betController animated:YES];
}

#pragma mark - 注册
-(void)noticeForFirstRegister{
    CommonPopOutController* popDetail = [[CommonPopOutController alloc]init];
    NSString* descString = @"你已成功注册喜腾APP\n获得喜腾币奖励 赶快去投注吧!" ;
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc]initWithString:descString];
    NSRange range = [descString rangeOfString:@"喜腾币"];
    [str addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:range];
    [popDetail setTitle:@"恭喜你！" descInfo:str];
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:popDetail];
    popupController.navigationBarHidden = YES ;
    popupController.style = STPopupStyleFormSheet;
    popupController.containerView.layer.cornerRadius = 6 ;
    [popupController presentInViewController:self];
    popDetail.popViewBlock = ^(){
        [popupController dismiss];
    };
}


-(void)showTipView{
    UIWindow* rootView = [UIApplication sharedApplication].keyWindow ;
    UIControl* maskView = [[UIControl alloc]init];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.76 ;
    maskView.frame = CGRectMake(0, 0, SCREENWidth, SCREENHeight) ;
    [rootView addSubview:maskView];
    
    UIControl* menuView = [[UIControl alloc]init];
    menuView.backgroundColor = [UIColor clearColor];
    menuView.frame = CGRectMake(12+12+18, HomeBannerHeight +100 +250, 118, 35);
    [rootView addSubview:menuView];
    
   
    UIImageView* leftTip = [[UIImageView alloc]init];
    leftTip.image = [UIImage imageNamed:@"prompt_betting_img"];
    CGRect frame = menuView.bounds ;
    leftTip.frame = frame ;
    [menuView addSubview:leftTip];

    UIImageView* topView = [[UIImageView alloc]init];
    topView.image = [UIImage imageNamed:@"prompt_betting_words"];
    CGPoint center = rootView.center ;
    center.y = HomeBannerHeight +100 + 250-60;
    topView.center = center ;
    topView.bounds  = CGRectMake(0, 0, 205, 82);
    [rootView addSubview:topView];
    
    
    //指示资产
    UIImageView* botLeftView = [[UIImageView alloc]init];
    botLeftView.image = [UIImage imageNamed:@"prompt_me_words"];
    center = rootView.center ;
    center.y = SCREENHeight - 62-20 ;
    botLeftView.center = center ;
    botLeftView.bounds  = CGRectMake(0, 0, 218, 62);
    [rootView addSubview:botLeftView];
    

    UIImageView* botRight = [[UIImageView alloc]init];
    botRight.image = [UIImage imageNamed:@"prompt_me_img"];
    botRight.frame = CGRectMake(SCREENWidth-49-20, SCREENHeight-49, 49, 48);
    [rootView addSubview:botRight];


    CABasicAnimation *jumpAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    jumpAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    jumpAnimation.toValue = [NSNumber numberWithFloat:8.0f];
    
    jumpAnimation.duration = 0.5f;//动画持续时间
    jumpAnimation.repeatCount = 2;//动画重复次数
    jumpAnimation.autoreverses = YES;//是否自动重复
    [topView.layer addAnimation:jumpAnimation forKey:@"animateLayer"];
    
    [[menuView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIView* x) {
        [x removeFromSuperview];
        [maskView removeFromSuperview];
        [botLeftView removeFromSuperview];
        [botRight removeFromSuperview];
        [topView removeFromSuperview];
        [menuView removeFromSuperview];
    }];
    
    UIButton* btnClose = [UIButton new];
    btnClose.titleLabel.font = PZFont(18.0f);
    [btnClose setTitle:@"关闭" forState:UIControlStateNormal];
    [maskView addSubview:btnClose];
    [btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(80, 80));
        make.right.mas_equalTo(-20);
    }];
    [[btnClose rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIView* x) {
        [x removeFromSuperview];
        [maskView removeFromSuperview];
        [botLeftView removeFromSuperview];
        [botRight removeFromSuperview];
        [topView removeFromSuperview];
        [menuView removeFromSuperview];
    }];
}

-(void)settingNavItem
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
    InviteFriendController* invite = [[InviteFriendController alloc]init];
    invite.title = @"邀请朋友" ;
    [self.navigationController pushViewController:invite animated:YES];
}

#pragma mark - 定时更新数据60秒
#pragma mark - 下啦刷新
-(void)reloadAllData{
    WEAKSELF
    [self requestStockDataCompleteBlock:^(id json) {
        StockGameList* gameList = [StockGameList yy_modelWithJSON:json];
        weakSelf.gameList = gameList ;
        [weakSelf createHeadWithStock:gameList];
        [weakSelf.footerView refreshUI];
    }];
}

#pragma mark - 定时更新倒计时1秒
-(void)updateDate{
    [self.headView updateDate:self.gameList];
}


-(void)requestStockDataCompleteBlock:(PZRequestSuccess)complete{
    WEAKSELF
    //    股票列表
    [HomeTool getStockGameListWithPageNo:0 pageSize:5 SuccessBlock:^(id json) {
        [MBProgressHUD dismiss];
        StockGameList* gameList = [StockGameList yy_modelWithJSON:json];
        weakSelf.gameList = gameList ;
        [weakSelf.tableView.mj_header endRefreshing];
        complete(json);
    } fail:^(id json) {
        [MBProgressHUD dismiss];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}


-(void)createHeadWithStock:(StockGameList*)stockM{
    WEAKSELF
    HomeHeadView* headView = [[HomeHeadView alloc]initWithStock:stockM incomeLimit:kIncomeCount];
    headView.betBlock = ^(GameModel* indexM){
        [weakSelf goBet:indexM];
        weakSelf.indexM = indexM ;
    };
    headView.guessUpBlock = ^(GameModel* indexM){
        GuessPageController* guessPage = [[GuessPageController alloc]init];
        guessPage.indexM = indexM ;
        guessPage.title = @"投注" ;
        guessPage.guessType =0 ;
        [weakSelf.navigationController pushViewController:guessPage animated:YES];
    };
    headView.guessDownBlock = ^(GameModel* indexM){
        GuessPageController* guessPage = [[GuessPageController alloc]init];
        guessPage.indexM = indexM ;
        guessPage.title = @"投注" ;
        guessPage.guessType = 1 ;
        [weakSelf.navigationController pushViewController:guessPage animated:YES];
    };
    headView.moreBlock = ^(){
        RankDetailController* detailList = [[RankDetailController alloc]init];
        detailList.title = @"收益排名" ;
        [weakSelf.navigationController pushViewController:detailList animated:YES];
    };
    headView.avtivityBlock = ^(){
        RRFActivityCanonController *canonController = [[RRFActivityCanonController alloc]init];
        canonController.title = @"规则" ;
        [weakSelf.navigationController pushViewController:canonController animated:YES];
    };
    //轮播点击
    headView.banner.activityClickBlock = ^(PurchaseGameActivity* model){
        if ([model.type isEqualToString:@"link"]) {
            //新闻
            PZWebController* web = [[PZWebController alloc]init];
            web.pathUrl = model.link? model.link : model.picUrl ;
            web.title = model.title ;
            [weakSelf.navigationController pushViewController:web animated:YES];
        }
        else if ([model.type isEqualToString:@"product"]){
            //商品列表
            FBActivityProductController* avtivity = [[FBActivityProductController alloc]init];
            avtivity.title = model.title ;
            [weakSelf.navigationController pushViewController:avtivity animated:YES];
        }
        else if([model.type isEqualToString:@"purchaseGame"]){
            FreeBuyController* freeBuy = [[FreeBuyController alloc]init];
            freeBuy.title = @"0元夺宝";
            [weakSelf.navigationController pushViewController:freeBuy animated:YES];
        }
        else if([model.type isEqualToString:@"presentShopMall"]){
            JNQPresentAwardViewController* freeBuy = [[JNQPresentAwardViewController alloc]init];
            freeBuy.title = @"礼品商城";
            [weakSelf.navigationController pushViewController:freeBuy animated:YES];
        }
        else if([model.type isEqualToString:@"ranking"]){
            [weakSelf goRankList:RankTypeCurrentWeek];
        }
        else if([model.type isEqualToString:@"fortune"]){
            FortuneController* freeBuy = [[FortuneController alloc]init];
            freeBuy.title = @"运程";
            [weakSelf.navigationController pushViewController:freeBuy animated:YES];
        }
    };
    //最近投注列表
    headView.recentBetClick = ^(){
        [weakSelf goRecentBet];
    };
    
    headView.frame = CGRectMake(0, 0, SCREENWidth,HomeBannerHeight + 100 +(0)+(HomeStockHeight + 12)*stockM.content.count  + 3*44 + 12);
    self.headView = headView ;
    self.tableView.tableHeaderView = headView ;
    
    //请求轮播数据
    [self requestBannerData];
}

#pragma mark - 投注界面
-(void)goBet:(GameModel* )indexM{
    FMViewController* echatController = [[FMViewController alloc]init];
    echatController.title = indexM.stockGameName ;
    echatController.indexM = indexM ;
    [self.navigationController pushViewController:echatController animated:YES];
}

#pragma mark - 股神争霸
-(void)goRankList:(int)rankType{
    JNQPageViewController *pageVC = [[JNQPageViewController alloc] init];
    pageVC.rankViewType = RankViewTypeCurrent;
    pageVC.title = @"股神争霸";
    pageVC.rankType = rankType;
    [self.navigationController pushViewController:pageVC animated:YES];
}



@end
