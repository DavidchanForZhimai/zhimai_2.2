//
//  MCRadarChartView.h
//  MCChartView
//
//  Created by zhmch0329 on 15/8/19.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCRadarChartView;
@protocol MCRadarChartViewDataSource <NSObject>

@required
- (NSInteger)numberOfValueInRadarChartView:(MCRadarChartView *)radarChartView;
- (id)radarChartView:(MCRadarChartView *)radarChartView valueAtIndex:(NSInteger)index;

@optional
- (NSAttributedString *)radarChartView:(MCRadarChartView *)radarChartView attributedTitleAtIndex:(NSInteger)index;
- (NSString *)radarChartView:(MCRadarChartView *)radarChartView titleAtIndex:(NSInteger)index;

@end

@interface MCRadarChartView : UIView

@property (nonatomic, weak) id<MCRadarChartViewDataSource> dataSource;

@property (nonatomic, strong) id maxValue;
@property (nonatomic, strong) id minValue;

@property (nonatomic, assign) CGPoint centerPoint;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) NSInteger numberOfLayer;

@property (nonatomic, assign) BOOL drawPoints;
@property (nonatomic, assign) CGFloat pointRadius;

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, strong) UIColor *fillColor;

@property (nonatomic, assign) CGFloat radarLineWidth;
@property (nonatomic, strong) UIColor *radarStrokeColor;
@property (nonatomic, strong) UIColor *radarFillColor;

- (void)reloadData;
- (void)reloadDataWithAnimate:(BOOL)animate;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com