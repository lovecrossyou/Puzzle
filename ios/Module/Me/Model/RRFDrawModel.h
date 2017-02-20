//
//  RRFDrawModel.h
//  Puzzle
//
//  Created by huibei on 16/9/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRFDrawModel : NSObject

//"accessInfo":{
    //            "app_key":"xxxxxxxxx",
    //            "access_token":"",
    //            "phone_num":"15810157156",
    //            "signature":"xxxxxxxxx"
    //        },
    //        "phoneNum": "18001198760",//手机号码，String
    //        "fullAddress": "北京市西城区百万庄大街",//区域和详细 连接，String
    //        "recievName": "小黑",//收货人，String
    //        "provinceId": null,//省份编号，Long
    //        "cityId": null,//城市编号，Long
    //        "detailAddress": "百万庄大街",//详细地址，String
    //        "districtAddress": "北京市西城区",//区域地址，String
    //        "positionX": null,//经度，Double
    //        "positionY": null,//纬度,Double
    //        "isDefault":1,//是否为 默认  1为默认  0不是， Integer，这里直接设置为非默认0
    //        "awardRecordId":1 //中奖记录ID,Long类型
@property(nonatomic,strong)NSString *phoneNum;
@property(nonatomic,strong)NSString *fullAddress;
@property(nonatomic,strong)NSString *recievName;
@property(nonatomic,assign)NSInteger provinceId;
@property(nonatomic,assign)NSInteger cityId;
@property(nonatomic,strong)NSString *detailAddress;
@property(nonatomic,strong)NSString *districtAddress;
@property(nonatomic,assign)CGFloat positionX;
@property(nonatomic,assign)CGFloat positionY;
@property(nonatomic,assign)int isDefault;
@property(nonatomic,assign)NSInteger awardRecordId;
@property(nonatomic,assign)NSInteger deliveryAddressId;


@end
