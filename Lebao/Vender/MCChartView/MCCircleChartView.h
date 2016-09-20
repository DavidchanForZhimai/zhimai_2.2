//
//  MCCircleChartView.h
//  MCChartView
//
//  Created by zhmch0329 on 15/8/19.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCCircleChartView;
@protocol MCCircleChartViewDataSource <NSObject>

@required
- (NSInteger)numberOfCircleInCircleChartView:(MCCircleChartView *)circleChartView;
- (id)circleChartView:(MCCircleChartView *)circleChartView valueOfCircleAtIndex:(NSInteger)index;

@optional
- (NSString *)circleChartView:(MCCircleChartView *)circleChartView introduceAtIndex:(NSInteger)index;

@end

@protocol MCCircleChartViewDelegate <NSObject>

@optional
- (UIColor *)circleChartView:(MCCircleChartView *)circleChartView colorOfCircleAtIndex:(NSInteger)index;
- (NSAttributedString *)titleInCircleChartView:(MCCircleChartView *)circleChartView;
- (UIView *)centerViewInCircleChartView:(MCCircleChartView *)circleChartView;

@end

@interface MCCircleChartView : UIView

@property (nonatomic, weak) id<MCCircleChartViewDataSource> dataSource;
@property (nonatomic, weak) id<MCCircleChartViewDelegate> delegate;

@property (nonatomic, assign) CGPoint centerPoint;
@property (nonatomic, assign) CGFloat maxAngle;
@property (nonatomic, assign) CGFloat maxRadius;
@property (nonatomic, assign) CGFloat circleWidth;
@property (nonatomic, assign) CGFloat circlePadding;

@property (nonatomic, assign) CGFloat introduceFontSize;
@property (nonatomic, strong) UIColor *introduceColor;

- (void)reloadData;
- (void)reloadDataWithAnimate:(BOOL)animate;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com