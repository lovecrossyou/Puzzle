//
//  RRFRemarkView.h
//  Puzzle
//
//  Created by huipay on 2016/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRFFreeBuyOrderModel,RRFWiningOrderModel,RRFOrderListModel;
@interface RRFRemarkFootView : UIView

@property(nonatomic,strong)RRFWiningOrderModel *winingModel;
@property(nonatomic,strong)RRFFreeBuyOrderModel *model;
@property(nonatomic,strong)RRFOrderListModel *listModel;

@end
@interface RRFRemarkFootBarView : UIView
@property(nonatomic,assign)RRFShowOrderType comeInType;
@property(nonatomic,copy)ItemClickParamBlock sendBlock;
@end
@interface RRFRemarkView : UIView

@end
