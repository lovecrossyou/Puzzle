//
//  RRFXTDelegateInfoModel.h
//  Puzzle
//
//  Created by huipay on 2016/12/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRFXTDelegateInfoModel : NSObject
//A用户人数
@property(nonatomic,strong)NSString *countOfALevelUser;
//邀请B用户的人数
@property(nonatomic,strong)NSString *countOfBLevelUser;
//邀请C用户的人数
@property(nonatomic,strong)NSString *countOfCLevelUser;
//用户id
@property(nonatomic,strong)NSString *userId;
//A级别购买钻石的数量
@property(nonatomic,strong)NSString *countDiamondOfALevel;
//B级别购买钻石的数量
@property(nonatomic,strong)NSString *countDiamondOfBLevel;
//C级别购买钻石的数量
@property(nonatomic,strong)NSString *countDiamondOfCLevel;

@end
