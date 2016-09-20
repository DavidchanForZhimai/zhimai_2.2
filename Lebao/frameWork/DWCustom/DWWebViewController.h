//
//  DWWebViewController.h
//  Lebao
//
//  Created by David on 16/1/21.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"
@interface DWWebViewController : BaseViewController

@property (strong, nonatomic) NSURL *homeUrl;
@property (strong, nonatomic) UIButton *rightBtn;
/** 传入控制器、url、标题 */
+ (void)showWithContro:(UIViewController *)contro withUrlStr:(NSString *)urlStr withTitle:(NSString *)title;


@end
