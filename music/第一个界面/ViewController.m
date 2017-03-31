//
//  ViewController.m
//  music
//
//  Created by sghy on 17/3/8.
//  Copyright © 2017年 lzj. All rights reserved.
//
#import "AppDelegate.h"
//#import "DetailViewController.h"

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
#import "PlayListView.h"
#import "SettingVC.h"
#import <UMSocialCore/UMSocialCore.h>

/**
 歌曲播放形式
 */
typedef enum : NSUInteger {
    MBAudioPlayTypeCircle,  //循环播放
    MBAudioPlayTypeRandom,  //随机播放
    MBAudioPlayTypeOneMusic,//单曲循环
    MBAudioPlayTypeNoNext,  //播完就不播了
} MBAudioPlayType;

@interface ViewController()<STKAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *Labsinger;
@property (weak, nonatomic) IBOutlet UILabel *Labdurtion;
@property (weak, nonatomic) IBOutlet UILabel *Labprogerss;
@property (weak, nonatomic) IBOutlet UILabel *lbMusicName;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (nonatomic, strong) STKAudioPlayer * audioPlayer;
@property (nonatomic, strong) LRCViewController * lrcVC;
@property (nonatomic, strong) PlayListView * playList;
@property (nonatomic, strong)UIView *shareView;
@property (nonatomic, strong)UIView *shareBackView;
@property (weak, nonatomic) IBOutlet UISlider *sider;//

@property (nonatomic, strong) NSMutableArray *musictime;
@property (nonatomic, strong) NSMutableArray *lyrics;
@property (nonatomic, strong) NSMutableArray *t;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *localArr;
@property (nonatomic, strong) NSString *listName;
@property (nonatomic, strong) NSString *audio;//正在播放的歌曲文件地址
@property (nonatomic, assign) NSInteger num;//歌曲序号
@property (nonatomic, assign) NSInteger selectList;//列表序号
@property (nonatomic, strong) NSTimer* timer;//定时器
@property (nonatomic, assign) BOOL isSearch;//搜索
@property (nonatomic, assign) BOOL isLoopState;//循环

@property (weak, nonatomic) IBOutlet UIImageView *bigBackView;
@property (nonatomic, strong) UIVisualEffectView *effectView;

// 下载句柄 歌词
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@end

@implementation ViewController
#pragma mark
- (void)initDoSomeTing
{
    self.title = @"正在播放";
    [self configureLeftBarButtonWithTitle:@"设置" action:^{
        NSLog(@"左侧按钮点击");
        [ShareApp.drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }];
    
    [self configureRightBarButtonWithTitle:@"搜索" action:^{
        NSLog(@"右侧按钮点击");
        [ShareApp.drawerController toggleDrawerSide:MMDrawerSideRight animated:YES completion:nil];
    }];
    //    self.automaticallyAdjustsScrollViewInsets=NO;
    
    //初始化数据
    _dataArr = [[NSMutableArray alloc]init];
    _localArr = [[NSMutableArray alloc]init];
    _num = 0;
    _selectList = 0;
    
}
- (void)viewWillAppear:(BOOL)animated
{
    ShareApp.tabBarController.tabBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDoSomeTing];
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [button setTitle:@"🔍" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(checkMusci) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];//创建单例对象并且使其设置为活跃状态.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)   name:AVAudioSessionRouteChangeNotification object:nil];//设置通知
    
    _audioPlayer = [[STKAudioPlayer alloc ] init];
    //    _audioPlayer.delegate = self;
    [_btn setTitle:@"等待" forState:UIControlStateNormal];
    _btn.titleLabel.font =  [UIFont fontWithName:@"HanHanTi" size:30];
    [_sider addTarget:self action:@selector(changeSider:) forControlEvents:UIControlEventValueChanged];
    
    
}
    
#pragma mark 选择不同类型的歌曲列表
- (IBAction)changeTypeClick:(id)sender
{
    _isSearch = NO;
    UIButton * btn = (UIButton *)sender;
    _num = 0;
    if(btn.tag == 100)//查找本地
    {
        NSUserDefaults * defauts = [NSUserDefaults standardUserDefaults];
        NSMutableArray * arr = [defauts objectForKey:@"LocalList"];
        if(arr.count >0)
        {
            _selectList = btn.tag;
            //            _isSearch = YES;
            _listName = btn.titleLabel.text;
            [_dataArr removeAllObjects];
            [_dataArr addObjectsFromArray:arr];
            //倒序  先显示最近的
            _dataArr = (NSMutableArray *)[[_dataArr reverseObjectEnumerator] allObjects];
            [self playMusic];
        }
        else
        {
            [PubFunction showMessage:@"您还没有收藏过歌曲哦！" keepTime:1];
        }
    }
    else
    {
        _selectList = btn.tag;
        _listName = btn.titleLabel.text;
        //网络获取
        [self getMusicList];
    }
}
#pragma mark 选择播放的歌曲
- (IBAction)selectMusic:(id)sender
{
    if(_dataArr.count >0)
    {
        if (_isSearch)
        {
            _listName = _dataArr[_num][@"musicName"];
        }
        _playList = [[PlayListView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _playList.dataArr = _dataArr;
        _playList.indexRow = _num;
        _playList.listNmae = _listName;
        
        
        BOOL isLocation = NO;
        if (_selectList == 100)
        {
            isLocation = YES;
        }
        _playList.isLocation = isLocation;
        [_playList initView];
        __block ViewController * vc = self;
        _playList.playBlock= ^(NSInteger selectRow)
        {
            vc.num = selectRow;
            [vc playMusic];
        };
        _playList.saveBlock = ^(NSInteger selectRow)
        {
            [vc saveMusic:selectRow];
        };
        [self.view addSubview:_playList];
        
        [UIView animateWithDuration:0.3 animations:^{
            _playList.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        } completion:^(BOOL finished) {
            
        }];
    }
}
#pragma mark 进入搜索界面
- (void)checkMusci
{
    SearchViewController * Searchvc = [[SearchViewController alloc]init];
    __block ViewController * vc =self;
    Searchvc.playBlock = ^(NSDictionary *dic)
    {
        vc.selectList = 0;//改为非本地列表
        _isSearch = YES;
        vc.num = 0;
        [vc.dataArr removeAllObjects];
        [vc.dataArr addObject:dic];
        [vc playMusic];
    };
    [self.navigationController pushViewController:Searchvc animated:YES];
    //    self.hidesBottomBarWhenPushed = NO;
    ShareApp.tabBarController.tabBarHidden = YES;
}
#pragma mark 快进 更改进度条
- (void)changeSider:(UISlider *)sider
{
    [_audioPlayer seekToTime:sider.value];
}
#pragma mark 点击循环
- (IBAction)LoopSwitch:(id)sender
{
    UISwitch * switchs = (UISwitch *)sender;
    _isLoopState = switchs.on;
}
#pragma mark 进入设置页面
- (IBAction)settingClick:(id)sender {
    SettingVC * vc = [[SettingVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 开启定时器
- (void)setupTimer
{
    if (!_timer)
    {
        _timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(tick) userInfo:nil repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}
#pragma mark 定时器方法
- (void)tick
{
    //停止时候自动播放下下一首
    if (_audioPlayer.state == STKAudioPlayerStateStopped)
    {
        [self right:nil];
    }
    
    //获取当前播放音频的总时间时间
    //    float duration = _audioPlayer.duration;
    _sider.maximumValue = _audioPlayer.duration;
    //当前播放的时间
    float progress = _audioPlayer.progress;
    
    //    _progress.progress = progress/duration;
    
    _sider.value = progress;
    
    _Labprogerss.text =  [self timeFormatted:progress];
}
#pragma mark 秒>>>分.秒
- (NSString *)timeFormatted:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    //    int hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%02d:%02d",minutes, seconds];
}
#pragma mark 进入查看歌词
- (IBAction)lrcClick:(id)sender
{
    _lrcVC = [[LRCViewController alloc]init];
    _lrcVC.lrcs = _lyrics;
    _lrcVC.musictime = _musictime;
    _lrcVC.timeInt = _audioPlayer.progress;
    [self.navigationController pushViewController:_lrcVC animated:YES];
}
#pragma mark 获取选择的歌曲列表
- (void)getMusicList
{
    _isSearch = NO;
    NSMutableArray * agoArr = [_dataArr copy];
    [_dataArr removeAllObjects];
    NSString *urlStr = [NSString stringWithFormat:@"http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.billboard.billList&type=%ld&size=100&offset=0",(long)_selectList];
    [ReloadDataModel getData:urlStr successBlock:^(id posts) {
        NSArray * arr = posts[@"song_list"];
        for (NSDictionary * dic in arr)
        {
            NSString * musicName = dic[@"title"];
            NSString * musicURL = [NSString stringWithFormat:@"http://s.music.163.com/search/get/?type=1&s='%@'",musicName];
            NSMutableDictionary * mudic = [[NSMutableDictionary alloc]init];
            [mudic setObject:musicURL forKey:@"musicURL"];
            if ([dic.allKeys containsObject:@"pic_big"])
            {
                [mudic setObject:dic[@"pic_big"] forKey:@"picURL"];
            }
            else
            {
                [mudic setObject:dic[@"pic_small"] forKey:@"picURL"];
            }
            if ([dic.allKeys containsObject:@"lrclink"])
            {
                [mudic setObject:dic[@"lrclink"] forKey:@"lrclink"];
            }
            [mudic setObject:musicName forKey:@"musicName"];
            [_dataArr addObject:mudic];
        }
        if(_dataArr.count >0)
        {
            [self playMusic];
        }
        else
        {
            [_dataArr addObjectsFromArray:agoArr];
            [PubFunction showMessage:@"列表为空" keepTime:1];
        }
    }];
}
#pragma mark 获取歌曲播放地址 播放
- (void)playMusic
{
    _sider.value = 0;
    NSDictionary * dic = _dataArr[_num];
    
    //歌手图片
    [_photoView sd_setImageWithURL:[NSURL URLWithString:dic[@"picURL"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL)
     {
         _photoView.image = image;
         CGFloat height = (_photoView.image.size.height*_photoView.frame.size.width)/_photoView.image.size.width;
         _photoView.frame = CGRectMake(_photoView.frame.origin.x, _photoView.frame.origin.y, _photoView.frame.size.width, height);
         CGFloat radius = height/2;
         _photoView.layer.cornerRadius = radius;
         _photoView.layer.masksToBounds = YES;
     }];
    
    //背景大图
    [_bigBackView sd_setImageWithURL:[NSURL URLWithString:dic[@"picURL"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL)
     {
         _bigBackView.image = image;
         CGFloat height = (SCREEN_HEIGHT*SCREEN_WIDTH)/SCREEN_WIDTH;
         _bigBackView.frame = CGRectMake(0, 0,SCREEN_WIDTH, height);
         
         UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
         if (!_effectView)
         {
             _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
             _effectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
         }
         [_bigBackView addSubview:_effectView];
         
         //转动
         [_photoView animateWithType:AnimateType_Ronatate Duration:12 speed:1 completeBlock:nil];
     }];
    
    if(_isSearch)
    {
        //歌曲信息字典
        _lbMusicName.text = dic[@"musicName"];
        NSString * audioURL = dic[@"audio"];
        _audio = audioURL;
        [_audioPlayer play:audioURL];
        
        NSString * singer = dic[@"singer"];
        _Labsinger.text = singer;
        [_btn setTitle:@"暂停" forState:UIControlStateNormal];
        [self performSelector:@selector(updatelock:) withObject:dic afterDelay:1];
        
        [self parselyric:dic name:_lbMusicName.text];
        
        [self setupTimer];
    }
    else
    {
        //获取到歌曲具体信息模型 并播放
        [ReloadDataModel getData:dic[@"musicURL"] successBlock:^(id posts) {
            NSArray * songsArr = posts[@"result"][@"songs"];
            
            //歌曲信息不存在。跳过 直接下一首
            if(!songsArr)
            {
                [self right:nil];
                return ;
            }
            
            NSDictionary * musinDic = [songsArr firstObject];
            _lbMusicName.text = musinDic[@"name"];
            NSString * audioURL = musinDic[@"audio"];
            
            [_audioPlayer play:audioURL];
            _audio = audioURL;
            
            NSArray * artists = musinDic[@"artists"];
            NSMutableString * mutStr = [[NSMutableString alloc]init];
            for (NSDictionary *artistDic  in artists)
            {
                [mutStr appendString:artistDic[@"name"]];
            }
            NSString * singer = mutStr;
            _Labsinger.text = singer;
            [_btn setTitle:@"暂停" forState:UIControlStateNormal];
            [self performSelector:@selector(updatelock:) withObject:musinDic afterDelay:1];
            
            [self parselyric:dic name:_lbMusicName.text];
            
            [self setupTimer];
        }];
    }
    
}
#pragma mark 保存数据
- (void)saveMusic:(NSInteger)selectRow
{
    //先取到已有数据
    NSDictionary * dic = _dataArr[selectRow];
    NSMutableDictionary * muDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
    NSUserDefaults * defauts = [NSUserDefaults standardUserDefaults];
    NSMutableArray * muArr = [[NSMutableArray alloc]init];
    NSMutableArray * oldArr = [[defauts objectForKey:@"LocalList"] copy];
    [muArr addObjectsFromArray:oldArr];
    [defauts removeObjectForKey:@"LocalList"];
    
    if (_isSearch)
    {
        NSString * musicURL = [NSString stringWithFormat:@"http://s.music.163.com/search/get/?type=1&s='%@'",dic[@"musicName"]];
        [muDic setObject:musicURL forKey:@"musicURL"];
    }
    //保存歌曲地址
    [muDic setObject:_audio forKey:@"audio"];
    //判断是不是已经存在
    bool isSame = NO;
    for (NSDictionary * dic1 in muArr)
    {
        NSString * name = dic1[@"musicName"];
        if ([name isEqualToString:dic[@"name"]])
        {
            isSame = YES;
        }
    }
    if (isSame == NO)
    {
        //本地和内存都存
        [muArr addObject:muDic];
        [_localArr addObject:muDic];
    }
    [PubFunction showMessage:@"已收藏！" keepTime:0.5];
    [defauts setObject:muArr forKey:@"LocalList"];
    [defauts synchronize];
}
#pragma mark 准备更新锁屏
- (void)updatelock:(id)withObject
{
    NSDictionary * dic = (NSDictionary *)withObject;
    [self updatelockScreenInfo:dic];
    _Labdurtion.text = [self timeFormatted:_audioPlayer.duration];
    
    _sider.minimumValue = 0;
}
#pragma mark 下一首
- (IBAction)right:(id)sender
{
    if (_num <= _dataArr.count-1 && _dataArr.count >0)
    {
        if (!_isLoopState && !_isSearch)
        {
            _num ++;
        }
        if (_num > _dataArr.count-1)
        {
            _num --;
        }
        [self playMusic];
    }
    _playList.indexRow = _num;
    [_playList initView];
    
}
#pragma mark 上一首
- (IBAction)left:(id)sender
{
    if (_num != 0 && _dataArr.count >0)
    {
        if (!_isLoopState)
        {
            _num --;
        }
        [self playMusic];
    }
    _playList.indexRow = _num;
    [_playList initView];
}
#pragma mark 播放/暂停
- (IBAction)click:(id)sender {
    
    if (_audioPlayer.state == STKAudioPlayerStatePaused) {
        
        [_btn setTitle:@"暂停" forState:UIControlStateNormal];
        [_audioPlayer resume];
        [_photoView continueAnimation:0];
        
    }else if (_audioPlayer.state == STKAudioPlayerStatePlaying) {
        
        [_btn setTitle:@"播放" forState:UIControlStateNormal];
        [_audioPlayer pause];
        [_photoView stopAnyAnimation];
        
    }
}
#pragma mark 响应远程音乐播放控制消息
- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    //点击锁屏按钮
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause: //按了暂停或者耳机单击
            {
                [self click:nil];
                NSLog(@"RemoteControlEvents: pause");
            }
                break;
            case UIEventSubtypeRemoteControlNextTrack://按了下一首或者耳机双击
                [self right:nil];
                NSLog(@"RemoteControlEvents: playModeNext");
                break;
            case UIEventSubtypeRemoteControlPreviousTrack://按了上一首
                NSLog(@"RemoteControlEvents: playPrev");
                [self left:nil];
                
                break;
            case UIEventSubtypeRemoteControlPause://按了暂停
            {
                [self click:nil];
            }
                break;
            case UIEventSubtypeRemoteControlPlay:
                //                [_audioPlayer play];
                break;
            default:
                break;
        }
    }
}
#pragma mark 监听耳机
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
        {
            NSLog(@"AVAudioSessionRouteChangeReasonNewDeviceAvailable");
            NSLog(@"耳机插入");
            [_audioPlayer resume];
            [_btn setTitle:@"暂停" forState:UIControlStateNormal];
        }
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            NSLog(@"AVAudioSessionRouteChangeReasonOldDeviceUnavailable");
            NSLog(@"耳机拔出，停止播放操作");
            [_audioPlayer pause];
            [_btn setTitle:@"播放" forState:UIControlStateNormal];
        }
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}
#pragma mark 更新锁屏界面信息
- (void)updatelockScreenInfo:(NSDictionary *)dic
{
    // 直接使用defaultCenter来获取MPNowPlayingInfoCenter的默认唯一实例
    MPNowPlayingInfoCenter *infoCenter = [MPNowPlayingInfoCenter defaultCenter];
    
    NSString * name = @"";
    NSString * singer = @"暂无";
    if (_isSearch)
    {
        name = dic[@"musicName"];
        singer = dic[@"singer"];
    }
    else
    {
        NSDictionary * albumDic = dic[@"album"];
        name = albumDic[@"name"];
        if (name.length ==0)
        {
            name = @"暂无";
        }
        NSArray * artists = dic[@"artists"];
        NSDictionary * artistDic = [artists firstObject];
        
        if ([artistDic.allKeys containsObject:@"name"])
        {
            singer = artistDic[@"name"];
        }
    }
    if (singer.length ==0)
    {
        singer = @"暂无";
    }
    //    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:dic[picUrlStr]]];
    //    UIImage * image = [UIImage imageWithData:data];
    
    // MPMediaItemArtwork 用来表示锁屏界面图片的类型
    //    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc]initWithImage:image];
    
    // 通过配置nowPlayingInfo的值来更新锁屏界面的信息
    infoCenter.nowPlayingInfo = @{
                                  // 歌曲名
                                  MPMediaItemPropertyTitle : name,
                                  // 艺术家名
                                  MPMediaItemPropertyArtist : singer,
                                  // 专辑名字
                                  //                                  MPMediaItemPropertyAlbumTitle : music.album,
                                  // 歌曲总时长
                                  MPMediaItemPropertyPlaybackDuration : @(_audioPlayer.duration),
                                  // 歌曲的当前时间
                                  MPNowPlayingInfoPropertyElapsedPlaybackTime : @(_audioPlayer.progress),
                                  // 歌曲的插图, 类型是MPMeidaItemArtwork对象
                                  //                                  MPMediaItemPropertyArtwork : artwork,
                                  
                                  // 无效的, 歌词的展示是通过图片绘制完成的, 即将歌词绘制到歌曲插图, 通过更新插图来实现歌词的更新的
                                  // MPMediaItemPropertyLyrics : lyric.content,
                                  };
}
#pragma mark 下载歌词 yes则为下载完
- (BOOL)downFileFromServer:(NSDictionary *)dic name:(NSString *)name
{
    __block BOOL isLoadComplete = NO;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    
    if (![dic.allKeys containsObject:@"lrclink"])
    {
        return YES;
    }
    if (![NSString isFileExist:name])
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSString * fileName = [NSString stringWithFormat:@"%@.lrc",name];
        NSString  *fullPath = [NSString stringWithFormat:@"%@/%@", docDir, fileName];
        NSURL *url = [NSURL URLWithString:dic[@"lrclink"]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSessionDownloadTask *task =
        [manager downloadTaskWithRequest:request
                                progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response)
         {
             return [NSURL fileURLWithPath:fullPath];
         }
                       completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error)
         {
             isLoadComplete = YES;
         }];
        [task resume];
    }
    return isLoadComplete;
}
#pragma mark 获取本地路径
- (NSString *)getDocumentPath:(NSString *)Name
{
    NSString *fullPath = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString * fileName = [NSString stringWithFormat:@"%@.lrc",Name];
    fullPath = [NSString stringWithFormat:@"%@/%@", docDir, fileName];
    NSLog(@"-----沙盒路径:%@",fullPath);
    return fullPath;
}
#pragma mark 获取歌词
-(void)parselyric:(NSDictionary *)dic name:(NSString *)name
{
    NSString *fullPath = nil;
    if ([NSString isFileExist:name])//判断文件是否存在
    {
        fullPath = [self getDocumentPath:name];
    }
    else
    {
        if (![self downFileFromServer:dic name:name])
        {
            [self performBlock:^{
                [self parselyric:dic name:name];
            } afterDelay:0.5];
        }
        else
        {
            fullPath = [self getDocumentPath:name];
        }
    }
    NSString *lyc = [NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:nil];
    
    //init
    _musictime = [[NSMutableArray alloc]init];
    _lyrics = [[NSMutableArray alloc]init];
    _t = [[NSMutableArray alloc]init];
    
    NSArray *arr = [lyc componentsSeparatedByString:@"\n"];
    
    for (NSString *item in arr) {
        
        //if item is not empty
        if ([item length]) {
            
            NSRange startrange = [item rangeOfString:@"["];
            //            NSLog(@"%d%d",startrange.length,startrange.location);
            NSRange stoprange = [item rangeOfString:@"]"];
            
            if(stoprange.length != 0)
            {
                NSString *content = [item substringWithRange:NSMakeRange(startrange.location+1, stoprange.location-startrange.location-1)];
                
                //            NSLog(@"%d",[item length]);
                
                //the music time format is mm.ss.xx such as 00:03.84
                if ([content length] == 8) {
                    NSString *minute = [content substringWithRange:NSMakeRange(0, 2)];
                    NSString *second = [content substringWithRange:NSMakeRange(3, 2)];
                    NSString *mm = [content substringWithRange:NSMakeRange(6, 2)];
                    
                    NSString *time = [NSString stringWithFormat:@"%@:%@.%@",minute,second,mm];
                    NSNumber *total =[NSNumber numberWithInteger:[minute integerValue] * 60 + [second integerValue]];
                    [_t addObject:total];
                    
                    NSString *lyric = [item substringFromIndex:10];
                    
                    [_musictime addObject:time];
                    [_lyrics addObject:lyric];
                }
            }
        }
    }
    //刷新歌词
    if (_lrcVC)
    {
        [_lrcVC reload:_lyrics];
    }
}
#pragma mark 分享
- (IBAction)shareApp:(id)sender {
    
    NSString * shareUrl;
    NSString * shareTitle;
    UIImage * shareImage;
    if (!_isNewsShare)
    {
        if (_dataArr.count ==0)
        {
            return;
        }
        NSDictionary * dic = _dataArr[_num];
        shareUrl = _audio;
        
        shareTitle = dic[@"musicName"];
        
        NSData * imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:dic[@"picURL"]]];
        shareImage = [UIImage imageWithData:imgData];
        
    }
    else
    {
        shareTitle = _shareTitle;
        NSData * imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:_shareImageStr]];
        shareImage = [UIImage imageWithData:imgData];
        shareUrl = _detailUrlStr;
    }
    
    NSString * bShareUrl = shareUrl;
    NSString * bShareTitle= shareTitle;
    UIImage * bShareImage = shareImage;
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:bShareTitle descr:@""thumImage:bShareImage];
    //设置网页地址
    shareObject.webpageUrl =bShareUrl;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    [_shareView removeFromSuperview];
    [_shareBackView removeFromSuperview];
    _shareBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _shareBackView.backgroundColor =[UIColor blackColor];
    _shareBackView.alpha = 0.7;
    
    _shareView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _shareView.backgroundColor =[UIColor clearColor];
    _shareView.userInteractionEnabled=YES;
    
    __block ViewController * vc = self;
    [_shareView setTapActionWithBlock:^{
        [vc.shareBackView removeFromSuperview];
        [vc.shareView removeFromSuperview];
    }];
    
    UIView * mainView = [[UIView alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGHT-200-5-50-10, SCREEN_WIDTH-20, 200)];
    mainView.backgroundColor = [UIColor whiteColor];
    mainView.layer.masksToBounds = YES;
    mainView.layer.cornerRadius = 10;
    [_shareView addSubview:mainView];
    
    UIButton * closeView = [[UIButton alloc]initWithFrame:CGRectMake(10, SCREEN_HEIGHT-50-10, SCREEN_WIDTH-20, 50)];
    closeView.backgroundColor = [UIColor whiteColor];
    closeView.layer.masksToBounds = YES;
    [closeView setTitle:@"取消" forState:UIControlStateNormal];
    [closeView setTitleColor:RGBCOLOR(0, 122, 255) forState:UIControlStateNormal];
    closeView.layer.cornerRadius = 10;
    [_shareView addSubview:closeView];
    [closeView performBlock:^{
        [UIView animateWithDuration:0.35 animations:^{
            vc.shareView.top=SCREEN_HEIGHT;
        } completion:^(BOOL finished) {
            [vc.shareBackView removeFromSuperview];
            [vc.shareView removeFromSuperview];
        }];
    } controlEvents:UIControlEventTouchUpInside];
    
    // 微信分享
    UIButton *btnWeixinShare = [[UIButton alloc] initWithFrame:CGRectMake(25, 22, 44, 44)];
    [btnWeixinShare setImage:[UIImage imageNamed:@"share_weixin@2x.png"] forState:UIControlStateNormal];
    [btnWeixinShare setImage:[UIImage imageNamed:@"share_weixin@2x.png"] forState:UIControlStateHighlighted];
    btnWeixinShare.backgroundColor = [UIColor clearColor];
    [btnWeixinShare performBlock:^ {
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatSession messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
            }else{
                
            }
        }];
        [self.shareBackView removeFromSuperview];
        [self.shareView removeFromSuperview];
    }controlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:btnWeixinShare];
    
    
    // 微信朋友圈
    UIButton *btnWeixin_friend = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(mainView.frame)/2-22, 22, 44, 44)];
    [btnWeixin_friend setImage:[UIImage imageNamed:@"share_weixin_friend@2x.png"] forState:UIControlStateNormal];
    [btnWeixin_friend setImage:[UIImage imageNamed:@"share_weixin_friend@2x.png"] forState:UIControlStateHighlighted];
    btnWeixin_friend.backgroundColor = [UIColor clearColor];
    [btnWeixin_friend performBlock:^ {
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_WechatTimeLine messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
            }else{
                
            }
        }];
        [self.shareBackView removeFromSuperview];
        [self.shareView removeFromSuperview];
    }controlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:btnWeixin_friend];
    
    [self.shareBackView removeFromSuperview];
    [self.shareView removeFromSuperview];
    
    
    UILabel *lbWeixin = [[UILabel alloc] initWithFrame:CGRectMake(5, btnWeixinShare.origin.y+btnWeixinShare.size.height+10, 82, 13)];
    lbWeixin.backgroundColor = [UIColor clearColor];
    lbWeixin.textAlignment = NSTextAlignmentCenter;
    lbWeixin.font = [UIFont systemFontOfSize:14];
    lbWeixin.textColor = [UIColor blackColor];
    [mainView addSubview:lbWeixin];
    lbWeixin.text = @"微信";
    
    UILabel *lbWeixin_friend = [[UILabel alloc] initWithFrame:CGRectMake(btnWeixin_friend.origin.x-15, btnWeixinShare.origin.y+btnWeixinShare.size.height+10, 75, 13)];
    lbWeixin_friend.backgroundColor = [UIColor clearColor];
    lbWeixin_friend.textAlignment = NSTextAlignmentCenter;
    lbWeixin_friend.font = [UIFont systemFontOfSize:14];
    lbWeixin_friend.textColor = [UIColor blackColor];
    [mainView addSubview:lbWeixin_friend];
    lbWeixin_friend.text = @"朋友圈";
    //
    //
    // qq分享
    UIButton *btnQQShare = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(mainView.frame)-25-44, 22, 44, 44)];
    [btnQQShare setImage:[UIImage imageNamed:@"share_qq@2x.png"] forState:UIControlStateNormal];
    [btnQQShare setImage:[UIImage imageNamed:@"share_qq@2x.png"] forState:UIControlStateHighlighted];
    btnQQShare.backgroundColor = [UIColor clearColor];
    [btnQQShare performBlock:^ {
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_QQ messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            
        }];
        
        [self.shareBackView removeFromSuperview];
        [self.shareView removeFromSuperview];
    }controlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:btnQQShare];
    
    UILabel *lbQQ = [[UILabel alloc] initWithFrame:CGRectMake(btnQQShare.origin.x-15, btnWeixinShare.origin.y+btnWeixinShare.size.height+10, 75, 14)];
    lbQQ.backgroundColor = [UIColor clearColor];
    lbQQ.textAlignment = NSTextAlignmentCenter;
    lbQQ.font = [UIFont systemFontOfSize:14];
    lbQQ.textColor = [UIColor blackColor];
    [mainView addSubview:lbQQ];
    lbQQ.text = @"QQ";
    //
    
    // sina 分享
    UIButton *btnSinaShare = [[UIButton alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(btnWeixin_friend.frame)+43, 44, 44)];
    [btnSinaShare setImage:[UIImage imageNamed:@"share_sina@2x.png"] forState:UIControlStateNormal];
    [btnSinaShare setImage:[UIImage imageNamed:@"share_sina@2x.png"] forState:UIControlStateHighlighted];
    btnSinaShare.backgroundColor = [UIColor clearColor];
    [btnSinaShare performBlock:^ {
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Sina messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        }];
        [self.shareBackView removeFromSuperview];
        [self.shareView removeFromSuperview];
    }controlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:btnSinaShare];
    
    UILabel *lbSina = [[UILabel alloc] initWithFrame:CGRectMake(btnSinaShare.origin.x-15, btnSinaShare.origin.y+btnSinaShare.size.height+10, 75, 14)];
    lbSina.backgroundColor = [UIColor clearColor];
    lbSina.textAlignment = NSTextAlignmentCenter;
    lbSina.font = [UIFont systemFontOfSize:14];
    lbSina.textColor = [UIColor blackColor];
    [mainView addSubview:lbSina];
    lbSina.text = @"新浪微博";
    
    //复制链接
    UIButton *copyBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(mainView.frame)/2-22, CGRectGetMaxY(btnWeixin_friend.frame)+43, 44, 44)];
    [copyBtn setImage:[UIImage imageNamed:@"film_CopyIcn@2x.png"] forState:UIControlStateNormal];
    [copyBtn setImage:[UIImage imageNamed:@"film_CopyIcn@2x.png"] forState:UIControlStateHighlighted];
    copyBtn.backgroundColor = [UIColor clearColor];
    [copyBtn performBlock:^ {
        [PubFunction showMessage:@"复制成功!" keepTime:1.0f];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = _audio;
        [self.shareBackView removeFromSuperview];
        [self.shareView removeFromSuperview];
    }controlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:copyBtn];
    
    UILabel *lbCopy = [[UILabel alloc] initWithFrame:CGRectMake(copyBtn.origin.x-15, copyBtn.origin.y+copyBtn.size.height+10, 75, 14)];
    lbCopy.backgroundColor = [UIColor clearColor];
    lbCopy.textAlignment = NSTextAlignmentCenter;
    lbCopy.font = [UIFont systemFontOfSize:14];
    lbCopy.textColor = [UIColor blackColor];
    [mainView addSubview:lbCopy];
    lbCopy.text = @"复制链接";
    //    }
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:_shareBackView];
    [window addSubview:_shareView];
    [UIView animateWithDuration:0.35 animations:^{
        self.shareView.top=0;
    } completion:^(BOOL finished) {
        
    }];
}
@end
