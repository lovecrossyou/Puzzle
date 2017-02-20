//
//  FBActivityProductController.m
//  Puzzle
//
//  Created by huibei on 16/12/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "FBActivityProductController.h"
#import "FBTool.h"
#import "FBProductListModel.h"
#import "JNQBookFBOrderViewController.h"
#import "FBActivityProductCell.h"
#import "JNQFBComContentPageController.h"
#import "HBLoadingView.h"

@interface FBActivityProductController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)NSArray* productList ;
@end

@implementation FBActivityProductController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 120.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.delegate = self ;
    self.tableView.dataSource = self ;

    [self.tableView registerClass:[FBActivityProductCell class] forCellReuseIdentifier:@"FBActivityProductCell"];
    
    NSDictionary *filterDic = [[NSDictionary alloc]init];
    filterDic = @{
                  @"popularity":@(-1),
                  @"price":@(1),
                  @"rateOfProgress":@(-1)
                  };
    WEAKSELF
    [HBLoadingView showCircleView:self.view];
    [FBTool getPurchaseGameListWithPageNo:0 pageSize:12 FilterDic:filterDic SuccessBlock:^(id json) {
        FBProductListModel* list = [FBProductListModel yy_modelWithJSON:json];
        weakSelf.productList = list.content ;
        [weakSelf.tableView reloadData];
        [HBLoadingView dismiss];
    } fail:^(id json) {
        [HBLoadingView dismiss];
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray* list = self.productList ;
    return list.count  ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WEAKSELF
    FBActivityProductCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FBActivityProductCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    NSArray* list = self.productList ;
    FBProductModel* model = list[indexPath.row];
    cell.productDetailBlock = ^(){
        [weakSelf goProductDetail:model];
    };
    cell.clickBlock = ^() {
        JNQBookFBOrderViewController *bookFBOrderVC = [[JNQBookFBOrderViewController alloc] init];
        bookFBOrderVC.navigationItem.title = @"夺宝订单";
        bookFBOrderVC.productM = model;
        [self.navigationController pushViewController:bookFBOrderVC animated:YES];
    };
    [cell configModel:model];
    return cell ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FBProductModel *model = _productList[indexPath.row] ;
    [self goProductDetail:model];
}

-(void)goProductDetail:(FBProductModel *)model{
    JNQFBComContentPageController *vc = [[JNQFBComContentPageController alloc] init];
    vc.fbPurchaseGameId = model.purchaseGameId;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
