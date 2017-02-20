//
//  RRFPhoneListModel.h
//  Puzzle
//
//  Created by huibei on 16/10/27.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRFPhoneListModel : NSObject
//northTel = "010-666666";
//southTel = "010-777777";
//tel = "010-888888";
@property(nonatomic,strong)NSString *tel;
// 北区
@property(nonatomic,strong)NSString *northTel;
// 南区
@property(nonatomic,strong)NSString *southTel;

@end
