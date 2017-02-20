//
//  HomeRankModel.h
//  Puzzle
//
//  Created by huipay on 2016/8/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeRankModel : NSObject
//addGuessAmount = "<null>";
//bonusXtbAmount = 4000;
//hitAmount = "<null>";
//hitRate = "<null>";
//iconUrl = "";
//identityType = "<null>";
//ranking = "<null>";
//userName = "\U6731\U7406\U54f2";

@property(assign,nonatomic)int bonusXtbAmount ;
@property(strong,nonatomic)NSString* iconUrl ;
@property(strong,nonatomic)NSString* userName ;
@property(nonatomic,assign)NSInteger userId;
@property(strong,nonatomic)NSString* addGuessAmount ;
@property(strong,nonatomic)NSString* hitAmount ;
@property(strong,nonatomic)NSString* hitRate ;
@property(strong,nonatomic)NSString* identityType ;
@property(assign,nonatomic)int ranking ;

@end
