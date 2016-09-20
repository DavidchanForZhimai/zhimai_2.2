//
//  MessageCell.h
//  Lebao
//
//  Created by David on 15/12/10.
//  Copyright © 2015年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationModal.h"
@interface MessageCell : UITableViewCell
@property(nonatomic,strong)UILabel *message;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth;
- (void)setData:(NotificationData *)modal;
@end
