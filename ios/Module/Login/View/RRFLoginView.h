
//  Created by  on 16/5/10.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

typedef void(^LoginBlock)(int type);
#import <UIKit/UIKit.h>
@class LoginModel;
@interface RRFLoginView : UIView
@property(strong,nonatomic) NSString* userName ;
@property(strong,nonatomic) NSString* pwd ;

@property(copy,nonatomic)LoginBlock loginBlock ;
@property(copy,nonatomic)ItemClickBlock openShopBlock ;
@property(copy,nonatomic)ItemClickBlock protocolBlock ;

@property(nonatomic,strong)LoginModel *loginM;
@end
