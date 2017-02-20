//
//  Contact.h
//  CommandLineDemo
//
//  Created by frankhou on 7/9/15.
//  Copyright (c) 2015 qinggong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface Contact : RLMObject

@property  NSString *name;
@property NSString *phone;

+ (instancetype)contactWithItem:(id)item;
- (instancetype)initWithItem:(id)item;

@end
