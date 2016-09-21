//
//  NotificationDetailViewController.h
//  Lebao
//
//  Created by David on 16/5/24.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseModal.h"
@interface SystemMessageModal :BaseModal

@end

@interface SystemMessageData : NSObject
@property(nonatomic,copy) NSString *  createtime;
@property(nonatomic,assign) BOOL isread;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,assign) BOOL iscoop;
@property(nonatomic,assign) BOOL isself;
@property(nonatomic,copy) NSString *ID;
@end

@interface NotificationDetailViewController : BaseViewController
@property(nonatomic,assign)BOOL isSystempagetype;
@end


@interface SystemMessageCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth;
- (void)setData:(SystemMessageData *)modal showDetial:(BOOL)showDetial;
@end