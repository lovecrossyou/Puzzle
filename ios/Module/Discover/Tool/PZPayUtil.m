//
//  JNQPayUtil.m
//  Puzzle
//
//  Created by HuHuiPay on 16/8/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZPayUtil.h"
#import "PZParamTool.h"
#import "JNQConfirmOrderModel.h"
#import "JNQHttpTool.h"
#import "UPPayPlugin.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "JNQConfirmOrderParam.h"

@interface PZPayUtil () <UPPayPluginDelegate,WXApiDelegate>

@end

@implementation PZPayUtil 

static UIViewController* _controller ;
static ItemClickParamBlock _complete ;
static PZPayUtil* sharedInstance ;

+(PZPayUtil *)sharedInstance
{
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}

- (void)payWithPayReadyModel:(JNQPayReadyModel *)payReadyModel complete:(ItemClickParamBlock)complete sender:(UIViewController *)sender {
    _controller = sender ;
    if (complete != nil) {
        _complete= complete ;
    }
    NSDictionary *param = [payReadyModel yy_modelToJSONObject];
    [JNQHttpTool JNQHttpRequestWithURL:@"tradeOrder/confirm" requestType:@"post" showSVProgressHUD:YES parameters:param successBlock:^(id json) {
        JNQConfirmOrderParam* model = [JNQConfirmOrderParam yy_modelWithJSON:json];
        if ([payReadyModel.channel isEqualToString:UnionPay]) {
            //银联
            [self uniPayWithConfirmOrder:model];
        }
        else if ([payReadyModel.channel isEqualToString:WeixinPay] ){
            //微信
            [self wechatPayWithConfirmOrder:model];
        }
        else if ([payReadyModel.channel isEqualToString:AlipayClient]){
            //支付宝
            [self aliPayWithConfirmOrder:model];
        }
        [MBProgressHUD dismiss];
    } failureBlock:^(id json) {
        [MBProgressHUD dismiss];
    }];
}

- (void)UPPayPluginResult:(NSString *)result {
    [MBProgressHUD dismiss];
    if (_complete != nil) {
        _complete(result);
    }
}

#pragma mark - 银联支付
- (void)uniPayWithConfirmOrder:(JNQConfirmOrderParam*)confirmOrder {
    [UPPayPlugin startPay:confirmOrder.tn mode:@"00" viewController:_controller delegate:self];
}

#pragma mark - 微信支付
- (void)wechatPayWithConfirmOrder:(JNQConfirmOrderParam*)confirmOrder {
    WeXinSpec* comfirm = confirmOrder.wexinSpec;
    if (comfirm != nil) {
        PayReq* request = [[PayReq alloc] init];
        request.partnerId = comfirm.partnerid;
        request.prepayId = confirmOrder.tn;
        request.package = comfirm.packageValue;
        request.nonceStr = comfirm.noncestr;
        NSString* timestamp = comfirm.timestamp;
        request.timeStamp = timestamp.intValue;
        request.nonceStr = comfirm.noncestr;
        request.sign = comfirm.sign;
        [WXApi sendReq:request];
    }
}
#pragma mark - 支付宝支付
- (void)aliPayWithConfirmOrder:(JNQConfirmOrderParam*)confirmOrder {
    NSString* appScheme = @"com.huibei.puzzle" ;
    AliPayModel* aliModel = confirmOrder.paras ;
    [[AlipaySDK defaultService] payOrder:aliModel.info fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        [[NSNotificationCenter defaultCenter] postNotificationName:QueryOrderState object:nil];
    }];
}


+ (id)allocWithZone:(struct _NSZone *)zone {
    @synchronized (self) {
        if (sharedInstance == nil) {
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}


@end
