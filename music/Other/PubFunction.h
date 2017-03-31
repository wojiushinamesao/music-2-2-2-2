//
//  PubFunction.h
//  dream
//
//  Created by zhengkai on 14/12/8.
//  Copyright (c) 2014年 zhengkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface PubFunction : NSObject

/**
 *  当前时间时间戳
 */
+ (NSString *)getTimeNow;
/**
 *  根据字符串获取时间戳
 */
+ (NSTimeInterval)getTimeInterValWithStr:(NSString*)str format:(NSString*)format;


/**
 *  时间戳转字符串
 */
+ (NSString*)getTime:(NSInteger)time;

/**
 *  时间戳转字符串格式
 */
+ (NSString*)getTime:(NSInteger)time
              Format:(NSString*)format;

/**
 *  获取时间戳
 */
+ (unsigned long long)getTimesp:(NSDate*)date;


/**
 *  获取刷新时间
 */
+ (NSString*)getRefreshTime;


/**
 *  获取刷新时间
 */
+ (NSString*)getRefreshTimeSecond;


/**
 *  判断是否时间过期
 */
+ (BOOL)isTimeOut:(NSString*)strTime
         keepTime:(NSString*)keepTime;

/**
 *  获取html字符串
 */
+ (NSString*)getHtmlString:(NSString*)str;
+ (NSString*)getHtmlStringChang:(NSString*)str;
+ (NSString*)getHtmlStringNew:(NSString*)str;

/**
 *  显示信息
 */
+ (void)showMessage:(NSString*)str;

+ (void)showHubMessage:(NSString*)str
                    vc:(UIView*)view;

//显示信息
+ (void)showHubMessage:(NSString*)str
                    vc:(UIView*)view isSuccess:(BOOL)isSuccess;
//自定义图片显示信息
+ (void)showHubMessage1:(NSString*)str
                    vc:(UIView*)view image:(NSString *)imageName;
/**
 *  显示信息保持几秒后消失
 */
+ (void)showMessage:(NSString*)str
           keepTime:(CGFloat)time;


/**
 *  添加无数据时候的图片
 */
+ (UIImageView*)addNoImage:(NSString*)imageName
                      view:(UIView*)view;


/**
 *  添加无数据时候的图片,文字
 */
+ (UIImageView*)addNoImage:(NSString*)imageName
                   content:(NSString*)content
                      view:(UIView*)view;

+ (UIImageView*)addNoImage:(NSString*)imageName
                   content:(NSString*)content
                         y:(CGFloat)y
                      view:(UIView*)view;

/**
 *  删除无数据时候的图片
 */
+ (void)removeNoImage:(UIView*)view;

/**
 *  获取删除无数据时候的图片
 */
+ (UIImageView*)getNoImage:(UIView*)view;

/**
 *  获取结束时间
 */
+ (NSString *)getOverTimeBegin:(NSString*)begin
                          keep:(NSString*)keep;


/**
 *  获取日期显示
 */

+ (NSString *)getWeekDayFordate:(long long)data;

+ (NSString*)getWeekString:(NSString*)strDate;

+ (NSString*)getHoursString:(NSInteger)second;
/**
 *  获取设备唯一id
 */
+ (NSString*)getOnlyDeviceKey;

/**
 *  添加电影类型
 */
+ (void)AddFilmType:(NSString*)type
               view:(UIView*)view;

+ (void)AddFilmFrame:(CGRect)theRect
                Type:(NSString*)type
                view:(UIView*)view;

/**



**
 *  获取剪短后的文字
 */
+ (NSString*)getCutString:(NSString*)str
                   Length:(NSInteger)length;


/**
 *  获取合适的价格
 */
+ (CGFloat)getCurrentPrise:(NSDictionary*)dic;
/**
 * 不同的座区获取合适的价格
 */
+ (CGFloat)getFitPriceInDiffernt:(NSDictionary*)dic seatPieceNo:(NSInteger)seatPNo;

/**
 * 获取服务费
 */
+ (CGFloat)getServicePrice:(NSDictionary*)dic;
/**
 * 获取不同座区的服务费
 */
+ (CGFloat)getPieceServicePrice:(NSDictionary*)dic seatPieceNo:(NSInteger)seatPNo;


/**
 *  获取合线
 */
+ (UIView*)getLine:(CGRect)rect;


/**
 *  验证手机号
 */
+ (BOOL)checkPhoneNum:(NSString*)phoneNum;



@end
