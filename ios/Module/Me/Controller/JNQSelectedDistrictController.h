//
//  RRFSelectedAreaController.h
//  Puzzle
//
//  Created by huibei on 16/8/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//


typedef void(^DistrictNameBlock)(NSString *districtName, NSInteger provinceId, NSInteger cityId );

@interface JNQSelectedDistrictController : UIViewController

@property (nonatomic, strong) DistrictNameBlock districtNameBlock;

@end
