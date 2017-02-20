//
//  EChatHead.h
//  Puzzle
//
//  Created by huipay on 2016/8/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StockDetailModel ;
@interface EChatHead : UIView
-(instancetype)initWithStockDetailModel:(StockDetailModel*)m;
-(void)updateModel:(StockDetailModel*)m;
@end
