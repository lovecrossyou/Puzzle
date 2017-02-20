//
//  JPIMMore.m
//  JPush IM
//
//  Created by Apple on 14/12/30.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JCHATMoreView.h"
#import "JChatConstants.h"

@implementation JCHATMoreView

-(void)awakeFromNib{
    [super awakeFromNib];
    self.photoBtn.imageView.contentMode = UIViewContentModeScaleAspectFit ;
    self.photoBtn.titleLabel.textAlignment = NSTextAlignmentCenter ;
    
    self.cameraBtn.imageView.contentMode = UIViewContentModeScaleAspectFit ;
    self.cameraBtn.titleLabel.textAlignment = NSTextAlignmentCenter ;
    
    self.redPaperBtn.imageView.contentMode = UIViewContentModeScaleAspectFit ;
    self.redPaperBtn.titleLabel.textAlignment = NSTextAlignmentCenter ;
}

- (void)drawRect:(CGRect)rect {
  
}

- (IBAction)photoBtnClick:(id)sender {
  
  if (self.delegate &&[self.delegate respondsToSelector:@selector(photoClick)]) {
    [self.delegate photoClick];
  }
}
- (IBAction)cameraBtnClick:(id)sender {
  if (self.delegate &&[self.delegate respondsToSelector:@selector(cameraClick)]) {
    [self.delegate cameraClick];
  }
}

- (IBAction)redPaperClick:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(redPaperClick)]) {
        [self.delegate redPaperClick];
    }
}


@end


@implementation JCHATMoreViewContainer

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  
  _moreView = NIB(JCHATMoreView);
  
  _moreView.frame =CGRectMake(0, 0, 320, 227);
  
  
  //  [_toolbar drawRect:_toolbar.frame];
  
  //  _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [self addSubview:_moreView];
}

@end

