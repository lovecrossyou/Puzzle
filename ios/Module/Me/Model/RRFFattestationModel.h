//
//  RRFFattestationModel.h
//  Puzzle
//
//  Created by huibei on 16/9/6.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRFFattestationModel : NSObject

// 名字
@property(nonatomic,strong)NSString *realName;
// 身份证号
@property(nonatomic,strong)NSString *cardIdNumber;
// 职务名字
@property(nonatomic,strong)NSString *jobName;
// 简介
@property(nonatomic,strong)NSString *descriptionStr;
// 公司名字
@property(nonatomic,strong)NSString *companyName;
//身份证照片
@property(nonatomic,strong)NSArray *cardIdImages;
///职称照片
@property(nonatomic,strong)NSArray *professionalImages;

@end
