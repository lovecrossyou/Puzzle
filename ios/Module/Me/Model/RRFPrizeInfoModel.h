//
//  RRFPrizeInfoModel.h
//  Puzzle
//
//  Created by huipay on 2016/11/2.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface RRFPrizeInfoModel : NSObject

@property(nonatomic,assign)NSInteger rank;
@property(nonatomic,assign)NSInteger userId;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *phoneNumber;
@property(nonatomic,assign)NSInteger profit;
@property(nonatomic,strong)NSString *awardName;
@property(nonatomic,assign)NSInteger awardRecordId;
@property(nonatomic,strong)NSString *pic;
@property(nonatomic,strong)NSString *userIcon;
@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,assign)BOOL accept;
@end
