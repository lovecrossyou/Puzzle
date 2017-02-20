//
//  Singleton.h
//  HuiBeiWaterMerchant
//
//  Created by huibei on 16/5/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserDetailModel,WechatUserInfo,LoginModel,RRFPhoneListModel;
@interface Singleton : NSObject
// 添加在购物车中商品的数量
@property(nonatomic,assign)int shoppingCarProductTotalCount;


// 支付前的信息
@property(nonatomic,strong)NSMutableDictionary *payInfoDic;

// 运营商的orderNo
@property(nonatomic,strong)NSNumber *orderNo;


//  是否删除进货里提交的订单
@property(nonatomic,assign)BOOL isDeletedClearShoppingCar;


// 庄园的库存量
@property(nonatomic,assign)CGFloat totalCount;

// 庄园的剩余量
@property(nonatomic,assign)NSInteger remainingCount;

// 庄园的名字
@property(nonatomic,copy)NSString *teaStallName;
// 茶叶的名字
@property(nonatomic,copy)NSString *teaCategoryName;
// 庄园的id
@property(nonatomic,strong)NSNumber *teaStoreCardProductId;
// 用户名字
@property(nonatomic,strong)NSString *userName;
//  是否刷新定制礼盒中的茶叶的的余量
@property(nonatomic,assign)BOOL isUpdateRemaining;
// 上次登录的LoginModel
@property(nonatomic,strong)LoginModel *loginModel;


@property(strong,nonatomic)WechatUserInfo* wechatInfo ;

//md5key
@property(strong,nonatomic)NSString* md5key ;
@property(nonatomic,strong)RRFPhoneListModel *phoneListM;

+(Singleton *)sharedInstance;
@end
