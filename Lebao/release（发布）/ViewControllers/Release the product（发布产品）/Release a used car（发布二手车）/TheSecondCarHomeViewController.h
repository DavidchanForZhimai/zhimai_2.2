//
//  TheSecondCarHomeViewController.h
//  Lebao
//
//  Created by David on 16/4/14.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"
#import "FSComboListView.h"
@interface TheSecondCarHomeViewController : BaseViewController
@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong)NSMutableArray *comboBoxArray;
@property(nonatomic,strong) FSComboListView *comboBox;
@property(nonatomic,strong) BaseButton *selectedBtn;
@property(nonatomic,strong) NSMutableArray *selectedArray;
@property(nonatomic,strong) NSMutableArray *images;
//@property(nonatomic,strong) NSMutableDictionary *newimages;

@property(nonatomic,strong) NSString *acid;
@property(nonatomic,strong) NSString *uid;
@property(nonatomic,assign)BOOL isEdit;
@end
