//
//  RRFApplyDelegaterModel.h
//  Puzzle
//
//  Created by huibei on 16/9/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRFApplyDelegaterModel : NSObject

//{
//    "accessInfo":{
//        "access_token":"8bd6631847094fe8a651b0140c5a9987",
//        "app_key":"b5958b665e0b4d8cae77d28e1ad3f521",
//        "loginType": "weixin", //传值 为微信
//        "phone_num":"13220168837",
//        "signature":"9C23B36C18F1195D047A24AE119CC20D"},
//    "realName":"樊朋杰",
//    "phoneNumber":"18001198760",
//    "provinceId":"850018",
//    "cityId":"850019",
//    "districtId":"850026",
//    "inviteId":1 //客户端 不用传 web端 传入
//}
@property(nonatomic,assign)NSInteger districtId;
@property(nonatomic,assign)NSInteger cityId;
@property(nonatomic,assign)NSInteger provinceId;
@property(nonatomic,strong)NSString *realName;
@property(nonatomic,strong)NSString *phoneNumber;

@end
