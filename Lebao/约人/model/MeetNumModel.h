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
@property (nonatomic,copy)NSString *userid;
@end
