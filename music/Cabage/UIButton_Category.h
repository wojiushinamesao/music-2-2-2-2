//
//  UIButton_Category.h
//  dream
//
//  Created by zhengkai on 14/12/21.
//  Copyright (c) 2014年 zhengkai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIButton(ButtonExtention)
typedef void(^ButtonEventsBlock)(void);

/**
 *    一个UIButton实例执行一个指定控件事件执行的block
 *
 *    @param block         需要在此控件事件上执行的block
 *    @param controlEvents 执行block的触发事件
 */
- (void)performBlock:(ButtonEventsBlock)block controlEvents:(UIControlEvents)controlEvents;


/**
 *   设置圆角边框
 */
- (void)setRoundedBorder:(UIColor*)color;

/**
 *   设置图片和文字
 */
- (void) setImage:(UIImage *)image
        withTitle:(NSString *)title
         sizeFont:(UIFont*)font
       titleColor:(UIColor*)color
         forState:(UIControlState)stateType;
@end
