//
//  PlayListView.m
//  music
//
//  Created by sghy on 17/3/10.
//  Copyright © 2017年 lzj. All rights reserved.
//
#import "UIImageView+WebCache.h"
#import "PlayListView.h"
#import "AppDelegate.h"
#import "MMDrawerController.h"
@interface PlayListView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel * LblistNmae;
@property (nonatomic, strong) UIButton * btnClose;
@property (nonatomic, strong) UIView * topView;
@end
@implementation PlayListView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //        [self addSubview:self.topView];
        //防止和cell手势冲突关闭侧滑
        ShareApp.drawerController.isOpen = NO;
        [self addSubview:self.tableView];
        [self addSubview:self.LblistNmae];
        [self addSubview:self.btnClose];
    }
    return self;
}
- (void)initView
{
    self.LblistNmae.text = _listNmae;
    if (_dataArr.count >0)
    {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_indexRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        [_tableView reloadData];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIndenfice = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndenfice];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndenfice];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary * dic = _dataArr[indexPath.row];
    [cell.imageView sd_setImageWithURL:dic[@"picURL"] placeholderImage:[UIImage imageNamed:@"default_iamgeView.jpg"]];
    cell.textLabel.text = dic[@"musicName"];
    if (indexPath.row == _indexRow)
    {
        cell.backgroundColor = RGBCOLOR(210, 238, 244);
    }
    else
    {
        cell.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_playBlock)
    {
        _indexRow = indexPath.row;
        _playBlock(indexPath.row);
        [_tableView reloadData];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}
//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isLocation)//不是本地收藏
    {
        if (_saveBlock)
        {
            self.saveBlock(indexPath.row);
        }
    }
    else
    {
        NSUserDefaults * defauts = [NSUserDefaults standardUserDefaults];
        NSMutableArray * muArr = [[NSMutableArray alloc]init];
        NSMutableArray * oldArr = [[defauts objectForKey:@"LocalList"] copy];
        [muArr addObjectsFromArray:oldArr];
        [defauts removeObjectForKey:@"LocalList"];
        //执行删除操作
        [muArr removeObjectAtIndex:indexPath.row];
        [_dataArr removeObjectAtIndex:indexPath.row];
        [defauts setObject:muArr forKey:@"LocalList"];
        [defauts synchronize];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    [tableView setEditing:NO animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
// 左滑结束时调用(只对默认的左滑按钮有效，自定义按钮时这个方法无效)
-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"左滑结束");
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isLocation)
    {
        return @"删除";
    }
    return @"收藏";
}
- (UIView *)topView
{
    if (!_topView)
    {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
        _topView.backgroundColor = [UIColor blackColor];
        _topView.alpha = 0.5;
    }
    return _topView;
}
- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, SCREEN_HEIGHT-200-TAB_BAR_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor grayColor];
//        [_tableView gestureRecognizerShouldBegin:_tableView.panGestureRecognizer];
    }
    return _tableView;
}
- (UILabel *)LblistNmae
{
    if (!_LblistNmae)
    {
        _LblistNmae = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH-80, 50)];
        _LblistNmae.text = _listNmae;
        _LblistNmae.backgroundColor = [UIColor grayColor];
        _LblistNmae.textAlignment = 1;
        _LblistNmae.textColor = [UIColor whiteColor];
    }
    return _LblistNmae;
}
- (UIButton *)btnClose
{
    if (!_btnClose)
    {
        _btnClose = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_LblistNmae.frame), 150, 80, 50)];
        [_btnClose addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
        [_btnClose setTitle:@"关" forState:UIControlStateNormal];
        _btnClose.titleLabel.textColor = [UIColor whiteColor];
        _btnClose.backgroundColor = [UIColor redColor];
    }
    return _btnClose;
}
//滑动控制器调 可以写在自定义的uiscrollview；里面
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
//        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
//        if ([pan translationInView:self].x > 0.0f && self.contentOffset.x == 0.0f) {
//            return NO;
//        }
//    }
//    return [super gestureRecognizerShouldBegin:gestureRecognizer];
//}

- (void)closeClick
{
    _topView.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        ShareApp.drawerController.isOpen = YES;
    }];
}

@end
