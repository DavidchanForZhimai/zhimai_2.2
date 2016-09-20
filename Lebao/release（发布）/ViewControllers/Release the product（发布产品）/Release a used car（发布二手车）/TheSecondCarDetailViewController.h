//
//  TheSecondCarDetailViewController.h
//  Lebao
//
//  Created by David on 16/4/14.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"
#import "TheSecondCarHomeModel.h"
#import "FSComboListView.h"
@interface TheSecondCarDetailViewController : BaseViewController
@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong) NSMutableArray *images;
@property(nonatomic,strong) NSMutableArray *selecteds;
@property(nonatomic,assign)BOOL isEdit;
@property(nonatomic,strong)TheSecondCarHomeModel *modal;


@property(nonatomic,strong) NSMutableArray *comboBoxColorArray;
@property(nonatomic,strong) NSMutableArray *comboBoxYearArray;
@property(nonatomic,strong) NSMutableArray *comboBoxMonArray;
@property(nonatomic,strong) FSComboListView *comboBoxColor;
@property(nonatomic,strong) FSComboListView *comboBoxYear;
@property(nonatomic,strong) FSComboListView *comboBoxMon;
@end
