//
//  ImgAndLabView.m
//  Lebao
//
//  Created by adnim on 16/9/6.
//  Copyright © 2016年 David. All rights reserved.
//

#import "ImgAndLabView.h"

@implementation ImgAndLabView

//
//-(UIView *)initWithFrame:(CGRect)frame AndImg:(UIImage *)img AndTitle:(NSString *)title AndTitleColor:(UIColor *)color AndTextFont:(UIFont *)font
//{
//    CGSize maximumLabelSize = CGSizeMake(100, 9999);//labelsize的最大值
//    
//    self.frame=frame;
//    UIImageView *imgView=[[UIImageView alloc]initWithImage:img];
//    imgView.frame=CGRectMake(0, (self.height-img.size.height)/2.0, img.size.width, img.size.width);
//    [self addSubview:imgView];
//    UILabel *lab=[[UILabel alloc]init];
//    lab.text=title;
//    lab.textColor=color;
//    lab.font=font;
//     CGSize expectSize = [lab sizeThatFits:maximumLabelSize];
//    lab.frame=CGRectMake(imgView.width+3, (self.height-lab.height)/2.0, expectSize.width, expectSize.height);
//    [self addSubview:lab];
//    
//    self.frame=CGRectMake(frame.origin.x, frame.origin.y, CGRectGetMaxX(lab.frame), frame.size.height);
//    return self;
//    
//}

@end
