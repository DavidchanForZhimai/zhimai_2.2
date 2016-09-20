//
//  SearchAndAddTagsViewController.m
//  Lebao
//
//  Created by David on 16/9/12.
//  Copyright © 2016年 David. All rights reserved.
//

#import "SearchAndAddTagsViewController.h"
#import "AddIndustryViewController.h"
#import "DWTagsView.h"
#define TagHeight 30
#define ViewStartX StatusBarHeight + NavigationBarHeight
@interface SearchAndAddTagsViewController ()<DWTagsViewDelegate>
@property(nonatomic,strong)UILabel *hotLb;//热门标签
@property(nonatomic,strong)DWTagsView *hotTagsView;//热门标签
@property(nonatomic,copy)NSMutableArray *hotTags;//热门标签
@property(nonatomic,strong)DWTagsView *hasTagsView;//已关注标签
@property(nonatomic,copy)NSMutableArray *hasTags;//已关注标签
@property(nonatomic,strong)UILabel *hasLb;//已关注标签
@property(nonatomic,strong)BaseButton *addHasLb;//添加关注标签
@end

@implementation SearchAndAddTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.backgroundColor = WhiteColor;
    [self navViewTitleAndBackBtn:@""];
    [self.view addSubview:self.hotLb];
    [self.view addSubview:self.hotTagsView];
    [self.view addSubview:self.hasLb];
    [self.view addSubview:self.hasTagsView];
    [self.view addSubview:self.addHasLb];
    
    [self resetFrame];
    
}


#pragma mark getter
- (UILabel *)hotLb
{
    if (_hotLb) {
        return _hotLb;
    }
    _hotLb = [UILabel createLabelWithFrame:frame(10, ViewStartX, APPWIDTH, 40) text:@"热门标签" fontSize:28*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:nil];
    return _hotLb;
}
- (DWTagsView *)hotTagsView
{
    if (_hotTagsView) {
        return _hotTagsView;
    }
    _hotTagsView = allocAndInitWithFrame(DWTagsView, frame(10, CGRectGetMaxY(_hotLb.frame), APPWIDTH -20, 70));
    _hotTagsView.contentInsets = UIEdgeInsetsZero;
    _hotTagsView.tagInsets = UIEdgeInsetsMake(5, 15, 5, 15);
    _hotTagsView.tagBorderWidth = 0.5;
    _hotTagsView.tagcornerRadius = 5;
    _hotTagsView.mininumTagWidth = (APPWIDTH - 30)/3.0;
    _hotTagsView.tagHeight  = TagHeight;
    _hotTagsView.tagBorderColor = LineBg;
    _hotTagsView.tagSelectedBorderColor = LineBg;
    _hotTagsView.tagBackgroundColor = [UIColor whiteColor];
    _hotTagsView.lineSpacing = 5;
    _hotTagsView.interitemSpacing = 5;
    _hotTagsView.tagFont = [UIFont systemFontOfSize:14];
    _hotTagsView.tagTextColor = LightBlackTitleColor;
    _hotTagsView.tagSelectedBackgroundColor = _hotTagsView.tagBackgroundColor;
    _hotTagsView.tagSelectedTextColor = _hotTagsView.tagTextColor;
    
    _hotTagsView.delegate = self;
    _hotTagsView.tagsArray = self.hotTags;

    return _hotTagsView;
    
}
- (UILabel *)hasLb
{
    if (_hasLb) {
        return _hasLb;
    }
    _hasLb = [UILabel createLabelWithFrame:frame(10, _hotTagsView.height + _hotTagsView.y +20, APPWIDTH, 40) text:@"已关注的行业" fontSize:28*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:nil];
    return _hasLb;
}

- (BaseButton *)addHasLb
{
    if (_addHasLb) {
        return _addHasLb;
    }
    _addHasLb = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 38 , _hasLb.y,28, _hasLb.height) setTitle:@"添加" titleSize:28*SpacedFonts titleColor:BlackTitleColor textAlignment:NSTextAlignmentRight backgroundColor:[UIColor clearColor] inView:nil];
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
    _hasTagsView = allocAndInitWithFrame(DWTagsView, frame(10,_hasLb.y + _hasLb.height , APPWIDTH-20, 100));
    _hasTagsView.contentInsets = UIEdgeInsetsZero;
    _hasTagsView.tagInsets = UIEdgeInsetsMake(5, 15, 5, 15);
    _hasTagsView.tagBorderWidth = 0.5;
    _hasTagsView.tagcornerRadius = 5;
    _hasTagsView.mininumTagWidth = (APPWIDTH - 30)/3.0;
    _hasTagsView.tagHeight  = TagHeight;
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

- (NSMutableArray *)hotTags
{
    if (_hotTags) {
        return _hotTags;
    }
    _hotTags = [[NSMutableArray alloc]initWithObjects:@"销售",@"销售",@"销售",@"销售",@"销售",@"销售", nil];
    return _hotTags;
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
#pragma mark  setframe
- (void)resetFrame
{
    int hotRow = 0;
    if (_hasTags.count%3==0) {
        hotRow=(int)(_hasTags.count/3);
    }
    else
    {
      hotRow=(int)(_hasTags.count/3) + 1;
    }
    _hotTagsView.frame = frame(10, CGRectGetMaxY(_hotLb.frame), APPWIDTH -20, (TagHeight+50)*hotRow);
    _hasLb.frame =frame(10, _hotTagsView.height + _hotTagsView.y +10, APPWIDTH, 40);
    _addHasLb.frame = frame(APPWIDTH - 38 , _hasLb.y,28, _hasLb.height);
    _hasTagsView.frame = frame(10,_hasLb.y + _hasLb.height , APPWIDTH-20, APPHEIGHT - (_hasLb.y + _hasLb.height));
    
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
