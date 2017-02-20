//
//  JNQPresentProductModel.h
//  Puzzle
//
//  Created by HuHuiPay on 16/8/29.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

RLM_ARRAY_TYPE(Pictures)
@interface Picture : RLMObject
@property NSString *picUrl;
@end

@interface Pictures : RLMObject
//@property(assign,nonatomic)NSInteger output ;
@property NSString* picUrl ;
@end



@interface JNQPresentProductModel : RLMObject<NSMutableCopying>

@property NSString *picUrl;
@property NSInteger productId;
@property NSInteger price;
@property NSString *productName;
@property NSString *detail;
@property NSInteger inventory;
@property NSInteger sales;
@property NSInteger shopId;
@property NSString *smallPicture;
@property RLMArray<RLMObject *> *specifications;
@property RLMArray<RLMObject *> *pictures;
@property NSInteger count;
@property NSString *validState;
@property BOOL selected;

@end

