//
//  LRCViewController.h
//  music
//
//  Created by sghy on 17/3/9.
//  Copyright © 2017年 lzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LRCViewController : UIViewController
@property (nonatomic, strong) NSArray * lrcs;
@property (nonatomic, strong) NSArray * musictime;
@property (nonatomic, assign) NSInteger timeInt;
- (void)reload:(NSArray *)lrcs;
@end
