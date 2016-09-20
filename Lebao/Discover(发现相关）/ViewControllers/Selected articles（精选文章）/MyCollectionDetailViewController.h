//
//  MyCollectionDetailViewController.h
//  Lebao
//
//  Created by David on 16/2/16.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"

@interface MyCollectionDetailViewController : BaseViewController
@property(nonatomic,assign)BOOL  isAdd;
@property(nonatomic,strong) NSString *ID;
@property(nonatomic,strong) NSString *acid; //文章列表id
@property(nonatomic,strong) UIImage *shareImage;
@end

@interface MyCollectionDetailModal : NSObject
@property(nonatomic,assign)BOOL  rtcode;
@property(nonatomic,strong) NSString *rtmsg;
@property(nonatomic,strong) NSDictionary *datas;
@end