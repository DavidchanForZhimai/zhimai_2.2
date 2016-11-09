//
//  MeetNumModel.h
//  Lebao
//
//  Created by adnim on 16/9/7.
//  Copyright © 2016年 David. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MeetNumModel : NSObject

@property (nonatomic,assign)int invited;
@property (nonatomic,assign)int beinvited;
@property (nonatomic,assign)int cansee;
@property (nonatomic,strong)NSMutableArray *cansee_datas;
@property (nonatomic,copy)NSString *realname;
@property (nonatomic,assign)int rtcode;
@end

@interface canseeDatas : NSObject

@property (nonatomic,copy)NSString *imgurl;
@property (nonatomic,copy)NSString *realname;
@property (nonatomic,copy)NSString *userid;
@end
