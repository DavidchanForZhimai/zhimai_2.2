//
//  ClueCommunityCell.h
//  Lebao
//
//  Created by David on 16/5/23.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClueCommunityModal.h"
typedef void (^ClueCommunityBlock)(NSString *jjrID);
@interface ClueCommunityCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth;

- (void)setModal:(ClueCommunityData *)data clueCommunityBlock:(ClueCommunityBlock)clueCommunityBlock;
@end
