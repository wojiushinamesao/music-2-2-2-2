//
//  ThreeViewController.h
//  music
//
//  Created by sghy on 17/3/16.
//  Copyright © 2017年 lzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreeViewController : BaseViewController
@property (nonatomic, strong) void(^goDetailBlock)(NSString * urlStr);
@end
