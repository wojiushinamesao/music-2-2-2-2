//
//  SearchViewController.m
//  music
//
//  Created by sghy on 17/3/9.
//  Copyright © 2017年 lzj. All rights reserved.
//
#import "SearchViewController.h"
#import "STKAudioPlayer.h"
#import "ViewController.h"
#import "ReloadDataModel.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import "AFURLSessionManager.h"
#import "AFHTTPSessionManager.h"
#import "NSObject+MethodExt.h"
#import "LRCViewController.h"
#import "SearchViewController.h"
@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UITableView * oldSearchTableView;
@property (weak, nonatomic) IBOutlet UITextField *textTF;
@property (nonatomic,strong) UILabel * lbAlert;
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, strong) NSMutableArray * oldDataArr;
@property (nonatomic, strong)  STKAudioPlayer * audioPlayer;
@property (nonatomic, assign) BOOL isClick;//点击了搜索列表
@property (nonatomic, assign) NSInteger indexRow;//选择歌曲
@end

@implementation SearchViewController
- (void)viewDidLoad {
    
    _isClick = NO;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    self.title = @"查找歌曲";
    
    _audioPlayer = [[STKAudioPlayer alloc ] init];
    _dataArr = [[NSMutableArray alloc]init];
    _oldDataArr = [[NSMutableArray alloc]init];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_textTF.frame)+10, SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_textTF.frame)-TAB_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.hidden = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    _lbAlert = [[UILabel alloc]init];
    _lbAlert.center = self.view.center;
    _lbAlert.hidden = YES;
    _lbAlert.textAlignment = 1;
    _lbAlert.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    _lbAlert.text = @"加载中......";
    [self.view addSubview:_lbAlert];
    
    _oldSearchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_textTF.frame)+10, SCREEN_WIDTH, 300) style:UITableViewStyleGrouped];
    _oldSearchTableView.delegate = self;
    _oldSearchTableView.dataSource = self;
    _oldSearchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _oldSearchTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_oldSearchTableView];
    
    [_textTF addTarget:self action:@selector(textDingEdit) forControlEvents:UIControlEventEditingChanged];
    
    NSUserDefaults * defauts = [NSUserDefaults standardUserDefaults];
    NSMutableArray * arr = [defauts objectForKey:@"SearchList"];
    [_oldDataArr addObjectsFromArray:arr];
    _oldDataArr = (NSMutableArray *)[[_oldDataArr reverseObjectEnumerator] allObjects];
    NSString * lastObject = [defauts objectForKey:@"lastObject"];
    if (lastObject.length > 0)
    {
        _textTF.text = lastObject;
        [self searchClick:nil];
        _tableView.hidden = NO;
        _oldSearchTableView.hidden = YES;
    }
}
#pragma mark 请求数据
- (void)fillData
{
    _lbAlert.hidden = NO;
    NSString * musicURL = [NSString stringWithFormat:@"http://s.music.163.com/search/get/?type=1&s='%@'&limit=1000",_textTF.text];
    [_dataArr removeAllObjects];
    [ReloadDataModel getData:musicURL successBlock:^(id posts) {
        _lbAlert.hidden = YES;
        NSArray * songsArr = posts[@"result"][@"songs"];
        for (NSDictionary * musinDic in songsArr)
        {
            NSString *name = musinDic[@"name"];
            NSString * audioURL = musinDic[@"audio"];
            NSArray * artists = musinDic[@"artists"];
            NSMutableString * mutStr = [[NSMutableString alloc]init];
            for (NSDictionary *artistDic  in artists)
            {
                [mutStr appendString:artistDic[@"name"]];
            }
            NSString * singer = mutStr;
            NSDictionary * albumDic = musinDic[@"album"];
            NSString * picUrl = @"";
            if ([albumDic isKindOfClass:[NSDictionary class]])
            {
                picUrl = albumDic[@"picUrl"];
            }
            NSMutableDictionary * muDic = [[NSMutableDictionary alloc]init];
            [muDic setObject:name forKey:@"musicName"];
            [muDic setObject:audioURL forKey:@"audio"];
            [muDic setObject:singer forKey:@"singer"];
            [muDic setObject:picUrl forKey:@"picURL"];
            [_dataArr addObject:muDic];
        }
        [_tableView reloadData];
    }];
}
- (IBAction)searchClick:(id)sender
{
    [self fillData];
    [_textTF resignFirstResponder];
    _oldSearchTableView.hidden = YES;
    _tableView.hidden = NO;
    NSUserDefaults * defauts = [NSUserDefaults standardUserDefaults];
    NSMutableArray * arr = [[NSMutableArray alloc]init];
    NSMutableArray * oldArr = [[defauts objectForKey:@"SearchList"] copy];
    [arr addObjectsFromArray:oldArr];
    [defauts removeObjectForKey:@"SearchList"];
    
    //数据最多
    if (arr.count == 9)
    {
        [arr removeLastObject];
    }
    
    bool isSame = NO;
    for (NSString * str in arr)
    {
        if ([str isEqualToString:_textTF.text])
        {
            isSame = YES;
        }
    }
    if (isSame == NO)
    {
        [arr addObject:_textTF.text];
        [_oldDataArr addObject:_textTF.text];
    }
    [defauts setObject:_textTF.text forKey:@"lastObject"];
    [defauts setObject:arr forKey:@"SearchList"];
    [defauts synchronize];
    
}
#pragma mark 表代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _oldSearchTableView)
    {
        return _oldDataArr.count;
    }
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
    
    if (_oldSearchTableView == tableView)
    {
        cell.textLabel.text = _oldDataArr[indexPath.row];
    }
    else
    {
        if (_isClick && _indexRow == indexPath.row)
        {
            cell.backgroundColor = RGBCOLOR(210, 238, 244);
        }
        else
        {
            cell.backgroundColor = [UIColor whiteColor];
        }
        NSDictionary * dic = _dataArr[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@--%@",dic[@"musicName"],dic[@"singer"]];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _oldSearchTableView)
    {
        _oldSearchTableView.hidden = YES;
        _textTF.text = _oldDataArr[indexPath.row];
        [self searchClick:nil];
    }
    else
    {
        _isClick = YES;
        _indexRow = indexPath.row;
        if(_playBlock)
        {
            _playBlock(_dataArr[indexPath.row]);
        }
        [_tableView reloadData];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == _oldSearchTableView)
    {
        return 50.0f;
    }
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView == _oldSearchTableView && _oldDataArr.count >0)
    {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        [button setTitle:@"清空全部" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(removeAllSearchData) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        return view;
    }
    return nil;
}
- (void)removeAllSearchData
{
    NSUserDefaults * defauts = [NSUserDefaults standardUserDefaults];
    [_oldDataArr removeAllObjects];
    [defauts setObject:[[NSMutableArray alloc]init] forKey:@"SearchList"];
    [defauts synchronize];
    
    [_oldSearchTableView reloadData];
}
#pragma mark 监听输入框
- (void)textDingEdit
{
    if (_textTF.text.length == 0)
    {
        _tableView.hidden = YES;
        _oldSearchTableView.hidden = NO;
        _oldDataArr = (NSMutableArray *)[[_oldDataArr reverseObjectEnumerator] allObjects];
        [_oldSearchTableView reloadData];
    }
}

@end
