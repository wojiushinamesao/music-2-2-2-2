//
//  RouteAnnotation.h
//  music
//
//  Created by sghy on 17/3/28.
//  Copyright © 2017年 lzj. All rights reserved.
//


@interface RouteAnnotation : BMKPointAnnotation
@property (nonatomic) int type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
@property (nonatomic) int degree;
@end
