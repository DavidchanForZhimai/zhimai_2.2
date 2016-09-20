//
//  BasicInformationViewController.h
//  Lebao
//
//  Created by David on 16/1/28.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"

@interface BasicInformationViewController : BaseViewController

@end

@interface BasicInfoModal : NSObject
@property(copy,nonatomic)NSString *synopsis;
@property(copy,nonatomic)NSString *sex;
@property(copy,nonatomic)NSString *address;
@property(copy,nonatomic)NSString *area;
@property(copy,nonatomic)NSString *imgurl;
@property(copy,nonatomic)NSString *workyears;
@property(copy,nonatomic)NSString *tel;
@property(copy,nonatomic)NSString *realname;
@property(assign,nonatomic)int rtcode;
@property(copy,nonatomic)NSString *rtmsg;
@property(copy,nonatomic)NSString *version;
@property(copy,nonatomic)NSString *mylabels;
@property(copy,nonatomic)NSString *filllabels;
@property(copy,nonatomic)NSString *relabls;
@property(assign,nonatomic)BOOL verify;
@end

@interface BasicInformationView : UITableViewCell
@property(nonatomic,strong)UILabel *title;
@property(nonatomic,strong) UILabel *detailTitle;
@property(nonatomic,strong) UIImageView *userIcon;
@property(nonatomic,strong) UIImageView *userBg;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth;
- (void)showTitle:(NSString *)title icon:(NSString *)icon bg:(NSString *)bg detail:(NSString *)detail canEdit:(BOOL)canEdit;
@end