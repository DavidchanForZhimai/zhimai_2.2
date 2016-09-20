//
//  SelecteCarTypeViewController.h
//  Lebao
//
//  Created by David on 16/4/14.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^SelecteCarTypeBlock)(NSString *str,NSString *keyid,NSString *seriesid,NSString *model_id);
typedef void (^DimissBlock)();
@interface SelecteCarTypeViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *selectedTable;
@property(nonatomic,strong)NSMutableArray *selectedArray;
@property(nonatomic,strong)NSMutableArray *selectedKeyArray;
@property(nonatomic,copy)SelecteCarTypeBlock resultBlock;
@property(nonatomic,copy)DimissBlock dimissBlock;
@end
