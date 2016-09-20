//
//  MyArticleDetailModal.h
//  Lebao
//
//  Created by David on 16/3/2.
//  Copyright © 2016年 David. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyArticleDetailDataModal : NSObject
@property(nonatomic,strong) NSString *ID;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSString *industry;
@property(nonatomic,strong) NSString *readnum;
@property(nonatomic,strong) NSString *createtime;
@property(nonatomic,assign)BOOL isaddress;
@property(nonatomic,strong) NSString *isaddress_name;
@property(nonatomic,strong) NSString *isaddress_imgurl;
@property(nonatomic,strong) NSString *isaddress_tel;
@property(nonatomic,strong) NSString *isaddress_add;
@property(nonatomic,strong) NSString *isaddress_area;
@property(nonatomic,assign) BOOL islibrary;
@property(nonatomic,assign) BOOL isranking;
@property(nonatomic,assign) BOOL iscollect;
@property(nonatomic,assign) BOOL isgetclue;
@property(nonatomic,assign)BOOL  iscross;
@property(nonatomic,strong) NSString *author;//文章来源
@property(nonatomic,strong) NSString  *next_acid;//下一篇文章
@property(nonatomic,strong) NSString  *next_id;//下一篇文章id
@property(nonatomic,strong) NSString  *url;//下一篇文章id
@property(nonatomic,assign) BOOL  isreward;
@property(nonatomic,strong) NSString  *reward;
@property(nonatomic,strong) NSString  *amount;
@property(nonatomic,strong) NSString  *productpics;
@property(nonatomic,strong) NSString  *fields;


@property(nonatomic,strong) NSString  *productid;
@property(nonatomic,strong) NSString  *product_title;
@property(nonatomic,strong) NSString  *product_imgurl;
@property(nonatomic,strong) NSString  *product_isgetclue;
@property(nonatomic,strong) NSString  *product_uid;
@property(nonatomic,strong) NSString  *product_actype;
@property(nonatomic,strong) NSString  *product_industry;
@end

@interface MyArticleDetailModal : NSObject
@property(nonatomic,assign)int  rtcode;
@property(nonatomic,strong) NSString *rtmsg;
@property(nonatomic,strong) MyArticleDetailDataModal *datas;
@property(nonatomic,strong) NSArray  *product;
@end
