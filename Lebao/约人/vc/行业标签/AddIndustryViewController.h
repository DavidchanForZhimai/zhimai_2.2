//
//  AddIndustryViewController.h
//  Lebao
//
//  Created by David on 16/9/12.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^AddTagsFinishBlock)(NSArray *tags);
@interface AddIndustryViewController : BaseViewController
@property(nonatomic,strong)NSMutableArray *hasTags;//已关注标签
@property(nonatomic,copy)AddTagsFinishBlock addTagsfinishBlock;
@end
