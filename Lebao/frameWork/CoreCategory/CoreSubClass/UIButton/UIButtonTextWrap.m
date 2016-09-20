//
//  UIButtonTextWrap.m
//  Lebao
//
//  Created by David on 15/12/3.
//  Copyright © 2015年 David. All rights reserved.
//

#import "UIButtonTextWrap.h"

@implementation UIButtonTextWrap
//重写父类UIButton的方法
- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        //可根据自己的需要随意调整
        
        self.titleLabel.textAlignment=NSTextAlignmentRight;
        
        self.titleLabel.font=[UIFont systemFontOfSize:14.0];
        
        self.imageView.contentMode=UIViewContentModeLeft;
        
    }
    
    return self;
    
}

//更具button的rect设定并返回文本label的rect

- (CGRect)titleRectForContentRect:(CGRect)contentRect

{
    
    CGFloat titleW = contentRect.size.width-30;
    
    CGFloat titleH = contentRect.size.height;
    
    CGFloat titleX = 0;
    
    CGFloat titleY = 0;
    
    
    
    contentRect = (CGRect){{titleX,titleY},{titleW,titleH}};
    
    return contentRect;
    
}

//更具button的rect设定并返回UIImageView的rect

- (CGRect)imageRectForContentRect:(CGRect)contentRect

{
    
    CGFloat imageW = 25;
    
    CGFloat imageH = 25;
    
    CGFloat imageX = contentRect.size.width-26;
    
    CGFloat imageY = 2.5;
    
    
    
    contentRect = (CGRect){{imageX,imageY},{imageW,imageH}};
    
    return contentRect;
    
}
@end
