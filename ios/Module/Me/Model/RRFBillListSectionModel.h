//
//  RRFBillListSectionModel.h
//  Puzzle
//
//  Created by huibei on 16/9/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRFBillListSectionModel : NSObject
//"monthTime":8,  //当前月份, int
//"totalAmount":100,//喜腾币或钻石数量，long
//"dayBills":[
@property(nonatomic,assign)NSInteger monthTime;
@property(nonatomic,assign)NSInteger totalAmount;
@property(nonatomic,strong)NSArray *dayBills;

@end
