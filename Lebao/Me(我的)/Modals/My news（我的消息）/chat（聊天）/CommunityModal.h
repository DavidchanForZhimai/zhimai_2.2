//
//  CommunityModal.h
//  Lebao
//
//  Created by David on 15/12/28.
//  Copyright © 2015年 David. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModal.h"
@interface CommunityModal : BaseModal
@property(nonatomic,strong)NSString *receiver;
@end

@interface CommunityDataModal : NSObject
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *createtime;
@property(nonatomic,strong)NSString *imgurl;
@property(nonatomic,assign)BOOL isself;
@property(nonatomic,assign)int sex;
@property(nonatomic,assign)int brokerid;
@property(nonatomic,strong)NSString *realname;
@end
