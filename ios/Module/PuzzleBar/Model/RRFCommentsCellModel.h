//
//  RRFCommentsCellModel.h
//  Puzzle
//
//  Created by huibei on 16/8/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PraiseUsersModel : NSObject
@property(nonatomic,assign)int identityType ;
@property(nonatomic,strong) NSString* sex ;
@property(nonatomic,strong) NSString* userIconUrl ;
@property(nonatomic,assign) NSInteger userId ;
@property(nonatomic,strong) NSString* userName ;
@property(nonatomic,strong) NSString* userStatue ;

@end


@interface RRFCommentsCellModel : NSObject
@property(nonatomic,strong)NSIndexPath *indexPath;
// 点赞的用户列表
@property(nonatomic,strong)NSArray *praiseUsers;
// 赞赏的用户列表
@property(nonatomic,strong)NSArray *presentUsers;
// 性别
@property(nonatomic,strong)NSString *sex;
// 是否已经认证
@property(nonatomic,strong)NSString *userStatue;
@property(nonatomic,strong)NSString *userIconUrl;
@property(nonatomic,strong)NSString *userName;
//aise表示 没赞过 alreadyPraise表示已经赞过
@property(nonatomic,strong)NSString *isPraise;
@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSArray *contentImages;
@property(assign,nonatomic)int userId;
//打赞钻石的数量
@property(assign,nonatomic)int presentDiamondAmount;
@property(assign,nonatomic)int presentXtbAmount;

//赞的数量
@property(assign,nonatomic)int praiseAmount;
//回复的数量
@property(assign,nonatomic)int responseAmount;
@property(nonatomic,assign)int ID;
// 是否是自己发的 self自己 other 其它
@property(nonatomic,strong)NSString *isSelfComment;
// 是否是自己打赏 //noPresnt没打赏 alreadyPresnt已经打赏
@property(nonatomic,strong)NSString *isPresentDiamond;


//{
//    commentModel =             {
//        content = "The only thing that would make it ";
//        contentImages =                 (
//                                         {
//                                             "big_img" = "http://114.251.53.22/M00/00/3C/wKgKZlghyEOAJ5KWAAAlVZ5q2fs498.jpg";
//                                             "head_img" = "http://114.251.53.22/M00/00/3C/wKgKZlghyEOAJyVSAAAG3S7NV8s233.jpg";
//                                         },
//                                         {
//                                             "big_img" = "http://114.251.53.22/M00/00/3C/wKgKZlghyEOAXIeQAAAtA3zFB9o819.jpg";
//                                             "head_img" = "http://114.251.53.22/M00/00/3C/wKgKZlghyEOAQOFJAAAHeeweqd4395.jpg";
//                                         }
//                                         );
//        title = "<null>";
//    };
//    description = "\U4eb2,\U6211\U9001\U4f60100\U559c\U817e\U5e01,";
//    guessAmount = "<null>";
//    guessWithStockModel = "<null>";
//    iconUrl = "http://wx.qlogo.cn/mmopen/BMHKHSSSwmcVqviczyOnYe4zoJ0siapApxuukmK4xmWj19NVadQibmsiaOox8uNCImicf2Fuhm6xYHQR2Yx0KnF1iaUMNLVWxAHkVm/0";
//    id = 7;
//    isPraise = noPraise;
//    isPresentXitengB = noPresnt;
//    isSelfComment = self;
//    praiseAmount = 0;
//    presentXitengBAmount = 0;
//    ranking = "<null>";
//    responseAmount = 0;
//    sex = "\U5973";
//    time = "2016-11-08";
//    type = friendCircleComment;
//    userId = 6;
//    userName = "\U7136\U540e";
//    userStatue = "<null>";
//},


@end
