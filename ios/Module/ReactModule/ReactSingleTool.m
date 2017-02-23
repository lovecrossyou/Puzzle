//
//  ReactSingleTool.m
//  Puzzle
//
//  Created by huibei on 17/2/23.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "ReactSingleTool.h"

@implementation ReactSingleTool
static ReactSingleTool* sharedInstance ;

+(ReactSingleTool *)sharedInstance{
  @synchronized(self) {
    if (sharedInstance == nil) {
      sharedInstance = [[self alloc] init];
    }
  }
  return sharedInstance;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
  @synchronized (self) {
    if (sharedInstance == nil) {
      sharedInstance = [super allocWithZone:zone];
      return sharedInstance;
    }
  }
  return nil;
}

-(id)copyWithZone:(NSZone *)zone
{
  return self;
}

@end
