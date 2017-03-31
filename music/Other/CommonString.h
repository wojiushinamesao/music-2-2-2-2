//
//  CommonString.h
//  dream
//
//  Created by zhengkai on 15/1/31.
//  Copyright (c) 2015年 zhengkai. All rights reserved.
//
#import "UIView+AnimateExtension.h"
#import "UIButton_Category.h"
#import "UIView_Category.h"
#import "NSObject+MethodExt.h"
#import "PubFunction.h"
#import <Foundation/Foundation.h>
#import "MMDrawerController.h" // 引入第三方库
#import "RDVTabBarController.h"
#import "AppDelegate.h"
#import "BaseViewController.h"
#import "ReloadDataModel.h"
#import "mainTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "Config.h"
#import <CoreLocation/CoreLocation.h>
#import <UShareUI/UShareUI.h>
#import "UIAlertView+Blocks.h"
#import <iflyMSC/IFlySpeechRecognizerDelegate.h>
#import <iflyMSC/IFlySpeechRecognizer.h>
#import "iflyMSC/IFlyMSC.h"
/**
 Create a UIColor with r,g,b values between 0.0 and 1.0.
 */
#define RGBCOLOR(r,g,b) \
[UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1.f]
// 取得AppDelegate单利
#define ShareApp ((AppDelegate *)[[UIApplication sharedApplication] delegate])
/**
 Create a UIColor with r,g,b,a values between 0.0 and 1.0.
 */
#define RGBACOLOR(r,g,b,a) \
[UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]


#define kDispatchAllocSingleton(instance, implement) \
static id instance = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance = [[implement alloc] init];\
});
//控制器__block
#define weakify(...) \
ext_keywordify \
metamacro_foreach_cxt(ext_weakify_,, __weak, __VA_ARGS__)

#define strongify(...) \
ext_keywordify \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
metamacro_foreach(ext_strongify_,, __VA_ARGS__) \
_Pragma("clang diagnostic pop")

#define HEXCOLOR(hexValue) \
[UIColor colorWithRed:((CGFloat)((hexValue & 0xFF0000) >> 16))/255.0 \
green:((CGFloat)((hexValue & 0xFF00) >> 8))/255.0 \
blue:((CGFloat)(hexValue & 0xFF))/255.0 alpha:1.0] \

#define HEXACOLOR(hexValue,alpha1) \
[UIColor colorWithRed:((CGFloat)((hexValue & 0xFF0000) >> 16))/255.0 \
green:((CGFloat)((hexValue & 0xFF00) >> 8))/255.0 \
blue:((CGFloat)(hexValue & 0xFF))/255.0 alpha:alpha1] \

//输出宏定义
#define NSSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#define STRING_NET_ERROR                    @"网络异常，请稍候重试！"
#define NEWS_RELODATA         @"Nofification_NEWS_RELODATA"
#define NEWS_GO_Detail         @"Nofification_NEWS_GO_Detail"
#define RouteChangeTF         @"Nofification_RouteChangeTF"
//平台appkey
#define BaiDuAppID                  @"155155d6d0"
#define UMAppkey                     @"58c6b8058f4a9d19590009cd"

#define ShareQQAppId                @"1106054988"
#define ShareQQKey                  @"mDubcQZ9B1VFTCvz"

#define ShareSinaWeibo              @"545001875"
#define SinaWeiboSecret             @"966cd48001cee332d101f99b319b97dd"

#define ShareWeixinAppID            @"wx09539aab392fb572"
#define ShareWeixinAppSecret        @"efaa1a461cd88fca83e051a24f588689"

#define PayWeixinAppID              @"wx2a8a1141b748b72a"
#define PayWeixinAppSecret          @"c27c738a774182167e909593749e3042"

#define BaiDuAK                    @"RdpnzIX3ZUPgnR7FpHUPfKy3Em1OHhGq"
#define bundleID                   @"com.yy.music"
#define BaiDuService_id            136548
#define BaiDuUserLocation            @"Jin"

#define iflyAppID                  @"58db2e26"

#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]


#define IOS6_IFDEF  (#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0)
#define IOS6_ENDIF  (#endif)


#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define STATUS_BAR_HEIGHT		20		//系统状态栏高度
#define NAVIGATION_BAR_HEIGHT	44		//导航状态栏高度
#define TAB_BAR_HEIGHT			49		//底部栏高度
#define TOP_HEIGHT              64

#define COLOR_BLUECOLOR    RGBCOLOR(23,159,237)
#define COLOR_REDCOLOR     HEXCOLOR(0xF85340)

#define COLOR_BLACK333     HEXCOLOR(0x333333)
#define COLOR_BLACK666     HEXCOLOR(0x666666)
#define COLOR_BLACK999     HEXCOLOR(0x999999)

#define COLOR_BORDER       HEXCOLOR(0xe5e5e5)
#define COLOR_LINE         RGBCOLOR(236,236,236)
#define COLOR_BACKGROUND   RGBCOLOR(245, 245, 245)//HEXCOLOR(0xf5f5f5)


#define COLOR_GREENCOLOR   RGBCOLOR(59, 196, 76)
#define COLOR_ORANGECOLOR  RGBCOLOR(249, 148, 18)
#define COLOR_GRAYCOLOR    RGBCOLOR(212, 212, 212)

#define COLOR_BLACK_CONTENT  RGBCOLOR(102, 102, 102)
#define COLOR_BLACK_TITLE    RGBCOLOR(46, 46, 46)

#define COLOR_TALBECOLOR        RGBCOLOR(247, 246, 246)
#define COLOR_TALBELINE1COLOR   RGBCOLOR(229, 229, 229)
#define COLOR_TALBELINE2COLOR   RGBCOLOR(255, 255, 255)
#define COLOR_TALBELINE3COLOR   RGBCOLOR(128, 128,128)
#define COLOR_TALBELINE4COLOR   RGBCOLOR(240, 240,240)
#define COLOR_BLACK63      RGBCOLOR(63, 63, 63)
#define COLOR_BLACK51      RGBCOLOR(51, 51, 51)
#define COLOR_BLACK128      RGBCOLOR(128, 128, 128)
#define COLOR_BLACK102      RGBCOLOR(102, 102, 102)
#define COLOR_BLUESKYCOLOR_1    RGBCOLOR(104,182,239) //浅蓝
#define COLOR_BLUESKYCOLOR    RGBCOLOR(135,206,250) //天空色 
#define COLOR_LINE246    RGBCOLOR(246,246,246) //线
#define COLOR_WHITE      RGBCOLOR(255,255,255)
#define COLOR_BLACK153      RGBCOLOR(153, 153, 153)

#define COLOR_BLACKLINE_8        RGBCOLOR(236, 236, 236)
#define COLOR_GRAYCOLOR_7      RGBCOLOR(102, 102, 102)
#define COLOR_BLACKLINE        RGBCOLOR(214, 214, 214)
#define COLOR_GRAYCOLOR_1      RGBCOLOR(127, 129, 132)
#define COLOR_GRAYCOLOR_2      RGBCOLOR(228, 228, 228)
#define COLOR_GRAYCOLOR_3      RGBCOLOR(190, 190, 190)
#define COLOR_GRAYCOLOR_4      RGBCOLOR(148, 148, 148)
#define COLOR_GRAYCOLOR_5      RGBCOLOR(247, 246, 246)
#define COLOR_GRAYCOLOR_6      RGBCOLOR(156, 156, 156)

#define COLOR_ORANGEColor      RGBCOLOR(253, 163, 47)

#define define_BindcardId [LoginSingleton sharedSingleton].BindcardId//用户绑定会员卡或者优惠卡卡编号

#define  define_bindCardType [LoginSingleton sharedSingleton].bindCardType////绑定实体卡类型 0代表未绑定任何卡 1 代表实体会员卡 2代表优惠卡
#define  define_LookNum [LoginSingleton sharedSingleton].LookNum////绑定实体卡类型 0代表未绑定任何卡 1 代表实体会员卡 2代表优惠卡
#define define_CardBack [LoginSingleton sharedSingleton].CardBack//优惠卡支付充值，返回页面指引。
#define define_SaleList [LoginSingleton sharedSingleton].SaleList //1.卖品 2.周边
#define define_Status [LoginSingleton sharedSingleton].status //状态。判断为加群失败
#define define_sendCouponSumS [LoginSingleton sharedSingleton].sendCouponSumS //注册成功劵


typedef void(^MyCompletionBlock)(id obj);
typedef void(^MyRefreshBlock)(id obj);

typedef enum {
    searchDefault,//主页上点搜索
    searchStart,//路线规划页面点起始位
    searchEnd // 路线规划页面点终止位
} SerchType;

#define CODE_LOGINGOUT     20001
#define CODE_TOKENTIMEOUT  10001

#define IS_IPhone6plus (736 == [[UIScreen mainScreen] bounds].size.height ? YES : NO)
#define IS_IPhone6 (667 == [[UIScreen mainScreen] bounds].size.height ? YES : NO)
#define IS_IPhone5 (568 == [[UIScreen mainScreen] bounds].size.height ? YES : NO)
#define IS_IPhone4 (480 == [[UIScreen mainScreen] bounds].size.height ? YES : NO)

@interface CommonString : NSObject

@end
