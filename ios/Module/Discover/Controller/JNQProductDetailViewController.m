//
//  JNQProductDetailViewController.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQProductDetailViewController.h"
#import "JNQConfirmOrderViewController.h"
#import "JNQShoppingCartViewController.h"
#import "JNQProductCommentViewController.h"

#import "JNQPresentProductModel.h"
#import "JNQProductCommentModel.h"
#import "JNQAwardDetailModel.h"

#import "JNQFailFooterView.h"
#import "JNQPresentStoreDetailView.h"
#import "JNQProductCommentCell.h"

#import "JNQHttpTool.h"
#import "PZParamTool.h"
#import "ShoppingCartTool.h"
#import "UIButton+EdgeInsets.h"

#import "AFNetworking.h"
#import "MJRefreshGifHeader.h"
#define kEndH 80

@import WebKit;

@interface JNQProductDetailViewController () <UITableViewDelegate, UITableViewDataSource,WKNavigationDelegate> {
    TPKeyboardAvoidingTableView *_detailTv;
    JNQPresentDetailHeaderView *_headerView;
    NSString *_tel;
    
    CGFloat minY;
    CGFloat maxY;
    // 是否显示底部视图，
    BOOL _isShowBottom;
    
    CGFloat mainHeight ;
}
@property (nonatomic, strong) JNQFailFooterView *failFailFooter;
@property (nonatomic, strong) JNQPresentProductModel *productModel;
@property (nonatomic, strong) JNQPresentStoreDetailBottomView *bottomView;
@property (nonatomic, strong) JNQPresentStoreDetailOperationView *operationView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) WKWebView* webView;
@property(nonatomic,strong) UIView   *contentView;
@property(nonatomic,strong) UILabel  *bottomLab;

@end

@implementation JNQProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HBColor(245, 245, 245);
    _dataArray = [NSMutableArray array];
    mainHeight = _viewType == ProductDetailViewTypeProduct ? SCREENHeight - 64 : SCREENHeight;
    [self buildUI];
    [self loadServiceTel];
    [self loadData];
}



- (void)buildUI {
    WEAKSELF
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.webView];
    
    _detailTv = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, mainHeight-50) style:UITableViewStyleGrouped];
    [self.contentView addSubview:_detailTv];
    _detailTv.backgroundColor = HBColor(245, 245, 245);
    _detailTv.estimatedRowHeight = 120.0f;
    _detailTv.rowHeight = UITableViewAutomaticDimension;
    _detailTv.delegate = self;
    _detailTv.dataSource = self;
    _detailTv.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    CGFloat headerHeight = _viewType == ProductDetailViewTypeProduct ? 135 + SCREENWidth : 75+SCREENWidth;
    _headerView = [[JNQPresentDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, headerHeight)];
    [_detailTv setTableHeaderView:_headerView];;
    _headerView.viewType = _viewType;
    
    UIButton* tableFooter = [[UIButton alloc]init];
    tableFooter.titleLabel.font = PZFont(15.0f);
    [tableFooter setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [tableFooter setTitle:@" 上拉查看图文详情" forState:UIControlStateNormal];
    [tableFooter setImage:[UIImage imageNamed:@"fanning_up"] forState:UIControlStateNormal];
    tableFooter.frame = CGRectMake(0, 0, SCREENWidth, 24);
    _detailTv.tableFooterView = tableFooter ;
    
    if (_viewType == ProductDetailViewTypeProduct) {
        _bottomView = [[JNQPresentStoreDetailBottomView alloc] init];
        [self.view addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.mas_equalTo(self.view).offset(0.5);
            make.size.mas_equalTo(CGSizeMake(SCREENWidth+1, 50));
        }];
        _bottomView.layer.borderColor = HBColor(231, 231, 231).CGColor;
        _bottomView.layer.borderWidth = 0.5;
        
        _operationView = [[JNQPresentStoreDetailOperationView alloc] initWithFrame:CGRectMake(0, SCREENHeight-64, SCREENWidth, 150)];
        [self.view addSubview:_operationView];
        
        [self eventControl];
    }
    _failFailFooter = [[JNQFailFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64)];
    [self.view addSubview:_failFailFooter];
    _failFailFooter.hidden = YES;
    _failFailFooter.reloadBlock = ^() {
        [weakSelf loadData];
        [weakSelf loadServiceTel];
        NSString *pathUrl = [NSString stringWithFormat:@"%@xitenggame/singleWrap/productDetail.html?productId=%ld",Base_url, weakSelf.productId];
        [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:pathUrl]]];
    };
}

- (void)eventControl {
    WEAKSELF
    [[_bottomView.payBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        BOOL hasLogin = [PZParamTool hasLogin];
        if (!hasLogin) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"goLogin" object:nil];
            return;
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.operationView.frame = CGRectMake(0, SCREENHeight-64-150, SCREENWidth, 150);
        }];
    }];
    [[_bottomView.seviceBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        UIApplication *app =[UIApplication sharedApplication];
        NSString *fullString = [NSString stringWithFormat:@"telprompt://%@",_tel];
        NSURL *url = [NSURL URLWithString:fullString];
        if ([app canOpenURL:url]) {
            [app openURL:url];
        }
    }];
    [[_bottomView.shoppingCartBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        JNQShoppingCartViewController *shoppingCartVC = [[JNQShoppingCartViewController alloc] init];
        shoppingCartVC.navigationItem.title = @"购物车";
        [self.navigationController pushViewController:shoppingCartVC animated:YES];
    }];
    [[_bottomView.addShopCart rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (self.productModel == nil) {
            [MBProgressHUD showInfoWithStatus:@"未获取到商品信息！"];
            return ;
        }
        [ShoppingCartTool addOrUpdatePoduct:[self.productModel mutableCopy]];
        [[NSNotificationCenter defaultCenter] postNotificationName:ShoppingCartReloadNotificate object:nil];
        [MBProgressHUD showInfoWithStatus:@"加入购物车成功！"];
        NSInteger count = [ShoppingCartTool queryShoppingCarCount];
        [weakSelf.bottomView setProductCount:count];
        
    }];
    
    [[_operationView.confirmBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        BOOL hasLogin = [PZParamTool hasLogin];
        if (!hasLogin) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"goLogin" object:nil];
            return;
        }
        JNQConfirmOrderViewController *conOrderVC = [[JNQConfirmOrderViewController alloc] init];
        NSArray *array = [NSArray arrayWithObject:@[_productModel]];
        conOrderVC.dataArray = [NSMutableArray arrayWithArray:array];
        conOrderVC.navigationItem.title = @"确认订单";
        [self.navigationController pushViewController:conOrderVC animated:YES];
    }];
    [[_operationView.quitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [UIView animateWithDuration:0.3 animations:^{
            self.operationView.frame = CGRectMake(0, SCREENHeight-64, SCREENWidth, 150);
        }];
    }];
    _operationView.countBlock = ^(NSInteger count) {
        weakSelf.productModel.count = count;
    };
}


#pragma mark - getter/setter
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.frame = CGRectMake(0, 0, SCREENWidth, 2*mainHeight);
    }
    return _contentView;
}


- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc]init];
        _webView.scrollView.delegate = self;
        _webView.backgroundColor = [UIColor colorWithHexString:@"2e2e2e"] ;
        _webView.frame = CGRectMake(0, SCREENHeight, SCREENWidth, mainHeight-50);
        _webView.navigationDelegate = self;
        NSString *url = _viewType == ProductDetailViewTypeProduct ? @"xitenggame/singleWrap/productDetail.html?productId=" : @"xitenggame/singleWrap/awardDetail.html?awardId=";
        NSString *pathUrl = [NSString stringWithFormat:@"%@%@%ld",Base_url, url, _productId];
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:pathUrl]]];
        
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        header.lastUpdatedTimeLabel.hidden = YES ;
        [header setTitle:@"下拉回到商品详情" forState:MJRefreshStateIdle];
        [header setTitle:@"释放回到商品详情" forState:MJRefreshStatePulling];
        [header setTitle:@"正在进入商品详情" forState:MJRefreshStateRefreshing];
        _webView.scrollView.mj_header = header;
    }
    return _webView;
}

-(void)loadNewData {
    [_webView.scrollView.mj_header endRefreshing];
    [UIView animateWithDuration:0.6 animations:^{
        CGRect frame = _contentView.frame;
        frame.origin.y = 0;
        _contentView.frame = frame;
    }];
}


- (void)loadData {
    NSString *url = _viewType == ProductDetailViewTypeProduct ? @"product/detail" : @"award/detail";
    NSString *paramId = _viewType == ProductDetailViewTypeProduct ? @"productId" : @"awardId";
    [JNQHttpTool JNQHttpRequestWithURL:url requestType:@"post" showSVProgressHUD:YES parameters:@{paramId : @(_productId)} successBlock:^(id json) {
        _failFailFooter.hidden = YES;
        if (_viewType == ProductDetailViewTypeProduct) {
            _productModel = [JNQPresentProductModel yy_modelWithJSON:json[@"productInfo"]];
            _productModel.selected = 1;
            _productModel.count = 1;
            _productModel.pictures = [json[@"productInfo"] objectForKey:@"pictures"];
            _headerView.productModel = _productModel;
            _bottomView.payBtn.userInteractionEnabled = YES;
            _bottomView.addShopCart.userInteractionEnabled = YES;
        } else {
            JNQAwardDetailModel *model = [JNQAwardDetailModel yy_modelWithJSON:json];
            _headerView.awardModel = model;
        }
        NSArray *data = json[@"commentInfo"];
        for (NSDictionary *dict in data) {
            JNQProductCommentModel *model = [JNQProductCommentModel yy_modelWithJSON:dict];
            [_dataArray addObject:model];
        }
        [_detailTv reloadData];
    } failureBlock:^(id json) {
        _failFailFooter.hidden = NO;
    }];
}

- (void)loadServiceTel {
    [JNQHttpTool JNQHttpRequestWithURL:@"service/tel" requestType:@"post" showSVProgressHUD:NO parameters:@{} successBlock:^(id json) {
        _tel = json[@"tel"];
    } failureBlock:^(id json) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat secHeight = 45 ;
    return secHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat secHeight = 45 ;
    if (IPHONE4||IPHONE5) {
        secHeight += 54 ;
    }
    JNQPresentDetailSectionHeaderView *header = [[JNQPresentDetailSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, secHeight)];
    header.commentCount = _dataArray.count;
    header.buttonBlock = ^() {
        JNQProductCommentViewController *productCommentVC = [[JNQProductCommentViewController alloc] init];
        productCommentVC.navigationItem.title = @"所有评论";
        productCommentVC.productId = _productId;
        [self.navigationController pushViewController:productCommentVC animated:YES];
    };
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JNQProductCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JNQProductCommentCell"];
    if (!cell) {
        cell = [[JNQProductCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JNQProductCommentCell"];
    }
    JNQProductCommentModel *model = [_dataArray objectAtIndex:indexPath.row];
    cell.commentModel = model;
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSInteger count = [ShoppingCartTool queryShoppingCarCount];
    [self.bottomView setProductCount:count];
}



#pragma makr - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _detailTv) {
        CGFloat delHeight = _detailTv.contentOffset.y - _detailTv.contentSize.height +SCREENHeight ;
        if (delHeight > 150 && scrollView.isDragging == NO) {
            [UIView animateWithDuration:0.8 animations:^{
                CGRect frame = self.contentView.frame;
                frame.origin.y = -SCREENHeight;
                _contentView.frame = frame;
            }];
        }
        
    }
}


@end
