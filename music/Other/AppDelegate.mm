//
//  AppDelegate.m
//  music
//
//  Created by sghy on 17/3/8.
//  Copyright © 2017年 lzj. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "SettingVC.h"
#import "videoViewController.h"
#import "NewsVC.h"
#import "RDVTabBarItem.h"
#import <AVFoundation/AVFoundation.h>
#import <UMSocialCore/UMSocialCore.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self setViewController];
    self.window.rootViewController = self.drawerController;
    
    NSError* error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    // 设置后台播放的代码,步骤
    // 1.获取音频的会话
    AVAudioSession *session = [AVAudioSession sharedInstance];
    // 2.设置后台播放类型
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    // 3.激活会话
    [session setActive:YES error:nil];
    
    //3D touch
    [self add3DTouch];
    
    //友盟
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:UMAppkey];
    
    //讯飞appid
    //设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_ALL];
    
    //打开输出在console的log开关
    [IFlySetting showLogcat:YES];
    
    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",iflyAppID];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
    
    //分享的平台信息设置
    [self configUSharePlatforms];
    
    [self confitUShareSettings];
    
    //百度地图
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:BaiDuAK  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }

    
    //上次缓存数据
    [self clearAllUserDefaultsData];
    
    return YES;
}
- (void)add3DTouch
{
    //创建系统风格的icon
    UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare];
    
    //    //创建自定义图标的icon
    //    UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"分享.png"];
    
    //创建快捷选项
    UIApplicationShortcutItem * item = [[UIApplicationShortcutItem alloc]initWithType:@"com.mycompany.myapp.share" localizedTitle:@"分享" localizedSubtitle:@"点就对了" icon:icon userInfo:nil];
    
    //添加到快捷选项数组
    [UIApplication sharedApplication].shortcutItems = @[item];
    
    
}
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    MMDrawerController * mmdraw = (MMDrawerController *)window.rootViewController;
    RDVTabBarController * tabbar = (RDVTabBarController *)mmdraw.centerViewController;
    if ([shortcutItem.localizedTitle isEqualToString:@"看地图"]) {
        tabbar.selectedIndex = 1;
    } else if ([shortcutItem.localizedTitle isEqualToString:@"听歌"]) {
        tabbar.selectedIndex = 0;
    }
}
- (void)setViewController
{
    //控制器加载StoryBoard
    ViewController *mainVC = [[ViewController alloc] init];
    mainVC = (ViewController *)[self loadStoryBoardVC:mainVC identifier:@"MainVC"];
    UINavigationController *centerNav = [[UINavigationController alloc] initWithRootViewController:mainVC];
    SettingVC *leftNav = [[SettingVC alloc]init];
    videoViewController * videoVC = [[videoViewController alloc]init];
    UINavigationController *videoNav = [[UINavigationController alloc] initWithRootViewController:videoVC];
    NewsVC *newsVC = [[NewsVC alloc]init];
    UINavigationController *newsNav = [[UINavigationController alloc] initWithRootViewController:newsVC];
    //创建Tabbar
    _tabBarController = [[RDVTabBarController alloc]init];
    [_tabBarController setViewControllers:@[centerNav,videoNav,newsNav]];
    [self customizeTabBarForController:_tabBarController];
    self.drawerController = [[MMDrawerController alloc] initWithCenterViewController:_tabBarController leftDrawerViewController:leftNav rightDrawerViewController:nil];
    self.drawerController.isOpen = YES;//默认开启侧滑
    [self.drawerController setShowsShadow:YES]; // 是否显示阴影效果
    self.drawerController.maximumLeftDrawerWidth = SCREEN_WIDTH*2/4; // 左边拉开的最大宽度
    self.drawerController.maximumRightDrawerWidth = SCREEN_WIDTH*2/4; // 右边拉开的最大宽度
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
}
//填充tabbarTtem
- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    NSArray *tabBarItemImages = @[@"first", @"second", @"third"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[tabBarController tabBar] items]) {
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
                                                      [tabBarItemImages objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
                                                        [tabBarItemImages objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        index++;
    }
}
- (UIViewController *)loadStoryBoardVC:(UIViewController *)vc identifier:(NSString *)identifier{
    vc =[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:identifier];
    return vc;
}
- (void)configUSharePlatforms
{
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxdc1e388c3822c80b" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:@"http://mobile.umeng.com/social"];
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:ShareQQAppId/*设置QQ平台的appID*/  appSecret:ShareQQKey redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置新浪的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:ShareSinaWeibo  appSecret:SinaWeiboSecret redirectURL:@"http://www.baidu.com"];
    
    /* 支付宝的appKey */
    [[UMSocialManager defaultManager] setPlaform: UMSocialPlatformType_AlipaySession appKey:@"2015111700822536" appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
}
- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    [UMSocialGlobal shareInstance].isUsingWaterMark = YES;
     //关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
}
//回调 1.
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
// 支持所有iOS系统 //客户端回调 以前的回调方法。回调 2
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
//仅支持iOS9以上系统，iOS8及以下系统不会回调  ／／回调3
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
- (BOOL) canBecomeFirstResponder {
    return YES;
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    // 在App要终止前结束接收远程控制事件, 也可以在需要终止时调用该方法终止
    [application endReceivingRemoteControlEvents];
}
//在程序挂起的时候，要手动加权限的
- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"\n\n倔强的打出一行字告诉你我要挂起了。。\n\n");
     [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}
#pragma mark 清除网络缓存数据
- (void)clearAllUserDefaultsData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dic = [userDefaults dictionaryRepresentation];
    for (id  key in dic)
    {
        if ([key isKindOfClass:[NSString class]])
        {
            NSString * keyStr = key;
            if (keyStr.length > 15)
            {
                 [userDefaults removeObjectForKey:key];
            }
        }
    }
    [userDefaults synchronize];
}
@end
