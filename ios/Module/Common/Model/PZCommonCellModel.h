//
//  PZCommontCellModel.h
//  Puzzle
//
//  Created by huibei on 16/8/3.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZCommonBaseModel.h"

@interface PZCommonCellModel : PZCommonBaseModel
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *subTitle;
@property(nonatomic,assign)UITableViewCellAccessoryType accessoryType;
@property(nonatomic,copy)NSString *rightIcon;

@property(nonatomic,copy)Class descVc;
@property(nonatomic,strong)UIView *accessoryView;
@property(assign,nonatomic) BOOL editable ;


+(instancetype)cellModelWithIcon:(NSString *)icon title:(NSString *)title subTitle:(NSString *)subTitle accessoryType:(UITableViewCellAccessoryType)accessoryType descVc:(Class)descVc;
-(instancetype)initWithTitle:(NSString*)title;
@end
