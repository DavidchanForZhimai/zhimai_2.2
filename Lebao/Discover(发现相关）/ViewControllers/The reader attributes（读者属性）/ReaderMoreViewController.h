//
//  ReaderMoreViewController.h
//  Lebao
//
//  Created by David on 16/5/26.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"
@interface ReaderMoreData : NSObject
@property(nonatomic,strong)NSString *city;
@property(nonatomic,assign)int count;
@end
@interface ReaderMoreViewController : BaseViewController
@property(nonatomic,strong)NSMutableArray *citys;
@end

@interface ReaderMoreCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth;
- (void)setData:(ReaderMoreData *)modal isClear:(BOOL)isClear;
@end