//
//  UILabel+Extend.h
//  Lebao
//
//  Created by David on 15/11/27.
//  Copyright © 2015年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWLable.h"
@interface UILabel (Extend)
//文字自动左上角对齐
- (void) textLeftTopAlign;

+ (DWLable *)createLabelWithFrame:(CGRect)frame text:(NSString *)text fontSize:(CGFloat)size textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment inView:(UIView *)view;
+ (DWLable *)CreateLineFrame:(CGRect)frame inView:(UIView *)view;
//单行文本
- (CGSize)sizeWithContent:(NSString *)content font:(UIFont * )font;
//多行文本的显示
- (CGSize)sizeWithMultiLineContent:(NSString *)content rowWidth:(CGFloat)rowWidth font:(UIFont * )font;
@end
