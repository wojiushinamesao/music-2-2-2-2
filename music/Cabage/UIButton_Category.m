//
//  UIButton_Category.m
//  dream
//
//  Created by zhengkai on 14/12/21.
//  Copyright (c) 2014年 zhengkai. All rights reserved.
//

#import "UIButton_Category.h"
#import <objc/runtime.h>

@implementation UIButton(ButtonExtention)
static NSString *KEY_UIBUTTON_BLOCK = @"UIBUTTON_BLOCK_KEY";

- (void)performBlock:(ButtonEventsBlock)block controlEvents:(UIControlEvents)controlEvents {
    objc_setAssociatedObject(self, (__bridge const void *)(KEY_UIBUTTON_BLOCK), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(invokeBlock) forControlEvents:controlEvents];
}
- (void)invokeBlock{
    ButtonEventsBlock block = objc_getAssociatedObject(self, (__bridge const void *)(KEY_UIBUTTON_BLOCK));
    if (block) {
        block();
    }
}

- (void)setRoundedBorder:(UIColor*)color {
    CALayer *roundedLayer = [self layer];
    [roundedLayer setMasksToBounds:YES];
    roundedLayer.cornerRadius = 2.0;
    roundedLayer.borderColor = [color CGColor];
}

- (void) setImage:(UIImage *)image
        withTitle:(NSString *)title
         sizeFont:(UIFont*)font
       titleColor:(UIColor*)color
         forState:(UIControlState)stateType {
    
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGSize titleSize = [title sizeWithAttributes:attributes];
    [self.imageView setContentMode:UIViewContentModeCenter];
    [self setImageEdgeInsets:UIEdgeInsetsMake(-8.0,
                                              0.0,
                                              0.0,
                                              -titleSize.width)];
    [self setImage:image forState:stateType];
    
    [self.titleLabel setContentMode:UIViewContentModeCenter];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setFont:font];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(40.0,
                                              -image.size.width,
                                              0.0,
                                              0.0)];
    [self setTitle:title forState:stateType];
    [self setTitleColor:color forState:stateType];
}
@end
