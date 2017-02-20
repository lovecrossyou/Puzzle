//
//  WechatUserInfo.h
//  Puzzle
//
//  Created by huipay on 2016/8/31.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface WechatUserInfo : RLMObject
@property NSString* city ;
@property NSString* country ;
@property NSString* headimgurl ;
@property NSString* access_token;
@property NSString* language ;
@property NSString* nickname ;
//@property NSString* openid ;
@property NSString* unionid ;
@property NSNumber<RLMInt>* xtbTotalAmount ;
@property NSNumber<RLMInt>* sex ;


//city = West;
//country = CN;
//headimgurl = "http://wx.qlogo.cn/mmopen/Q3auHgzwzM7nicTcM3pic3JFu9gqLImc771sqAiaYWmXmoJnbj7Mics0gFRfibzxanGGU169y0oP0VN7G6Qican9IXEzU6IyFQahErv6hjWaEZXiao/0";
//language = "zh_CN";
//nickname = "\Ue32f \Ue32f \U90e8\U843d\U683c";
//openid = "or-a7wHVio-FKJUcs-UdkAEhGqX0";
//privilege =     (
//);
//province = Beijing;
//sex = 2;
//unionid = "o_KegwWypY6h5rfrHMMIPnWdZET0";


@end
