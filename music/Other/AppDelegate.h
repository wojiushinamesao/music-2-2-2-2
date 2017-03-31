//
//  AppDelegate.h
//  music
//
//  Created by sghy on 17/3/8.
//  Copyright © 2017年 lzj. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BMKMapManager* _mapManager;
}
@property (nonatomic,strong) MMDrawerController *drawerController;
@property (nonatomic,strong) RDVTabBarController * tabBarController;
@property (strong, nonatomic) UIWindow *window;



@end

