//
//  EchatHeadFooter.h
//  Puzzle
//
//  Created by huipay on 2016/8/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StockDetailModel ;
//看涨跌
@interface StageView : UIView
@property(strong,nonatomic)StockDetailModel* model ;
-(instancetype)initWithModel:(StockDetailModel*)model isUp:(BOOL)isUp;
-(instancetype)initWithUp:(BOOL)isUp percent:(NSString*)percent amount:(NSString*)amount;
@end

@interface EchatHeadFooter : UIView
-(instancetype)initWithModel:(StockDetailModel*)m;
-(void)updateModel:(StockDetailModel*)m;
@end
