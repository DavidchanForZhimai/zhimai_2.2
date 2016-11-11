//
//  BasicInformationViewController.h
//  Lebao
//
//  Created by David on 16/1/28.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^AuthenBlock) (NSString *imgurl,NSString *realname,NSString *position, NSString *address);
@interface BasicInformationViewController : BaseViewController
@property(copy,nonatomic)AuthenBlock authenBlock;
@end

@interface BasicInfoModal : NSObject
@property(assign,nonatomic) int server_max_limit;
@property(assign,nonatomic) int resource_max_limit;
@property(assign,nonatomic) int my_max_limit;
@property(nonatomic,assign)int  authen;
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
@property(copy,nonatomic)NSMutableArray *relabels;
@property(copy,nonatomic)NSString *filllabels;
@property(copy,nonatomic)NSString *mylabels;

@property(copy,nonatomic)NSString *position;//职位
@property(copy,nonatomic)NSString *service;//产品服务标签
@property(copy,nonatomic)NSString *resource;//资源特点
@property(copy,nonatomic)NSMutableArray *service_labels;//待选产品服务标签
@property(copy,nonatomic)NSMutableArray *resource_labels;//待选资源特点
@property(copy,nonatomic)NSString *industry;//行业
@property(copy,nonatomic)NSString *focus_industrys;//关注行业

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
