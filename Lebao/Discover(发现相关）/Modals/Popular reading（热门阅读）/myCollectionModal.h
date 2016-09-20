//
//  myCollectionModal.h
//  Lebao
//
//  Created by David on 16/2/16.
//  Copyright © 2016年 David. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myCollectionModal : NSObject
@property(nonatomic,assign)int  allpage;
@property(nonatomic,assign)int  count;
@property(nonatomic,assign)int  page;
@property(nonatomic,assign)int  rtcode;
@property(nonatomic,strong)NSString *rtmsg;
@property(nonatomic,strong)NSMutableArray *datas;
@end


@interface myCollectionDataModal : NSObject
@property(nonatomic,strong)NSString *acid;
@property(nonatomic,strong)NSString *createtime;
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *imgurl;
@property(nonatomic,assign)BOOL isshare;
@property(nonatomic,strong)NSString *state;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *userid;
@end