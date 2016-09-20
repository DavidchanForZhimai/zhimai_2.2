//
//  SelectedCarResultViewController.h
//  Lebao
//
//  Created by David on 16/4/14.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^ResultBlock)(NSString *str,NSString *model_id);
@interface SelectedCarResultView : UIView<UITableViewDelegate,UITableViewDataSource>
- (instancetype)initWithFrame:(CGRect)frame seriesID:(NSString *)seriesID;
@property(nonatomic,strong)UITableView *selectedTable;
@property(nonatomic,strong)NSMutableArray *selectedArray;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,copy)ResultBlock resultBlock;
@end
