//
//  RRFReceiveView.h
//  Puzzle
//
//  Created by huipay on 2016/12/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRFFreeBuyOrderModel,RRFWiningOrderModel;
@interface RRFReceiveView : UIView

@end

@interface RRFReceiveFooterView : UIView
@property(nonatomic,strong)RRFWiningOrderModel *winingM;
@property(nonatomic,strong)RRFFreeBuyOrderModel *model;
@property(nonatomic,weak)UIButton *footBtn;

@end
