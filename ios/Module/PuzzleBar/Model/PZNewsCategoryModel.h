//
//  PZNewsCategoryModel.h
//  Puzzle
//
//  Created by huibei on 16/12/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PZNewsCategoryModel : NSObject
@property(nonatomic,assign)int ID;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *name;

@end

@interface PZNewsCategoryListModel : NSObject
@property NSArray *content ;
@end
