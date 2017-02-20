//
//  RRFOrderDetailView.h
//  Puzzle
//
//  Created by huibei on 16/8/5.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RRFOrderListModel,RRFAddressModel;

@interface RRFOrderDetailHeadView : UIView
@property(nonatomic,strong)RRFOrderListModel *listM;
@property(nonatomic,strong)RRFAddressModel *addrM;

@end
@interface RRFOrderDetailFooterView:UIView
@property(nonatomic,strong)RRFOrderListModel *listM;
@end


@interface RRFOrderDetailFooterBarView :UIView;
@property(nonatomic,weak)UIButton *clickBtn;
@property(nonatomic,copy)ItemClickParamBlock footBarBlock;
@end
@interface RRFOrderDetailView : UIView

@end
