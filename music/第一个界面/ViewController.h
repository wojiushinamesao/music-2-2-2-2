//
//  ViewController.h
//  music
//
//  Created by sghy on 17/3/8.
//  Copyright © 2017年 lzj. All rights reserved.
//
#import "BaseViewController.h"
#import <UIKit/UIKit.h>

@interface ViewController : BaseViewController

@property (nonatomic, assign) BOOL isNewsShare;
@property (nonatomic, strong) NSString * detailUrlStr;
@property (nonatomic, strong) NSString * shareTitle;
@property (nonatomic, strong) NSString * shareImageStr;
- (IBAction)shareApp:(id)sender;
@end

