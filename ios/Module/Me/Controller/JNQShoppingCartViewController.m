//
//  JNQShoppingCartViewController.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQShoppingCartViewController.h"
#import "TPKeyboardAvoidingTableView.h"
#import "JNQShoppingCartView.h"
#import "JNQShoppingCartCell.h"
#import "JNQPresentProductModel.h"
#import "JNQConfirmOrderViewController.h"
#import "ShoppingCartTool.h"
#import "PZParamTool.h"
#import <Realm/Realm.h>

@interface JNQShoppingCartViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
}
@property (nonatomic, strong) TPKeyboardAvoidingTableView *shoppingCartTv;
@property (nonatomic, strong) JNQShoppingCartBottomView *bottomView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property(weak,nonatomic) TPKeyboardAvoidingTableView* tableView ;
@end

@implementation JNQShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HBColor(245, 245, 245);
    [self setNav];
    [self buildUI];
    [self loadData];
    [self refreshTable];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearShoppingCart) name:ShoppingCartClearNotificate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTable) name:ShoppingCartReloadNotificate object:nil];
}

- (void)setNav {
    UIButton *navRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [navRightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [navRightBtn setTitle:@"取消" forState:UIControlStateSelected];
    navRightBtn.titleLabel.font = PZFont(16);
    navRightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [[navRightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        navRightBtn.selected = !navRightBtn.selected;
        _bottomView.payBtn.selected = navRightBtn.selected;
        _bottomView.payBtn.backgroundColor = _bottomView.payBtn.selected ? BasicRedColor : BasicGoldColor;
        
    }];
    UIBarButtonItem *navRight = [[UIBarButtonItem alloc] initWithCustomView:navRightBtn];
    self.navigationItem.rightBarButtonItem = navRight;
}


- (void)buildUI {
    WEAKSELF
    _shoppingCartTv = [[TPKeyboardAvoidingTableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64-50) style:UITableViewStylePlain];
    [self.view addSubview:_shoppingCartTv];
    _shoppingCartTv.backgroundColor = HBColor(245, 245, 245);
    _shoppingCartTv.separatorStyle = UITableViewCellSeparatorStyleNone;
    _shoppingCartTv.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag ;
    _shoppingCartTv.delegate = self;
    _shoppingCartTv.dataSource = self;
    
    _bottomView = [[JNQShoppingCartBottomView alloc] initWithFrame:CGRectMake(0, SCREENHeight-64-50, SCREENWidth, 50)];
    [self.view addSubview:_bottomView];
    [[_bottomView.allBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf clickAllBtnWithSender:weakSelf state:!_bottomView.allBtn.selected];
    }];
    [[_bottomView.payBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        BOOL hasLogin = [PZParamTool hasLogin];
        if (!hasLogin) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"goLogin" object:nil];
            return;
        }
        if (![self computerAllCount]) {
            [MBProgressHUD showInfoWithStatus:@"请您选择商品"];
            return;
        }
        if (_bottomView.payBtn.selected) {
            
            [self clearShoppingCart];
        } else {
            NSMutableArray *array = [NSMutableArray array];
            for (NSArray *temp in _dataArray) {
                NSMutableArray *mArray = [NSMutableArray array];
                for (JNQPresentProductModel *model in temp) {
                    if (model.selected) {
                        [mArray addObject:model];
                    }
                }
                [array addObject:mArray];
            }
            JNQConfirmOrderViewController *confirmOrderVC = [[JNQConfirmOrderViewController alloc] init];
            confirmOrderVC.dataArray = array;
            confirmOrderVC.navigationItem.title = @"确认订单";
            [self.navigationController pushViewController:confirmOrderVC animated:YES];
        }
    }];
}

- (void)loadData {
    _dataArray = [NSMutableArray array];
    _dataArray = [ShoppingCartTool loadShoppingCart];
    [_shoppingCartTv reloadData];
}

- (void)deleteSingleProduct:(JNQPresentProductModel *)productModel {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    if (![productModel isInvalidated]) {
        [realm deleteObject:productModel];
    }
    [realm commitWriteTransaction];
    [_dataArray removeObject:productModel];
    [[NSNotificationCenter defaultCenter] postNotificationName:ShoppingCartReloadNotificate object:nil];
    [_shoppingCartTv reloadData];
}

- (void)clearShoppingCart {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    NSMutableArray* productsToDel = [NSMutableArray array];
    for(NSArray *sec in _dataArray) {
        for (JNQPresentProductModel *productModel in sec) {
            if (![productModel isInvalidated]) {
                if (productModel.selected) {
                [realm deleteObject:productModel];
                [productsToDel addObject:productModel];
                }
            }
        }
    }
    [realm commitWriteTransaction];
    [_dataArray removeObjectsInArray:productsToDel];
    [[NSNotificationCenter defaultCenter] postNotificationName:ShoppingCartReloadNotificate object:nil];
    [_shoppingCartTv reloadData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (![textField.text integerValue]) {
        [MBProgressHUD showInfoWithStatus:@"请勿输入非法数字"];
        JNQShoppingCartCell *cell = (JNQShoppingCartCell *)textField.superview.superview.superview;
        cell.addMinusView.count = 1;
        textField.text = @"1";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sec = _dataArray[section];
    return sec.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WEAKSELF
    __block JNQShoppingCartSectionHeaderView *header = [[JNQShoppingCartSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 60)];
    header.allBtn.selected = [self checkSelectStateForSection:section];
    header.btnBlock = ^(UIButton *button) {
        [weakSelf clickSectionAtSection:section sender:weakSelf state:!button.selected];
        [weakSelf.shoppingCartTv reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    };
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sec = _dataArray[indexPath.section];
    JNQPresentProductModel *model = [sec objectAtIndex:indexPath.row];
    JNQShoppingCartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JNQShoppingCartCell"];
    if (!cell) {
        cell = [[JNQShoppingCartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JNQShoppingCartCell"];
    }
    WEAKSELF
    cell.btnBlock = ^(UIButton *button) {
        [self clickSectionAtIndexPath:indexPath];
        [self.shoppingCartTv reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    };
    cell.countBlock = ^(NSInteger count) {
        if (model.selected) {
            [weakSelf.bottomView updateAllSelectState:[weakSelf checkShoppingCartState] totalPrice:[weakSelf computeShoppingCartPrice] totalCount:[weakSelf computerAllCount]];
            [weakSelf refreshTable];
        }
    };
    cell.vc = self;
    cell.productModel = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self clickSectionAtIndexPath:indexPath];
    [_shoppingCartTv reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *sec = _dataArray[indexPath.section];
        JNQPresentProductModel *model = [sec objectAtIndex:indexPath.row];
        [self deleteSingleProduct:model];
    }
}


-(void)updateSeleteModelForSection:(NSInteger)section state:(BOOL)state{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    NSArray *sec = _dataArray[section];
    for (JNQPresentProductModel* model in sec) {
        if ([model isInvalidated])return;
        model.selected = state ;
    }
    [realm commitWriteTransaction];
    [_shoppingCartTv reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - 全选／反选
- (void)clickAllBtnWithSender:(JNQShoppingCartViewController *)sender state:(BOOL)state {
    for (int i = 0; i<_dataArray.count; i++) {
        [self clickSectionAtSection:i sender:self state:state];
    }
    [_shoppingCartTv reloadData];
}

-(void)clickSectionAtSection:(NSInteger)section sender:(JNQShoppingCartViewController *)sender state:(BOOL)state {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    NSArray *sec = _dataArray[section];
    for (JNQPresentProductModel* model in sec) {
        if ([model isInvalidated])return;
        model.selected = state ;
    }
    [realm commitWriteTransaction];
    [sender updateFootUI];
    [sender refreshTable];
}

- (void)clickSectionAtIndexPath:(NSIndexPath*)indexPath {
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    NSArray *sec = _dataArray[indexPath.section];
    JNQPresentProductModel* model = sec[indexPath.row];
    model.selected = !model.selected;
    
    [realm commitWriteTransaction];
    [self updateFootUI];
    [self refreshTable];
}

- (void)updateFootUI {
    float totalPrice = [self computeShoppingCartPrice];
    [_bottomView updateAllSelectState:[self checkShoppingCartState] totalPrice:totalPrice totalCount:[self computerAllCount]];
}

-(BOOL)checkShoppingCartState{
    NSArray* shoppingCarts = _dataArray ;
    for (int section = 0; section<shoppingCarts.count; section++) {
        if (![self checkSelectStateForSection:section]) {
            return NO ;
        }
    }
    return YES ;
}

#pragma mark - 计算每组的选中状态
-(BOOL)checkSelectStateForSection:(NSInteger)section{
    NSArray *sec = _dataArray[section];
    BOOL state = YES;
    for (JNQPresentProductModel *model in sec) {
        if ([model isInvalidated])return NO;
        if (model.selected == 0) {
            state = NO ;
        }
    }
    return state;
}

- (float)computeShoppingCartPrice {
    NSInteger sections = _dataArray.count;
    float totalPrice = 0.0f ;
    for (int i = 0; i<sections; i++) {
        totalPrice += [self computeSectionPrice:i];
    }
    return totalPrice ;
}

- (float)computeSectionPrice:(NSInteger)section {
    float sectionPrice = 0.0f ;
    NSArray *sec = _dataArray[section];
    for (JNQPresentProductModel* model in sec) {
        if (model.selected) {
            sectionPrice += model.price * model.count;
        }
    }
    return sectionPrice ;
}

- (NSInteger)computerAllCount {
    NSInteger sections = _dataArray.count;
    NSInteger totalCount = 0;
    for (int i = 0; i<sections; i++) {
        totalCount += [self computerSectionCount:i];
    }
    return totalCount ;
}

- (NSInteger)computerSectionCount:(NSInteger)section {
    NSInteger sectionCount = 0;
    NSArray *sec = _dataArray[section];
    for (JNQPresentProductModel* model in sec) {
        if (model.selected) {
            sectionCount += model.count;
        }
    }
    return sectionCount ;
}

- (void)refreshTable {
    _dataArray = [ShoppingCartTool loadShoppingCart];
    if (_dataArray.count == 0) {
        
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64)];
        header.backgroundColor = HBColor(245, 245, 245);
        UILabel *atten = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 40)];
        [header addSubview:atten];
        atten.center = CGPointMake(header.center.x, header.center.y-50);
        atten.textColor = HBColor(153, 153, 153);
        atten.font = PZFont(15);
        atten.text = @"购物车是空的";
        atten.textAlignment = NSTextAlignmentCenter;
        [_shoppingCartTv setTableHeaderView:header];
        _bottomView.hidden = YES;
    }
    else{
        [_shoppingCartTv setTableHeaderView:nil];
        _bottomView.hidden = NO;
    }
    [self updateFootUI];
    [self.tableView reloadData];
}

@end
