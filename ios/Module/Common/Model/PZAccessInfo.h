//
//  PZAccessInfo.h
//  Puzzle
//
//  Created by huibei on 16/8/22.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PZAccessInfo : NSObject
@property(copy,nonatomic)NSString* app_key ;
@property(copy,nonatomic)NSString* signature ;
@property(copy,nonatomic)NSString* access_token ;
@property(copy,nonatomic)NSString* phone_num ;

@property(nonatomic,strong)NSString *loginType;
//version os
@property(copy,nonatomic)NSString* version ;
@property(copy,nonatomic)NSString* os ;

@end
