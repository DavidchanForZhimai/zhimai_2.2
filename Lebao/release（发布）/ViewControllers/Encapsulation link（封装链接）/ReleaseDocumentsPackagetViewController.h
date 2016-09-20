//
//  ReleaseDocumentsPackagetViewController.h
//  Lebao
//
//  Created by David on 15/12/11.
//  Copyright © 2015年 David. All rights reserved.
//

#import "BaseViewController.h"

@interface ReleaseDocumentsDatas : NSObject
@property(nonatomic,strong)NSString *amount;
@property(nonatomic,strong)NSString *author;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSMutableArray *imgurl;
@property(nonatomic,strong)NSString *title;

@property(nonatomic,strong)NSString *productid;
@property(nonatomic,strong) NSString  *product_title;
@property(nonatomic,strong) NSString  *product_imgurl;
@property(nonatomic,strong) NSString  *product_isgetclue;
@property(nonatomic,strong) NSString  *product_uid;
@property(nonatomic,strong) NSString  *product_actype;
@property(nonatomic,strong) NSString  *product_industry;
@end
@interface ReleaseDocumentsModal : NSObject
@property(nonatomic,strong)ReleaseDocumentsDatas *datas;
@property(nonatomic,strong)NSString *rtmsg;
@property(nonatomic,assign)int rtcode;
@property(nonatomic,strong)NSArray *product;
@end


@interface ReleaseDocumentsPackagetViewController : BaseViewController

@end
