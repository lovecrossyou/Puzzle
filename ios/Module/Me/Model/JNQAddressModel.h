//
//  RRFCreadAddressModel.h
//  Puzzle
//
//  Created by huibei on 16/8/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JNQAddressModel : NSObject
//"phoneNum": "18001198760",//手机号码，String
//"fullAddress": "北京市西城区百万庄大街",//区域和详细 连接，String
//"recievName": "小黑",//收货人，String
//"provinceId": null,//省份编号，Long
//"cityId": null,//城市编号，Long
//"detailAddress": "百万庄大街",//详细地址，String
//"districtAddress": "北京市西城区",//区域地址，String
//"positionX": null,//经度，Double
//"positionY": null//纬度,Double
//"isDefault":1//是否为 默认  1为默认  0不是， Integer
//
//deliveryAddressId = 11;
//fullAddress = "\U5317\U4eac\U5317\U4eac\U4e1c\U57ce\U533a\U90a3\U5c31\U770b";
//phoneNum = 13512341234;
//recievName = "\U6d4b\U8bd5";

@property (nonatomic, strong) NSString *phoneNum;
@property (nonatomic, strong) NSString *fullAddress;
@property (nonatomic, strong) NSString *recievName;
@property (nonatomic, assign) NSInteger provinceId;
@property (nonatomic, assign) NSInteger cityId;
@property (nonatomic, strong) NSString *detailAddress;
@property (nonatomic, strong) NSString *districtAddress;
@property (nonatomic, assign) double positionX;
@property (nonatomic, assign) double positionY;
@property (nonatomic, assign) int isDefault;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) NSInteger addressId;
// 订单里的地址id
@property (nonatomic, assign) NSInteger deliveryAddressId;

@end
