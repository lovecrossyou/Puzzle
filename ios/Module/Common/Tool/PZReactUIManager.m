//
//  PZReactUIManager.m
//  Puzzle
//
//  Created by huibei on 17/2/16.
//  Copyright © 2017年 HuiBei. All rights reserved.
//

#import "PZReactUIManager.h"
#import <React/RCTRootView.h>
#import <CodePush/CodePush.h>

@implementation PZReactUIManager

+(UIView*)createWithPage:(NSString*)pageName params:(id)param size:(CGSize)size{
    if (param==nil) {
        param = @{};
    }
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:param];
    [params setObject:pageName forKey:@"page"];
    NSURL *jsCodeLocation;
#ifdef DEBUG
    jsCodeLocation = [NSURL
                    URLWithString:@"http://localhost:8081/index.ios.bundle?platform=ios"];
#else
    jsCodeLocation = [CodePush bundleURL];
#endif
    
    RCTRootView *rootView =[[RCTRootView alloc] initWithBundleURL : jsCodeLocation
                                                moduleName        : @"Puzzle"
                                                initialProperties :params
                                                 launchOptions    : nil];
    if (size.width != 0) {
        rootView.frame = CGRectMake(0, 0, size.width, size.height);
    }
    return rootView ;
}
@end
