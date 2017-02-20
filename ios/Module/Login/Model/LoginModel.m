
//  Created by  on 16/6/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel

-(NSString *)xtNumber{
    if ([_xtNumber isEqualToString:@"0"]) {
        return @"" ;
    }
    return _xtNumber ;
}
@end
