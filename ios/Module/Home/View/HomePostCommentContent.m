//
//  HomePostCommentContent.m
//  Puzzle
//
//  Created by huipay on 2016/12/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "HomePostCommentContent.h"
#import "CommentPictureDisplay.h"
#import "PZTextView.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import "TZImageManager.h"
@interface HomePostCommentContent()
@property(nonatomic,weak)PZTextView* pzTextView;
@end

@implementation HomePostCommentContent
-(instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        WEAKSELF
        PZTextView* textView = [[PZTextView alloc]initWithPlaceHolder:@"这一刻的想法..."];
        textView.backgroundColor = [UIColor whiteColor];
        self.pzTextView = textView;
        [self addSubview:textView];
        self.textView = textView.textView ;
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_offset(12);
            make.right.mas_offset(-12);
            make.height.mas_offset(120 - 30);
        }];
        
        CommentPictureDisplay* picListPanel = [[CommentPictureDisplay alloc]initWithMargin:0 padding:8 rowCount:3];
        picListPanel.addBlock = ^(id obj){
            
        };
        
        picListPanel.delBlock = ^(id obj){
            weakSelf.delItemHandler(obj);
        };
        
        picListPanel.broswerBlock = ^(id obj){
            self.tapPhotoHandler(NO);
        };
        
        self.picListPanel = picListPanel ;
        self.picListPanel.userInteractionEnabled = YES ;
        [self addSubview:self.picListPanel];
        [self.picListPanel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(textView.mas_bottom).offset(12);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.bottom.mas_equalTo(0);
        }];
        [self updateImages:@[]];
    }
    return self ;
}
-(void)setPlaceHolder:(NSString *)placeHolder
{
    [self.pzTextView setPlaceHolder:self.placeHolder];

}
-(void)setHiddenPhoto:(BOOL)hiddenPhoto
{
    self.picListPanel.hidden = hiddenPhoto;
}
-(void)updateImages:(NSArray *)images{
    [self.picListPanel updateImages:images];
}
@end


