//
//  routeVCViewController.h
//  music
//
//  Created by sghy on 17/3/27.
//  Copyright © 2017年 lzj. All rights reserved.
//

#import "BaseViewController.h"

@interface routeVCViewController : BaseViewController
@property (nonatomic, copy) void(^backBlock)(SerchType type);
@property (nonatomic, copy) void(^routeBlock)(NSString * stratStr , NSString * endStr);
@end
