//
//  EChatHeadView.h
//  Puzzle
//
//  Created by huipay on 2016/8/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StockDetailModel ;
@interface EChatHeadView : UIView
-(instancetype)initWithModel:(StockDetailModel*)m;
-(void)updateStock:(StockDetailModel*)stockM ;
@end
