//
//  RRFXTPlanModel.h
//  Puzzle
//
//  Created by huipay on 2016/12/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRFXTPlanModel : NSObject
//Printing description of json:
//{
//    inviterAmount = 0;
//    myRebateAmount = 0;
//    userId = "<null>";
//}
// 邀请的人数
@property(nonatomic,assign)NSInteger inviterAmount;
// 我的返利
@property(nonatomic,assign)double myRebateAmount;

@property(nonatomic,assign)NSInteger userId;

@end
