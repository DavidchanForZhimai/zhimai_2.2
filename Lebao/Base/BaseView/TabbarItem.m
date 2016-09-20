//
//  TabbarItem.m
//  1233Shop
//
//  Created by 陈江彬 on 14/12/26.
//  Copyright (c) 2014年 CJB. All rights reserved.
//

#import "TabbarItem.h"
#import "ToolManager.h"
#import "BaseButton.h"
#import "UILabel+Extend.h"
@interface TabbarItem()
{
    float frameWidth;
    float frameHeight;
    
}

@property (nonatomic, strong) BaseButton *backBtn;
@end

@implementation TabbarItem

#pragma mark-
#pragma mark 初始化
- (id)initWithFrame:(CGRect)frame itemData:(TabbarDataType *)type
{
    self = [super initWithFrame:frame];
    if (self)
    {
        frameWidth  = frame.size.width;
        frameHeight = frame.size.height;
        
        UIImage *imageNormal =[UIImage imageNamed:type.itemImage];
        UIImage *imagePresses =[UIImage imageNamed:type.itemSelectImage];
        
        UILabel *lb = allocAndInit(UILabel);
        CGSize lbSize =[lb sizeWithContent:type.itemTitle font:Size(20)];
        _backBtn = [[BaseButton  alloc]initWithFrame:frame(0, 0, frameWidth, frameHeight) setTitle:type.itemTitle titleSize:20*BandFonts titleColor:BlackTitleColor backgroundImage:nil iconImage:imageNormal highlightImage:imagePresses setTitleOrgin:CGPointMake(frameHeight - 7 - 20*BandFonts, (frameWidth - lbSize.width)/2.0 - imageNormal.size.width) setImageOrgin:CGPointMake(5, (frameWidth - imageNormal.size.width)/2.0) inView:self];
        _backBtn.anmialScal = 1.1;
    
        if (type.itemIsSelected) {
            
            [_backBtn setTitleColor:AppMainColor forState:UIControlStateNormal];
            [_backBtn setImage:imagePresses forState:UIControlStateNormal];
            [_backBtn setImage:imageNormal forState:UIControlStateHighlighted];
      
            
        }
        else
        {
            
            [_backBtn setTitleColor:BlackTitleColor forState:UIControlStateNormal];
            [_backBtn setImage:imagePresses forState:UIControlStateHighlighted];
            [_backBtn setImage:imageNormal forState:UIControlStateNormal];
            
        }
        __weak typeof(self) weakSelf= self;
        _backBtn.didClickBtnBlock = ^
        {
            if (weakSelf.itemSelectBlock)
            {
                weakSelf.itemSelectBlock(type.itemIndex);
            }
  
        };

    }
    return self;
}



#pragma mark-
#pragma mark 内存
- (void)dealloc
{
}

@end


#pragma mark-
#pragma mark
@implementation TabbarDataType

- (id)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

- (void)dealloc
{
}

@end