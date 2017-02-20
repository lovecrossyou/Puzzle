//
//  FortuneProductList.h
//  Puzzle
//
//  Created by huibei on 16/12/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FortuneProduct : NSObject
@property NSString* desc ;
@property NSString* name ;
@property NSInteger count ;
@property CGFloat price ;
@property int productId ;
@property (nonatomic, assign) int shopId;
@property (nonatomic, assign) int productType;
@property NSString* image ;

@end

@interface FortuneProductList : NSObject
@property NSArray* fortuneList ;
@end
