//
//  JJRCell.h
//  KuaJie
//
//  Created by 严文斌 on 16/5/12.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JJRCell : UITableViewCell
@property (strong,nonatomic) UIImageView * headImg;
@property (strong,nonatomic) UILabel     * userNameLab;
@property (strong,nonatomic) UILabel     * positionLab;
@property (strong,nonatomic) UILabel     * hanyeLab;
@property (strong,nonatomic) UILabel     * fuwuLab;
@property (strong,nonatomic) UILabel     * fansLab;
@property (strong,nonatomic) UIButton    *  guanzhuBtn;
@property (strong,nonatomic) UIView * nextV ;
@property (strong,nonatomic) UIImageView * renzhImg;
@end
