//
//  LRCViewController.m
//  music
//
//  Created by sghy on 17/3/9.
//  Copyright © 2017年 lzj. All rights reserved.
//
#import "LRCViewController.h"

@interface LRCViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UITableView * tableView;
@property (weak, nonatomic) IBOutlet UILabel *Labemperty;
@property (nonatomic, strong) NSMutableArray * timeArr;
@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, assign) NSInteger selectRow;

@end

@implementation LRCViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    ShareApp.tabBarController.tabBarHidden = YES;
    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeRun) userInfo:nil repeats:YES];
        [_timer fire];
    }
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    ShareApp.tabBarController.tabBarHidden = NO;
    [_timer invalidate];
    _timer = nil;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _timeArr = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view from its nib.
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-TAB_BAR_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    if (_lrcs.count ==0)
    {
        _tableView.hidden = YES;
         _Labemperty.hidden = NO;
    }
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"mm:ss.SSS"];
    NSDate * lastDate = [inputFormatter dateFromString:[_musictime firstObject]];
    //00:45.76
    for (NSString * itm in _musictime)
    {
        NSDate* inputDate = [inputFormatter dateFromString:itm];
        NSInteger timeCount = [inputDate timeIntervalSinceDate:lastDate];
        [_timeArr addObject:[NSString stringWithFormat:@"%ld",(long)timeCount]];
    }
}
-(void)reload:(NSArray *)lrcs
{
    _lrcs = lrcs;
    _timeInt = 0;
    [_tableView reloadData];
}
- (void)timeRun
{
    _timeInt ++;
    [_timeArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:idx-1 inSection:0];
        NSIndexPath* lastIndexPath = [NSIndexPath indexPathForItem:_selectRow inSection:0];
        if ([_timeArr[idx] isEqualToString:[NSString stringWithFormat:@"%ld",_timeInt]])
        {
            NSString * itmStr = _lrcs[idx];
            if (itmStr.length >2)
            {
                [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                UITableViewCell * cell = [_tableView cellForRowAtIndexPath:indexPath];
                cell.backgroundColor = RGBCOLOR(210, 238, 244);
                
                UITableViewCell * lastCell = [_tableView cellForRowAtIndexPath:lastIndexPath];
                lastCell.backgroundColor = [UIColor whiteColor];
                
                _selectRow = idx-1;
                
            }
            NSLog(@"%ld",idx);
        }
        else if(idx-1 != _selectRow)
        {
            UITableViewCell * cell = [_tableView cellForRowAtIndexPath:indexPath];
            cell.backgroundColor = [UIColor whiteColor];
        }
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _lrcs.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;;
    }
    cell.textLabel.text = _lrcs[indexPath.row];
    return cell;
}

@end
