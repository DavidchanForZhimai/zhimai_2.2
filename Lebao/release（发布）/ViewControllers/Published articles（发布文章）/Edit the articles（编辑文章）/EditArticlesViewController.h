//
//  EditArticlesViewController.h
//  Lebao
//
//  Created by David on 16/4/5.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"

@interface EditArticlesData :NSObject
@property(nonatomic,strong)NSString *documentID;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,assign)BOOL  isAddress;
@property(nonatomic,assign)BOOL  islibrary;
@property(nonatomic,assign)BOOL  isRanking;
@property(nonatomic,assign)BOOL  isgetclue;
@property(nonatomic,assign)BOOL  isreward;
@property(nonatomic,strong)NSString *author;
@property(nonatomic,strong)NSString *reward;
@property(nonatomic,strong)NSString *amount;
@property(nonatomic,strong)NSString *imageurl;
@property(nonatomic,assign)BOOL isReleseArticle;

@property(nonatomic,strong)NSString *productID;
@property(nonatomic,strong) NSString  *product_title;
@property(nonatomic,strong) NSString  *product_imgurl;
@property(nonatomic,strong) NSString  *product_isgetclue;
@property(nonatomic,strong) NSString  *product_uid;
@property(nonatomic,strong) NSString  *product_actype;
@property(nonatomic,strong) NSString  *product_industry;
@property(nonatomic,strong)NSArray *product;
@end

@interface EditArticlesViewController : BaseViewController
@property(nonatomic,strong)EditArticlesData *data;
@end
