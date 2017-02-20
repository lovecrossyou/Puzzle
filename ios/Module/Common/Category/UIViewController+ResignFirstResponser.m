//
//  UIViewController+ResignFirstResponser.m
//  HuiBeiWaterMerchant
//
//  Created by 朱理哲 on 16/5/23.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "UIViewController+ResignFirstResponser.h"

@implementation UIViewController (ResignFirstResponser)
- (UIView*)findFirstResponderBeneathView:(UIView*)view {
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] ) return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result ) return result;
    }
    return nil;
}

-(void)resignAll{
    for (UIView* child in self.view.subviews) {
        UIView* firstResponder = [self findFirstResponderBeneathView:child];
        if (firstResponder != nil) {
            [firstResponder resignFirstResponder];
        }
    }
}
@end
