//
//  RRFProductModel.h
//  Puzzle
//
//  Created by huibei on 16/8/27.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRFProductModel : NSObject

@property(nonatomic,assign)NSInteger count;
@property(nonatomic,strong)NSString *picUrl;
@property(nonatomic,assign)NSInteger productId;
@property(nonatomic,strong)NSString *productName;
@property(nonatomic,assign)NSInteger xtbPrice;
//(2, "商品兑换"),(5, "领取奖品"
@property(nonatomic,assign)NSInteger tradeWay;


@end
