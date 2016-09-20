//
//  TheSecondHourseNextViewController.h
//  Lebao
//
//  Created by David on 16/4/11.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"
#import "TheSecondaryHouseModal.h"
@interface TheSecondHourseNextViewController : BaseViewController
@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong) NSMutableArray *images;
@property(nonatomic,strong)NSMutableArray *selecteds;
@property(nonatomic,assign)BOOL isEdit;
@property(nonatomic,strong)TheSecondaryHouseModal *modal;
@end
