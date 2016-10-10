//
//  CooperateView.h
//  Lebao
//
//  Created by adnim on 16/10/9.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CooperateView;

typedef void(^CooperateViewBlock)(CooperateView *customAlertView,NSString *logFieldText);//成功时回调

@protocol CooperateViewDelegate <NSObject>

- (void) customAlertView:(CooperateView *) customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
@interface CooperateView : UIView
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic,copy)NSString *oldText;//水印
@property (nonatomic, strong) UIView *middleView;
@property (nonatomic,strong)NSIndexPath * indexth;
@property(nonatomic, weak) id<CooperateViewDelegate> delegate;
@property(nonatomic,copy)CooperateViewBlock sureblock;
@property(nonatomic,strong)UITextView *logField;

/**
 * 弹窗在视图中的中心点
 **/
@property (nonatomic, assign) CGFloat centerY;


- (instancetype) initAlertViewWithFrame:(CGRect)frame  LogFieldDefaultText:(NSString *)text andSuperView:(UIView *)superView;

- (void) dissMiss;

@end
