//
//  UIButton+Extend.m
//  Lebao
//
//  Created by David on 15/11/27.
//  Copyright © 2015年 David. All rights reserved.
//

#import "UIButton+Extend.h"

@implementation UIButton (Extend)
#pragma mark ----
#pragma mark UIButton

+ (UIButton *)createButtonWithfFrame:(CGRect)frame  title:(NSString *)titleT backgroundImage:(UIImage *)backgroundImage iconImage:(UIImage *)iconImage highlightImage:(UIImage *)highLightImage tag:(NSInteger)tagN
{
   return  [self createButtonWithfFrame:frame title:titleT backgroundImage:backgroundImage iconImage:iconImage highlightImage:highLightImage tag:tagN inView:nil ];
}
+ (UIButton *)createButtonWithfFrame:(CGRect)frame  title:(NSString *)titleT backgroundImage:(UIImage *)backgroundImage iconImage:(UIImage *)iconImage highlightImage:(UIImage *)highLightImage tag:(NSInteger)tagN inView:(UIView *)view
{
    UIButton *button = [[self alloc] initWithFrame:frame];
    [button setTitle:titleT forState:UIControlStateNormal];
    [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [button setImage:iconImage forState:UIControlStateNormal];
    [button setImage:highLightImage forState:UIControlStateHighlighted];
    button.tag = tagN;
    if (view) {
        [view addSubview:button];
    }
   
    return button;
}
@end
