//
//  ContactManager.m
//  contactsDemo
//
//  Created by frankhou on 15/8/25.
//  Copyright (c) 2015年 qinggong. All rights reserved.
//

#import "ContactManager.h"
#import "Contact.h"
#import "RRFDetailInfoModel.h"
#import "PZContact.h"
#import <AddressBook/AddressBook.h>

@interface ContactManager ()

//通讯录
@property (nonatomic, strong) NSArray *myContacts;
@property (nonatomic, strong) NSMutableDictionary *contactsDic;

//朋友圈
@property (nonatomic, strong) NSArray *myFriends;
@property (nonatomic, strong) NSMutableDictionary *friendsDic;

//我的通讯录
@property (nonatomic, strong) NSArray *myPlatFormContacts;
@property (nonatomic, strong) NSMutableDictionary *platFormContactsDic;

@end

@implementation ContactManager

+ (NSString *)phonetic:(NSString*)sourceString
{
    if (sourceString == nil) {
        return @"#" ;
    }
    NSMutableString *source = [sourceString mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
    return source;
}

- (instancetype)initWithFriends:(NSArray *)friends{
    if (self = [super init]) {
        _myFriends = friends;
    }
    return self;
}


- (instancetype)initWithArray:(NSArray *)contacts
{
    if (self = [super init]) {
        _myContacts = contacts;
    }
    return self;
}

- (NSDictionary *)friendsWithGroup{
    for ( RRFDetailInfoModel* friend in _myFriends) {
        NSString *nameInEnglish = [ContactManager phonetic:friend.cnName];
        nameInEnglish = [nameInEnglish capitalizedString];
        if (nameInEnglish.length == 0) {
            nameInEnglish = @"-" ;
        }
        unichar k = [nameInEnglish characterAtIndex:0];
        if (!(k >= 'A' && k <= 'Z')) {
            k = '#';
        }
        NSString *key = [NSString stringWithFormat:@"%c",k];
        
        NSMutableArray *arrayGroupK = [self.friendsDic objectForKey:key];
        if (!arrayGroupK) {
            arrayGroupK = [[NSMutableArray alloc]initWithCapacity:5];
            [arrayGroupK addObject:friend];
            if (nil == self.friendsDic) {
                self.friendsDic = [[NSMutableDictionary alloc]initWithCapacity:5];
            }
            [self.friendsDic setObject:arrayGroupK forKey:key];
        }else{
            [arrayGroupK addObject:friend];
        }
    }
    return self.friendsDic ;
}


- (NSDictionary *)contactsWithGroup
{
    for(id item in _myContacts)
    {
        Contact *people = [Contact contactWithItem:item];
        
        NSString *nameInEnglish = [ContactManager phonetic:people.name];
        nameInEnglish = [nameInEnglish capitalizedString];
        if (nameInEnglish.length == 0) {
            nameInEnglish = @"-" ;
        }
        unichar k = [nameInEnglish characterAtIndex:0];
        if (!(k >= 'A' && k <= 'Z')) {
            k = '#';
        }
        NSString *key = [NSString stringWithFormat:@"%c",k];
        
        NSMutableArray *arrayGroupK = [self.contactsDic objectForKey:key];
        if (!arrayGroupK) {
            arrayGroupK = [[NSMutableArray alloc]initWithCapacity:5];
            [arrayGroupK addObject:people];
            if (nil == self.contactsDic) {
                self.contactsDic = [[NSMutableDictionary alloc]initWithCapacity:5];
            }
            [self.contactsDic setObject:arrayGroupK forKey:key];
        }else{
            [arrayGroupK addObject:people];
        }
    }
    
    return self.contactsDic;
}

//PZContact
- (NSDictionary *)platformContactsWithGroup{
    for ( PZContact* friend in _myPlatFormContacts) {
        NSString *nameInEnglish = [ContactManager phonetic:friend.userName];
        nameInEnglish = [nameInEnglish capitalizedString];
        if (nameInEnglish.length == 0) {
            nameInEnglish = @"-" ;
        }
        unichar k = [nameInEnglish characterAtIndex:0];
        if (!(k >= 'A' && k <= 'Z')) {
            k = '#';
        }
        NSString *key = [NSString stringWithFormat:@"%c",k];
        
        NSMutableArray *arrayGroupK = [self.platFormContactsDic objectForKey:key];
        if (!arrayGroupK) {
            arrayGroupK = [[NSMutableArray alloc]initWithCapacity:5];
            [arrayGroupK addObject:friend];
            if (nil == self.platFormContactsDic) {
                self.platFormContactsDic = [[NSMutableDictionary alloc]initWithCapacity:5];
            }
            [self.platFormContactsDic setObject:arrayGroupK forKey:key];
        }else{
            [arrayGroupK addObject:friend];
        }
    }
    return self.platFormContactsDic ;
}

- (instancetype)initWithPlatformContacts:(NSArray *)friends{
    if (self = [super init]) {
        _myPlatFormContacts = friends;
    }
    return self;
}


-(void)saveConatctList:(NSArray*)contactlist{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];

    RLMResults<Contact *>* results = [Contact allObjects];
    [realm deleteObjects:results];
    for (Contact* c in contactlist) {
        [realm addObject:c];
    }
    [realm commitWriteTransaction];
}

-(NSArray*)getOldContacts{
    RLMResults<Contact *>* results = [Contact allObjects];
    NSMutableArray* contactsOld = [NSMutableArray array];
    for (Contact* contact in results) {
        [contactsOld addObject:contact];
    }
    return contactsOld;
}

-(NSArray*)getNewlyContactList:(NSArray *)contactlist{
    NSArray* oldContacts = [self getOldContacts];
    if (oldContacts.count == 0) {
        [self saveConatctList:contactlist];
        return [self convertConatcts:contactlist] ;
    }
    NSMutableArray* contactsNewly = [NSMutableArray array];
    for (Contact* c in contactlist) {
        if (![self isExistContact:c in:oldContacts]) {
            [contactsNewly addObject:c];
        }
    }
    if (contactsNewly.count != 0) {
        [self saveConatctList:contactlist];
    }
    return [self convertConatcts:contactsNewly] ;
}

-(BOOL)isExistContact:(Contact*)c in:(NSArray*)oldContacts{
    BOOL exist = NO ;
    for (Contact* o in oldContacts) {
        if ([c.phone isEqualToString:o.phone]) {
            exist = YES ;
        }
    }
    return exist ;
}


-(NSArray*)convertConatcts:(NSArray*)contacts{
    NSMutableArray* arr = [NSMutableArray array];

    for (Contact* c in contacts) {
        NSString* name = c.name ;
        NSString* phone = c.phone ;
        if (name == nil) {
            continue;
        }
        if (phone == nil) {
            continue;
        }
        [arr addObject:@{@"userName":name,@"phoneNum":phone}];
    }
    return arr ;
}
@end
