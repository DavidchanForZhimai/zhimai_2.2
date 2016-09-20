//
//  MyProductDetailViewController.h
//  Lebao
//
//  Created by David on 16/4/7.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"

@interface MyProductDetailViewController : BaseViewController
@property(nonatomic,strong) NSString *ID;
@property(nonatomic,strong) NSString *uid;
@property(nonatomic,strong)NSString *imageurl;
@property(nonatomic,assign)BOOL isNoEdit;
@property(nonatomic,strong)UIImage *shareImage;
@end
