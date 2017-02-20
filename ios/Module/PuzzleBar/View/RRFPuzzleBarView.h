//
//  RRFPuzzleBarView.h
//  Puzzle
//
//  Created by huibei on 16/8/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

typedef enum : NSUInteger {
    KeyBoardTypeChat = 1,
    KeyBoardTypeComment = 2
} KeyBoardType;
#import <UIKit/UIKit.h>
typedef void (^EditorTextViewBlock)(NSInteger type);
typedef void (^SearchBarBlock)();

@interface RRFEditorTextView : UIView
@property(nonatomic,copy)EditorTextViewBlock editBlock;
@property(weak,nonatomic)UITextField* inputField ;
@property(nonatomic,assign)KeyBoardType keyType;
@property(nonatomic,strong)NSString *placeholderStr;
@end



@interface RRFPuzzleBarSearchView : UIView
@property(nonatomic,weak)UISearchBar *searchBar;
@property(nonatomic,copy)ItemClickBlock searchBlock;
-(void)settingPlaceholder:(NSString *)placeholder;
@property(nonatomic,assign)ComeInType type;
@end




@interface RRFPuzzleBarView : UIView

@end
