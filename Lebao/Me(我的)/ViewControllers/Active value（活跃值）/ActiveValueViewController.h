//
//  ActiveValueViewController.h
//  Lebao
//
//  Created by David on 15/12/23.
//  Copyright © 2015年 David. All rights reserved.
//

#import "BaseViewController.h"

@class ActiveValueDatas;
@interface ActiveValueModal : NSObject

@property (nonatomic, strong) NSString *desc;

@property (nonatomic, assign) NSInteger rtcode;

@property (nonatomic, strong) NSString *rtmsg;

@property (nonatomic, strong) NSDictionary *ac;

@property (nonatomic, strong) NSString *imgurl;

@property (nonatomic, strong) NSMutableArray<ActiveValueDatas *> *datas;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) NSInteger level;

@property (nonatomic, assign) NSInteger allpage;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, strong) NSString *num;

@end


@interface ActiveValueDatas : NSObject


@property (nonatomic, strong) NSString *imgurl;

@property (nonatomic, strong) NSString *ID;

@property (nonatomic, strong) NSString *userid;

@property (nonatomic, strong) NSString *score;

@property (nonatomic, strong) NSString *source;

@property (nonatomic, strong) NSString *inputtime;

@property (nonatomic, strong) NSString *remark;

@end



@interface ActiveValueViewController : BaseViewController

@end


@interface ActiveValueCell : UITableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth;
- (void)dataModal:(ActiveValueDatas *)modal;
@end

@interface CurveView : UIView

@end


