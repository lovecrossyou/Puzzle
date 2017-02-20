//
//  ContactManager.h
//  contactsDemo
//
//  Created by frankhou on 15/8/25.
//  Copyright (c) 2015年 qinggong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactManager : NSObject
@property (nonatomic, strong) NSDictionary *filterContactsDic;
@property (nonatomic, copy) NSArray *filterKeys;


- (instancetype)initWithArray:(NSArray *)contacts;
- (NSDictionary *)contactsWithGroup;

- (NSDictionary *)friendsWithGroup;
- (instancetype)initWithFriends:(NSArray *)friends;


- (NSDictionary *)platformContactsWithGroup;
- (instancetype)initWithPlatformContacts:(NSArray *)friends;

-(NSArray*)getNewlyContactList:(NSArray*)contactlist;
@end
