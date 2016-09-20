//
//  MyLinQuCell.h
//  KuaJie
//
//  Created by 严文斌 on 16/5/19.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyLinQuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *hanyeBtn;
@property (weak, nonatomic) IBOutlet UIButton *xuqiuBtn;
@property (weak, nonatomic) IBOutlet UIImageView *beixuanzhongImg;

@property (weak, nonatomic) IBOutlet UIImageView *manyiImg;
@property (weak, nonatomic) IBOutlet UIImageView *fuweikuanImg;
@property (weak, nonatomic) IBOutlet UIImageView *jieshuImg;
@property (weak, nonatomic) IBOutlet UILabel *jirenlqLab;
@property (weak, nonatomic) IBOutlet UILabel *jirenLookLab;
@property (weak, nonatomic) IBOutlet UIImageView *linquImg;
@property (weak, nonatomic) IBOutlet UISlider *mySlider;
@property (weak, nonatomic) IBOutlet UILabel *qwbcLab;
@property (weak, nonatomic) IBOutlet UILabel *laiziLab;
@property (weak, nonatomic) IBOutlet UILabel *fabuyuLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bxzOrg_x;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *manyiOrg_x;
@property (weak, nonatomic) IBOutlet UILabel *fwkLab;
@property (weak, nonatomic) IBOutlet UILabel *jieshuLab;
@property (weak, nonatomic) IBOutlet UILabel *lqLab;
@property (weak, nonatomic) IBOutlet UILabel *bxzLab;
@property (weak, nonatomic) IBOutlet UILabel *manyiLab;
@property (weak, nonatomic) IBOutlet UILabel *dingjinLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fwkOrgx;

@property (weak, nonatomic) IBOutlet UIView *allinV;
@end
