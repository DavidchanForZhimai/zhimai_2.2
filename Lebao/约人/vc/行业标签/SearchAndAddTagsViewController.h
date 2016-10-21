//
//  SearchAndAddTagsViewController.h
//  Lebao
//
//  Created by David on 16/9/12.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^SearchResultBlock) (NSString *str);
@interface SearchAndAddTagsViewController : BaseViewController
@property(nonatomic,copy)SearchResultBlock  searchResultBlock;
@end
