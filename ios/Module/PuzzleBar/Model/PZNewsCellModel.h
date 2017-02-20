//
//  PZNewsCellModel.h
//  Puzzle
//
//  Created by huibei on 16/12/22.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PZNewsCellModel : NSObject
@property(nonatomic,assign)int responseUserId;
//newMessageId
@property(nonatomic,assign)int newMessageId;
@property(nonatomic,strong)NSString *category;
@property(nonatomic,strong)NSString *realtype;
@property(nonatomic,strong)NSString *thumbnail_pic_s;
@property(nonatomic,strong)NSString *thumbnail_pic_s02;
@property(nonatomic,strong)NSString *thumbnail_pic_s03;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *author_name;
@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSString *url;

@end

@interface PZNewsCellListModel : NSObject
@property NSArray *content ;
@property BOOL last ;
@end
