//
//  MyContentDetailViewController.h
//  Lebao
//
//  Created by David on 16/2/18.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"

@interface MyContentDetailViewController : BaseViewController
@property(nonatomic,strong) NSString *ID;
@property(nonatomic,strong) NSString *uid;
@property(nonatomic,strong)NSString *imageurl;
@property(nonatomic,assign)BOOL isNoEdit;
@property(nonatomic,strong)UIImage *shareImage;
@end

