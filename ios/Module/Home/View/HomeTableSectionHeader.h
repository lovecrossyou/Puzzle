//
//  HomeTableSectionHeader.h
//  Puzzle
//
//  Created by huipay on 2016/9/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

typedef void(^RankTypeSwitch)(int type);
#import <UIKit/UIKit.h>


@interface HomeSecHeader : UIView
@property(copy,nonatomic)RankTypeSwitch rankTypeBlock ;
@end

@interface HomeTableSectionOne : UIControl
@end

@interface HomeTableSectionTwo : UIView

@end
