//
//  BottomView.m
//  1233Shop
//
//  Created by 陈江彬 on 14/12/26.
//  Copyright (c) 2014年 CJB. All rights reserved.
//

#import "BottomView.h"
#import "AppDelegate.h"
#import "ToolManager.h"
#import "UIButton+Extend.h"

@interface BottomView()
{
    float tabItemWidth;
    float tabItemHeight;
}

@end

@implementation BottomView
#pragma mark-
#pragma mark 
- (id)initWithFrame:(CGRect)frame selectIndex:(int)selectIndex clickCenterButton:(ClickCenterButton)clickCenterButton
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _clickCenterButton = clickCenterButton;
        
        NSArray *iconNormal = [NSArray arrayWithObjects:@"weixianyuejian",@"weixiandongtai", @"icon_bar_message",@"weixianfaxian",nil];
        NSArray *iconPressed = [NSArray arrayWithObjects:@"yuejian",@"dongtai",@"icon_bar_selected_message",@"faxian", nil];
        NSArray *name = [NSArray arrayWithObjects:@"约人", @"动态",@"消息",@"发现",nil];
        
        tabItemWidth  = APPWIDTH/iconNormal.count;
        tabItemHeight = self.frame.size.height;
        
        self.backgroundColor = WhiteColor;
        self.layer.borderWidth = 0.5*ScreenMultiple;
        self.layer.borderColor = LineBg.CGColor;
        
        for (int i=0; i<iconNormal.count; i++)
        {
        
                TabbarDataType *type = [[TabbarDataType alloc] init];
                type.itemIndex = i;
                type.itemIsSelected = NO;
                if (selectIndex==i)
                {
                    type.itemIsSelected = YES;
                }
                
               
                type.itemImage = iconNormal[i];
                type.itemSelectImage = iconPressed[i];
                type.itemTitle = name[i];
                
                CGRect itemRect;
            
                    itemRect = CGRectMake(i*tabItemWidth, 0, tabItemWidth, tabItemHeight);
            
                TabbarItem *item = [[TabbarItem alloc] initWithFrame:itemRect itemData:type];
                
                item.itemSelectBlock = ^(int index){
                    
                [getAppDelegate().mainTab setSelectedIndex:index];
                    
                };
                
                [self addSubview:item];
        
           
            
        }

     
    }
    
    return self;
}
#pragma mark

#pragma mark-
#pragma mark 内存
- (void)dealloc
{
}


@end


