//
//  FabuCell.h
//  KuaJie
//
//  Created by 严文斌 on 16/5/18.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FabuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *hanyeBtn;
@property (weak, nonatomic) IBOutlet UIButton *xuqiuBtn;

@property (weak, nonatomic) IBOutlet UILabel *jirenlqLab;
@property (weak, nonatomic) IBOutlet UILabel *jirenLookLab;

@property (weak, nonatomic) IBOutlet UISlider *mySlider;
@property (weak, nonatomic) IBOutlet UILabel *qwbcLab;
@property (weak, nonatomic) IBOutlet UIImageView *fabuImg;
@property (weak, nonatomic) IBOutlet UIImageView *shengheImg;
@property (weak, nonatomic) IBOutlet UIImageView *hezuozImg;
@property (weak, nonatomic) IBOutlet UIImageView *sdwkImg;

@property (weak, nonatomic) IBOutlet UIImageView *sddjImg;

@property (weak, nonatomic) IBOutlet UIImageView *yipjiaImg;
@property (weak, nonatomic) IBOutlet UIImageView *jieshuImg;

@property (weak, nonatomic) IBOutlet UILabel *fabuLab;
@property (weak, nonatomic) IBOutlet UILabel *shenheLab;
@property (weak, nonatomic) IBOutlet UILabel *hezuozLab;

@property (weak, nonatomic) IBOutlet UILabel *sddjLab;
@property (weak, nonatomic) IBOutlet UILabel *sdwkLab;
@property (weak, nonatomic) IBOutlet UILabel *yipjiaLab;
@property (weak, nonatomic) IBOutlet UILabel *jsLab;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shheOrgx;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hzzOrgx;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sddjOrgx;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sdwkOrgx;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ypjOrgx;

@property (weak, nonatomic) IBOutlet UIView *allinV;

@end
