//
//  PubFunction.m
//  dream
//
//  Created by zhengkai on 14/12/8.
//  Copyright (c) 2014年 zhengkai. All rights reserved.
//
#import "UIAlertView+Blocks.h"
#import "PubFunction.h"
#define NOImageTag 2000
#define NOLableTag 2001

@interface PubFunction ()<UIWebViewDelegate>
@end

@implementation PubFunction


+ (NSString *)getTimeNow {
    NSInteger interval = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]];
    NSDate *localeDate = [[NSDate date]  dateByAddingTimeInterval: interval];
    long long timeNow = (long long)[localeDate timeIntervalSince1970];
    return [NSString stringWithFormat:@"%lld",timeNow];
}

+ (NSTimeInterval)getTimeInterValWithStr:(NSString*)str format:(NSString*)format{
    if (str) {
        if (format) {
            NSDate *localeDate =[NSDate date];
            NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
            [formatter setDateFormat:format];
            localeDate =[formatter dateFromString:str];
            NSTimeInterval timeInt =[localeDate timeIntervalSince1970];
            return timeInt;
        }
    }
    return 0;
}

+ (NSString*)getTime:(NSInteger)time {
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@" DD HH:mm:ss"]; //@"yyyy-MM-dd HH:mm:ss"
    return [dateFormatter stringFromDate: detaildate];
}

+ (NSString*)getTime:(NSInteger)time
              Format:(NSString*)format {
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format]; //@"yyyy-MM-dd HH:mm:ss"
    return [dateFormatter stringFromDate: detaildate];
}

+ (unsigned long long)getTimesp:(NSDate*)date {
    return (unsigned long long)[date timeIntervalSince1970];
}

+ (NSString*)getRefreshTime {
    return [self getTimeNow];
    
}

+ (NSString*)getRefreshTimeSecond {
    NSDate *detaildate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; //@"yyyy-MM-dd HH:mm:ss"
    NSString *str = [dateFormatter stringFromDate: detaildate];
    str = [str substringToIndex:str.length];
    str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@":" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    return str;
    
}

+ (BOOL)isTimeOut:(NSString*)strTime
         keepTime:(NSString*)keepTime {
    
    long long time = [strTime longLongValue];
    NSInteger interval = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:[NSDate date]];
    NSDate *localeDate = [[NSDate date]  dateByAddingTimeInterval: interval];
    long long timeNow = (long long)[localeDate timeIntervalSince1970];
    if(timeNow - time < [keepTime integerValue]) {  //时间有效
        return NO;
    } else {
        return YES;
    }
    return YES;
}

+ (NSString*)getHtmlString:(NSString*)str {    
    str = [str stringByReplacingOccurrencesOfString:@"&quot;" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    str = [str stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    str = [str stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    str = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    return str;
}
+ (NSString*)getHtmlStringChang:(NSString*)str {
    str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@"\""];
    str = [str stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];

    return str;
}

+ (NSString*)getHtmlStringNew:(NSString*)str{
    
    if (str.length <=0) {
        return str;
    }
    str = [str stringByReplacingOccurrencesOfString:@"&quot;" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"&style;" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"&span;" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"&amp;" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"&lt;" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"&gt;" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"br/" withString:@"\n"];
    str = [str stringByReplacingOccurrencesOfString:@"&lt;p&gt;" withString:@"\n"];
    str = [str stringByReplacingOccurrencesOfString:@"style=" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"span" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"font" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"family:" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"宋体;" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"san" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"/" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"text" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"indent:" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"宋体" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"margin" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"left:0" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@";0" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"p" withString:@"\n"];
    str = [str stringByReplacingOccurrencesOfString:@"white" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"ace:" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"s" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"normal;" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"lineheight:24" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"x;" withString:@""];


    return str;
}

+ (void)showMessage:(NSString*)str {

    if(!str || str.length <= 0) {
        return;
    }

    UIAlertView *alt = [[UIAlertView alloc] initWithTitle:str
                                                  message:nil
                                                 delegate:self
                                        cancelButtonTitle:nil
                                        otherButtonTitles:@"确定", nil];
    [alt handlerWillDismiss:^(UIAlertView *alertView, NSInteger btnIndex)
    {
    }];
    [alt show];
}

+ (void)showMessage:(NSString*)str
           keepTime:(CGFloat)time {
    
    if(!str || str.length <= 0) {
        return;
    }
    
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:nil
                                                          message:str
                                                         delegate:self
                                                cancelButtonTitle:nil
                                                otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:time
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}


+ (UIImageView*)addNoImage:(NSString*)imageName
                      view:(UIView*)view {
    
    UIImageView *imgNO = (UIImageView*)[view viewWithTag:NOImageTag];
    if(imgNO) {
        return nil;
    }
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    CGPoint point = view.center;
    point.y -= 60;
    img.center = point;
    img.image = [UIImage imageNamed:imageName];
    img.tag = NOImageTag;
    [view addSubview:img];
    return img;
}

+ (UIImageView*)addNoImage:(NSString*)imageName
                   content:(NSString*)content
                      view:(UIView*)view {
    UIImageView *imgNO = (UIImageView*)[view viewWithTag:NOImageTag];
    if(imgNO) {
        return nil;
    }
    
    imgNO.backgroundColor = [UIColor clearColor];
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    CGPoint point = view.center;
    point.y -= 60;
    img.center = point;
    img.image = image;
    img.tag = NOImageTag;
    [view addSubview:img];
    
    
    UILabel *lblContent = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(img.frame) + 20, SCREEN_WIDTH, 15)];
    lblContent.textAlignment = NSTextAlignmentCenter;
    lblContent.textColor = HEXCOLOR(0x999999);
    lblContent.font = [UIFont systemFontOfSize:14];
    lblContent.text = content;
    lblContent.tag = NOLableTag;
    [view addSubview:lblContent];
    
    return img;
}

+ (UIImageView*)addNoImage:(NSString*)imageName
                   content:(NSString*)content
                         y:(CGFloat)y
                      view:(UIView*)view {
    UIImageView *imgNO = (UIImageView*)[view viewWithTag:NOImageTag];
    if(imgNO) {
        return nil;
    }
    
    imgNO.backgroundColor = [UIColor redColor];
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    CGPoint point = view.center;
    point.y = y;
    img.center = point;
    img.image = image;
    img.tag = NOImageTag;
    [view addSubview:img];
    
    
    UILabel *lblContent = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(img.frame) + 20, SCREEN_WIDTH, 15)];
    lblContent.textAlignment = NSTextAlignmentCenter;
    lblContent.textColor = HEXCOLOR(0x999999);
    lblContent.font = [UIFont systemFontOfSize:14];
    lblContent.text = content;
    lblContent.tag = NOLableTag;
    [view addSubview:lblContent];
    
    return img;
}

+ (void)removeNoImage:(UIView*)view {
    UIImageView *img = (UIImageView*)[view viewWithTag:NOImageTag];
    if(img) {
        [img removeFromSuperview];
    }
    
    
    UILabel *lbl = (UILabel*)[view viewWithTag:NOLableTag];
    if(lbl) {
        [lbl removeFromSuperview];
    }
}

+ (UIImageView*)getNoImage:(UIView*)view {
    UIImageView *img = (UIImageView*)[view viewWithTag:NOImageTag];
    return img;
}



+ (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{

    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert = nil;
}

+ (NSString *)getOverTimeBegin:(NSString*)begin
                          keep:(NSString*)keep {
    
    NSArray *arrBegin = [begin componentsSeparatedByString:@":"];
    NSInteger hour = 0,min = 0;
    if(arrBegin.count > 1){
        min += [arrBegin[1] integerValue] + [keep integerValue];
        hour += min/60;
        min = min%60;
        hour += [arrBegin[0] integerValue];
        if(hour >= 24) {
            hour -= 24;
        }
    }
    return [NSString stringWithFormat:@"%02ld:%02ld",(long)hour,(long)min];
}



+ (NSString*)getWeekString:(NSString*)strDate {
    
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger yearToday=[comps year];
    NSInteger monthToday = [comps month];
    NSInteger dayToday = [comps day];
    NSArray *arr = [strDate componentsSeparatedByString:@"-"];
    if(arr.count > 2) {
        NSInteger year = [arr[0] integerValue];
        NSInteger month = [arr[1] integerValue];
        NSInteger day = [arr[2] integerValue];
        
        if(year == yearToday && month == monthToday && day == dayToday) {
            return [NSString stringWithFormat:@"今天%ld月%ld日",(long)month,(long)day];
        } else if(year == yearToday && month == monthToday && day == dayToday+1) {
            return [NSString stringWithFormat:@"明天%ld月%ld日",(long)month,(long)day];
        } else if(year == yearToday && month == monthToday && day == dayToday+2) {
            return [NSString stringWithFormat:@"后天%ld月%ld日",(long)month,(long)day];
        } else {
            return [self getWeek:strDate];
        }
    }
    return strDate;
}

+ (NSString*)getHoursString:(NSInteger)second{
    NSInteger hours =second/3600;
    NSInteger hoursother = second%3600;
    NSInteger min = hoursother/60;
//    NSInteger minsother = hoursother%60;
    if (hours==0 && min!=0) {
        return [NSString stringWithFormat:@"%ld分钟",(long)min];
    }else if (hours !=0 && min==0){
        return [NSString stringWithFormat:@"%ld小时",(long)hours];
    }else if (hours !=0 && min!=0){
        return [NSString stringWithFormat:@"%ld小时%ld分钟",(long)hours,(long)min];
    }else{
        return nil;
    }
}

+ (NSString *)getWeekDayFordate:(long long)data
{
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:data];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit fromDate:newDate];
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
}


+ (NSString*)getWeek:(NSString*)strDate {
    
    NSArray * arrWeek = [NSArray arrayWithObjects:@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六", nil];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:strDate];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =  NSWeekdayCalendarUnit ;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger week=[comps weekday];
    NSArray *arr = [strDate componentsSeparatedByString:@"-"];
    
    if(arr.count > 2) {
        if(week-1 < arrWeek.count) {
            NSInteger month = [arr[1] integerValue];
            NSInteger day = [arr[2] integerValue];
            return [NSString stringWithFormat:@"%@%ld月%ld日",[arrWeek objectAtIndex:week-1],(long)month,(long)day];
        }
    }
    return strDate;
}


+ (void)AddFilmType:(NSString*)type
               view:(UIView*)view {
    
    [self AddFilmFrame:CGRectMake(8, 80-5-12, 100, 12) Type:type view:view];
}



+ (NSString*)getCutString:(NSString*)str
                   Length:(NSInteger)length {
    
    if(str.length > length) {
        return [NSString stringWithFormat:@"%@...",[str substringToIndex:length]];
    }
    return str;
}


+ (UIView*)getLine:(CGRect)rect {
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = COLOR_BLACKLINE;
    return view;
}


+ (BOOL)checkPhoneNum:(NSString*)phoneNum {

    NSString *errMessage = @"手机号格式有误";
    NSString *newNum = phoneNum;
    newNum = [newNum stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(newNum.length != 0) {
        [PubFunction showMessage:errMessage keepTime:1.5];
        return NO;
    }
    
    if(phoneNum.length != 11) {
        [PubFunction showMessage:errMessage keepTime:1.5];
        return NO;
    }
    
    phoneNum = [phoneNum substringToIndex:1];
    if([phoneNum integerValue] != 1) {
        [PubFunction showMessage:errMessage keepTime:1.5];
        return NO;
    }
    
    return YES;
}

@end
