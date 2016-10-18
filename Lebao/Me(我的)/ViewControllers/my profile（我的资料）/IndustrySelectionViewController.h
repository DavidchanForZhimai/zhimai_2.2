//
//  IndustrySelectionViewController.h
//  Lebao
//
//  Created by David on 16/10/8.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^EditBlock)(NSString *text);
@interface IndustrySelectionViewController : BaseViewController
@property(nonatomic,copy)EditBlock editBlock;
@property(nonatomic,strong)id dataObj;
@end
