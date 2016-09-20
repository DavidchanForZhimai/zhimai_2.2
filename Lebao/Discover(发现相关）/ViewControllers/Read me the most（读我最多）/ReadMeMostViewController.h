//
//  ReadMeMostViewController.h
//  Lebao
//
//  Created by David on 16/5/17.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"
@interface ReadMeMostModal : NSObject
@property(nonatomic,assign) int page;
@property(nonatomic,assign) int rtcode;
@property(nonatomic,strong) NSString *rtmsg;
@property(nonatomic,assign) int allpage;
@property(nonatomic,assign) int count;
@property(nonatomic,strong) NSMutableArray  *datas;
@end

@interface ReadMeMostData: NSObject
@property(nonatomic,strong) NSString *imgrul;
@property(nonatomic,strong) NSString *nickname;
@property(nonatomic,strong) NSString *number;
@property(nonatomic,strong) NSString *openid;
@property(nonatomic,strong) NSString *title;
@end

@interface ReadMeMostViewController : BaseViewController

@end

@interface ReadMeMostCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth;
- (void)setModel:(ReadMeMostData *)model isLast:(BOOL)isLast;
@end