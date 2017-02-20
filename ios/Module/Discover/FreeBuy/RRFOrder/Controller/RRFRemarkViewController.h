//
//  RRFRemarkViewController.h
//  Puzzle
//
//  Created by huipay on 2016/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZBaseViewController.h"
@class RRFFreeBuyOrderModel,RRFWiningOrderModel,RRFOrderListModel;
@interface RRFRemarkViewController : PZBaseViewController
@property(nonatomic,assign)RRFShowOrderType showOrderType;

@property(nonatomic,copy)ControllerRefreBlock isRefre;

@property(nonatomic,strong)RRFFreeBuyOrderModel *model;

@property(nonatomic,strong)RRFWiningOrderModel *winingModel;

@property(nonatomic,strong)RRFOrderListModel *listModel;


@end
