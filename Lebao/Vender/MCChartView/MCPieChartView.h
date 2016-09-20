//
//  MCPieChartView.h
//  MCChartView
//
//  Created by zhmch0329 on 15/8/20.
//  Copyright (c) 2015年 zhmch0329. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCPieChartView;
@protocol MCPieChartViewDataSource <NSObject>

@required
- (NSInteger)numberOfPieInPieChartView:(MCPieChartView *)pieChartView;
- (id)pieChartView:(MCPieChartView *)pieChartView valueOfPieAtIndex:(NSInteger)index;

@optional
- (id)sumValueInPieChartView:(MCPieChartView *)pieChartView;

@end

@protocol MCPieChartViewDelegate <NSObject>

@optional
- (UIColor *)pieChartView:(MCPieChartView *)pieChartView colorOfPieAtIndex:(NSInteger)index;
- (NSAttributedString *)ringTitleInPieChartView:(MCPieChartView *)pieChartView;
- (UIView *)ringViewInPieChartView:(MCPieChartView *)pieChartView;

@end

@interface MCPieChartView : UIView

@property (nonatomic, weak) id<MCPieChartViewDataSource> dataSource;
@property (nonatomic, weak) id<MCPieChartViewDelegate> delegate;

@property (nonatomic, assign) CGPoint centerPoint;
@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, strong) UIColor *pieBackgroundColor;

@property (nonatomic, assign) BOOL ring;
@property (nonatomic, assign) CGFloat ringWidth;
@property (nonatomic, copy) NSString *ringTitle;

@property (nonatomic, assign) BOOL circle;

- (void)reloadData;
- (void)reloadDataWithAnimate:(BOOL)animate;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com