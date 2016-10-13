//
//  BaseModal.h
//  Lebao
//
//  Created by David on 16/3/8.
//  Copyright © 2016年 David. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModal : NSObject
@property(nonatomic,assign) int page;
@property(nonatomic,assign) int rtcode;
@property(nonatomic,strong) NSString *rtmsg;
@property(nonatomic,assign) int allpage;
@property(nonatomic,assign) int count;
@property(nonatomic,strong) NSMutableArray  *datas;

@end
