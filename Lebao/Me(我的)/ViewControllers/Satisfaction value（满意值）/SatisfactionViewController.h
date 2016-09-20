//
//  SatisfactionViewController.h
//  Lebao
//
//  Created by David on 16/5/20.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"

#import "BaseModal.h"
@interface SatisfactionModal : BaseModal
@property(nonatomic,assign)int  regrade;
@property(nonatomic,strong)NSString *satisfied;
@property(nonatomic,strong)NSString *nosatisfied;
@property(nonatomic,strong)NSString *fcount;
@property(nonatomic,strong)NSString *lcount;
@property(nonatomic,strong)NSString *bcount;
@property(nonatomic,strong)NSString *desc;
@end

@interface SatisfactionData : NSObject
@property(nonatomic,strong)NSString *title;
@property(nonatomic,assign)int  createtime;
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,assign)BOOL scord;
@property(nonatomic,assign)BOOL iscoop;
@property(nonatomic,assign)BOOL isself;
@property(nonatomic,strong)NSString *realname;
@end


@interface SatisfactionViewController : BaseViewController

@end

@interface SatisfactionCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHight:(float)cellHight cellWidth:(float)cellWidth;

- (void)setmodal:(SatisfactionData *)data;
@end
