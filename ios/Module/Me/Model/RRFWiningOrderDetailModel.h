//
//  RRFWiningOrderDetailModel.h
//  Puzzle
//
//  Created by huipay on 2017/2/7.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRFWiningOrderInfoModel : NSObject
@property(nonatomic,strong)NSString *createTime;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,assign)NSInteger orderId;

@end

@interface OrderInfo : NSObject
@property(nonatomic,strong)NSString *fullAddress;
@property(nonatomic,strong)NSString *phoneNumber;
@property(nonatomic,strong)NSString *recievName;
@end

@interface RRFWiningOrderAddressModel : NSObject
@property(nonatomic,strong)NSString *fullAddress;
@property(nonatomic,strong)NSString *phoneNumber;
@property(nonatomic,strong)NSString *recievName;
@end

@interface UserInfo : NSObject
@property(nonatomic,strong)NSString *sex;
@property(nonatomic,strong)NSString *userIconUrl;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,assign)NSInteger userId;

@end

@interface AwardInfo : NSObject
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *picUrl;
@property(nonatomic,strong)NSString *productInfo;
@property(nonatomic,assign)NSInteger price;
@property(nonatomic,assign)NSInteger rank;
//String awardType;   //获奖类型
@property(nonatomic,strong)NSString *awardType;

//String awardTypeName;
@property(nonatomic,strong)NSString *awardTypeName;

//Long profit;        //收益
@property(nonatomic,assign)NSInteger profit;

//String awardStatus; //状态
@property(nonatomic,strong)NSString *awardStatus;

//String openResultTime;//投注开奖时间
@property(nonatomic,strong)NSString *openResultTime;


@end


@interface RRFWiningOrderDetailModel : NSObject
@property(nonatomic,strong)RRFWiningOrderInfoModel *orderInfo;
@property(nonatomic,strong)RRFWiningOrderAddressModel *deliveryAddress;

@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *showTime;
@property(nonatomic,strong)UserInfo *userInfo;
@property(nonatomic,strong)AwardInfo *awardInfo;
@property(nonatomic,strong)NSArray *pictures;
@end
