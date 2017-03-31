//
//  UIView+AnimateExtension.h
//  封装
//
//  Created by 王海林 on 17/3/10.
//  Copyright © 2017年 中瑞国际. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, animateType) {
    AnimateType_Scale      =  0,
    AnimateType_Transform  =  1,
    AnimateType_Ronatate   =  2,
};
@interface UIView (AnimateExtension)
- (void)animateWithType:(animateType)type Duration:(CGFloat)animateTime speed:(CGFloat)speed completeBlock:(void(^)(void))block;
/**
 * 暂停动画
 */
- (void)stopAnyAnimation;
/**
 * 开始动画
 */
- (void)continueAnimation:(CGFloat)speed;
@end
