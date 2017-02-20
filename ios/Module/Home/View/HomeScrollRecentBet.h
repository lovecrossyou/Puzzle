//
//  HomeScrollRecentBet.h
//  Puzzle
//
//  Created by huipay on 2016/10/24.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JustNowWithStockModel ;
@interface HomeScrollCell : UIView
@property(strong,nonatomic)JustNowWithStockModel* model ;
@end

@interface HomeScrollRecentBet : UIView
@property(strong,nonatomic) NSArray *recentList ;
@property(copy,nonatomic)ItemClickBlock itemClick ;
@end
