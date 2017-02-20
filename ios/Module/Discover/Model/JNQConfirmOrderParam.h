//
//  JNQConfirmOrderParam.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/30.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliPayModel:NSObject
@property (nonatomic, strong) NSString* _input_charset ;
@property (nonatomic, strong) NSString* body ;
@property (nonatomic, strong) NSString* info ;
@property (nonatomic, strong) NSString* it_b_pay ;
@property (nonatomic, strong) NSString* notify_url ;
@property (nonatomic, strong) NSString* out_trade_no ;
@property (nonatomic, strong) NSString* payment_type ;
@property (nonatomic, strong) NSString* partner ;
@property (nonatomic, strong) NSString* seller_id ;

@property (nonatomic, assign) CGFloat total_fee ;
@property (nonatomic, strong) NSString* service ;
@property (nonatomic, strong) NSString* subject ;
@property (nonatomic, strong) NSString* tn ;

@end

@interface WeXinSpec :NSObject
@property(copy,nonatomic) NSString* appid ;
@property(copy,nonatomic) NSString* noncestr ;
@property(copy,nonatomic) NSString* packageValue ;
@property(copy,nonatomic) NSString* partnerid ;
@property(copy,nonatomic) NSString* sign ;
@property(copy,nonatomic) NSString* timestamp ;

@end



@interface JNQConfirmOrderParam : NSObject

@property (nonatomic, assign) NSInteger orderNo;
@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) WeXinSpec *wexinSpec ;
@property (nonatomic, strong) AliPayModel *paras ;
@property (nonatomic, strong) NSString *tn;

@end
