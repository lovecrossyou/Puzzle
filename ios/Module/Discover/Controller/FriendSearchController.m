//
//  FriendSearchController.m
//  Puzzle
//
//  Created by huibei on 16/12/6.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "FriendSearchController.h"
#import "FriendSearchFilterController.h"
@interface FriendSearchController ()<UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchResultsUpdating>
@property(strong,nonatomic)NSArray* titles;
@property(strong,nonatomic)NSArray* images;

//searchController
@property (strong, nonatomic)  UISearchController *searchController;

//数据源
@property (strong,nonatomic) NSMutableArray  *dataList;

@property (strong,nonatomic) NSMutableArray  *searchList;


@end

@implementation FriendSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @[@"股神",@"女神",@"V认证"];
    self.images = @[@"icon_diamonds-vip",@"icon_diamonds-vip",@"icon_diamonds-vip"];
    
    _dataList = [NSMutableArray array];
    _searchList = [NSMutableArray array];
    
    [self setupSearchController];
    self.tableView.delegate =self ;
    self.tableView.dataSource = self ;
    
}

-(void)setupSearchController{
    //创建UISearchController
    _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    //设置代理
    _searchController.delegate = self;
    _searchController.searchResultsUpdater= self;
    _searchController.searchBar.barTintColor = HBColor(243, 243, 243);
    _searchController.searchBar.placeholder = @"喜腾号/昵称" ;
    //隐藏导航栏
    _searchController.hidesNavigationBarDuringPresentation = NO;
    
    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    
    // 添加 searchbar 到 headerview
    self.tableView.tableHeaderView = _searchController.searchBar;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FriendSearchController"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FriendSearchController"];
    }
    cell.textLabel.text = self.titles[indexPath.row];
    cell.imageView.image= [UIImage imageNamed:self.images[indexPath.row]];
    return cell ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FriendSearchFilterController* filter = [[FriendSearchFilterController alloc]init];
    [self.navigationController pushViewController:filter animated:YES];
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSLog(@"updateSearchResultsForSearchController");
    NSString *searchString = [self.searchController.searchBar text];
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    //过滤数据
    self.searchList= [NSMutableArray arrayWithArray:[_dataList filteredArrayUsingPredicate:preicate]];
    //刷新表格
    [self.tableView reloadData];
}




@end
