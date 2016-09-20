//
//  GzHyViewController.m
//  Lebao
//
//  Created by David on 16/9/12.
//  Copyright © 2016年 David. All rights reserved.
//

#import "GzHyViewController.h"
#import "AddIndustryViewController.h"
#import "DWTagsView.h"
#define ViewStartX StatusBarHeight + NavigationBarHeight
@interface GzHyViewController ()<DWTagsViewDelegate>
@property(nonatomic,strong)DWTagsView *hasTagsView;//已关注标签
@property(nonatomic,copy)NSMutableArray *hasTags;//已关注标签
@property(nonatomic,strong)BaseButton *addHasLb;//添加关注标签

@end

@implementation GzHyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.backgroundColor = WhiteColor;
    [self navViewTitleAndBackBtn:@"关注行业"];
    [self.view addSubview:self.hasTagsView];
    [self.view addSubview:self.addHasLb];
    
    
}


#pragma mark getter
- (BaseButton *)addHasLb
{
    if (_addHasLb) {
        return _addHasLb;
    }
    _addHasLb = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 50 ,StatusBarHeight,50, NavigationBarHeight) setTitle:@"添加" titleSize:28*SpacedFonts titleColor:BlackTitleColor textAlignment:NSTextAlignmentRight backgroundColor:[UIColor clearColor] inView:nil];
    _addHasLb.shouldAnmial = NO;
    __weak typeof(self) weakSelf = self;
    _addHasLb.didClickBtnBlock = ^
    {
        __strong typeof(weakSelf) strongSelf =weakSelf;
        AddIndustryViewController *addIndustryVC = allocAndInit(AddIndustryViewController);
        addIndustryVC.hasTags = weakSelf.hasTags;
        addIndustryVC.addTagsfinishBlock = ^(NSArray *tags)
        {
            
            for (id str  in strongSelf.hasTags) {
                [strongSelf.hasTagsView removeTagWithName:str];
            }
            for (id str  in tags) {
                [strongSelf.hasTagsView addTag:str];
            }
            
        };
        PushView(weakSelf, addIndustryVC);
    };
    return _addHasLb;
}

- (DWTagsView *)hasTagsView
{
    if (_hasTagsView) {
        return _hasTagsView;
    }
    _hasTagsView = allocAndInitWithFrame(DWTagsView, frame(10,10+ViewStartX , APPWIDTH-20, APPHEIGHT - (10 + ViewStartX)));
    _hasTagsView.contentInsets = UIEdgeInsetsZero;
    _hasTagsView.tagInsets = UIEdgeInsetsMake(5, 15, 5, 15);
    _hasTagsView.tagBorderWidth = 0.5;
    _hasTagsView.tagcornerRadius = 5;
    _hasTagsView.mininumTagWidth = (APPWIDTH - 30)/3.0;
    _hasTagsView.tagHeight  = 30;
    _hasTagsView.tagBorderColor = LineBg;
    _hasTagsView.tagSelectedBorderColor = LineBg;
    _hasTagsView.tagBackgroundColor = [UIColor whiteColor];
    _hasTagsView.lineSpacing = 5;
    _hasTagsView.interitemSpacing = 5;
    _hasTagsView.tagFont = [UIFont systemFontOfSize:14];
    _hasTagsView.tagTextColor = BlackTitleColor;
    _hasTagsView.tagSelectedBackgroundColor = _hasTagsView.tagBackgroundColor;
    _hasTagsView.tagSelectedTextColor = _hasTagsView.tagTextColor;
    
    _hasTagsView.delegate = self;
    _hasTagsView.tagsArray = self.hasTags;
    return _hasTagsView;
}


- (NSMutableArray *)hasTags
{
    if (_hasTags) {
        return _hasTags;
    }
    _hasTags = [[NSMutableArray alloc]initWithObjects:@"销售",@"销售",@"销售",nil];
    return _hasTags;
}

#pragma mark
#pragma mark buttons Aticon
- (void)buttonAction:(UIButton *)sender
{
    PopView(self);
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end