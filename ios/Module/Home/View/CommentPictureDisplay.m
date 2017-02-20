//
//  CommentPictureDisplay.m
//  Puzzle
//
//  Created by huipay on 2016/10/20.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "CommentPictureDisplay.h"


@implementation CommentPicture
-(instancetype)initWithImage:(UIImage*)image isDefault:(BOOL)defaultBtn index:(NSUInteger)index{
    if (self = [super init]) {
        self.userInteractionEnabled = YES ;
        WEAKSELF
        self.defaultBtn = defaultBtn ;
        UIButton* imageBtn = [[UIButton alloc]init];

        [imageBtn setImage:image forState:UIControlStateNormal];
        [self addSubview:imageBtn];
        [imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        if (!defaultBtn) {
            imageBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            imageBtn.layer.borderWidth = 0.5 ;
            imageBtn.layer.masksToBounds = YES ;
            
            
            UIButton* delIcon = [[UIButton alloc]init];
            [delIcon setImage:[UIImage imageNamed:@"comment_delete_img"] forState:UIControlStateNormal];
            [self addSubview:delIcon];
            [[delIcon rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                weakSelf.delBlock(@(index));
            }];
            [delIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(8);
                make.top.mas_equalTo(-8);
                make.size.mas_equalTo(CGSizeMake(30, 30));
            }];
        }
        else{
            [[imageBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                weakSelf.broswerBlock(@(index));
            }];
        }
    }
    return self ;
}

@end


@interface CommentPictureDisplay()
@property(assign,nonatomic) CGFloat margin ;
@property(assign,nonatomic) CGFloat padding ;
@property(assign,nonatomic) CGSize imageSize ;
@property(assign,nonatomic) NSUInteger rowCount ;

@property(weak,nonatomic) UIView* imageContent;
@property(strong,nonatomic)NSMutableArray* images ;
@end

@implementation CommentPictureDisplay

-(instancetype)initWithMargin:(CGFloat)margin padding:(CGFloat)padding rowCount:(NSUInteger)count{
    if (self = [super init]) {
        self.userInteractionEnabled = YES ;
        self.margin = margin ;
        self.padding = padding ;
        self.rowCount = count ;
        
        UIView* imageContent = [[UIView alloc]init];
        imageContent.userInteractionEnabled = YES ;
        [self addSubview:imageContent];
        self.imageContent = imageContent ;
        [imageContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return self ;
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

-(void)refreshImages{
    WEAKSELF
    //remove all
    NSArray* subImageViews = self.imageContent.subviews ;
    for (UIView* v in subImageViews) {
        [v removeFromSuperview];
    }
    NSArray* currentImages = self.images ;
    CGFloat imageSize = (SCREENWidth - 2*_margin - (_rowCount - 1)*_padding - 2*12)/_rowCount ;
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
        NSUInteger row = i/self.rowCount ;
        NSUInteger column = i%self.rowCount ;
        CGFloat x = _margin + (imageSize + _padding)*column ;
        CGFloat y = _padding + (imageSize + _padding)*row ;
        pictureView.frame = CGRectMake(x, y, imageSize, imageSize);
        [self.imageContent addSubview:pictureView];
    }
}

@end
