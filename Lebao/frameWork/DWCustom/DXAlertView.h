//
//  DWAlertView.h
//  Lebao
//
//  Created by David on 16/1/19.
//  Copyright © 2016年 David. All rights reserved.
#import <UIKit/UIKit.h>


@interface DXAlertView : UIView

//提示
- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
    leftButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle;


- (void)show;

@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) dispatch_block_t rightBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;

@end

@interface UIImage (colorful)

+ (UIImage *)imageWithColor:(UIColor *)color;

@end