//
//  PlayListView.h
//  music
//
//  Created by sghy on 17/3/10.
//  Copyright © 2017年 lzj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayListView : UIView
@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, assign) BOOL isLocation;//判断是不是本地
@property (nonatomic, strong) NSString * listNmae;
@property (nonatomic, assign) NSInteger indexRow;
@property (nonatomic, copy) void(^playBlock)(NSInteger selectNum);
@property (nonatomic, copy) void(^saveBlock)(NSInteger selectNum);
- (id)initWithFrame:(CGRect)frame;
- (void)initView;
@end
