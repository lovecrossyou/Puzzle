//
//  RRFWenBarCellModel.h
//  Puzzle
//
//  Created by huibei on 16/8/31.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RRFAnswerModel,RRFQuestionModel;
@interface RRFWenBarCellModel : NSObject
@property(nonatomic,strong)RRFQuestionModel *questionModel;
@property(nonatomic,strong)NSArray *answerModels;

@end

@interface RRFQuestionModel : NSObject

@property(nonatomic,strong)NSString *questionUserIconUrl;
@property(nonatomic,strong)NSString *questionContent;
@property(nonatomic,strong)NSString *questionUserName;
@property(nonatomic,assign)NSInteger questionId;
@property(nonatomic,strong)NSString *time;

@end
@interface RRFAnswerModel : NSObject

@property(nonatomic,assign)NSInteger answerId;
@property(nonatomic,assign)NSInteger answerUserId;
@property(nonatomic,strong)NSString *answerUserIconUrl;
@property(nonatomic,strong)NSString *answerUserName;
@property(nonatomic,strong)NSString *answerContent;
@property(nonatomic,strong)NSArray *answerImages;
//回答的时间
@property(nonatomic,strong)NSString *answerTime;
// 点赞数量
@property(nonatomic,assign)NSInteger praiseAmount;
// 是否点赞 noPraise  表示 没点赞 alreadyPraise表示 已经点赞
@property(nonatomic,strong)NSString *isPraise;
// 是否打赏  noPresent没打赏 aleradyPesent 已经打赏
@property(nonatomic,strong)NSString *isPresentDiamonds;

@end


@interface RRFQuestionModelList : NSObject
@property NSArray *content ;
@property(assign,nonatomic)BOOL last ;
@end

@interface RRFWenBarCellModelList : NSObject
@property NSArray *content ;
@property(assign,nonatomic)BOOL last ;
@end

