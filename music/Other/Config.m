//
//  Config.m
//  Project
//
//  Created by 甘良栋 on 13-10-15.
//  Copyright (c) 2013年 tbanana. All rights reserved.
//

#import "Config.h"
#import "AppDelegate.h"

#define ConfigData_SaveTime    @"ConfigData_SaveTime"
#define ConfigData_Value       @"ConfigData_Value"
#define ConfigData_KeepTime    @"ConfigData_KeepTime"


@implementation Config

@synthesize isLogin;  

#pragma mark - 唯一值

- (NSString*)getDvieceId {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"DeivceId"];
}

- (void)saveDeviceId:(NSString*)deviceId {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString *str = [settings objectForKey:@"DeivceId"];
    if(str && str.length > 0) {
        return;
    }
    
    [settings removeObjectForKey:@"DeivceId"];
    [settings setObject:deviceId forKey:@"DeivceId"];
    [settings synchronize];
}


#pragma mark - 登录

- (BOOL)getIsLogin {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    return [[settings objectForKey:@"IsLogin"] boolValue];
}


- (void)saveIsLogin:(BOOL)bLogin {
    
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"IsLogin"];
    [settings setObject:[NSNumber numberWithInt:bLogin] forKey:@"IsLogin"];
    [settings synchronize];
}

#pragma mark - 付款中使用爱来卡
- (void)saveisUserAlkCard:(BOOL)alk
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"IsUserAlkCard"];
    [settings setObject:[NSNumber numberWithInt:alk] forKey:@"IsUserAlkCard"];
    [settings synchronize];
}

- (void)saveisUserVoucher:(BOOL)Voucher
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"IsUserVoucher"];
    [settings setObject:[NSNumber numberWithInt:Voucher] forKey:@"IsUserVoucher"];
    [settings synchronize];
}

- (BOOL)getIsUserAlkCard
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    return [[settings objectForKey:@"IsUserAlkCard"] boolValue];
}
- (BOOL)getIsUserVoucher
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    return [[settings objectForKey:@"IsUserVoucher"] boolValue];
}

-(int)getLoginType // 1普通用户登录  2会员卡登录 3
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    return [[settings objectForKey:@"getLoginType"]intValue];
    
}
-(void)saveLoginType:(int)type {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"getLoginType"];
    [settings setObject:[NSNumber numberWithInt:type] forKey:@"getLoginType"];
    [settings synchronize];
}


- (NSString*)getBindCard {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"BindCard"];
}


- (NSString*)getBindPhone {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"BindPhone"];
}


- (NSString*)getVoucherReminder
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"VoucherReminder"];
}

- (void)saveVoucherReminder
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"VoucherReminder"];
    [settings setObject:[NSString stringWithFormat:@"VoucherReminder"] forKey:@"VoucherReminder"];
    [settings synchronize];
}

- (void)saveBindCard:(NSString*)bindCard {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"BindCard"];
    [settings setObject:[NSString stringWithFormat:@"%@",bindCard] forKey:@"BindCard"];
    [settings synchronize];
}



- (void)saveBindPhone:(NSString*)bindPhone {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"BindPhone"];
    [settings setObject:[NSString stringWithFormat:@"%@",bindPhone] forKey:@"BindPhone"];
    [settings synchronize];
}


- (void)saveMeberGroupId:(NSString*)memberGroupId {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"memberGroupId"];
    [settings setObject:memberGroupId forKey:@"memberGroupId"];
    [settings synchronize];
}

- (NSString*)getMeberGroupId {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"memberGroupId"];
}


- (void)saveMeberGroupIdName:(NSString*)memberGroupName {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"memberGroupName"];
    [settings setObject:memberGroupName forKey:@"memberGroupName"];
    [settings synchronize];
}

- (NSString*)getMeberGroupName {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString *name = [settings objectForKey:@"memberGroupName"];
    if(name.length == 0) {
        name = @"普通会员";
    }
    return name;
}



-(void)savePhoneNum:(NSString*)tel {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"PhoneNum"];
    [settings setObject:[NSString stringWithFormat:@"%@",tel] forKey:@"PhoneNum"];
    [settings synchronize];
}

-(NSString*)getPhoneNum {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"PhoneNum"];
}

-(void)saveMemberNum:(NSString*)num {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"MemberNum"];
    [settings setObject:[NSString stringWithFormat:@"%@",num] forKey:@"MemberNum"];
    [settings synchronize];
}
-(void)saveUseInFor:(NSDictionary*)UseInForDic
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"UseInFor"];
    [settings setObject:UseInForDic forKey:@"UseInFor"];
    [settings synchronize];

}
-(void)saveMovieId:(NSString*)MovieId
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"MovieId"];
    [settings setObject:MovieId forKey:@"MovieId"];
    [settings synchronize];

}
- (NSString*)MovieId
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"MovieId"];

}
-(NSString*)getMenberNum {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"MemberNum"];
}
- (NSDictionary*)UseInFor{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"UseInFor"];
}


- (void)saveLoginMessage:(NSDictionary*)dic {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"LoginMessage"];
    [settings setObject:dic forKey:@"LoginMessage"];
    [settings synchronize];
}


- (NSDictionary*)getLoginMessage {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"LoginMessage"];
}


- (void)deleteLoginMessage {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"LoginMessage"];
    [settings synchronize];

}


-(void)saveStoreId:(NSString*)storeid {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"StoreId"];
    [settings setObject:[NSString stringWithFormat:@"%@",storeid] forKey:@"StoreId"];
    [settings synchronize];
}

-(NSString*)getStoreId {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"StoreId"];
}

-(void)saveUserName:(NSString *)userName {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"UserName"];
    [settings setObject:[NSString stringWithFormat:@"%@",userName] forKey:@"UserName"];
    [settings synchronize];
}

-(void)saveUserIcn:(NSString *)userIcn {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"userIcn"];
    [settings setObject:[NSString stringWithFormat:@"%@",userIcn] forKey:@"userIcn"];
    [settings synchronize];
}
-(NSString *)getUserName {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"UserName"];
}
-(NSString *)getUserIcn {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"userIcn"];
}

-(void)saveUID:(NSString*)uid {
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"UID"];
    [setting setObject:uid forKey:@"UID"];
    [setting synchronize];
}

-(NSString*)getUID {
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    return [setting objectForKey:@"UID"];
}

-(void)saveLogo:(NSString*)logo {
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"uLogo"];
    [setting setObject:[NSString stringWithFormat:@"%@",logo] forKey:@"uLogo"];
    [setting synchronize];
}

-(NSString*)getLogo {
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    return [setting objectForKey:@"uLogo"];
}

-(void)saveIfBindALK:(BOOL)YON{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"isBindALK"];
    [settings setBool:YON forKey:@"isBindALK"];
    [settings synchronize];
}
-(BOOL)getIfBindALK{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    return [settings boolForKey:@"isBindALK"];
}
- (void)saveScanCode:(BOOL)Code
{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"SweepCodePaymentBind"];
    [settings setBool:Code forKey:@"SweepCodePaymentBind"];
    [settings synchronize];
}
-(BOOL)getScanCode{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    return [settings boolForKey:@"SweepCodePaymentBind"];
}


//存取用户票券数
- (void)saveUserTicket:(NSInteger)count{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"userTicketCount"];
    [settings setObject:@(count) forKey:@"userTicketCount"];
    [settings synchronize];
}
//获取用户票券数
- (NSNumber*)getUserTicet{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"userTicketCount"];
}
- (void)saveIntegralOutDay:(NSInteger)day{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"integralOutDay"];
    [settings setObject:@(day) forKey:@"integralOutDay"];
    [settings synchronize];
}
- (NSInteger)getIntegralOutDay{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    NSNumber *num = [settings objectForKey:@"integralOutDay"];
    return [num integerValue];
}
- (NSString*)getCinemaPhone
{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"CinemaPhone"];
}
-(void)saveCinemaPhone:(NSString*)Phone
{
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"CinemaPhone"];
    [setting setObject:[NSString stringWithFormat:@"%@",Phone] forKey:@"CinemaPhone"];
    [setting synchronize];
}
-(BOOL)isLogin {
    return [self getIsLogin];
}

-(void)saveSeesionToken:(NSString*)sToken {
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"SessionToken"];
    [setting setObject:sToken forKey:@"SessionToken"];
    [setting synchronize];
}

-(NSString*)getSessionToken {
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    return [setting objectForKey:@"SessionToken"];
}

//退出登录
-(void)loginOut
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"RememberPwd"];
    [settings removeObjectForKey:@"getLoginType"];
    [settings removeObjectForKey:@"UserName"];
    [settings removeObjectForKey:@"Password"];
    [settings removeObjectForKey:@"UID"];
    [settings removeObjectForKey:@"uLogo"];
    [settings removeObjectForKey:@"SessionToken"];
    [settings removeObjectForKey:@"MemberNum"];
    [settings removeObjectForKey:@"PhoneNum"];
    [settings removeObjectForKey:@"StoreId"];
    
    [settings synchronize];
    self.isLogin = NO;
}

//是否显示欢迎界面
-(BOOL)showWelcome
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    BOOL welcome = [[settings objectForKey:@"WelcomeVersion"] boolValue];
    return !welcome;
    
}
-(void)didWelcome
{
     NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings setValue:[NSNumber numberWithBool:1] forKey:@"WelcomeVersion"];
    [settings synchronize];
}


#pragma mark - 倒计时
- (void)saveObj:(NSString*)obj
       overtime:(unsigned long long)time {
    
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings setObject:[NSString stringWithFormat:@"%lld",time] forKey:[NSString stringWithFormat:@"Timer%@",obj]];
    [settings synchronize];
}

- (unsigned long long)getObjOverTime:(NSString*)obj {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    return [[settings objectForKey:[NSString stringWithFormat:@"Timer%@",obj]] longLongValue];
}



#pragma mark - 影院选择

- (NSString*)getStopSaleTime
{
   NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    for (NSDictionary *dic in [settings objectForKey:@"CinemaInfo"]) {
        if ([dic[@"cinemaList"] isKindOfClass:NSClassFromString(@"NSArray")]) {
            for (NSDictionary *dicTime in dic[@"cinemaList"]) {
                if([[dicTime objectForKey:@"cinemaCode"] isEqualToString:[self getCinemaPlaceNo]]) {
                    return  [dicTime objectForKey:@"stopSaleTime"];
                }
            }
        }
    }
    return nil;
}

- (NSString*)getCinemaPlaceNo
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString *placeNo = [settings objectForKey:@"cinemaCode"];
    
    if(placeNo && placeNo.length > 0) {
        return placeNo;
    }
    
    NSArray *arr = [self getCinemaInfo];
    if(arr.count > 0) {
        NSDictionary *dic = arr[0];
        NSArray *OneArray=dic[@"cinemaList"];
        NSDictionary *dics =OneArray[0];
        [self saveCinemaPlaceNo:dics[@"cinemaCode"]];
        NSString *cinemaCode = dics[@"cinemaCode"];
        if (cinemaCode != nil) {
            return dics[@"cinemaCode"];
        } else {
            NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
            NSString *placeNo = [settings objectForKey:@"PlaceNo"];
            if(placeNo && placeNo.length > 0) {
                return [settings objectForKey:@"PlaceNo"];
            }

        }
    }
    return @"35012401";
}
- (NSString*)getCinemaShortName:(NSInteger )teger
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    for(NSDictionary *dic in [settings objectForKey:@"CinemaInfo"]) {
        
        NSArray *ListArray=dic[@"cinemaList"];
        NSDictionary *dicA=ListArray[teger];
        
        if([[dicA objectForKey:@"cinemaCode"] isEqualToString:[self getCinemaPlaceNo]]) {
            return  [dicA objectForKey:@"shortName"];
        }
    }
    return @"";
}
- (NSString*)getCinemaShortName {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString *string= [settings objectForKey:@"cinemaName"];
    
    if (string.length==0) {
        for(NSDictionary *dic in [settings objectForKey:@"CinemaInfo"]) {
            
            NSArray *ListArray=dic[@"cinemaList"];
            NSDictionary *dicA=ListArray[0];
            
            if([[dicA objectForKey:@"cinemaCode"] isEqualToString:[self getCinemaPlaceNo]]) {
                return  [dicA objectForKey:@"shortName"];
            }
        }

    }
    
//    for(NSDictionary *dic in [settings objectForKey:@"CinemaInfo"]) {
//        
//        NSLog(@"getCinemaShortName===%@",dic);
//
//        if([[dic objectForKey:@"cinemaCode"] isEqualToString:[self getCinemaPlaceNo]]) {
//            return  [dic objectForKey:@"shortName"];
//        }
//    }
    return string;
}
-(BOOL)getVersion{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    return [settings boolForKey:@"Version"];
}

/**
 *    保存是否是最新版本
 */
-(void)saveVersion:(BOOL)Version
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"Version"];
    [setting setBool:Version forKey:@"Version"];
    [setting synchronize];

}
- (NSString*)getCinemaLongName {
    
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString *LongName= [settings objectForKey:@"APPcinemaName"];

    
    return LongName;
}

-(void)saveCinemaPlaceNo:(NSString*)placeNo  {
    
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"cinemaCode"];
    [setting setObject:placeNo forKey:@"cinemaCode"];
    [setting synchronize];
}
-(void)saveCinemaName:(NSString*)Name  {
    
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"CinemaName"];
    [setting setObject:Name forKey:@"CinemaName"];
    [setting synchronize];
}
#pragma mark - 影院选择
- (NSString*)getCinemaName
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString *Name = [settings objectForKey:@"CinemaName"];
    if(Name && Name.length > 0) {
        return Name;
    }
    return @"测试影院";

}
- (NSString*)getCinemaName1
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString *Name = [settings objectForKey:@"APPcinemaName"];
    if(Name && Name.length > 0) {
        return Name;
    }
    return @"测试影院";
    
}
- (NSArray*)getCinemaInfo {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"CinemaInfo"];
}

/**
 *  保存当前选择的城市影院
 */
- (void)saveCurrentCinema:(NSArray*)arr{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"CurrentCinemaArr"];
    [settings setObject:arr forKey:@"CurrentCinemaArr"];
    [settings synchronize];
}
/**
 * 获取当前选择的城市影院
 */
- (NSArray*)getCurrentCinema{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"CurrentCinemaArr"];
}

/*************  设备部分   ***********/

//用户坐标
-(void)saveLocationLat:(NSString*)lat lon:(NSString*)lon
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"LocationLon"];
    [setting setObject:lon forKey:@"LocationLon"];
    [setting removeObjectForKey:@"LocationLat"];
    [setting setObject:lat forKey:@"LocationLat"];
    [setting synchronize];
    
}
-(NSString*)getLocationLon
{
    //经度
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString * value = [setting objectForKey:@"LocationLon"];
    if (!value) {
        return @"119.28";
    }
    return value;
}
-(NSString*)getLocationLat
{
    //纬度
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString * value = [setting objectForKey:@"LocationLat"];
    if (!value) {
        return @"26.08";
    }
    return value;
}


//获取App版本
-(NSString*)getAppVersion
{
    NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return version;
}
-(void)SAveAppVersion:(NSString*)Version
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"ZRBundleShortVersionString"];
    [setting setObject:Version forKey:@"ZRBundleShortVersionString"];
    [setting synchronize];
    
}
//获取App版本
-(NSString*)getZRAppVersion
{
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSString * value = [setting objectForKey:@"ZRBundleShortVersionString"];
    return value;
}

//获取系统版本如：7.1
-(double)getSystemVersion
{
    return [[[UIDevice currentDevice]systemVersion] doubleValue];
}

//获取系统名称如 :ganld
-(NSString*)getSystemName
{
    return [[UIDevice currentDevice]systemName];
}


//设备Token ---推送
- (void)saveTokenId:(NSString*)vale
           KeepTIme:(NSString*)keepTime {
    
    NSDictionary *dic = @{ConfigData_Value : vale,
                          ConfigData_KeepTime : keepTime,
                          ConfigData_SaveTime : [PubFunction getTimeNow]};
    
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"TokenId"];
    [setting setObject:dic forKey:@"TokenId"];
    [setting synchronize];
}

- (void)removeToken {
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"TokenId"];
    [setting synchronize];
}

- (BOOL)isTokenIdTimeOut {
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [setting objectForKey:@"TokenId"];
    if(!dic || ![dic objectForKey:ConfigData_Value]) {
        return YES;
    }
    
    if([PubFunction isTimeOut:[dic objectForKey:ConfigData_SaveTime] keepTime:[dic objectForKey:ConfigData_KeepTime]]) {
        return YES;
    } else {
        return NO;
    }
    return YES;
}

- (NSString*)getTokenId {
    
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [setting objectForKey:@"TokenId"];
    if(dic) {
        return [dic objectForKey:ConfigData_Value];
    }
    
    return nil;
}

- (void)savePushMessage:(BOOL )Message
{
    
    NSUserDefaults * setting = [NSUserDefaults standardUserDefaults];
    [setting removeObjectForKey:@"PushMessageTO"];
    [setting setBool:Message forKey:@"PushMessageTO"];
    [setting synchronize];
}
- (BOOL)PushMessage
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    return [settings boolForKey:@"PushMessageTO"];
}

- (void)saveMessUser:(BOOL)YON{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"hasMessUser"];
    [settings setBool:YON forKey:@"hasMessUser"];
    [settings synchronize];
}
- (BOOL)haveMessUser{
    NSUserDefaults *settings=[NSUserDefaults standardUserDefaults];
    return [settings boolForKey:@"hasMessUser"];
}
-(void)saveUserInfo_new:(NSDictionary*)dic
{
    NSUserDefaults *settiongs =[NSUserDefaults standardUserDefaults];
    [settiongs removeObjectForKey:@"SaveUserInfo_new"];
    [settiongs setObject:dic forKey:@"SaveUserInfo_new"];
    [settiongs synchronize];
}
- (NSDictionary*)getSaveUserInfo_new{
    NSUserDefaults *settings =[NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"SaveUserInfo_new"];
}
- (void)saveWXUserInfo:(NSDictionary*)dic{
    NSUserDefaults *settiongs =[NSUserDefaults standardUserDefaults];
    [settiongs removeObjectForKey:@"sendSaveUserInfo"];
    [settiongs setObject:dic forKey:@"sendSaveUserInfo"];
    [settiongs removeObjectForKey:@"sendTime"];
    [settiongs setObject:[PubFunction getTimeNow] forKey:@"sendTime"];
    [settiongs synchronize];
}
- (NSDictionary*)getWxUserInfo{
    NSUserDefaults *settings =[NSUserDefaults standardUserDefaults];
    return [settings objectForKey:@"sendSaveUserInfo"];
}
- (BOOL)getIfOutTimeSendInfo{
    NSUserDefaults *settins =[NSUserDefaults standardUserDefaults];
    long long keepTime =3*24*3600;
    long long time = [[settins objectForKey:@"sendTime"] longLongValue];
    NSInteger interval = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]];
    NSDate *localeDate = [[NSDate date]  dateByAddingTimeInterval: interval];
    long long timeNow = (long long)[localeDate timeIntervalSince1970];
    if(timeNow - time < keepTime) {  //时间有效
        return NO;
    } else {
        return YES;
    }
    return YES;
}


/*************  设备部分 End   ***********/

  
static Config * instance = nil;
+(Config *)share
{
    @synchronized(self)
    {
        if(nil == instance)
        {
            [self new];
           
        }
     
    }
    return instance;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if(instance == nil)
        {
            instance = [super allocWithZone:zone];
            instance.isLogin = NO;
            return instance;
        }
    }
    return nil;
}
+(void)removeAllKeys
{
    
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    [settings removeObjectForKey:@"RememberPwd"];
    [settings removeObjectForKey:@"getLoginType"];
    [settings removeObjectForKey:@"UserName"];
    [settings removeObjectForKey:@"Password"];
     [settings removeObjectForKey:@"cookie"];
    [settings removeObjectForKey:@"UID"];
    [settings removeObjectForKey:@"uLogo"];
    [settings removeObjectForKey:@"SessionToken"];
    [settings removeObjectForKey:@"MemberNum"];
    [settings removeObjectForKey:@"PhoneNum"];
    [settings removeObjectForKey:@"StoreId"];
    
    [settings removeObjectForKey:@"CouponMsgNotice"];
    [settings removeObjectForKey:@"WelcomeVersion"];
    [settings removeObjectForKey:@"GuideTypeMain"];
    [settings removeObjectForKey:@"GuideTypeLoc"];
    [settings removeObjectForKey:@"GuideTypePlan"];
    [settings removeObjectForKey:@"GuideTypeMDet"];
    [settings removeObjectForKey:@"MsgPush"];
    [settings removeObjectForKey:@"TokenId"];    
    [settings removeObjectForKey:@"MsgPush"];
    [settings removeObjectForKey:@"saveCinema"];
    [settings removeObjectForKey:@"DefaultCinema"];
    [settings removeObjectForKey:@"couponSwitch"];
    [settings removeObjectForKey:@"LocationLon"];
    [settings removeObjectForKey:@"LocationLat"];
    [settings synchronize];
    
    
}


@end
