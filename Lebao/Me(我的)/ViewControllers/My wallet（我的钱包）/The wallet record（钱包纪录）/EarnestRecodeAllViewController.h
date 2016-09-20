//
//  EarnestRecodeAllViewController.h
//  Lebao
//
//  Created by David on 16/1/27.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSUInteger,EarnestRecodeType)  {
    
  EarnestRecodeAll,
  EarnestRecodeIncome,
  EarnestRecodePay,
};


@interface EarnestRecodeAllData : NSObject
@property(nonatomic,strong)NSString *action;
@property(nonatomic,strong)NSString *actiontime;
@property(nonatomic,strong)NSString *amount;
@property(nonatomic,strong)NSString *frozen;
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *lastmoney;
@property(nonatomic,strong)NSString *money;
@property(nonatomic,strong)NSString *purpose;
@property(nonatomic,strong)NSString *repackets;
@property(nonatomic,strong)NSString *sourceid;
@property(nonatomic,strong)NSString *sourcetype;
@property(nonatomic,strong)NSString *userid;
@end
@interface EarnestRecodeAllModal : NSObject
@property(nonatomic,strong)NSString *rtmsg;
@property(nonatomic,assign)int allpage;
@property(nonatomic,assign)int count;
@property(nonatomic,assign)int page;
@property(nonatomic,assign)int rtcode;
@property(nonatomic,strong)NSMutableArray *datas;
@end
@interface EarnestRecodeAllViewController : BaseViewController
@property(nonatomic,assign)EarnestRecodeType recodeType;
@end


@interface EarnestRecodeAllView : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth;
- (void)setmodal:(EarnestRecodeAllData *)modal;
@end
