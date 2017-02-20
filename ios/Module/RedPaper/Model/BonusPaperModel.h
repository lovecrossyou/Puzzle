//
//  BonusPaperModel.h
//  Puzzle
//
//  Created by huibei on 17/1/17.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface AcceptModel : NSObject
@property(nonatomic,strong)NSString *acceptIconUrl;
@property(nonatomic,strong)NSString *acceptUserName;
@property(nonatomic,strong)NSString *message;
@property(nonatomic,strong)NSString *acceptTime;
@property(nonatomic,assign)NSInteger averageMount;
@property(nonatomic,assign)NSInteger accepterId;
@property(nonatomic,strong)NSString *isBest;
@property(nonatomic,assign)NSInteger selfReceiveMonut;

@end


@interface BonusPaperModel : NSObject

@property(nonatomic,strong)NSString *sendIconUrl;
@property(nonatomic,strong)NSString *sendUserName;
@property(nonatomic,strong)NSString *desInfo;
@property(nonatomic,assign)NSInteger bonusPackageId;
@property(nonatomic,assign)NSInteger sendUserId;
@property(nonatomic,strong)NSString *place;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,assign)NSInteger mount;
@property(nonatomic,strong)NSString *isReceive;
@property(nonatomic,strong)AcceptModel *acceptModel;
@property(nonatomic,strong)NSArray *acceptModels;
@property(nonatomic,assign)NSInteger totalCount;
@property(nonatomic,assign)NSInteger receiveCount;
@property(nonatomic,assign)NSInteger totalMount;
@property(nonatomic,assign)NSInteger receiveMount;
@property(nonatomic,assign)NSString *finshUseTime;
@property(nonatomic,assign)NSInteger selfReceiveMonut;
@property(nonatomic,strong)NSString *bonusType;//average  random
@end
