//
//  MyContentModal.h
//  Lebao
//
//  Created by David on 16/2/17.
//  Copyright © 2016年 David. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyContentModal : NSObject
@property(nonatomic,assign)int  allpage;
@property(nonatomic,assign)int  count;
@property(nonatomic,assign)int  page;
@property(nonatomic,assign)BOOL  rtcode;
@property(nonatomic,strong)NSString *rtmsg;
@property(nonatomic,strong)NSMutableArray *datas;
@end

@interface MyContentDataModal : NSObject
@property(nonatomic,strong)NSString *actype;
@property(nonatomic,strong)NSString *readcount;
@property(nonatomic,strong)NSString *readcover;
@property(nonatomic,strong)NSString *createdate;
@property(nonatomic,strong)NSString *uid;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *imgurl;
@property(nonatomic,strong)NSString *industry;
@property (nonatomic, assign) BOOL isgetclue;
@end