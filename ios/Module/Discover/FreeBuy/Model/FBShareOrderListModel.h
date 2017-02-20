//
//  FBShareOrderListModel.h
//  Puzzle
//
//  Created by 朱理哲 on 2016/12/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FBPurchaseGameInfo :NSObject
@property(nonatomic,assign)NSInteger bidCount;
@property(nonatomic,assign)NSInteger luckCode;
@property(nonatomic,assign)NSInteger purchaseGameId;
@property(nonatomic,assign)NSInteger stage;
@property(nonatomic,copy)NSString *desc;
@property(nonatomic,copy)NSString *finishTime;
@property(nonatomic,copy)NSString *productName;
@property(nonatomic,copy)NSString *pic;

@end

@interface FBShareOrderModel : NSObject
@property(nonatomic,assign)NSInteger userId;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,assign)NSInteger ID;
@property(strong,nonatomic) NSArray* pictures ;
@property(strong,nonatomic) FBPurchaseGameInfo* purchaseGameInfo;
@property(strong,nonatomic) NSString* time;
@property(strong,nonatomic) NSString* userIcon;
@property(strong,nonatomic) NSString* userName;
@property(strong,nonatomic) NSString* userSex;
@end

@interface FBShareOrderListModel : NSObject
@property(strong,nonatomic) NSArray* content ;
@property(assign,nonatomic) BOOL last;
@end


