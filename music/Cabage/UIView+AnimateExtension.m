//
//  UIView+AnimateExtension.m
//  封装
//
//  Created by 王海林 on 17/3/10.
//  Copyright © 2017年 中瑞国际. All rights reserved.
//

#import "UIView+AnimateExtension.h"
#import <CoreGraphics/CoreGraphics.h>
#import <objc/runtime.h>

@implementation UIView (AnimateExtension)
static char animateCompleteBlock;
#pragma mark UIViewAnimate
- (void)animateWithType:(animateType)type Duration:(CGFloat)animateTime speed:(CGFloat)speed completeBlock:(void(^)(void))block{
    if (type == AnimateType_Scale)
    {
        [UIView beginAnimations:@"" context:nil];
        [UIView setAnimationRepeatCount:-1];
        [UIView setAnimationDuration:animateTime];
        self.transform = CGAffineTransformMakeScale(2, 2);
        [UIView setAnimationDelegate:self];
        [UIView commitAnimations];
    }
    else if (type == AnimateType_Ronatate)
    {
        CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        [basic setRemovedOnCompletion:NO];
        [basic setFillMode:kCAFillModeForwards];
        [basic setDuration:animateTime];
        [basic setSpeed:speed];
        [basic setFromValue:@(0)];
        [basic setToValue:@(M_PI*2)];
        [basic setRepeatCount:HUGE_VALF];
        [self.layer addAnimation:basic forKey:@""];
    }
    else if (type == AnimateType_Transform)
    {
        
    }
    objc_setAssociatedObject(self, &animateCompleteBlock, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)complete{
    
    void (^action)() = objc_getAssociatedObject(self, &animateCompleteBlock);
    if (action) {
        action();
    }
}
#pragma mark CoreAnimate
static char kCoreAnimateCompleteBlock;
- (void)coreAnimateInCustomPath:(CGPathRef)path duration:(NSTimeInterval)duration completeBlock:(void(^)())block{
    CAAnimation *animate = [CAAnimation animation];
    
    [animate setDuration:duration];
    [animate setRemovedOnCompletion:YES];//动画完成后变回原样
    [animate setFillMode:kCAFillModeForwards];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path=path;
    [shapeLayer addAnimation:animate forKey:@""];
    [self.layer addSublayer:shapeLayer];
    objc_setAssociatedObject(self, &kCoreAnimateCompleteBlock, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self performSelector:@selector(coreComplete) withObject:nil afterDelay:duration];
}
- (void)coreComplete{
    
    void(^action)() =objc_getAssociatedObject(self, &kCoreAnimateCompleteBlock);
    if (action) {
        action();
    }
}
- (void)stopAnyAnimation{
    CFTimeInterval pauseTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.timeOffset = pauseTime;
    self.layer.speed = 0;
}
- (void)continueAnimation:(CGFloat)speed{
    CFTimeInterval pauseTime = self.layer.timeOffset;
    CFTimeInterval SincePause =CACurrentMediaTime() - pauseTime;
    self.layer.timeOffset = 0;
    self.layer.beginTime = SincePause;
    self.layer.speed = (!speed || speed == 0)? 1 : speed;
}
@end
