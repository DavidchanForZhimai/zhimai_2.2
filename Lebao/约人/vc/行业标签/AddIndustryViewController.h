//
//  AddIndustryViewController.h
//  Lebao
//
//  Created by David on 16/9/12.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^AddTagsFinishBlock)(NSMutableArray *tags);
@interface AddIndustryViewController : BaseViewController
@property(nonatomic,strong)id data;
@property(nonatomic,copy)AddTagsFinishBlock addTagsfinishBlock;
@end
