//
//  MeetHeadV.h
//  Lebao
//
//  Created by adnim on 16/8/26.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MeetHeadVDelegate <NSObject>

- (void)pushView:(UIViewController *)viewC userInfo:(id)userInfo;

@end


@class CanmeetTabVC;
@interface MeetHeadV : UIView
@property(nonatomic,strong)UILabel *nearManLab;
@property(nonatomic,strong)UIButton *wantMeBtn;//想约我
@property(nonatomic,strong)UIButton *meWantBtn;//我相约
@property(nonatomic,strong)UIButton *midBtn;//可约
@property(nonatomic,strong) NSTimer *timer1;
@property(nonatomic,strong) NSTimer *timer2;
@property(nonatomic,strong) NSTimer *timer3;
@property(nonatomic,strong)NSArray *headimgsArr;

@property(nonatomic,weak) id<MeetHeadVDelegate>delegate;

-(void)addEightImgView;
@end
