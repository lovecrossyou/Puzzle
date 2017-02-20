//
//  RRFSelectedAreaController.m
//  Puzzle
//
//  Created by huibei on 16/8/26.
//  Copyright © 2016年 HuiBei. All rights reserved.
//

#import "JNQSelectedDistrictController.h"
#import "JNQProcitiesView.h"
#import "JNQProvinceCityModel.h"
#import "JNQHttpTool.h"

typedef NS_ENUM(NSInteger, PZDistrictType) {
    PZDistrictTypeProvince = 1,  //省
    PZDistrictTypeCity = 2,      //市
    PZDistrictTypeArea = 3       //区
};

@interface JNQSelectedDistrictController () <UITableViewDelegate, UITableViewDataSource> {
    JNQProcitiesView *_backView;
    PZDistrictType _disType;
    NSString *_urlStr;
    NSMutableDictionary *_params;
    NSMutableArray *_proArray;
    NSMutableArray *_citiesArray;
    NSMutableArray *_areaArray;
    JNQProvinceCityModel *_provinceModel;
    JNQProvinceCityModel *_cityModel;
}
@end

@implementation JNQSelectedDistrictController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    _params = [NSMutableDictionary dictionary];
    _disType = PZDistrictTypeProvince;
    [self settingUIView];
    [self loadData];
}

- (void)settingUIView {
    WEAKSELF
    _backView = [[JNQProcitiesView alloc]initWithFrame:CGRectMake(0, SCREENHeight/2, SCREENWidth, SCREENHeight/2)];
    _backView.backgroundColor = HBColor(245, 245, 245);
    [self.view addSubview:_backView];
    _backView.vc = self;
    _backView.backScrollView.delegate = self;
    _backView.selectBlock = ^(UIButton *btn){
        if (btn.tag == 66666) {
            [weakSelf dismissViewControllerAnimated:YES completion:^{}];
        } else {
            [weakSelf backScrollViewDidEdited:btn.tag];
        }
    };
    
}

- (void)loadData {
    [_params setObject:@(10) forKey:@"size"];
    [_params setObject:@(0) forKey:@"pageNo"];
    if (_disType == PZDistrictTypeProvince) {
        _urlStr = @"area/provinces";
    } else {
        _urlStr = @"area/cities";
    }
    [JNQHttpTool JNQHttpRequestWithURL:_urlStr requestType:@"post" showSVProgressHUD:NO parameters:_params successBlock:^(id json) {
        NSArray *areas = json[@"areas"];
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in areas) {
            JNQProvinceCityModel *model = [JNQProvinceCityModel yy_modelWithJSON:dict];
            [array addObject:model];
        }
        if (_disType == PZDistrictTypeProvince) {
            _proArray = array;
            [_backView.proTv reloadData];
        } else if(_disType == PZDistrictTypeCity) {
            _citiesArray = array;
            [_backView.cityTv reloadData];
        } else {
            _areaArray = array;
            [_backView.areaTv reloadData];
        }
    } failureBlock:^(id json) {
        
    }];
}

- (void)backScrollViewDidEdited:(NSInteger)index {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:PZFont(13), NSParagraphStyleAttributeName:paragraphStyle};
    CGRect procinveRect = [[NSString stringWithFormat:@"    %@", _provinceModel.label] boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    CGRect cityRect = [[NSString stringWithFormat:@"    %@", _cityModel.label] boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    if (index == 0) {
        _backView.glideView.frame = CGRectMake(12, 62, procinveRect.size.width, 0.8);
    } else if (index == 1) {
        if (_cityModel) {
            _backView.glideView.frame = CGRectMake(12+procinveRect.size.width+9, 62, cityRect.size.width, 0.8);
        } else {
            _backView.glideView.frame = CGRectMake(12+procinveRect.size.width+9, 62, 54, 0.8);
        }
    } else {
        _backView.glideView.frame = CGRectMake(12+procinveRect.size.width+9+cityRect.size.width+9, 62, 54, 0.8);
    }
    [_backView.backScrollView setContentOffset:CGPointMake(SCREENWidth*index, 0)];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 0) {
        return _proArray.count;
    } else if (tableView.tag == 1) {
        return _citiesArray.count;
    } else {
        return _areaArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JNQProvinceCityModel *model;
    if (tableView.tag == 0) {
        model = [_proArray objectAtIndex:indexPath.row];
    } else if (tableView.tag == 1){
        model = [_citiesArray objectAtIndex:indexPath.row];
    } else {
        model = [_areaArray objectAtIndex:indexPath.row];
    }
    static NSString *reuseID = @"reuseID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
        cell.textLabel.font = PZFont(13);
        cell.textLabel.textColor = HBColor(51, 51, 51);
        cell.backgroundColor = HBColor(245, 245, 245);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = model.label;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JNQProvinceCityModel *model;
    if (tableView.tag == 2) {
        model = [_areaArray objectAtIndex:indexPath.row];
        NSString *districtName = [NSString stringWithFormat:@"%@%@%@", _provinceModel.label, _cityModel.label, model.label];
        if (self.districtNameBlock) {
            self.districtNameBlock(districtName, _provinceModel.modelId, _cityModel.modelId);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        if (tableView.tag){
            model = [_citiesArray objectAtIndex:indexPath.row];
            _cityModel = model;
            _disType = PZDistrictTypeArea;
            _backView.areaBtn.hidden = NO;
            [_backView.cityBtn setTitle:[NSString stringWithFormat:@"  %@  ", model.label] forState:UIControlStateNormal];
        } else {
            model = [_proArray objectAtIndex:indexPath.row];
            _provinceModel = model;
            _cityModel = nil;
            _disType = PZDistrictTypeCity;
            _backView.cityBtn.hidden = NO;
            _backView.areaBtn.hidden = YES;
            [_backView.cityBtn setTitle:@"  请选择  " forState:UIControlStateNormal];
            [_backView.areaBtn setTitle:@"  请选择  " forState:UIControlStateNormal];
            [_backView.proBtn setTitle:[NSString stringWithFormat:@"  %@  ", model.label] forState:UIControlStateNormal];
        }
        [_params setObject:@(model.modelId) forKey:@"parentAreaId"];
        [self loadData];
        [self backScrollViewDidEdited:tableView.tag+1];
    }
}



@end
