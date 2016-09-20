//
//  DWOptionView.m
//  Lebao
//
//  Created by David on 16/2/18.
//  Copyright © 2016年 David. All rights reserved.
//

#import "DWOptionView.h"
#import "ToolManager.h"
#import "BaseButton.h"
#import "UILabel+Extend.h"
@interface DWOptionView()
@property(nonatomic,strong) BaseButton *boy;
@property(nonatomic,strong) BaseButton *girl;
@end
@implementation DWOptionView
{
    UIView *bg;
    BOOL isBoy;
    
}

- (id)initWithFrame:(CGRect)frame block:(SureSeletedBlock)sureBlock
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = rgba(0, 0, 0, 0.3);

        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        bg = allocAndInitWithFrame(UIView, frame((APPWIDTH - 228*ScreenMultiple)/2.0, (APPHEIGHT - StatusBarHeight - NavigationBarHeight - 170*ScreenMultiple)/2.0, 228*ScreenMultiple, 170*ScreenMultiple));
        bg.backgroundColor = WhiteColor;
        [bg setRadius:8.0];
        [self addSubview:bg];
        
        [UILabel createLabelWithFrame:frame(10, 0, frameWidth(bg), 50*ScreenMultiple) text:@"选择性别" fontSize:35*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:bg];
        
        UILabel *line1 = allocAndInitWithFrame(UILabel, frame(0, 50*ScreenMultiple, frameWidth(bg), 1.0));
        line1.backgroundColor = LineBg;
        [bg addSubview:line1];
        
        _boy = [[BaseButton alloc]initWithFrame:frame(0, 50*ScreenMultiple, frameWidth(line1), 40*ScreenMultiple) setTitle:@"男" titleSize:28*SpacedFonts titleColor:AppMainColor textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] inView:bg];
        
        UILabel *line2 = allocAndInitWithFrame(UILabel, frame(0, CGRectGetMaxY(_boy.frame), frameWidth(bg), 1.0));
        line2.backgroundColor = LineBg;
        [bg addSubview:line2];
        
        _girl = [[BaseButton alloc]initWithFrame:frame(0, CGRectGetMaxY(_boy.frame), frameWidth(line2), frameHeight(_boy)) setTitle:@"女" titleSize:28*SpacedFonts titleColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] inView:bg];
        
        UILabel *line3 = allocAndInitWithFrame(UILabel, frame(0, CGRectGetMaxY(_girl.frame), frameWidth(_girl), 0.5));
        line3.backgroundColor = LineBg;
        [bg addSubview:line3];
        isBoy = YES;
        __weak DWOptionView *weakSelf = self;
        _boy.didClickBtnBlock = ^
        {
            [weakSelf.boy setTitleColor:AppMainColor forState:UIControlStateNormal];
            [weakSelf.girl setTitleColor:LightBlackTitleColor forState:UIControlStateNormal];
            isBoy = YES;
        };
        _girl.didClickBtnBlock = ^
        {
            [weakSelf.girl setTitleColor:AppMainColor forState:UIControlStateNormal];
            [weakSelf.boy setTitleColor:LightBlackTitleColor forState:UIControlStateNormal];
            isBoy = NO;
        };
        
        BaseButton *sure = [[BaseButton alloc]initWithFrame:frame(0, CGRectGetMaxY(_girl.frame), frameWidth(line3), frameHeight(_boy)) setTitle:@"确定" titleSize:28*SpacedFonts titleColor:AppMainColor textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] inView:bg];
        sure.didClickBtnBlock = ^
        {
            sureBlock(isBoy);
            
            [self removeFromSuperview];
            
        };
        
        
    }
    
    return self;
    
}

- (id)initWithFrame:(CGRect)frame options:(NSArray *)array block:(SureSeletedItemBlock)sureBlock
{
    
    if (self = [super initWithFrame:frame]) {
    self.backgroundColor = rgba(0, 0, 0, 0.3);
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    bg = allocAndInitWithFrame(UIView, frame((APPWIDTH - 228*ScreenMultiple)/2.0, (APPHEIGHT - StatusBarHeight - NavigationBarHeight - (50*ScreenMultiple + (array.count+ 1)*40*ScreenMultiple))/2.0, 228*ScreenMultiple, 50*ScreenMultiple + (array.count+ 1)*40*ScreenMultiple));
    bg.backgroundColor = WhiteColor;
    [bg setRadius:8.0];
    [self addSubview:bg];
    
    [UILabel createLabelWithFrame:frame(10, 0, frameWidth(bg), 50*ScreenMultiple) text:@"选择行业" fontSize:35*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:bg];
    
        
    for (int i =0; i<array.count; i++) {
        
        UILabel *line1 = allocAndInitWithFrame(UILabel, frame(0, 50*ScreenMultiple + i*40*ScreenMultiple, frameWidth(bg), 1.0));
            line1.backgroundColor = LineBg;
            [bg addSubview:line1];
            
        BaseButton *item = [[BaseButton alloc]initWithFrame:frame(0, 50*ScreenMultiple + i*40*ScreenMultiple, frameWidth(line1), 40*ScreenMultiple) setTitle:array[i] titleSize:28*SpacedFonts titleColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] inView:bg];
       
        item.didClickBtnBlock =^
        {
            sureBlock(i);
            [self removeFromSuperview];
        };
    }
   
    
    UILabel *line2 = allocAndInitWithFrame(UILabel, frame(0, frameHeight(bg) - 40*ScreenMultiple, frameWidth(bg), 0.5));
    line2.backgroundColor = LineBg;
    [bg addSubview:line2];
    
        
    BaseButton *sure = [[BaseButton alloc]initWithFrame:frame(0, frameY(line2), frameWidth(bg), 40*ScreenMultiple) setTitle:@"取消" titleSize:28*SpacedFonts titleColor:AppMainColor textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] inView:bg];
    sure.didClickBtnBlock = ^
    {
        
        [self removeFromSuperview];
        
    };

    }
    return self;
}
//本地分享
- (id)initWithFrame:(CGRect)frame options:(NSArray *)array sureSeletedItemsBlock:(SureSeletedItemsBlock)sureBlock
{
     if (self = [super initWithFrame:frame]) {
         
         _items = [NSMutableArray new];
         
         for (NSDictionary *dic  in array) {
             
             [_items addObject:dic[@"item"]];
             
         }
         self.backgroundColor = rgba(0, 0, 0, 0.3);
         
         [[UIApplication sharedApplication].keyWindow addSubview:self];
         
         float cellH= 50*ScreenMultiple;
         bg = allocAndInitWithFrame(UIView, frame((APPWIDTH - 228*ScreenMultiple)/2.0, (APPHEIGHT - StatusBarHeight - NavigationBarHeight - (array.count+ 1)*cellH)/2.0, 228*ScreenMultiple, (array.count+ 1)*cellH));
         bg.backgroundColor = WhiteColor;
         [bg setRadius:8.0];
         [self addSubview:bg];
         
         
         for (int i =0; i<array.count; i++) {
             
             UILabel *line1 = allocAndInitWithFrame(UILabel, frame(10, (i+1)*cellH, frameWidth(bg) -20, 1.0));
             line1.backgroundColor = LineBg;
             [bg addSubview:line1];
             
            [UILabel createLabelWithFrame:frame(10, i*cellH, frameWidth(bg), cellH) text:array[i][@"title"] fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:bg];
             
             UISwitch *_infoSwitch =allocAndInitWithFrame(UISwitch, frame(frameWidth(bg) -60, 10 + i*cellH, 50, 30));
             _infoSwitch.tag = i;
             _infoSwitch.on = [_items[i] boolValue];
             _infoSwitch.onTintColor = AppMainColor;
             [_infoSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
             [bg addSubview:_infoSwitch];
             
         }
         
         
         BaseButton *sure = [[BaseButton alloc]initWithFrame:frame(20, array.count*cellH  + 10, frameWidth(bg)/2.0 - 40, 30*ScreenMultiple) setTitle:@"确定分享" titleSize:28*SpacedFonts titleColor:WhiteColor textAlignment:NSTextAlignmentCenter backgroundColor:AppMainColor inView:bg];
         [sure setRadius:5.0];
         sure.didClickBtnBlock = ^
         {
             sureBlock(_items);
             [self removeFromSuperview];
             
         };
         
         BaseButton *cancel = [[BaseButton alloc]initWithFrame:frame(frameWidth(bg) - 20 - frameWidth(sure), frameY(sure), frameWidth(sure), frameHeight(sure)) setTitle:@"取消分享" titleSize:24*SpacedFonts titleColor:WhiteColor textAlignment:NSTextAlignmentCenter backgroundColor:AppMainColor inView:bg];
         [cancel setRadius:5.0];
         cancel.didClickBtnBlock = ^
         {
             
             [self removeFromSuperview];
             
         };

         
     }
    return self;

}
#pragma mark switchAction
- (void)switchAction:(UISwitch *)sender
{
    [_items replaceObjectAtIndex:sender.tag withObject:[NSString stringWithFormat:@"%i",sender.isOn]];
}
@end


