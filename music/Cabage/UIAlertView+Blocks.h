//
//  UIAlertView+Blocks.h
//  Shibui
//
//  Created by Jiva DeVoe on 12/28/10.
//  Copyright 2010 Random Ideas, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UIAlertView_block_self_index)(UIAlertView *alertView, NSInteger btnIndex);
typedef void(^UIAlertView_block_self)(UIAlertView *alertView);
typedef BOOL(^UIAlertView_block_shouldEnableFirstOtherButton)(UIAlertView *alertView);

@interface UIAlertView (Blocks)

- (void)handlerClickedButton:(UIAlertView_block_self_index)aBlock;
- (void)handlerCancel:(UIAlertView_block_self)aBlock;
- (void)handlerWillPresent:(UIAlertView_block_self)aBlock;
- (void)handlerDidPresent:(UIAlertView_block_self)aBlock;
- (void)handlerWillDismiss:(UIAlertView_block_self_index)aBlock;
- (void)handlerDidDismiss:(UIAlertView_block_self_index)aBlock;
- (void)handlerShouldEnableFirstOtherButton:(UIAlertView_block_shouldEnableFirstOtherButton)aBlock;

// 延时消失
- (void)showWithDuration:(NSTimeInterval)i;

@end
