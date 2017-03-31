//
//  ThreeViewController.m
//  music
//
//  Created by sghy on 17/3/16.
//  Copyright © 2017年 lzj. All rights reserved.
//
#import "ThreeViewController.h"
#import "mainTableViewCell.h"
#import "NewsDetail.h"
@interface ThreeViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic, strong)NSMutableArray * dataArr;
@property (nonatomic, assign) NSInteger page;
@end

@implementation ThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArr = [[NSMutableArray alloc]init];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-TAB_BAR_HEIGHT-104) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    
    
    __block ThreeViewController * vc = self;
    // 下拉刷新
    _tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        [vc fillData];
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    // 上拉刷新
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [vc freshData];
    }];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    _page = 1;
    [self freshData];
}
- (void)fillData
{
    [_dataArr removeAllObjects];
    [ReloadDataModel getData:@"http://wangyi.butterfly.mopaasapp.com/news/api?type=war&page=1&limit=15" successBlock:^(id posts) {
        NSDictionary * dic = (NSDictionary *)posts;
        NSArray * listArr = dic[@"list"];
        [_dataArr addObjectsFromArray:listArr];
        [_tableView reloadData];
        if (_tableView.mj_header)
        {
            [_tableView.mj_header endRefreshing];
        }
    }];
}
- (void)freshData
{
    _page ++;
    [ReloadDataModel getData:[NSString stringWithFormat:@"http://wangyi.butterfly.mopaasapp.com/news/api?type=war&page=%ld&limit=15",(long)_page] successBlock:^(id posts) {
        NSDictionary * dic = (NSDictionary *)posts;
        NSArray * listArr = dic[@"list"];
        [_dataArr addObjectsFromArray:listArr];
        [_tableView reloadData];
        [_tableView.mj_footer endRefreshing];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;;
    }
    NSDictionary * dic = _dataArr[indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"imgurl"]] placeholderImage:[UIImage imageNamed:@"default_iamgeView.jpg"]];
    cell.textLabel.text = dic[@"title"];
    cell.textLabel.numberOfLines = 2;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dic = _dataArr[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:NEWS_GO_Detail object:dic];
}
@end

