//
//  JNQPayViewContoller.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQPayViewContoller.h"
#import "RRFMeController.h"
#import "GuessPageController.h"
#import "RRFBuyFortuneController.h"
#import "JNQDiamondViewController.h"
#import "JNQVIPUpdateViewController.h"
#import "JNQPresentAwardViewController.h"
#import "JNQShoppingCartViewController.h"

#import "PZCommonCellModel.h"

#import "JNQPayView.h"
#import "CommonTableViewCell.h"

#import "JNQHttpTool.h"
#import "PZPayUtil.h"

@interface JNQPayViewContoller () {
    NSArray *_dataArray;
    JNQPayHeaderView *_headerView;
    JNQPayDiamondHeaderView *_payDiamondHeaderView;
    JNQPayReadyFooterView *_footerView;
    JNQPayFooterView *_resultFooterView;
    BOOL _loadNone;
    UIButton *_navRightBtn;
}

@property(copy,nonatomic)NSString *channel;
@property(strong,nonatomic)NSIndexPath* selectedIndexPath ;
@end

@implementation JNQPayViewContoller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = HBColor(245, 245, 245);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dataArray = [NSArray array];
    _payRedyModel = [[JNQPayReadyModel alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryOrderState:) name:QueryOrderState object:nil];
    _payRedyModel.descript = @"";
    [self buildUI];
    _loadNone = NO;
    [self setNav];
    if (_viewType == PayViewTypeProduct) {
        _loadNone = YES;
    } else {
        [self loadData];
        [self.tableView reloadData];
    }
    //默认选中项
    self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
}

- (void)setNav {
    WEAKSELF
    _navRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    NSString *str = _viewType == PayViewTypeDiamond || _viewType == PayViewTypeDelegate ? @"取消" : @"完成";
    [_navRightBtn setTitle:str forState:UIControlStateNormal];
    _navRightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_navRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _navRightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [[_navRightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf backToRoot];
    }];
    
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToRoot)];
    self.navigationItem.leftBarButtonItem = leftItem ;
}

-(void)backToRoot{
    NSArray* pushedControllers = self.navigationController.viewControllers ;
    for (UIViewController* vc in pushedControllers) {
        if ([vc isKindOfClass:[RRFBuyFortuneController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
        if ([vc isKindOfClass:[GuessPageController class]] ||[vc isKindOfClass:[JNQVIPUpdateViewController class]] || [vc isKindOfClass:[JNQPresentAwardViewController class]] || [vc isKindOfClass:[JNQShoppingCartViewController class]] || [vc isKindOfClass:[RRFMeController class]] || [vc isKindOfClass:[JNQDiamondViewController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        } else {
        }
    }
}

- (void)buildUI {
    _payRedyModel.totalFee = _confirmOrderModel.realTotalFee;
    _payRedyModel.orderId = _confirmOrderModel.orderId;
    _payRedyModel.channel = WeixinPay;
    
    _resultFooterView = [[JNQPayFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 300)];
    _resultFooterView.orderType = _viewType;
    CGFloat height = 0;
    _payDiamondHeaderView = [[JNQPayDiamondHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 160)];
    _headerView = [[JNQPayHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 110)];
    if (_viewType == PayViewTypeDiamond || _viewType == PayViewTypeHaul || _viewType == PayViewTypeVIP) {
        _payDiamondHeaderView.viewType = _viewType;
        if (_viewType == PayViewTypeHaul) {
            _payDiamondHeaderView.confirmModel = _confirmOrderModel;
        }
        if (_viewType == PayViewTypeDiamond) {
            if(_diamondModel != nil){
                _payDiamondHeaderView.diamondModel = _diamondModel;
            }else{
                _payDiamondHeaderView.confirmModel = _confirmOrderModel;
            }
        }
        if (_viewType == PayViewTypeVIP) {
            _payDiamondHeaderView.vipModel = _vipModel;
            _resultFooterView.vipIdentity = _vipModel.identityName;
        }
    } else if (_viewType == PayViewTypeProduct) {
        height = 110;
        _headerView.payResult = @"exchangeSuccess";
        _headerView.backBtn.hidden = NO;
        _resultFooterView.confirmOrderModel = _confirmOrderModel;
    } else if (_viewType == PayViewTypeDelegate) {
        height = 110;
        _headerView.frame = CGRectMake(0, 0, SCREENWidth, 110);
        _headerView.backBtn.isDelegate = YES;
        _headerView.backBtn.hidden = NO;
        _headerView.payCount = _confirmOrderModel.realTotalFee;
        
    }
    _headerView.frame = CGRectMake(0, 0, SCREENWidth, height);
    UIView *headerView = _viewType == PayViewTypeDiamond||_viewType==PayViewTypeHaul||_viewType==PayViewTypeVIP ? _payDiamondHeaderView : _headerView;
    [self.tableView setTableHeaderView:headerView];
    
    _footerView = [[JNQPayReadyFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 110)];
    [[_footerView.payBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self payOrder];
    }];
    UIView *footerView = _viewType == PayViewTypeProduct ? _resultFooterView : _footerView;
    [self.tableView setTableFooterView:footerView];
    
    [[_resultFooterView.payBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        _payRedyModel.resubmit = YES;
        _loadNone = NO;
        _headerView.payCount = _confirmOrderModel.realTotalFee;
        [self.tableView setTableFooterView:_footerView];
        [self.tableView reloadData];
    }];
    [[_resultFooterView.quitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"取消支付" message:@"您确定取消当前支付吗？" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        }];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:deleteAction];
        [self presentViewController:alertController animated:YES completion:^{
        }];

    }];
}

-(void)loadData {
    PZCommonCellModel* wechatM = [[PZCommonCellModel alloc]initWithTitle:@"微信"];
    wechatM.icon = @"icon_weixin" ;
    wechatM.subTitle = @"推荐开通微信支付的用户使用" ;
    
    PZCommonCellModel* aliPayM = [[PZCommonCellModel alloc]initWithTitle:@"支付宝"];
    aliPayM.icon = @"icon_zhifubao" ;
    aliPayM.subTitle = @"推荐开通支付宝的用户使用支付" ;
    
    PZCommonCellModel* uniPayM = [[PZCommonCellModel alloc]initWithTitle:@"银联"];
    uniPayM.icon = @"icon_yinlian" ;
    uniPayM.subTitle = @"无需开通网银，凭银行卡卡号及密码支付" ;
    
    _dataArray = @[wechatM,aliPayM,uniPayM];
}

- (void)payOrder {
    WEAKSELF
    if (_payRedyModel.channel == nil || [_payRedyModel.channel isEqualToString:@""]) {
        [MBProgressHUD showInfoWithStatus:@"请选择支付方式！"];
        return;
    }
    [MBProgressHUD show];
    [[PZPayUtil sharedInstance] payWithPayReadyModel:_payRedyModel complete:^(id obj) {
        //银联
        [weakSelf queryOrderState:nil];
    } sender:self];
}

- (void)queryOrderState:(NSNotification*)notificate {
    NSString* payResult = @"fail" ;
    if ([_payRedyModel.channel isEqualToString:AlipayClient]) {
        NSDictionary* object = notificate.object ;
        int resultStatus = [object[@"resultStatus"] intValue] ;
        if (resultStatus == 9000) {
            payResult = @"success" ;
        } else {
            return;
        }
    }
    NSDictionary *params = @{
                             @"orderId"   :   [NSString stringWithFormat:@"%ld", (long)_payRedyModel.orderId],
                             @"channel"   :   _payRedyModel.channel
                             };
    [JNQHttpTool JNQHttpRequestWithURL:@"tradeOrder/query" requestType:@"post" showSVProgressHUD:YES parameters:params successBlock:^(id json) {
        [MBProgressHUD dismiss];
        if ([json[@"payResult"] isEqualToString:@"success"]) {
            _headerView.frame = CGRectMake(0, 0, SCREENWidth, 110);
            [self.tableView setTableHeaderView:_headerView];
            _headerView.backBtn.hidden = NO;
            _headerView.vipPayBackView.hidden = YES;
            _headerView.payResult = @"paySuccess";
            _resultFooterView.payBtn.hidden = YES;
            _resultFooterView.quitBtn.hidden = YES;
            _loadNone = YES;
            if (_viewType == PayViewTypeDelegate) {
                [self delegatePaySuccess];
            }
            [self.tableView setTableFooterView:_resultFooterView];
        } else {
            _payRedyModel.resubmit = YES;
            UIView *view = _viewType == PayViewTypeDiamond || _viewType == PayViewTypeHaul ? _payDiamondHeaderView : _headerView;
            [self.tableView setTableHeaderView:view];
            _headerView.backBtn.hidden = YES;
            _headerView.payResult = @"payFail";
        }
        [self.tableView reloadData];
        _resultFooterView.isDelegateBuyDiamond = _isDelegateBuyDiamond;
        _resultFooterView.confirmOrderModel = _confirmOrderModel;
        _resultFooterView.payTypeStr = _payRedyModel.channel;
    } failureBlock:^(id json) {
        [MBProgressHUD dismiss];
    }];
}


- (void)delegatePaySuccess {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"您已成功申请加入喜鹊计划，我们将在两个工作日内完成审核并通知您！" preferredStyle: UIAlertControllerStyleAlert];

    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
    [alertController addAction:deleteAction];
    [self presentViewController:alertController animated:YES completion:^{
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = _loadNone ? 0 : 40;
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_loadNone == YES) {
        return nil;
    }
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 40)];
    UIView *backView = [[UIView alloc] init];
    [header addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, -0.5, 0, 0.5));
    }];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.borderColor = HBColor(231, 231, 231).CGColor;
    backView.layer.borderWidth = 0.5;
    
    UILabel *atten = [[UILabel alloc] init];
    [backView addSubview:atten];
    [atten mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(backView);
        make.left.mas_equalTo(backView).offset(15);
    }];
    atten.font = PZFont(14);
    atten.textColor = HBColor(51, 51, 51);
    atten.text = @"选择支付方式";
    
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_loadNone == YES) {
        return 0;
    } else {
        return _dataArray.count ;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64.0f ;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
        cell.textLabel.textColor = HBColor(51, 51, 51);
        cell.textLabel.font = PZFont(15);
        cell.detailTextLabel.textColor = HBColor(153, 153, 153);
        cell.detailTextLabel.font = PZFont(13);
        cell.sepLine.backgroundColor = HBColor(231, 231, 231);
        cell.topLineShow = NO;
        cell.sepHeight = 0.5;
        cell.bottomLineSetFlush = YES;
    }
    NSString* imageName = self.selectedIndexPath.row == indexPath.row ? @"btn_choose_s" : @"btn_choose_d";
    UIView* accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    cell.accessoryView = accessoryView;
    accessoryView.frame = CGRectMake(0, 16, 20, 20);
    
    PZCommonCellModel* payM = _dataArray[indexPath.row];
    cell.textLabel.text = payM.title ;
    cell.detailTextLabel.text = payM.subTitle ;
    cell.imageView.image = [UIImage imageNamed:payM.icon] ;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self changeCellStateForIndex:indexPath];
}

-(void)changeCellStateForIndex:(NSIndexPath*)indexPath{
    if (indexPath.row == 0) {
        _payRedyModel.channel = WeixinPay ;
//        self.channel = WeixinPay;
    }
    else if (indexPath.row == 1){
        _payRedyModel.channel = AlipayClient ;
    }
    else{
        _payRedyModel.channel = UnionPay ;
    }
    self.selectedIndexPath = indexPath ;
    [self.tableView reloadData];
}
@end
