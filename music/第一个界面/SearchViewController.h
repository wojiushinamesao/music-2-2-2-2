//
//  SearchViewController.h
//  music
//
//  Created by sghy on 17/3/9.
//  Copyright © 2017年 lzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController
@property (nonatomic, copy) void(^playBlock)(NSDictionary * dic);
@end
