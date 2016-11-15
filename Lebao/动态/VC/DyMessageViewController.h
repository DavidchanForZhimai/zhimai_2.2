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
@property(nonatomic,strong)NSMutableArray *datas;
@end

@interface DyMessageData : BaseModal
@property(nonatomic,copy)NSString *imgurl;
@property(nonatomic,copy)NSString *realname;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *fengmiam;
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

@property(nonatomic,strong)DyMessageLayout *layout;
@end
