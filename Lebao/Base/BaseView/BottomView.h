//
//  BottomView.h
//  1233Shop
//
//  Created by 陈江彬 on 14/12/26.
//  Copyright (c) 2014年 CJB. All rights reserved.
//

#import "TabbarItem.h"

typedef void (^ClickCenterButton)(void) ;
@interface BottomView : UIView
@property(nonatomic,copy)ClickCenterButton clickCenterButton;

- (id)initWithFrame:(CGRect)frame selectIndex:(int)selectIndex clickCenterButton:(ClickCenterButton)clickCenterButton;

@end
