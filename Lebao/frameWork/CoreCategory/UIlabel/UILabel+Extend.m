//
//  UILabel+Extend.m
//  Lebao
//
//  Created by David on 15/11/27.
//  Copyright © 2015年 David. All rights reserved.
//

#import "UILabel+Extend.h"

@implementation UILabel (Extend)
#pragma mark
#pragma mark UILabel
//文字自动左上角对齐
- (void) textLeftTopAlign
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName:self.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [self.text boundingRectWithSize:CGSizeMake(frameWidth(self), 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    CGRect dateFrame =CGRectMake(frameX(self), frameY(self), frameWidth(self), labelSize.height + 10);
    self.frame = dateFrame;
    self.numberOfLines = 0;
}


+ (DWLable *)createLabelWithFrame:(CGRect)frame text:(NSString *)text fontSize:(CGFloat)size textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment inView:(UIView *)view;
{
    UILabel *label = [[self alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.text = text;
    label.font = [UIFont systemFontOfSize:size];
    label.textAlignment = textAlignment;
    label.textColor = textColor;
    [view addSubview:label];
    
    return label;
}
+ (DWLable *)CreateLineFrame:(CGRect)frame inView:(UIView *)view
{
    UILabel *line = allocAndInitWithFrame(UILabel, frame(frame.origin.x, frame.origin.y - 0.5, frame.size.width, 0.5));
    line.backgroundColor = LineBg;
    [view addSubview:line];
   
    return line;
}
- (CGSize)sizeWithContent:(NSString *)content font:(UIFont * )font{
    
   return [content sizeWithAttributes:@{NSFontAttributeName:font}];
    
}

- (CGSize)sizeWithMultiLineContent:(NSString *)content rowWidth:(CGFloat)rowWidth font:(UIFont * )font
{
return [content boundingRectWithSize:CGSizeMake(rowWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}
@end
