//
//  RRFCommentContentListModel.h
//  Puzzle
//
//  Created by huibei on 16/8/27.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRFCommentContentListModel : NSObject
//{
//    isPraise = noPraise;
//    isSelfResponse = self;
//    respCommentContent = "\U725b\U903c";
//    respCommentImages =             (
//    );
//    respCommentPraiseAmount = 1;
//    respCommentUserIconUrl = "http://114.251.53.22/M00/00/02/wKgKZlfWdY-ADp78AAAlr8Wples83..jpg";
//    respCommentUserId = 9;
//    respCommentUserName = "\U77e5\U5df1";
//    respToRespList =             (
//    );
//    responseId = 197;
//}
// 时间
@property(nonatomic,strong)NSString *time;
// 性别
@property(nonatomic,strong)NSString *sex;
// 是否点赞过
@property(nonatomic,strong)NSString *isPraise;
// 是否是自己发送的 slef 代表自己 other代表其它
@property(nonatomic,strong)NSString *isSelfResponse;
// 回复者的内容
@property(nonatomic,strong)NSString *respCommentContent;
// 回复的图片集合
@property(nonatomic,strong)NSArray *respCommentImages;
// 回复的被点赞的次数
@property(nonatomic,assign)NSInteger respCommentPraiseAmount;
//回复者的头像地址
@property(nonatomic,strong)NSString *respCommentUserIconUrl;
// 回复的用户id
@property(nonatomic,assign)NSInteger respCommentUserId;
// 回复者的名字
@property(nonatomic,strong)NSString *respCommentUserName;
///回复的回复列表
@property(nonatomic,strong)NSArray *respToRespList;
// 回复的id
@property(nonatomic,assign)NSInteger responseId;




// 是否是自己的回复 slef 代表自己 other代表其它
//@property(nonatomic,strong)NSString *isPresentDiamond;













@end
