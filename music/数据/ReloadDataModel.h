//
//  ReloadDataModel.h
//  music
//
//  Created by sghy on 17/3/8.
//  Copyright © 2017年 lzj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReloadDataModel : NSObject

+ (void)getData:(NSString *)urlStr successBlock:(void (^)(id posts))block;
@end
