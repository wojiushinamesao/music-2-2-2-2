//
//  NSObject+MethodExt.m
//  ND91U
//
//  Created by devp on 14-1-14.
//  Copyright (c) 2014年 nd. All rights reserved.
//

#import "NSObject+MethodExt.h"

@implementation NSObject (MethodExt)

- (void)performBlock:(performBlock)block
          afterDelay:(NSTimeInterval)delay {
    block = [block copy];
    [self performSelector:@selector(doBlock:)
               withObject:block
               afterDelay:delay];
}



//判断文件是否已经在沙盒中已经存在？
+(BOOL) isFileExist:(NSString *)fileName
{
    fileName = [NSString stringWithFormat:@"%@.lrc",fileName];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    NSLog(@"这个文件已经存在：%@",result?@"是的":@"不存在");
    return result;
}

- (void)doBlock:(performBlock)block {
    block();
}



- (BOOL)makesureDictionary:(BOOL)needAssert {
    if (![self isKindOfClass:[NSDictionary class]] &&
        ![self isKindOfClass:[NSMutableDictionary class]]) {
        if (needAssert) {
            NSAssert(NO, @"该元素非NSDictionary对象");
        }
        return NO;
    }
    return YES;
}

//计算出大小
- (NSString *)fileSizeWithInterge:(NSInteger)size{
    // 1k = 1024, 1m = 1024k
    if (size < 1024) {// 小于1k
        return [NSString stringWithFormat:@"%ldB",(long)size];
    }else if (size < 1024 * 1024){// 小于1m
        CGFloat aFloat = size/1024;
        return [NSString stringWithFormat:@"%.0fK",aFloat];
    }else if (size < 1024 * 1024 * 1024){// 小于1G
        CGFloat aFloat = size/(1024 * 1024);
        return [NSString stringWithFormat:@"%.1fM",aFloat];
    }else{
        CGFloat aFloat = size/(1024*1024*1024);
        return [NSString stringWithFormat:@"%.1fG",aFloat];
    }
}
@end
