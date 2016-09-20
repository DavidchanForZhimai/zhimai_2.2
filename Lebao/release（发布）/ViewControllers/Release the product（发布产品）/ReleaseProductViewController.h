//
//  ReleaseProductViewController.h
//  Lebao
//
//  Created by David on 15/12/11.
//  Copyright © 2015年 David. All rights reserved.
//

#import "BaseViewController.h"

@interface ReleaseProduct :NSObject
@property(nonatomic,strong)NSString *documentID;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,assign)BOOL  isAddress;
@property(nonatomic,assign)BOOL  isgetclue;
@property(nonatomic,assign)BOOL  iscollect;
@property(nonatomic,assign)BOOL  isreward;
@property(nonatomic,assign)BOOL  iscross;

@property(nonatomic,strong)NSString *author;
@property(nonatomic,strong)NSString *reward;
@property(nonatomic,strong)NSString *amount;
@property(nonatomic,strong)NSMutableArray *imageurl;
@property(nonatomic,strong)NSString *currentImageurl;
@property(nonatomic,assign)BOOL isEdit;
@property(nonatomic,strong)NSMutableArray *selecteds;
@end

@interface ReleaseProductViewController : BaseViewController
@property(nonatomic,strong)ReleaseProduct *data;
@end
