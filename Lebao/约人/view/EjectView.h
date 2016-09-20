//
//  EjectView.h
//  Lebao
//
//  Created by adnim on 16/9/6.
//  Copyright © 2016年 FNY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "D3RecordButton.h"
#import "RecordHUD.h"

@class EjectView;

@protocol EjectViewDelegate <NSObject>

- (void) customAlertView:(EjectView *) customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface EjectView : UIView
{
    AVAudioPlayer *play;
}
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic,copy)NSString *title2Str;
@property (nonatomic, strong) UIView *middleView;
@property (nonatomic,strong)NSIndexPath * indexth;
@property(nonatomic, weak) id<EjectViewDelegate> delegate;
@property(nonatomic,strong)D3RecordButton *soundBtn;
/**
 * 弹窗在视图中的中心点
 **/
@property (nonatomic, assign) CGFloat centerY;

- (instancetype) initAlertViewWithFrame:(CGRect)frame andSuperView:(UIView *)superView;

- (void) dissMiss;

@end
