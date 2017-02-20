//
//  RRFMeTool.m
//  Puzzle
//
//  Created by huibei on 16/8/3.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFMeTool.h"
#import "PZHttpTool.h"
#import "PZParamTool.h"
#import "PZAccessInfo.h"
#import "RRFFattestationModel.h"
#import "LoginModel.h"
#import "Singleton.h"
#import "PZMMD5.h"
#import "RRFDrawModel.h"

@implementation RRFMeTool
+(void)requestAccountXTBWithSuccess:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    [PZHttpTool postRequestUrl:@"account/info" parameters:@{@"accessInfo":[accessInfo yy_modelToJSONObject]} successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
        NSLog(@"喜腾账户信息获取失败");
    }];
    
}

+(void)requestAccountDiamondWithSuccess:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    [PZHttpTool postRequestUrl:@"account/diamond" parameters:@{@"accessInfo":[accessInfo yy_modelToJSONObject]} successBlock:^(id json) {
        
    } fail:^(id json) {
        
    }];
    
}

+(void)requestAccountCapitalWithSuccess:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    [PZHttpTool postRequestUrl:@"account/xtb/capital" parameters:@{@"accessInfo":[accessInfo yy_modelToJSONObject]} successBlock:^(id json) {
        
    } fail:^(id json) {
        
    }];
    
}

+(void)requestAddressListWithPageNo:(int)pageNo Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"pageNo":@(pageNo),
                            @"size":@(20)
                            };
    [PZHttpTool postRequestUrl:@"deliveryAddress/list" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}
+(void)requestOrderListWithStatus:(int)status pageNo:(int)pageNo Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"pageNo":@(pageNo),
                            @"size":@(20),
                            @"status":@(status),
                            @"version":@"new"
                            };
    [PZHttpTool postRequestUrl:@"exchange/list" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}
// 获取订单详情
+(void)requestOrderDatailOrderId:(NSInteger)orderId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"orderId":@(orderId)
                            };
    [PZHttpTool postRequestUrl:@"exchange/detail" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}
+(void)dealWithOrderId:(NSNumber *)orderId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"orderId":orderId
                            };
    [PZHttpTool postRequestUrl:@"signIn" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}
+(void)requestRewoardListWithPageNo:(int)pageNo direction:(NSString *)direction
                            Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    //降序 DESC  升序 ASC
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"pageNo":@(pageNo),
                            @"size":@(20),
                            @"sortProperties":@[@"time"],
                            @"direction":direction
                            };
    [PZHttpTool postRequestUrl:@"getWithStockList" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}
+(void)getGuessWithStockStatisticSuccess:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    [PZHttpTool postRequestUrl:@"getGuessWithStockStatistics" parameters:@{@"accessInfo":[accessInfo yy_modelToJSONObject]} successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}

//请求路径：/product/comment/add
//请求方法：POST
//请求参数：
//
//{
//    "accessInfo":{
//        "app_key":"xxxxxxxxx",
//        "access_token":"",
//        "phone_num":"15810157156",
//        "signature":"xxxxxxxxx"
//    },
//    "orderId":1,        //订单ID，Long类型
//    "score":10,        //评分，Integer类型
//    "content":"评论内容"    //评论内容，String类型
//    "imageUrls":[
//                 {"head_img":"http://114/a.jpg", "big_img":"http://112/a.jpg"},
//                 {"head_img":"http://114/a.jpg", "big_img":"http://112/a.jpg"}
//                 ]  //图片地址
//    "isSynchoron":"true/false"
//}
// 评论订单
+(void)addCommentWithContent:(NSString *)content OrderId:( NSInteger)orderId Score:(NSInteger)score ImageUrls:(NSArray *)imageUrls IsSynchoron:(int)isSynchoron Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"orderId":@(orderId),
                            @"content":content,
                            @"imageUrls":imageUrls,
                            @"isSynchoron":@"yes"
                            };
    [PZHttpTool postRequestUrl:@"product/comment/add" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}
+(void)requestBillListWithType:(NSInteger )type Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"currencyType":@(type)
                            };
    [PZHttpTool postRequestUrl:@"account/bill" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}

+(void)modifyNameWith:(NSString *)name Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"cnName":name
                            };
    [PZHttpTool postRequestUrl:@"user/modify/name" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}
+(void)modifyIconWithUrlStr:(NSString *)iconUrl Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"icon":iconUrl
                            };
    [PZHttpTool postRequestUrl:@"user/modify/icon" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}
+(void)requestUserInfoWithSuccess:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{

    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            };
    [PZHttpTool postRequestUrl:@"user/info" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}
// 我的提问
+(void)requestMyQuestionListPageNo:(int)pageNo Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"pageNo":@(pageNo),
                            @"size":@(20),
                            @"sortProperties":@[@"createTime"],
                            @"direction":@"DESC"
                            };
    [PZHttpTool postRequestUrl:@"myQuestionList" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}

// 吧主认证
+(void)applicationReviewWithModel:(RRFFattestationModel *)model  Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    NSDictionary *param = [NSMutableDictionary dictionaryWithDictionary:[model yy_modelToJSONObject]];
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    [param setValue:[accessInfo yy_modelToJSONObject] forKey:@"accessInfo"];
   
    [PZHttpTool postRequestUrl:@"applicationReview" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}
//吧主信息
+(void)getQuestionBarMsgWithUserId:(NSInteger)userId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"userId":@(userId)
                            };
    [PZHttpTool postRequestUrl:@"getQuestionBarMsg" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}

// 最新提问
+(void)getWaitAnswerQuestionListWithPageNo:(int)pageNo Size:(int)size Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"pageNo":@(pageNo),
                            @"size":@(size),
                            @"sortProperties":@[@"createTime"],
                            @"direction":@"DESC"
                            };
    [PZHttpTool postRequestUrl:@"waitAnswerQuestionList" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}
// 最新回答
+(void)getAlReadyAnswerQuestionListWithPageNo:(int)pageNo Size:(int)size Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"pageNo":@(pageNo),
                            @"size":@(size),
                            @"sortProperties":@[@"createTime"],
                            @"direction":@"DESC"
                            };
    [PZHttpTool postRequestUrl:@"alReadyAnswerQuestionList" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}

// 最新回答
+(void)requestFattestationInfoWithSuccess:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject]
                            };
    [PZHttpTool postRequestUrl:@"mySalon" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}
// 打赏列表  "entityType":"all",// all所有的打赏  response 回复的打赏  answer回答的打赏  comment 评论的打赏
// 评论 或者 回复 回答的 id
+(void)requestPraiseListWithUrl:(NSString *)url PageNo:(int)pageNo size:(int)size entityType:(NSString *)entityType entityId:(NSInteger)entityId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"pageNo":@(pageNo),
                            @"size":@(size),
                            @"entityType":entityType,
                            @"entityId":@(entityId)
                            };
    [PZHttpTool postRequestUrl:url parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}

+(void)updatePwdWithOldPassword:(NSString *)oldPassword NewPassword:(NSString *)newPassword Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{

    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    LoginModel *model = [PZParamTool currentUser];
    NSString *phone = model.phone_num;
    if (phone.length == 0) {
        phone = model.phoneNumber;
    }
    [PZHttpTool getMd5KeyWithUserName:phone successBlock:^(id json) {
        NSString *md5Key = json[@"userMD5"];
        NSString* oldStr = [PZMMD5 digest:[NSString stringWithFormat:@"%@%@%@",phone,oldPassword,md5Key]];
        NSString* newStr = [PZMMD5 digest:[NSString stringWithFormat:@"%@%@%@",phone,newPassword,md5Key]];
        
        NSDictionary *param = @{
                                @"accessInfo":[accessInfo yy_modelToJSONObject],
                                @"oldPassword":oldStr,
                                @"newPassword":newStr
                                };
        [PZHttpTool postRequestUrl:@"updatePwd" parameters:param successBlock:^(id json) {
            success(json);
        } fail:^(id json) {
            fail(json);
        }];
    } fail:^(id json) {
        
    }];
    
}


// 通知列表
+(void)requestNoticeListWithPageNo:(int)pageNo Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"size":@(20),
                            @"pageNo":@(pageNo)
                            };
    [PZHttpTool postRequestUrl:@"pushMessage/list" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}
+(void)prizeWithModel:(RRFDrawModel*)model Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    NSDictionary *param = [NSMutableDictionary dictionaryWithDictionary:[model yy_modelToJSONObject]];
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    [param setValue:[accessInfo yy_modelToJSONObject] forKey:@"accessInfo"];
    [PZHttpTool postRequestUrl:@"accept/prize" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}
+(void)checkIsDelegaterWithSuccess:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            };
    [PZHttpTool postHttpRequestUrl:@"delegater/checkIsDelegater" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}


//修改个性签名
+(void)modifySelfSignWithText:(NSString *)text Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"selfSign":text
                            };
    [PZHttpTool postHttpRequestUrl:@"user/modify/selfSign" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}

//修改性别
+(void)modifySexWithSex:(int)sex Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"sex":@(sex)
                            };
    [PZHttpTool postHttpRequestUrl:@"user/modify/sex" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}
//修改地址
+(void)modifyUserAreaWithAddress:(NSString *)address Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"address":address
                            };
    [PZHttpTool postHttpRequestUrl:@"user/modify/userArea" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}
// 详细资料
+(void)requestFriendTnfoWithUserId:(NSInteger)userId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"friendUserId":@(userId)
                            };
    [PZHttpTool postRequestUrl:@"friend/info" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}

+(void)requestFriendVerifyInfoWithInviteId:(NSInteger)inviteId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"inviteId":@(inviteId)
                            };
    [PZHttpTool postRequestUrl:@"friend/verityInfo" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}

// 我的朋友列表
+(void)requestFriendListWithUserId:(NSInteger)userId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"relationType":@(userId)
                            };
    [PZHttpTool postRequestUrl:@"friend/list" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}
// 朋友圈的资料
+(void)requestFriendSelfProfitWithType:(NSString *)type Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"type":type
                            };
    [PZHttpTool postRequestUrl:@"friendSelfProfit" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}

// 订单数量
+(void)requestOrderInfoWithSuccess:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"version":@"new"
                            };
    [PZHttpTool postRequestUrl:@"order/info" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}

// 代理改版信息
+(void)requestDelegateRebateWithSuccess:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject]
                            };
    [PZHttpTool postRequestUrl:@"client/delegate/rebate/myRebateInfo" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}


//4、获取用户每个级别的返利信息
//
//请求路径: /client/delegate/rebate/delegateRebateInfoMsg
//请求方法: POST
//请求参数:
//
//
//{
//    
//    "accessInfo":{"access_token":"3e13fd9d06324e429af44ae3d27a4ef4","app_key":"b5958b665e0b4d8cae77d28e1ad3f521","phone_num":"o_KegwQb7-DBzyM69cCXAZbvwfD4","signature":"D6653621A719B92F3E914659B0E317AD"}
//}

// 我的返利
+(void)requestDelegateRebateInfoMsgWithSuccess:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject]
                            };
    [PZHttpTool postRequestUrl:@"client/delegate/rebate/delegateRebateInfoMsg" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}
//
//2、代理邀请用户 A B C的人数
//
//请求路径: /client/delegate/rebate/userInviterAmountMsg
//请求方法: POST
//请求参数:
//
//
//{
//    
//    "accessInfo":{"access_token":"16f8f5de98bd46978a64349b7f1581cc","app_key":"b5958b665e0b4d8cae77d28e1ad3f521","phone_num":"15038118651","signature":"C3688577AA1D85EDD6920D239272B047"}

// 代理邀请用户
+(void)requestUserInviterAmountMsgWithSuccess:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject]
                            };
    [PZHttpTool postRequestUrl:@"client/delegate/rebate/userInviterAmountMsg" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}

// 获取某个级别下的用户数量
+(void)requestLevelUserInfoMsgWithUserId:(NSString *)userId Level:(NSString*)level PageNo:(int)pageNo Size:(int)size Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"pageNo":@(pageNo),
                            @"size":@(size),
                            @"level":level,
                            @"userId":userId
                            };
    [PZHttpTool postRequestUrl:@"client/delegate/rebate/levelUserInfoMsg" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}


// 返利月信息
+(void)requestrebateMonthMsgWithPageNo:(int)pageNo Size:(int)size Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"pageNo":@(pageNo),
                            @"size":@(size)
                            };
    [PZHttpTool postRequestUrl:@"client/delegate/rebate/rebateMonthMsg" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}

// 根据月获取用户详细返利
+(void)requestRebateDetailByMonthWithYear:(NSString *)year Month:(NSString *)month PageNo:(int)pageNo Size:(int)size Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"pageNo":@(pageNo),
                            @"size":@(size),
                            @"year":year,
                            @"month":month
                            };
    [PZHttpTool postRequestUrl:@"client/delegate/rebate/rebateDetailByMonth" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
}

//请求路径：/award/win/records
//请求方法：POST
//请求参数：
//
//{
//    "accessInfo":{
//        "app_key":"b5958b665e0b4d8cae77d28e1ad3f521",
//        "access_token":"e1b2478b957f412d9f94a7c545eda082",
//        "phone_num":"18601250910",
//        "signature":"4CC219C0F50F4BDAB6F3CA9F35001014"
//    },
//    "status": "acceptPrize",//状态（待领奖：create，待收货：acceptPrize，待晒单：finish）
//    "size": 10,
//    "pageNo": 0
//}
+(void)requestWiningOrderListWithPageNo:(int)pageNo Size:(int)size Status:(NSString *)status Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"pageNo":@(pageNo),
                            @"size":@(size),
                            @"status":status
                            };
    [PZHttpTool postRequestUrl:@"stockWinOrders" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];

}
//26、发货消息提醒

+(void)stockWinOrderShowWithTradeOrderId:(NSInteger)tradeOrderId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"tradeOrderId":@(tradeOrderId)
                            };
    [PZHttpTool postRequestUrl:@"remindSend" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
    
}
// 中奖订单信息
+(void)requestWiningOrderInfoWithTradeOrderId:(NSInteger)tradeOrderId Success:(PZRequestSuccess)success failBlock:(PZRequestFailure)fail
{
    PZAccessInfo *accessInfo = [PZParamTool createAccessInfo];
    NSDictionary *param = @{
                            @"accessInfo":[accessInfo yy_modelToJSONObject],
                            @"tradeOrderId":@(tradeOrderId)
                            };
    [PZHttpTool postRequestUrl:@"stockWinOrderDetail" parameters:param successBlock:^(id json) {
        success(json);
    } fail:^(id json) {
        fail(json);
    }];
    
}
@end
