//
//  SelectedCarDetailViewController.h
//  Lebao
//
//  Created by David on 16/4/14.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^SelectedCarDetailBlock)(NSString *str,NSString *seriesid,NSString *model_id);
@interface SelectedCarDetailView : UIView<UITableViewDelegate,UITableViewDataSource>
- (instancetype)initWithFrame:(CGRect)frame seriesID:(NSString *)seriesID;
@property(nonatomic,strong)UITableView *selectedTable;
@property(nonatomic,strong)NSMutableArray *selectedArray;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,copy)SelectedCarDetailBlock resultBlock;
@end
