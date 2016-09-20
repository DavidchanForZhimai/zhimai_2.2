//
//  ReaderAttributesViewController.h
//  Lebao
//
//  Created by David on 16/5/25.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseModal.h"
@interface ReaderAttributesModal : NSObject
@property(nonatomic,assign) int page;
@property(nonatomic,assign) int rtcode;
@property(nonatomic,strong) NSString *rtmsg;
@property(nonatomic,assign) int allpage;
@property(nonatomic,assign) int count;
@property(nonatomic,assign)int unknow;
@property(nonatomic,assign)int man;
@property(nonatomic,assign)int women;
@property(nonatomic,assign)int all;
@property(nonatomic,assign)int browse;
@property(nonatomic,strong)NSMutableArray *city;
@end
@interface ReaderAttributesData : NSObject
@property(nonatomic,strong)NSString *city;
@property(nonatomic,assign)int count;
@end

@interface ReaderAttributesViewController : BaseViewController

@end
