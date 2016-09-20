//
//  DWActionSheetView.h
//  Lebao
//
//  Created by David on 16/1/12.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DWActionSheetView;

typedef void (^DWActionSheetViewDidSelectButtonBlock)(DWActionSheetView *actionSheetView, NSInteger buttonIndex);

typedef void (^DWShareViewDidSelectButtonBlock)(DWActionSheetView *actionSheetView, NSInteger buttonIndex,NSString *shareText);

@interface DWActionSheetView : UIScrollView
//选择按钮

+ (DWActionSheetView *)showActionSheetWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles handler:(DWActionSheetViewDidSelectButtonBlock)block;

- (instancetype)initWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles handler:(DWActionSheetViewDidSelectButtonBlock)block;

//分享按钮
+ (DWActionSheetView *)showShareViewWithTitle:(NSString *)title otherButtonTitles:(NSArray *)otherButtonTitles handler:(DWShareViewDidSelectButtonBlock)block;

- (instancetype)initShareViewWithTitle:(NSString *)title otherButtonTitles:(NSArray *)otherButtonTitles handler:(DWShareViewDidSelectButtonBlock)block;

- (void)show;
- (void)dismiss;
@end
