//
//  ReadMeMostDetailViewController.h
//  Lebao
//
//  Created by David on 16/5/17.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"
@interface ReadMeMostDetailUserinfo: NSObject
@property(nonatomic,strong) NSString *background;
@property(nonatomic,strong) NSString *headimgurl;
@property(nonatomic,strong) NSString *nickname;
@property(nonatomic,strong) NSString *readcount;
@property(nonatomic,strong) NSString *readcovercount;
@end
@interface ReadMeMostDetailModal : NSObject
@property(nonatomic,assign) int page;
@property(nonatomic,assign) int rtcode;
@property(nonatomic,strong) NSString *rtmsg;
@property(nonatomic,assign) int allpage;
@property(nonatomic,assign) int count;
@property(nonatomic,strong) NSMutableArray  *datas;
@property(nonatomic,strong) ReadMeMostDetailUserinfo  *userinfo;
@end
@interface ReadMeMostDetailData: NSObject
@property(nonatomic,strong) NSString *createdate;
@property(nonatomic,strong) NSString *readnum;
@property(nonatomic,strong) NSString *readtime;
@property(nonatomic,strong) NSString *title;

@end

@interface ReadMeMostDetailViewController : BaseViewController
@property(nonatomic,strong) NSString *openID;
@end
@interface ReadMeMostDetailCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth;
- (void)setModel:(ReadMeMostDetailData *)model isFirst:(BOOL)isFirst;
@end