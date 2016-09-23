//
//  VIPPrivilegeView.h
//  Lebao
//
//  Created by adnim on 16/9/23.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeViewController.h"
@interface VIPPrivilegeView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *icoudImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *renzhenImgV;
@property (weak, nonatomic) IBOutlet UIImageView *VIPImgV;
@property (weak, nonatomic) IBOutlet UILabel *boomlab;
@property (weak, nonatomic) IBOutlet UIImageView *privilegeImgV;
-(void)configWithModel:(MeViewModal *)modal;
@end
