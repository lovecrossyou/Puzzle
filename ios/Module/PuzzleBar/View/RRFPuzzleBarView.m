//
//  RRFPuzzleBarView.m
//  Puzzle
//
//  Created by huibei on 16/8/15.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "RRFPuzzleBarView.h"
#import "PZTitleInputView.h"


@interface RRFEditorTextView ()
@property(nonatomic,weak)PZTitleInputView *textView;
// 表情按钮
@property(nonatomic,weak)UIButton *expressionBtn;
// 添加图片的按钮
@property(nonatomic,weak)UIButton *addBtn;

@end
@implementation RRFEditorTextView

-(instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        UIButton *addBtn = [[UIButton alloc]init];
        [addBtn setImage:[UIImage imageNamed:@"more_ios"] forState:UIControlStateNormal];
        addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [addBtn sizeToFit];
        _addBtn = addBtn;
        [self addSubview:addBtn];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_equalTo(0);
            make.width.mas_equalTo(40);
        }];
        [[addBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.editBlock) {
                self.editBlock(1);
            }
        }];
        
        
        UIButton *expressionBtn = [[UIButton alloc]init];
        [expressionBtn setImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
        [expressionBtn sizeToFit];
        _expressionBtn = expressionBtn;
        [self addSubview:expressionBtn];
        [expressionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.right.mas_equalTo(_addBtn.mas_left);
            make.width.mas_equalTo(40);
        }];
        [[expressionBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            if (self.editBlock) {
                self.editBlock(2);
            }
        }];
        
        PZTitleInputView *textView = [[PZTitleInputView alloc]initWithLeftIcon:@"" placeHolder:@""];
        textView.layer.masksToBounds = YES;
        textView.layer.cornerRadius = 3;
        textView.textEnable = NO ;
        textView.backgroundColor = [UIColor whiteColor];
        _textView = textView;
        [self addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.top.mas_equalTo(6);
            make.bottom.mas_equalTo(-6);
            make.right.mas_equalTo(_expressionBtn.mas_left).offset(-6);
        }];
        [[textView rac_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(id x) {
            if (self.editBlock) {
                self.editBlock(1);
            }
        }];
    }
    return self;
}

-(void)setKeyType:(KeyBoardType)keyType
{
    _keyType = keyType;
    if (_keyType == KeyBoardTypeComment) {
        [self.expressionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
        }];
    }
}
-(void)setPlaceholderStr:(NSString *)placeholderStr
{
    _placeholderStr = placeholderStr;
    _textView.placeHolder = placeholderStr;
}
@end






@interface RRFPuzzleBarSearchView ()<UISearchBarDelegate>
{
    UIButton *_commentsBtn;
    UIButton *_questionsBtn;
    
    UIView *_rollingView;
    UIButton *_tempBtn;

}


@end
@implementation RRFPuzzleBarSearchView
-(instancetype)init{
    if (self = [super init]) {
        
//        self.backgroundColor = [UIColor colorWithHexString:@"f5f5f5"];
        
        
        UISearchBar *search = [[UISearchBar alloc]init];
        search.barTintColor = [UIColor colorWithHexString:@"f5f5f5"];
        search.placeholder = @"请输入证券代码/首字母";
        search.showsCancelButton = NO;
        search.delegate = self;
        
        self.searchBar = search;
        [self addSubview:search];
        [search mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(0);
        }];
        
        UIControl* searchPanel = [[UIControl alloc]init];
        [self addSubview:searchPanel];
        [searchPanel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(44);
            make.top.mas_equalTo(0);
        }];
        WEAKSELF
        [[searchPanel rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            weakSelf.searchBlock();
        }];
    }
    return self;
}
-(void)settingPlaceholder:(NSString *)placeholder
{
    self.searchBar.placeholder = placeholder;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    searchBar.text =  @"";
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"%@",searchBar.text);
    NSString *text = searchBar.text;
//    if (self.searchBarBlock) {
//        self.searchBarBlock();
//    }

}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"%@",searchBar.text);
}
-(void)setType:(ComeInType)type{
    _type = type;
    if (type == ComeInTypePersonCenter) {
        self.searchBar.hidden = YES;
        [_commentsBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
        }];
    }
}
@end
@implementation RRFPuzzleBarView

@end
