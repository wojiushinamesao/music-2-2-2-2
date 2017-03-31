//
//  Config.h
//  Project
//
//  Created by 甘良栋 on 13-10-15.
//  Copyright (c) 2013年 tbanana. All rights reserved.
//

#import <Foundation/Foundation.h> 

@interface Config : NSObject

@property (nonatomic, assign) BOOL isUserAlkCard;//付款使用了爱来卡

@property (nonatomic, assign) BOOL isUserVoucher;//付款使用了票券

/*************  APP及用户部分   ***********/

@property (nonatomic,assign)BOOL isLogin;

#pragma mark - 唯一值

- (NSString*)getDvieceId;

- (void)saveDeviceId:(NSString*)deviceId;

#pragma mark - 登录

/**
 *    保存是否付款使用了爱来卡
 */
- (void)saveisUserAlkCard:(BOOL)alk;

/**
 *    保存是否付款使用了票券
 */
- (void)saveisUserVoucher:(BOOL)Voucher;

/**
 *    获取是否付款使用了爱来卡
 */
- (BOOL)getIsUserAlkCard;
/**
 *    获取是否付款使用了票券
 */
- (BOOL)getIsUserVoucher;
/**
 *    获取是否已经登陆
 */
- (BOOL)getIsLogin;

/**
 *    保存是否登陆
 */
- (void)saveIsLogin:(BOOL)bLogin;

/**
 *    获取登录类型 1手机用户登录  2会员卡登录 3手机用户绑定会员卡
 */
- (int)getLoginType;

/**
 *    保存登录类型 1手机用户登录  2会员卡登录 3手机用户绑定会员卡
 */
-(void)saveLoginType:(int)type;


/**
 *    获取绑定会员卡
 */
- (NSString*)getBindCard;

/**
 *    获取绑定手机
 */
- (NSString*)getBindPhone;


/**
 *    保存是否绑定手机
 */
- (void)saveBindCard:(NSString*)bindCard;

/**
 *    获取是否显示会员送券提醒
 */
- (NSString*)getVoucherReminder;


/**
 *    保存会员送券提醒状态
 */
- (void)saveVoucherReminder;

/**
 *    保存是否绑定会员卡
 */
- (void)saveBindPhone:(NSString*)bindPhone;

/**
 *    保存会员等级
 */
- (void)saveMeberGroupId:(NSString*)memberGroupId;



/**
 *    获取会员等级
 */
- (NSString*)getMeberGroupId;


/**
 *    保存会员等级名
 */
- (void)saveMeberGroupIdName:(NSString*)memberGroupName;

/**
 *    获取会员等级名
 */
- (NSString*)getMeberGroupName;


/**
 *    保存电话号码
 */
-(void)savePhoneNum:(NSString*)tel;

/**
 *    获取电话号码
 */
-(NSString*)getPhoneNum;


/**
 *    获取会员卡卡号
 */
- (NSString*)getMenberNum;

/**
 *    保存会员卡卡号
 */
-(void)saveMemberNum:(NSString*)num;

/**
 *    保存用户信息
 */
-(void)saveUseInFor:(NSDictionary*)UseInForDic;

/**
 *    获取用户信息
 */
- (NSDictionary*)UseInFor;

/**
 *    保存用户想看的电影
 */
-(void)saveMovieId:(NSString*)MovieId;
/**
 *    获取用户信息
 */
- (NSString*)MovieId;

/**
 *    保存登录信息
 */
- (void)saveLoginMessage:(NSDictionary*)dic;



/**
 *    获取登录信息
 */
- (NSDictionary*)getLoginMessage;


/**
 *    删除登录信息
 */
- (void)deleteLoginMessage;




/**
 *    获取密码
 */
-(NSString *)getPwd;

/**
 *    保存密码
 */
-(void)savePwd:(NSString*)pwd;

/**
 *    获取用户名
 */
-(NSString *)getUserName;
/**
 *    获取头像
 */
-(NSString *)getUserIcn;
/**
 *    获取是否是最新版本
 */
-(BOOL)getVersion;

/**
 *    保存是否是最新版本
 */
-(void)saveVersion:(BOOL)Version;

/**
 *    保存用户名
 */
-(void)saveUserName:(NSString *)userName;

-(void)saveUserIcn:(NSString *)userIcn;

#pragma mark - 倒计时
- (void)saveObj:(NSString*)obj
       overtime:(unsigned long long)time;

- (unsigned long long)getObjOverTime:(NSString*)obj;

#pragma mark -  分割线


-(void)saveStoreId:(NSString*)storeid;
-(NSString*)getStoreId;

-(void)saveUID:(NSString*)uid;
-(NSString*)getUID;

-(void)saveLogo:(NSString*)logo;
-(NSString*)getLogo;


-(void)saveSeesionToken:(NSString*)sToken;
-(NSString*)getSessionToken;

//退出登录
-(void)loginOut;


//用户坐标
-(void)saveLocationLat:(NSString*)lat lon:(NSString*)lon;
-(NSString*)getLocationLon;
-(NSString*)getLocationLat;

#pragma mark - 影院选择
/**
 *  获取当前影院的停售时间
 */
- (NSString*)getStopSaleTime;

/**
 *    获取当前选择电影院id
 */
- (NSString*)getCinemaPlaceNo;

/**
 *    获取当前选择电影院短名称
 */
- (NSString*)getCinemaShortName:(NSInteger )teger ;
/**
 *    获取当前选择电影院短名称
 */
- (NSString*)getCinemaShortName;

//选择的影院
- (NSString*)getCinemaName1;
/**
 *    获取当前选择电影院长名称
 */
- (NSString*)getCinemaLongName;

/**
 *    保持当前选择电影院id
 */
-(void)saveCinemaPlaceNo:(NSString*)placeNo;

/**
 *    保持当前选择电影院名字
 */
-(void)saveCinemaName:(NSString*)Name;

/**
 *    获取全部电影院信息
 */
- (NSArray*)getCinemaInfo;

/**
 *  保存当前选择的城市影院
 */
- (void)saveCurrentCinema:(NSArray*)arr;
/**
 * 获取当前选择的城市影院
 */
- (NSArray*)getCurrentCinema;


/**
 *    保持全部电影院信息
 */
- (void)saveCinemaInfo:(NSArray*)arr;
/**
 * 存取用户是否绑定
 */
- (void)saveIfBindALK:(BOOL)YON;
/**
 * 获取是否绑定爱来卡
 */
-(BOOL)getIfBindALK;

/**
 * 存取用户是否扫码支付成功
 */
- (void)saveScanCode:(BOOL)Code;
/**
 * 获取是否点击扫码支付成功
 */
-(BOOL)getScanCode;


/**
 *    保存用户信息
 */
-(void)saveUserInfo_new:(NSDictionary*)dic;
/**
 *    获取用户信息
 */
- (NSDictionary *)getSaveUserInfo_new;
/**
 *    获取当前选择电影电话
 */
- (NSString*)getCinemaPhone;
/**
 *    保持当前选择电影院名字
 */
-(void)saveCinemaPhone:(NSString*)Phone;

//存取用户票券数
- (void)saveUserTicket:(NSInteger)count;
//获取用户票券数
- (NSNumber*)getUserTicet;
//用户积分过期时间
- (void)saveIntegralOutDay:(NSInteger)day;
//获取积分过期时间
- (NSInteger)getIntegralOutDay;
//推送开关
- (void)savePushMessage:(BOOL )Message;
- (BOOL)PushMessage;

//我的消息红点提示
- (void)saveMessUser:(BOOL)YON;
- (BOOL)haveMessUser;

#pragma mark 微信分享存取当前用户的信息
- (void)saveWXUserInfo:(NSDictionary*)dic;
- (NSDictionary*)getWxUserInfo;
- (BOOL)getIfOutTimeSendInfo;
#pragma mark -  分割线

/*************  用户登录部分 END   ***********/

/*************  设备部分   ***********/


//获取App版本
-(NSString*)getAppVersion;

//获取系统版本
-(double)getSystemVersion;

//获取系统名称如 :ganld
-(NSString*)getSystemName;

#pragma mark - token
- (BOOL)isTokenIdTimeOut;
- (void)saveTokenId:(NSString*)vale
               KeepTIme:(NSString*)keepTime;
- (NSString*)getTokenId;
- (void)removeToken;
#pragma mark -
//保存App版本
-(void)SAveAppVersion:(NSString*)Version;
//获取ZRApp版本
-(NSString*)getZRAppVersion;


//是否显示欢迎界面
-(BOOL)showWelcome;
-(void)didWelcome;



/*************  设备部分 End   ***********/


+(Config *)share;
+(id)allocWithZone:(NSZone *)zone;
+(void)removeAllKeys;

@end
