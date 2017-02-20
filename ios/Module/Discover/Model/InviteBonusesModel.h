//
//  InviteBonusesModel.h
//  Puzzle
//
//  Created by huipay on 2016/9/1.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface InviteBaseModel : NSObject
@property(assign,nonatomic) int acceptUserInviteAmout ;
@property(assign,nonatomic) int acceptUserId ;
@property(strong,nonatomic) NSString* acceptUserIconUrl ;
@property(strong,nonatomic) NSString* acceptUserName ;
@property(strong,nonatomic) NSString* hasGuess;
@property(assign,nonatomic) NSInteger xitengCode;
@property(strong,nonatomic) NSString* sex;
@end


@interface InviteBonuses : NSObject
@property(strong,nonatomic) InviteBaseModel* model ;
@property(assign,nonatomic) int bonusesXtb ;
@end

@interface InviteBonusesModel : NSObject
@property(strong,nonatomic) NSArray<InviteBonuses*>* content;
@property(assign,nonatomic) int oneLevelReward ;
@property(assign,nonatomic) int inviteBonusCount ;
@property(assign,nonatomic) int twoLevelReward ;
@property(assign,nonatomic) int twoLevelRewordStandard ;
@property(assign,nonatomic) int twoLevelPersonAmount;
@property(strong,nonatomic) NSString* selfUserIconUrl ;
@property(strong,nonatomic) NSString* selfUserName ;
@property(assign,nonatomic) int selfInviteAmount ;
@property(assign,nonatomic) int selfInviteBonusCount ;
@end


