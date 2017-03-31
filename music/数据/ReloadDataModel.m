//
//  ReloadDataModel.m
//  music
//
//  Created by sghy on 17/3/8.
//  Copyright © 2017年 lzj. All rights reserved.
//
#define dataKeepTime "3600"//一小时内数据缓存
#import "ReloadDataModel.h"
#import "AFHTTPRequestOperationManager.h"

@implementation ReloadDataModel

+ (void)getData:(NSString *)urlStr successBlock:(void (^)(id))block
{
    //中文转UTF8
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * oldDic = [defaults objectForKey:urlStr];
    //判断是否存在未过期数据
    if (oldDic.count >0 && ![self isTimeOut:oldDic[@"DataSaveTime"] keepTime:@dataKeepTime])
    {
        if (block)
        {
            block(oldDic);
        }
        return;
    }
    //1.请求管理器
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //去除value内空 导致取值崩溃问题
    AFJSONResponseSerializer *response = (AFJSONResponseSerializer *)manager.responseSerializer;
    response.removesKeysWithNullValues = YES;
    response.acceptableContentTypes = [NSSet setWithObjects:@"text/json",@"application/json",@"text/html", nil];
    //2.发起请求
     NSSLog(@"urlStr == %@", urlStr);
    [manager GET:urlStr parameters:nil success: ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSSLog(@"%@", responseObject);
        NSDictionary * dic = (NSDictionary *)responseObject;
        if (block)
        {
            block(dic);
            NSMutableDictionary * mubDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
            [mubDic setObject:[self getTimeNow] forKey:@"DataSaveTime"];
            [defaults setObject:mubDic forKey:urlStr];
            [defaults synchronize];
        }
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSSLog(@"%@", error);
    }];
}
+ (NSString *)getTimeNow {
    NSInteger interval = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]];
    NSDate *localeDate = [[NSDate date]  dateByAddingTimeInterval: interval];
    long long timeNow = (long long)[localeDate timeIntervalSince1970];
    return [NSString stringWithFormat:@"%lld",timeNow];
}
+ (BOOL)isTimeOut:(NSString*)strTime
         keepTime:(NSString*)keepTime {
    long long time = [strTime longLongValue];
    long long timeNow = [[self getTimeNow] longLongValue];
    if(timeNow - time < [keepTime integerValue])
    {  //时间未过期
        return NO;
    } else {
        return YES;
    }
    return YES;
}
@end
