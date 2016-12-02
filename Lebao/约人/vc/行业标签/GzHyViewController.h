//
//  GzHyViewController.h
//  Lebao
//
//  Created by David on 16/9/12.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"
#import "DWTagsView.h"
typedef void (^AddTagsFinishBlock)(NSMutableArray *tags);
@interface GzHyViewController : BaseViewController
@property(nonatomic,copy)AddTagsFinishBlock addTagsfinishBlock;
@end

@interface GzHyCell : UITableViewCell
@property(nonatomic,strong)UIView *view;
@property(nonatomic,strong)UILabel *title;
@property(nonatomic,strong)DWTagsView *content;
@end
