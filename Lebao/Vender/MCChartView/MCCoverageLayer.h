//
//  MCCoverageLayer.h
//  MCChartView
//
//  Created by zhmch0329 on 15/8/21.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MCCoverageLayer : CALayer

@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat endAngle;

@property (nonatomic, assign) CGPoint centerPoint;

@property (nonatomic, assign) CGFloat minRadius;
@property (nonatomic, assign) CGFloat maxRadius;

@property (nonatomic, assign) CGColorRef coverageColor;

@property (nonatomic, assign) CGFloat radius;

- (void)reloadRadiusWithAnimate:(BOOL)animate;
- (void)reloadRadiusWithAnimate:(BOOL)animate duration:(CFTimeInterval)duration;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com