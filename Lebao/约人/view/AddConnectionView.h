//
//  AddConnectionView.h
//  Lebao
//
//  Created by adnim on 16/9/23.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>



@class AddConnectionView;

@protocol AddConnectionViewDelegate <NSObject>

- (void) customAlertView:(AddConnectionView *) customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface AddConnectionView : UIView

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic,copy)NSString *title2Str;
@property (nonatomic, strong) UIView *middleView;
@property (nonatomic,strong)NSIndexPath * indexth;
@property(nonatomic, weak) id<AddConnectionViewDelegate> delegate;
@property(nonatomic,copy)NSString *money;
@property(nonatomic,strong)UITextField *logField;
/**
 * 弹窗在视图中的中心点
 **/
@property (nonatomic, assign) CGFloat centerY;

- (instancetype) initAlertViewWithFrame:(CGRect)frame andSuperView:(UIView *)superView;

- (void) dissMiss;

@end
