//
//  RRFShippingAddressController.m
//  Puzzle
//
//  Created by huibei on 16/8/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQAddressController.h"
#import "JNQAddrView.h"
#import "JNQAddrCell.h"
#import "PZChooseAddrCell.h"
#import "JNQAddressModel.h"
#import "JNQAddressOperateController.h"
#import "JNQHttpTool.h"
#import "MJRefresh.h"

@interface JNQAddressController () {
    int _pageNo;
    BOOL _refresh;
    NSInteger _selectInteger;
    JNQAddressModel *_model;
}
@property (nonatomic, strong) JNQAddrHeaderView *headerView;
@property (nonatomic, strong) UIButton *navRight;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation JNQAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = HBColor(245, 245, 245);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _pageNo = 0;
    _selectInteger = -1;
    
    [self settingNavItem];
    [self loadData:nil];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData:)];
    header.tag = 10010;
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.textColor = HBColor(135, 135, 135);
    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.tableView.mj_header = header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData:)];
    footer.triggerAutomaticallyRefreshPercent = 1;
    footer.automaticallyHidden = YES;
    footer.automaticallyRefresh = YES;
    footer.stateLabel.textColor = HBColor(135, 135, 135);
    self.tableView.mj_footer = footer;
}

-(void)settingNavItem {
    _navRight = [[UIButton alloc]init];
    if (_viewType == PZAddrViewTypeSelect) {
        [_navRight setTitle:@"完成" forState:UIControlStateNormal];
    } else {
        [_navRight setTitle:@"新建" forState:UIControlStateNormal];
    }
    [_navRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _navRight.titleLabel.font = [UIFont systemFontOfSize:16];
    [[_navRight rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (_viewType == PZAddrViewTypeSelect) {
            if (!_model) {
                [MBProgressHUD showInfoWithStatus:@"请选择收货地址！"];
                return;
            }
            if (self.selectBlock) {
                self.selectBlock(_model);
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            JNQAddressOperateController *desc = [[JNQAddressOperateController alloc]init];
            desc.title = @"新建地址";
            desc.viewType = AddressViewTypeCreate;
            desc.shouldReload = ^(BOOL shouldReload) {
                [self.tableView.mj_header beginRefreshing];
            };
            [self.navigationController pushViewController:desc animated:YES];
        }
    }];
    _navRight.frame = CGRectMake(0, 0, 44, 44);
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:_navRight];
    self.navigationItem.rightBarButtonItem = item;
    
}

-(void)creatAddress {
    JNQAddressOperateController *desc = [[JNQAddressOperateController alloc]init];
    desc.title = @"新建地址";
    desc.viewType = AddressViewTypeCreate;
    desc.shouldReload = ^(BOOL shouldReload) {
        [self.tableView.mj_header beginRefreshing];
    };
    [self.navigationController pushViewController:desc animated:YES];
}
- (void)loadData:(UIView *)sender {
    if (sender.tag == 10010) {
        _pageNo = 0;
    }
    NSDictionary *param = @{
                            @"size"  : @(10),
                            @"pageNo": @(_pageNo)
                            };
    [JNQHttpTool JNQHttpRequestWithURL:@"deliveryAddress/list" requestType:@"post" showSVProgressHUD:NO parameters:param successBlock:^(id json) {
        NSArray *data = json[@"content"];
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in data) {
            JNQAddressModel *model = [JNQAddressModel yy_modelWithJSON:dict];
            [array addObject:model];
        }
        
        if (_pageNo) {
            [_dataArray addObjectsFromArray:array];
        } else {
            _dataArray = array;
            [self refreshTableViewData];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer.hidden = [json[@"last"] boolValue];
        _pageNo++;
    } failureBlock:^(id json) {
        
    }];
}

- (void)deleteAddrFromBackground:(NSInteger)addressId {
    [JNQHttpTool JNQHttpRequestWithURL:@"deliveryAddress/delete" requestType:@"post" showSVProgressHUD:YES parameters:@{@"addressId" : @(addressId)} successBlock:^(id json) {
        [MBProgressHUD showInfoWithStatus:@"删除成功，刷新地址列表！"];
        [self.tableView.mj_header beginRefreshing];
    } failureBlock:^(id json) {
        
    }];
}

- (void)setDefaultToBackground:(JNQAddressModel *)adModel {
    NSDictionary *params = @{
                             @"addressId" : @(adModel.addressId),
                             @"isDefault" : @(adModel.isDefault)
                             };
    [JNQHttpTool JNQHttpRequestWithURL:@"deliveryAddress/setDefault" requestType:@"post" showSVProgressHUD:YES parameters:params successBlock:^(id json) {
        [MBProgressHUD showInfoWithStatus:@"设置默认成功！"];
        [self.tableView.mj_header beginRefreshing];
    } failureBlock:^(id json) {
        
    }];
}

- (void)cellBlock:(JNQAddrCell *)cell {
    __block JNQAddrCell *cellSelf = cell;
    cell.addrBlock = ^(int operate) {
                    //设置为默认地址
        if (operate == 1) {
            cellSelf.addrModel.isDefault = !cellSelf.defaultBtn.selected;
            [self setDefaultToBackground:cellSelf.addrModel];
        }
            //删除
        if (operate == 2) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"您确定要删除改地址？该操作不可恢复！" preferredStyle: UIAlertControllerStyleActionSheet];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self deleteAddrFromBackground:cellSelf.addrModel.addressId];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:deleteAction];
            [self presentViewController:alertController animated:YES completion:^{
            
            }];
        }
            //编辑地址
        if (operate == 3) {
            [self editAddrWithModel:cellSelf.addrModel];
        }
    };
}

- (void)editAddrWithModel:(JNQAddressModel *)addrModel {
    //编辑收货地址
    JNQAddressOperateController *addrOpeVC = [[JNQAddressOperateController alloc]init];
    addrOpeVC.title = @"编辑地址";
    addrOpeVC.viewType = AddressViewTypeEdit;
    addrOpeVC.addrModel = addrModel;
    addrOpeVC.shouldReload = ^(BOOL shouldReload) {
        [self.tableView.mj_header beginRefreshing];
//        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:addrOpeVC animated:YES];
    _refresh = YES;
}

- (void)refreshTableViewData {
    if (!_dataArray.count) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, SCREENHeight-64)];
        headerView.backgroundColor = HBColor(245, 245, 245);
        UILabel *atten = [[UILabel alloc] init];
        [headerView addSubview:atten];
        [atten mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.width.mas_equalTo(headerView);
            make.centerY.mas_equalTo(headerView).offset(-50);
            make.height.mas_equalTo(20);
        }];
        atten.font = PZFont(14);
        atten.textColor = HBColor(153, 153, 153);
        atten.textAlignment = NSTextAlignmentCenter;
        atten.text = @"还没有收货地址?";
        
        UIButton *button = [[UIButton alloc] init];
        [headerView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(atten.mas_bottom).offset(8);
            make.centerX.mas_equalTo(headerView);
            make.height.mas_equalTo(30);
        }];
        button.backgroundColor = [UIColor colorWithHexString:@"4964ef"];
        [button setTitle:@"  立即新建  " forState:UIControlStateNormal];
        button.titleLabel.font = PZFont(15);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self creatAddress];
        }];
        
        [self.tableView setTableHeaderView:headerView];
    } else {
        if (_viewType == PZAddrViewTypeSelect) {
            _headerView = [[JNQAddrHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWidth, 67)];
            [[_headerView.addNewAddr rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                [self creatAddress];
            }];
            [self.tableView setTableHeaderView:_headerView];
        } else {
            [self.tableView setTableHeaderView:nil];
        }
    }
}

- (void)selectBtnStateDidChanged:(NSIndexPath *)indexPath {
    if (_selectInteger == indexPath.row) {
        _selectInteger = -1;
    }
    JNQAddressModel *model = [_dataArray objectAtIndex:indexPath.row];
    model.isSelected = !model.isSelected;
    _model = model;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    if (_selectInteger != -1) {
        NSIndexPath *idp = [NSIndexPath indexPathForRow:_selectInteger inSection:0];
        JNQAddressModel *oriModel = [_dataArray objectAtIndex:_selectInteger];
        oriModel.isSelected = NO;
        [self.tableView reloadRowsAtIndexPaths:@[idp] withRowAnimation:UITableViewRowAnimationNone];
    }
    _selectInteger = indexPath.row;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_viewType == PZAddrViewTypeSelect) {
        return 60;
    } else {
        return 120;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_viewType == PZAddrViewTypeSelect) {
        PZChooseAddrCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PZChooseAddrCell"];
        if (!cell) {
            cell = [[PZChooseAddrCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PZChooseAddrCell"];
        }
        JNQAddressModel *model = [_dataArray objectAtIndex:indexPath.row];
        cell.addrModel = model;
        cell.btnClick = ^(UIButton *button){
            if (button.tag == 2333) {
                [self editAddrWithModel:model];
            }
            if (button.tag == 520) {
                [self selectBtnStateDidChanged:indexPath];
            }
        };
        return cell;
    } else {
        JNQAddrCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JNQAddrCell"];
        if (cell == nil) {
            cell = [[JNQAddrCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JNQAddrCell"];
        }
        JNQAddressModel *model = [_dataArray objectAtIndex:indexPath.row];
        cell.addrModel = model;
        [self cellBlock:cell];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JNQAddressModel *model = [_dataArray objectAtIndex:indexPath.row];
    if (_viewType == PZAddrViewTypeSelect) {
        [self selectBtnStateDidChanged:indexPath];
    } else {
        [self editAddrWithModel:model];
    }
}

@end
