//
//  BaseButton.h
//  Lebao
//
//  Created by David on 16/1/29.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseButton : UIButton
@property (nonatomic,assign) BOOL shouldAnmial;
@property (nonatomic,assign) float anmialTime;
@property (nonatomic,assign) float anmialScal;
@property (nonatomic,assign) CGPoint imagePoint;
@property (nonatomic,assign) CGPoint titlePoint;
@property (nonatomic, copy) dispatch_block_t didClickBtnBlock;
@property (nonatomic, copy) dispatch_block_t didClickOutBtnBlock;
@property (nonatomic, copy) dispatch_block_t didTouchBtnBlock;
@property (nonatomic, copy) dispatch_block_t didCancelBtnBlock;
- (UIButton *)initWithFrame:(CGRect)frame;
- (UIButton *)initWithFrame:(CGRect)frame setTitle:(NSString *)titleT titleSize:(float)size titleColor:(UIColor*)color backgroundImage:(UIImage *)backgroundImage iconImage:(UIImage *)iconImage highlightImage:(UIImage *)highLightImage  setTitleOrgin:(CGPoint)titlePoint  setImageOrgin:(CGPoint)imagePoint  inView:(UIView *)view;

- (void)textAndImageCenter;
- (void)textCenter;

- (UIButton *)initWithFrame:(CGRect)frame setTitle:(NSString *)titleT titleSize:(float)size titleColor:(UIColor*)tiltecColor textAlignment:(NSTextAlignment)textAlignment backgroundColor:(UIColor *)color inView:(UIView *)view;

- (UIButton *)initWithFrame:(CGRect)frame backgroundImage:(UIImage *)backgroundImage iconImage:(UIImage *)iconImage highlightImage:(UIImage *)highLightImage inView:(UIView *)view;

@end
