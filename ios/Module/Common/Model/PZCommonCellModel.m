//
//  PZCommontCellModel.m
//  Puzzle
//
//  Created by huibei on 16/8/3.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "PZCommonCellModel.h"

@implementation PZCommonCellModel
+(instancetype)cellModelWithIcon:(NSString *)icon title:(NSString *)title subTitle:(NSString *)subTitle accessoryType:(UITableViewCellAccessoryType)accessoryType descVc:(Class)descVc
{
    PZCommonCellModel *model = [[PZCommonCellModel alloc]init];
    model.icon = icon;
    model.title = title;
    model.subTitle = subTitle;
    model.accessoryType = accessoryType;
    model.descVc = descVc;
    model.editable = YES;
    return model;
}
-(instancetype)initWithTitle:(NSString*)title{
    if (self = [super init]) {
        self.title = title ;
        self.editable = YES;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self ;
}
@end
