//
//  PZContact.h
//  Puzzle
//
//  Created by huibei on 16/11/9.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PZContact : NSObject
//"id": null,
//"status": "no_regist",
//"userName": "张三",
//"phoneNum": "18991132567",
//"iconUrl": null,
//"xitengCode": null

@property(nonatomic,assign)NSInteger ID;
@property(nonatomic,assign)NSInteger userId;

@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *phoneNum;
@property(nonatomic,strong)NSString *iconUrl;
@property(nonatomic,strong)NSString *xitengCode;
@end


@interface PZContactList : NSObject
@property(strong,nonatomic)NSArray* content ;
@end
