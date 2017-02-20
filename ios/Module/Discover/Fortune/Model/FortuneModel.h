//
//  FortuneModel.h
//  Puzzle
//
//  Created by huibei on 16/12/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FortuneModel : NSObject
@property NSString* content ;
@property NSString* explanationTitle ;
@property NSString* fortuneDay ;
@property NSInteger fortuneId ;
@property NSInteger ID ;
@property int point ;
@property NSString* signName ;
@end

@interface FortuneListModel : NSObject
@property NSArray* content ;
@property(assign,nonatomic) BOOL last ;
@property(assign,nonatomic) int totalElements ;

@end
