//
//  XianSuoDetailVC.h
//  KuaJie
//
//  Created by 严文斌 on 16/5/17.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XianSuoDetailVC : UIViewController

@property (strong,nonatomic) UITableView * lqTab;
@property (strong,nonatomic) UIView      * zfdjV;
@property (strong,nonatomic) UIButton    * plusBtn;
@property (strong,nonatomic) UIButton    * subtraBtn;
@property (strong,nonatomic) UITextField     * bfbTex;
@property (strong,nonatomic) UILabel     * howMuchLab;
@property (strong,nonatomic) UIView      * jibaoV;
@property (strong,nonatomic) UILabel     * positionLab;
@property (strong,nonatomic) UIScrollView * bottomScr;
@property (strong,nonatomic) UIButton * linqBtn;
@property (strong,nonatomic) UIView * dangzhuV;;
@property (strong,nonatomic) UIButton * rightBtn;
@property (strong,nonatomic) UILabel * lqLab;
@property (strong,nonatomic) UIView * txV ;
@property (strong,nonatomic) UIView * duihuaV;
@property (strong,nonatomic) UIView * xsDetailV;
@property (strong,nonatomic) NSString * xs_id;
@end
