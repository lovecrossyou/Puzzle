//
//  NotificateMsgModel.h
//  Puzzle
//
//  Created by huipay on 2016/10/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface NotificateMsgModel : RLMObject
@property NSNumber<RLMInt>* type ;
@property NSNumber<RLMBool>* read ;
@property NSString* content ;
@end
