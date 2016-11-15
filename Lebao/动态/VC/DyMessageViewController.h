//
//  DyMessageViewController.h
//  Lebao
//
//  Created by David on 2016/11/14.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseModal.h"

/**
 数据模型
 */
@interface DyMessageModel : BaseModal
@end

@interface DyMessageData : BaseModal
@property(nonatomic,copy)NSString *imgurl;
@property(nonatomic,copy)NSString *realname;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *createtime;
@property(nonatomic,copy)NSString *title_img;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *userid;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *dynamicid;
@end




/**
 控制器
 */
@interface DyMessageViewController : BaseViewController

@end


/** 
 计算空间总高度 和 布局
 */

@interface DyMessageLayout : NSObject

@property(nonatomic,assign) float iconFrame;
@property(nonatomic,assign) float nameFrame;
@property(nonatomic,assign) float conentFrame;
@property(nonatomic,assign) float cellHeight;

@end
/**
  列表单元
 */

@interface DyMessageCell : UITableViewCell
@property(nonatomic,strong)UIImageView *userIcon;
@property(nonatomic,strong)UILabel *userLabel;
@property(nonatomic,strong)UILabel *userContent;
@property(nonatomic,strong)UIImageView *userLike;
@property(nonatomic,strong)UILabel *userTime;
@property(nonatomic,strong)UILabel *userTitle;
@property(nonatomic,strong)UIView *userTitleView;
@property(nonatomic,strong)UIImageView *userImage;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth;
- (void)setModel:(DyMessageData *)data;
@end
