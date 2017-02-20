//
//  RRFAddressModel.h
//  Puzzle
//
//  Created by huibei on 16/8/27.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRFAddressModel : NSObject

@property(nonatomic,assign)NSInteger addressId;
@property(nonatomic,strong)NSString *fullAddress;
@property(nonatomic,strong)NSString *phoneNumber;
@property(nonatomic,strong)NSString *recievName;

@end
