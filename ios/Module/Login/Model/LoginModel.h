
//  Created by on 16/6/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
@interface LoginModel : RLMObject
@property NSString* phone_num ;
@property NSString* access_token ;
@property NSString* access_token_secret ;
@property NSString* headimgurl ;
@property NSString* nickname ;
@property NSString* cnName ;
@property NSString* icon ;
// 会员等级
@property NSString* identityType ;
// 个性签名
@property NSString* selfSign ;
@property NSString* address ;
//1：男  2：女
@property NSNumber<RLMInt>* sex ;
@property NSString* phoneNumber ;
@property NSNumber<RLMInt>* userId ;
@property(readwrite) NSString* xtNumber ;

@property NSNumber<RLMBool>* login ;
// 喜腾全部
@property NSNumber<RLMInt>* xtbTotalAmount ;
// 钻石
@property NSNumber<RLMInt>* diamondAmount ;
// 本金
@property NSNumber<RLMInt>* xtbCapitalAmount ;

// 利润
@property NSNumber<RLMInt>* xtbProfitAmount ;

//cnName = Hhh;
//icon = "http://114.251.53.22/M00/00/10/wKgKZlfraq2AFVQtAAAG8fF95qw933.jpg";
//phoneNumber = 17600850481;
//selfSign = "<null>";
//sex = 1;
//userArea = "<null>";
//userId = 13;
//xtNumber = "<null>";
//rinting description of json:
//{
//    diamondAmount = 100752;
//    xtbCapitalAmount = 999774;
//    xtbProfitAmount = 98800;
//    xtbTotalAmount = 98574;
//}

//userInfo =     {
//    cnName = Dtfj;
//    icon = "http://114.251.53.22/M00/00/00/wKgKZlfOOaiADt16AADJAC54ank64..jpg";
//    phoneNumber = 17600850481;
//    userId = 31;
//    xtNumber = "<null>";
//};
@end
