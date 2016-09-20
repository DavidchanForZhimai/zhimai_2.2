//
//  UIButton+Extend.h
//  Lebao
//
//  Created by David on 15/11/27.
//  Copyright © 2015年 David. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extend)



+ (UIButton *)createButtonWithfFrame:(CGRect)frame  title:(NSString *)titleT backgroundImage:(UIImage *)backgroundImage iconImage:(UIImage *)iconImage highlightImage:(UIImage *)highLightImage tag:(NSInteger)tagN;

+ (UIButton *)createButtonWithfFrame:(CGRect)frame  title:(NSString *)titleT backgroundImage:(UIImage *)backgroundImage iconImage:(UIImage *)iconImage highlightImage:(UIImage *)highLightImage tag:(NSInteger)tagN inView:(UIView *)view;




@end
