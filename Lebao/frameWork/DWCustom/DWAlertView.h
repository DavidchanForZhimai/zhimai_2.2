//
//  DWAlertView.h
//  Lebao
//
//  Created by David on 16/1/19.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DWAlertViewBlock)(void);

@interface DWAlertView : UIView

+ (instancetype)alertViewWithTitle:(NSString *)title
                           message:(NSString *)message
                       buttonTitle:(NSString *)buttonTitle
               buttonTouchedAction:(DWAlertViewBlock)buttonBlock
                     dismissAction:(DWAlertViewBlock)dismissBlock;

- (void)show;
- (void)dismiss;

@end
