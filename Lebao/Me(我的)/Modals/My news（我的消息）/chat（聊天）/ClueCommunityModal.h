//
//  ClueCommunityModal.h
//  Lebao
//
//  Created by David on 16/5/23.
//  Copyright © 2016年 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModal.h"
@interface ClueCommunityModal : BaseModal
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,assign)int state;
@property(nonatomic,assign)int createtime;
@end

@interface ClueCommunityData : NSObject
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *sex;
@property(nonatomic,copy)NSString *realname;
@property(nonatomic,copy)NSString *imgurl;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,assign)int createtime;
@property(nonatomic,assign)int authen;
@end