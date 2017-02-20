//
//  EChatTitle.m
//  Puzzle
//
//  Created by huipay on 2016/8/17.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "EChatTitle.h"

@implementation EChatTitle
-(instancetype)initWithTitle:(NSString*)title value:(float)value{
    if (self = [super init]) {
        UILabel*label = [[UILabel alloc]init];
        label.font = PZFont(13.0f);
        label.textColor = [UIColor lightGrayColor];
        NSString* titleString = [NSString stringWithFormat:@"%@  %.2f",title,value];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:titleString];
        NSRange range = [titleString rangeOfString:[NSString stringWithFormat:@"%.2f",value]];
        [string addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:range];
        [label setAttributedText:string];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return self ;
}

-(instancetype)initWithTitle:(NSString *)title value:(NSString*)value attr:(NSDictionary *)attr{
    if (self = [super init]) {
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromSuperview];
        }];
        UILabel*label = [[UILabel alloc]init];
        label.font = PZFont(13.0f);
        label.lineBreakMode = NSLineBreakByTruncatingTail ;
        label.textColor = [UIColor lightGrayColor];
        NSString* titleString = [NSString stringWithFormat:@"%@  %@",title,value];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:titleString];
        NSRange range = [titleString rangeOfString:[NSString stringWithFormat:@"%@",value]];
        if (attr != nil) {
            [string addAttributes:attr range:range];
        }
        else{
            [string addAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} range:range];
        }
        [label setAttributedText:string];
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return self ;
}

@end
