//
//  BaseButton.m
//  Lebao
//
//  Created by David on 16/1/29.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseButton.h"
#import "UILabel+Extend.h"
@implementation BaseButton
- (UIButton *)initWithFrame:(CGRect)frame
{
    _anmialTime = .15;
    _anmialScal =1.2;
    _shouldAnmial = YES;
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(didClickOutBtn:) forControlEvents:UIControlEventTouchUpOutside];
        [self addTarget:self action:@selector(didTouchBtn:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(didCancelBtn:) forControlEvents:UIControlEventTouchDragInside];
    }
    return self;
}
- (UIButton *)initWithFrame:(CGRect)frame setTitle:(NSString *)titleT titleSize:(float)size titleColor:(UIColor*)color backgroundImage:(UIImage *)backgroundImage iconImage:(UIImage *)iconImage highlightImage:(UIImage *)highLightImage  setTitleOrgin:(CGPoint)titlePoint  setImageOrgin:(CGPoint)imagePoint  inView:(UIView *)view
{
    _anmialTime = .15;
    _anmialScal =1.2;
    _shouldAnmial = YES;
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:titleT forState:UIControlStateNormal];
        [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        [self setImage:iconImage forState:UIControlStateNormal];
        [self setImage:highLightImage forState:UIControlStateHighlighted];
        if (view) {
            [view addSubview:self];
        }
    
        self.titleLabel.font = [UIFont systemFontOfSize:size];
        [self setTitleColor:color forState:UIControlStateNormal];
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        [self setImageEdgeInsets:UIEdgeInsetsMake(imagePoint.x,imagePoint.y, 0, 0)];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(titlePoint.x,titlePoint.y, 0, 0)];
        
        [self addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(didClickOutBtn:) forControlEvents:UIControlEventTouchUpOutside];
        [self addTarget:self action:@selector(didTouchBtn:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(didCancelBtn:) forControlEvents:UIControlEventTouchDragInside];
    }
    return self;
    
}

- (void)textAndImageCenter
{
    CGSize sizeTime = [self.titleLabel sizeWithContent:self.titleLabel.text font:self.titleLabel.font];
    self.imagePoint = CGPointMake(7, (frameWidth(self) - self.imageView.image.size.width)/2.0);
    self.titlePoint = CGPointMake(self.imageView.image.size.height + 9, (frameWidth(self) - sizeTime.width)/2.0 - self.imageView.image.size.width);
    
}
- (void)textCenter
{
    CGSize sizeTime = [self.titleLabel sizeWithContent:self.titleLabel.text font:self.titleLabel.font];
    
    self.titlePoint = CGPointMake((frameHeight(self) - sizeTime.height)/2.0, (frameWidth(self) - sizeTime.width)/2.0);
}
- (UIButton *)initWithFrame:(CGRect)frame setTitle:(NSString *)titleT titleSize:(float)size titleColor:(UIColor*)tiltecColor textAlignment:(NSTextAlignment)textAlignment backgroundColor:(UIColor *)color inView:(UIView *)view
{
   
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:titleT forState:UIControlStateNormal];
        
        if (view) {
            [view addSubview:self];
        }
        
        self.titleLabel.font = [UIFont systemFontOfSize:size];
        [self setTitleColor:tiltecColor forState:UIControlStateNormal];
       
        self.backgroundColor = color;
        self.titleLabel.textAlignment = textAlignment;

        [self addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(didClickOutBtn:) forControlEvents:UIControlEventTouchUpOutside];
        [self addTarget:self action:@selector(didTouchBtn:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(didCancelBtn:) forControlEvents:UIControlEventTouchDragInside];
    }
    return self;
 
}

- (UIButton *)initWithFrame:(CGRect)frame backgroundImage:(UIImage *)backgroundImage iconImage:(UIImage *)iconImage highlightImage:(UIImage *)highLightImage inView:(UIView *)view
{

    
    self = [super initWithFrame:frame];
    if (self) {

        [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        [self setImage:iconImage forState:UIControlStateNormal];
        [self setImage:highLightImage forState:UIControlStateHighlighted];
        if (view) {
            [view addSubview:self];
        }
    
        
        [self addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(didClickOutBtn:) forControlEvents:UIControlEventTouchUpOutside];
        [self addTarget:self action:@selector(didTouchBtn:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(didCancelBtn:) forControlEvents:UIControlEventTouchDragInside];
    }
    return self;

    
}


- (void)setTitlePoint:(CGPoint)titlePoint
{
    [self setTitleEdgeInsets:UIEdgeInsetsMake(titlePoint.x,titlePoint.y, 0, 0)]; 
    
}
- (void)setImagePoint:(CGPoint)imagePoint
{
     [self setImageEdgeInsets:UIEdgeInsetsMake(imagePoint.x,imagePoint.y, 0, 0)];
}

#pragma mark
#pragma mark buttonAction
- (void)didClickBtn:(UIButton *)buttonAction
{
    if(self.didClickBtnBlock)
    {
        self.didClickBtnBlock();
    }
    if (_shouldAnmial) {
        
       [self scalingWithTime:_anmialTime andscal:1.0];
    
    }
    
}
#pragma mark
#pragma mark buttonAction
- (void)didClickOutBtn:(UIButton *)buttonAction
{
    if(self.didClickOutBtnBlock)
    {
        self.didClickOutBtnBlock();
    }
//    if (_shouldAnmial) {
//
//        [self scalingWithTime:_anmialTime andscal:1.0];
//    }
    
}
- (void)didTouchBtn:(UIButton *)buttonAction
{
    
    if(self.didTouchBtnBlock)
    {
        self.didTouchBtnBlock();
    }
      if (_shouldAnmial) {
       [self scalingWithTime:_anmialTime andscal:_anmialScal];
      }
}
- (void)didCancelBtn:(UIButton *)buttonAction
{
    if(self.didCancelBtnBlock)
    {
        self.didCancelBtnBlock();
    }
      if (_shouldAnmial) {
         [self scalingWithTime:_anmialTime andscal:1.0];
      }
    
    
}


@end
