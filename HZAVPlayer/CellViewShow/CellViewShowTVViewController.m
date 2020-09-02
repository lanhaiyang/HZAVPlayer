//
//  TableViewShowViewController.m
//  HZAVPlayer
//
//  Created by 何鹏 on 2020/9/1.
//  Copyright © 2020 何鹏. All rights reserved.
//

#import "CellViewShowTVViewController.h"
#import <Masonry/Masonry.h>
#import "TVTableViewCell.h"
#import "CellPlayerManage.h"

@interface CellViewShowTVViewController ()<TVTableViewDelegate,UITableViewDelegate,UITableViewDataSource,CellPlayerDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) CellPlayerManage *manage;


@end

@implementation CellViewShowTVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self confige];
    [self layout];
    [self registerCell];
}

-(void)confige{
    
    _manage = self.manage;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self.manage hz_playeStop];
}

-(void)registerCell{
    
    [TVTableViewCell registerCellWithTabelView:self.tableView];
}

-(void)layout{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).equalTo(@64);
        make.left.right.bottom.equalTo(self.view);
    }];
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 260;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    TVTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[TVTableViewCell cellName] forIndexPath:indexPath];
    
    cell.delegate = self;
    cell.indexPath = indexPath;
    [cell titleWithContent:[NSString stringWithFormat:@"%ld",indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{


    if ([_tableView.indexPathsForVisibleRows indexOfObject:_manage.playeIndexPath] == NSNotFound){
        
        if ([cell isKindOfClass:[TVTableViewCell class]]) {
            TVTableViewCell *tvCell = (TVTableViewCell *)cell;
            [tvCell hz_playStop];
            [_manage hz_removeOldIndexPath];
        }
        [_manage hz_playeStop];
    }
}


#pragma mark - CellPlayerDelegate

-(void)cellPlayerWithState:(HZ_ActionUserState)state indexPath:(NSIndexPath *)indexPath{
    
    
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:_manage.playeOldIndexPath];

    if ([cell isKindOfClass:[TVTableViewCell class]]) {
        TVTableViewCell *tvCell = (TVTableViewCell *)cell;
        [tvCell hz_playStop];
        [_manage hz_removeOldIndexPath];
    }
}

#pragma mark - TVTableViewDelegate

-(void)tvTabelViewActionWithShowView:(UIView *)showView indexPath:(NSIndexPath *)indexPath{
    
    [self cellPlayerWithState:HZ_ActionUserStopCellTV indexPath:indexPath];
    [_manage hz_playeStop];
    NSString *url = @"http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4";
    [self.manage hz_playeWithUrl:url crosswise:showView vertical:self.view playeIndexPath:indexPath];
}

#pragma mark - 懒加载

-(UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(CellPlayerManage *)manage{
    
    if (_manage == nil) {
        _manage = [[CellPlayerManage alloc] init];
        _manage.delegate = self;
    }
    return _manage;
}

@end
