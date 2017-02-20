//
//  RRFRebateDetailInfoModel.h
//  Puzzle
//
//  Created by huipay on 2016/12/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRFRebateDetailInfoModel : NSObject

    
//    "rebateCount":"100",//总返利
//    "rebateForAConsumer":"张三",//A级的返利
//    "rebateForBConsumer":"购买",//B级的返利
//    "rebateForCConsumer":10,//C级的返利
//    "rebateForMySelf":10,//自己的返利
//    "levelARate":"1%",  //A级的返利率
//    "levelBRate":"2%",//B级的返利率
//    "levelCRate":"3%",//C级的返利率
//    "rebateselfRate":"4%"//自己的返利率
//自己的返利率
@property(nonatomic,strong)NSString *rebateselfRate;
//A级的返利
@property(nonatomic,strong)NSString *levelARate;
//B级的返利
@property(nonatomic,strong)NSString *levelBRate;
//C级的返利
@property(nonatomic,strong)NSString *levelCRate;
//总返利
@property(nonatomic,assign)double rebateCount;
//自己的返利
@property(nonatomic,assign)double rebateForMySelf;
//A级的返利
@property(nonatomic,assign)double rebateForAConsumer;
//B级的返利
@property(nonatomic,assign)double rebateForBConsumer;
//C级的返利
@property(nonatomic,assign)double rebateForCConsumer;


@end
