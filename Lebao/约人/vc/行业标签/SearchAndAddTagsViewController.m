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
#import "XLDataService.h"
#define MeetHotsURL [NSString stringWithFormat:@"%@meet/hots",HttpURL]
#define TagHeight 30
#define ViewStartX StatusBarHeight + NavigationBarHeight
@interface SearchAndAddTagsViewController ()<DWTagsViewDelegate,UISearchBarDelegate>
@property(nonatomic,strong)UILabel *hotLb;//热门标签
@property(nonatomic,strong)DWTagsView *hotTagsView;//热门标签
@property(nonatomic,copy) NSMutableArray *hotTags;//热门标签
@property(nonatomic,strong) UISearchBar * bar;

@end

@implementation SearchAndAddTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.backgroundColor = WhiteColor;
    [self navViewTitleAndBackBtn:@""];
    [self.view addSubview:self.hotLb];
    [self.view addSubview:self.hotTagsView];
    [self.view addSubview:self.bar];
    [self netWork];
}
- (void)netWork
{
    
    [XLDataService postWithUrl:MeetHotsURL param:[Parameter parameterWithSessicon] modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        [[ToolManager shareInstance] dismiss];
        _hotTags= dataObj[@"hots"];
        for (NSString *str  in _hotTags) {
            [_hotTagsView addTag:str];
        }
    }];

}

#pragma mark getter
- (UISearchBar *)bar
{
    if (!_bar) {
        _bar = [[UISearchBar alloc]initWithFrame:CGRectMake(40*ScreenMultiple, StatusBarHeight + 7, APPWIDTH - 60*ScreenMultiple, NavigationBarHeight - 14)];
        _bar.backgroundColor = WhiteColor;
        _bar.barStyle = UIBarStyleDefault;
        _bar.tintColor = LineBg;
        _bar.translucent = YES;
        [_bar setBorder:LineBg width:0.5];
        [_bar setRadius:_bar.height/2.0];
        _bar.delegate = self;
        _bar.placeholder=@"搜索关键字找到感兴趣的人";
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if ([_bar respondsToSelector:@selector(barTintColor)]) {
            
            float iosversion7_1 = 7.1;
        
            if (version >= iosversion7_1)        {
                
                [[[[_bar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
    
                [_bar setBackgroundColor:[UIColor clearColor]];
                
                
                
            }
            
            
            else {            //iOS7.0
                
                [_bar setBarTintColor:[UIColor clearColor]];
                [_bar setBackgroundColor:[UIColor clearColor]];
                
            }
            
        }
        
    }
    return _bar;
}
- (UILabel *)hotLb
{
    if (_hotLb) {
        return _hotLb;
    }
    _hotLb = [UILabel createLabelWithFrame:frame(10, ViewStartX, APPWIDTH,40) text:@"热门标签" fontSize:28*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:nil];
    return _hotLb;
}
- (DWTagsView *)hotTagsView
{
    if (_hotTagsView) {
        return _hotTagsView;
    }
    _hotTagsView = allocAndInitWithFrame(DWTagsView, frame(10, CGRectGetMaxY(_hotLb.frame), APPWIDTH -20, APPHEIGHT - CGRectGetMaxY(_hotLb.frame)));
    _hotTagsView.contentInsets = UIEdgeInsetsZero;
    _hotTagsView.tagInsets = UIEdgeInsetsMake(5, 15, 5, 15);
    _hotTagsView.tagBorderWidth = 0.5;
    _hotTagsView.tagcornerRadius = 5;
    _hotTagsView.mininumTagWidth = 40;
    _hotTagsView.maximumTagWidth = APPWIDTH - 20;
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
- (NSMutableArray *)hotTags
{
    if (_hotTags) {
        return _hotTags;
    }
    _hotTags = [[NSMutableArray alloc]init];
    return _hotTags;
}
#pragma mark
#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
     if (_searchResultBlock) {
        _searchResultBlock(searchBar.text);
     }
    [self.navigationController popViewControllerAnimated:NO];
    
}

#pragma mark
#pragma mark - DWTagsViewDelegate
- (void)tagsView:(DWTagsView *)tagsView didSelectTagAtIndex:(NSUInteger)index
{
    if (index<_hotTags.count) {
        [_bar becomeFirstResponder];
         _bar.text = _hotTags[index];
    }

}
#pragma mark
#pragma mark buttons Aticon
- (void)buttonAction:(UIButton *)sender
{
   [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
