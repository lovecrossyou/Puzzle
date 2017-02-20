//
//  FriendCircleHeader.m
//  Puzzle
//
//  Created by huibei on 16/11/8.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "FriendCircleHeader.h"
#import "PZTextView.h"
#import "CommentPictureDisplay.h"
#define rowCount 10
#define _margin 12
#define padding 8

@interface FriendCircleHeader()
@property(weak,nonatomic) PZTextView* textView ;
@property(weak,nonatomic) UIScrollView* scrollView ;
@property(weak,nonatomic) UISwitch* toggleView ;
@property(weak,nonatomic) UIScrollView* imageContent ;
@property(strong,nonatomic)NSMutableArray* images ;
@property(weak,nonatomic)UIButton* syncBnt ;

@end

@implementation FriendCircleHeader
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = HBColor(243, 243, 243);
        
        UIView* topView = [[UIView alloc]init];
        topView.backgroundColor = [UIColor whiteColor];
        [self addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(92);
        }];
        
        PZTextView* textView = [[PZTextView alloc]initWithPlaceHolder:@"分享智慧 共享财富"];
        textView.backgroundColor = [UIColor whiteColor];
        [self addSubview:textView];
        self.textView = textView ;
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(80);
        }];
        
        UIScrollView* scrollView = [[UIScrollView alloc]init];
        scrollView.backgroundColor = [UIColor whiteColor];

        [self addSubview:scrollView];
        self.scrollView = scrollView ;
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(textView.mas_bottom);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(60+18);
        }];
        self.imageContent = scrollView ;
        
        UIView* bottomView = [[UIView alloc]init];
        bottomView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bottomView];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(scrollView.mas_bottom).offset(20);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(44);
        }];
        
        UIButton* syncBnt = [UIButton new];
        [syncBnt setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [syncBnt setTitle:@" 同步到沙龙" forState:UIControlStateNormal];
        [syncBnt setImage:[UIImage imageNamed:@"publish-dynamic_icon_synchronize"] forState:UIControlStateNormal];
        syncBnt.titleLabel.font= PZFont(13.0f);
        [bottomView addSubview:syncBnt];
        self.syncBnt = syncBnt ;
        [syncBnt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.centerY.mas_equalTo(bottomView.mas_centerY);
            make.height.mas_equalTo(44);
        }];
        
        UISwitch* toggleView = [[UISwitch alloc]init];
        toggleView.on = YES ;
        [bottomView addSubview:toggleView];
        self.toggleView = toggleView ;
        [toggleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(bottomView.mas_centerY);
            make.right.mas_equalTo(-12);
        }];
        [self updateImages:@[]];
    }
    return self ;
}

-(void)updateImages:(NSArray *)images{
    self.images = [[NSMutableArray alloc]initWithArray:images];
    [self refreshImages];
    [self addDefaultBtn];
}

-(void)addDefaultBtn{
    UIImage* image = [UIImage imageNamed:@"add"];
    [self.images addObject:image] ;
    [self refreshImages];
}

-(NSMutableArray *)images{
    if (_images == nil) {
        _images = [NSMutableArray array];
    }
    return _images ;
}

-(void)removeImageAt:(NSUInteger)index{
    [self.images removeObjectAtIndex:index];
    [self refreshImages];
}

-(void)refreshImages{
    WEAKSELF
    //remove all
    NSArray* subImageViews = self.imageContent.subviews ;
    for (UIView* v in subImageViews) {
        [v removeFromSuperview];
    }
    NSArray* currentImages = self.images ;
    
    
    CGFloat imageSize = 60.0f ;
    CGFloat lastX = 0.0f ;
    NSUInteger count = currentImages.count ;
    for (int i = 0; i<count; i++) {
        BOOL lastImg = i == count-1 ;
        UIImage* img = currentImages[i] ;
        CommentPicture* pictureView = [[CommentPicture alloc]initWithImage:img isDefault:lastImg index:i];
        pictureView.delBlock = ^(NSNumber* index){
            [weakSelf removeImageAt:[index intValue]];
            weakSelf.delBlock(index);
        };
        pictureView.broswerBlock = ^(NSNumber* index){
            weakSelf.broswerBlock(@"");
        };
        if (lastImg) {
            [[pictureView rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                weakSelf.addBlock(@"");
            }];
        }
        NSUInteger row = i/rowCount ;
        NSUInteger column = i%rowCount ;
        CGFloat x = _margin + (imageSize + padding)*column ;
        CGFloat y = padding + (imageSize + padding)*row ;
        pictureView.frame = CGRectMake(x, y, imageSize, imageSize);
        [self.imageContent addSubview:pictureView];
        lastX = CGRectGetMaxX(pictureView.frame) ;
    }
    
    //update contentSize
    CGFloat totalWidth = lastX > SCREENWidth ? lastX : SCREENWidth ;
    self.imageContent.contentSize = CGSizeMake(totalWidth, 0);
}

-(NSString*)getContent{
    return  self.textView.textView.text ;
}

-(BOOL)syncState{
    return self.toggleView.isOn ;
}

@end
