
//  Created by  on 16/5/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

typedef void(^GetUserNameBlock)(NSString* phoneNum);
#import <UIKit/UIKit.h>
@class WechatUserInfo;
@interface RRFFindPwdView : UIView
-(instancetype)initWithWechatUserInfo:(WechatUserInfo *)uesrInfo Reset:(BOOL)reset;
@property(strong,nonatomic)NSString* userNameStr ;
@property(nonatomic,copy)GetUserNameBlock getVerifyCodeBlock;
@property(nonatomic,copy)ItemClickBlock goProtocolBlock;
@end
