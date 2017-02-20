//
//  PurchaseGameActivity.h
//  Puzzle
//
//  Created by huibei on 16/12/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PurchaseGameActivity : NSObject
@property(nonatomic,assign)NSInteger ID;
@property(strong,nonatomic) NSString* title;
@property(strong,nonatomic) NSString* picUrl;
@property(strong,nonatomic) NSString* link;
@property(strong,nonatomic) NSString* type;
@property(strong,nonatomic) NSString* content;


/*"id": 1,
"title": "大礼包",  //活动标题
"picUrl": "http://www.baidu.com/1.png",//活动图片
"link": "http://www.baidu.com",   //活动链接
"content": "夺宝大礼包，来了就赠送"   //活动说明*/
@end


@interface PurchaseGameActivityList : NSObject
@property(strong,nonatomic) NSArray* content ;

@end
