//
//  AddIndustryViewController.m
//  Lebao
//
//  Created by David on 16/9/12.
//  Copyright © 2016年 David. All rights reserved.
//

#import "AddIndustryViewController.h"
#import "DWTagsView.h"
#import "XLDataService.h"
#import "NSString+Extend.h"
#define FocusIndustryURL [NSString stringWithFormat:@"%@user/focus-industry",HttpURL]
#define SaveFocusIndustryURL [NSString stringWithFormat:@"%@user/save-focusindustry",HttpURL]

#define MininumTagWidth (APPWIDTH - 60)/3.0
#define MaxinumTagWidth (APPWIDTH - 60)/3.0

#define TagHeight 30*ScreenMultiple
#define ViewStartX StatusBarHeight + NavigationBarHeight
@interface AddIndustryViewController ()<DWTagsViewDelegate>
{
    UIScrollView *scrView;
    //选中类别的索引
    NSUInteger seletedClassIndex;
}

@property(nonatomic,strong)NSMutableArray *hasTags;//已关注标签
@property(nonatomic,strong)UIView *newsViews;
@property(nonatomic,strong)DWTagsView *newsClassTagsView;//新热门标签 类型
@property(nonatomic,strong)DWTagsView *newsTagsView;//新热门标签
@property(nonatomic,copy)NSMutableArray *newsTags;//新标签
@property(nonatomic,copy)NSMutableArray *classNewsTags;//新标签 类型
@property(nonatomic,strong)UILabel *newsLb;//新标签
@property(nonatomic,strong)BaseButton *finishBtn;//完成

@property(nonatomic,strong)UIScrollView *bottomScrollView;//底层

@property(nonatomic,strong)NSMutableArray *industry_label;
@property(nonatomic,strong)NSMutableArray  *saveIndustry_label;
@end

@implementation AddIndustryViewController
{
    NSMutableArray *industrys;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navViewTitleAndBackBtn:@"添加行业"];
    [self.view addSubview:self.finishBtn];
    
    
    
}
#pragma mark
#pragma mark netWork
- (void)netWork
{
    NSMutableDictionary *parame = [Parameter parameterWithSessicon];
    [parame setValue:[_hasTags componentsJoinedByString:@"/"] forKey:@"focus_industrys"];
    [[ToolManager shareInstance] showWithStatus:@"保存行业..."];
//    NSLog(@"industrys------ =%@ [industry] ==%@",industrys,_hasTags);
    [XLDataService postWithUrl:SaveFocusIndustryURL param:parame modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        
        if (dataObj) {
            if ([dataObj[@"rtcode"] intValue] ==1) {
                [[ToolManager shareInstance] dismiss];
                if (self.addTagsfinishBlock) {
                    self.addTagsfinishBlock(_hasTags);
                }
                PopView(self);
                
            }
            else
            {
                
                [[ToolManager shareInstance] showInfoWithStatus:dataObj[@"rtmsg"]];
            }
            
        }
        else
        {
            
            [[ToolManager shareInstance] showInfoWithStatus];
        }
        
        
        
    }];
    
}
- (void)setData:(id)data
{
    NSMutableArray *industryDic= data[@"industry_label"];
    industrys = [NSMutableArray arrayWithArray:data[@"industrys"]];
    NSArray *focus_industrys;
    if (data[@"focus_industrys"]&&[data[@"focus_industrys"] isKindOfClass:[NSString class]]&&![data[@"focus_industrys"] isEqualToString:@""]) {
        focus_industrys =[data[@"focus_industrys"] componentsSeparatedByString:@"/"];
    }
    //创建标签
    [self.hasTags addObjectsFromArray:focus_industrys];
    
    for (id value in industryDic) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            [self.industry_label  addObject:value];
            [self.newsClassTagsView addTag:value[@"name"]];
            [self.classNewsTags addObject:value[@"code"]];
           
        }
       
    }
    //默认选择
    if (self.classNewsTags.count>0) {
        [self.newsClassTagsView selectTagAtIndex:0 animate:YES];
        [self tagsView:self.newsClassTagsView didSelectTagAtIndex:0];

    }
    //默认已选行业类别加颜色
    seletedClassIndex = 0;
    __weak  typeof(self) weakself = self;
    self.newsClassTagsView.reloadDataFinish = ^
    {
        [weakself hasClassSelected];
    };

    scrView=[[UIScrollView alloc]init];
    scrView.frame=CGRectMake(0,NavigationBarHeight+StatusBarHeight, APPWIDTH, APPHEIGHT-(NavigationBarHeight+StatusBarHeight));
    scrView.contentSize=CGSizeMake(0, CGRectGetMaxY(self.newsTagsView.frame));
    
    [scrView addSubview:self.newsViews];
    [scrView addSubview:self.newsLb];
    [scrView addSubview:self.newsClassTagsView];
    [scrView addSubview:self.newsTagsView];
    
    [self.view addSubview:scrView];
    [self resetFrame];
  
}
- (UIView *)newsViews
{
    if (!_newsViews) {
        _newsViews = [[UIView alloc]initWithFrame:CGRectZero];
        _newsViews.backgroundColor = WhiteColor;
    }
    
    return _newsViews;
}
- (BaseButton *)finishBtn
{
    if (_finishBtn) {
        return _finishBtn;
    }
    _finishBtn = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 50 , StatusBarHeight,50, NavigationBarHeight) setTitle:@"完成" titleSize:28*SpacedFonts titleColor:BlackTitleColor textAlignment:NSTextAlignmentRight backgroundColor:[UIColor clearColor] inView:nil];
    _finishBtn.shouldAnmial = NO;
    __weak typeof(self) weakSelf = self;
    _finishBtn.didClickBtnBlock = ^
    {
        [weakSelf netWork];

    };
    return _finishBtn;
}


- (UILabel *)newsLb
{
    if (_newsLb) {
        return _newsLb;
    }
    _newsLb = [UILabel createLabelWithFrame:frame(0, 10, APPWIDTH, 40) text:@"---------点击添加行业小类--------" fontSize:28*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:nil];
    return _newsLb;
}

- (DWTagsView *)newsClassTagsView
{
    if (_newsClassTagsView) {
        return _newsClassTagsView;
    }
    _newsClassTagsView = allocAndInitWithFrame(DWTagsView, frame(15, CGRectGetMaxY(_newsLb.frame) , APPWIDTH -30, 70));
    _newsClassTagsView.contentInsets = UIEdgeInsetsZero;
    _newsClassTagsView.tagInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _newsClassTagsView.tagBorderWidth = 0.5;
    _newsClassTagsView.tagcornerRadius = 5;
    _newsClassTagsView.mininumTagWidth = MininumTagWidth;
    _newsClassTagsView.maximumTagWidth = MaxinumTagWidth;
    _newsClassTagsView.tagHeight  = TagHeight;
    _newsClassTagsView.tagBorderColor = LineBg;
    _newsClassTagsView.tagSelectedBorderColor = AppMainColor;
    _newsClassTagsView.tagBackgroundColor = [UIColor whiteColor];
    _newsClassTagsView.lineSpacing = 15;
    _newsClassTagsView.interitemSpacing = 15;
    _newsClassTagsView.tagFont = [UIFont systemFontOfSize:14];
    _newsClassTagsView.tagTextColor = BlackTitleColor;
    _newsClassTagsView.tagSelectedBackgroundColor = AppMainColor;
    _newsClassTagsView.tagSelectedTextColor = WhiteColor;
    _newsClassTagsView.allowEmptySelection = NO;
    _newsClassTagsView.delegate = self;
    _newsClassTagsView.tag = 8888;
    _newsClassTagsView.backgroundColor = [UIColor clearColor];
    return _newsClassTagsView;
}

- (DWTagsView *)newsTagsView
{
    if (_newsTagsView) {
        return _newsTagsView;
    }
    _newsTagsView = allocAndInitWithFrame(DWTagsView, frame(15, CGRectGetMaxY(_newsClassTagsView.frame) + 20, APPWIDTH -30, 70));
    _newsTagsView.backgroundColor = [UIColor clearColor];
    _newsTagsView.contentInsets = UIEdgeInsetsZero;
    _newsTagsView.tagInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _newsTagsView.tagBorderWidth = 0.5;
    _newsTagsView.tagcornerRadius = 5;
    _newsTagsView.mininumTagWidth = MininumTagWidth;
    _newsTagsView.maximumTagWidth = MaxinumTagWidth;
    _newsTagsView.tagHeight  = TagHeight;
    _newsTagsView.tagBorderColor = LineBg;
    _newsTagsView.tagSelectedBorderColor = AppMainColor;
    _newsTagsView.tagBackgroundColor = [UIColor whiteColor];
    _newsTagsView.lineSpacing = 15;
    _newsTagsView.interitemSpacing = 15;
    _newsTagsView.tagFont = [UIFont systemFontOfSize:14];
    _newsTagsView.tagTextColor = BlackTitleColor;
    _newsTagsView.tagSelectedBackgroundColor = WhiteColor;
    _newsTagsView.tagSelectedTextColor = AppMainColor;
    _newsTagsView.delegate = self;
    _newsTagsView.tagsArray = self.newsTags;
    _newsTagsView.tag = 88888;
    _newsTagsView.allowsMultipleSelection = YES;
    return _newsTagsView;
}

- (NSMutableArray *)newsTags
{
    if (_newsTags) {
        return _newsTags;
    }
    _newsTags = [[NSMutableArray alloc]init];
    return _newsTags;
}
- (NSMutableArray *)hasTags
{
    if (!_hasTags) {
        _hasTags = [[NSMutableArray alloc]init];
    }
    return _hasTags;
}
- (NSMutableArray *)classNewsTags
{
    if (!_classNewsTags) {
        _classNewsTags = [[NSMutableArray alloc]init];
    }
    return _classNewsTags;
}
- (NSMutableArray *)industry_label
{
    if (!_industry_label) {
        _industry_label = [[NSMutableArray alloc]init];
    }
    return _industry_label;
}
- (NSMutableArray *)saveIndustry_label
{
    if (!_saveIndustry_label) {
        _saveIndustry_label = [[NSMutableArray alloc]init];
    }
    return _saveIndustry_label;
}
#pragma mark
#pragma mark DWTagsViewDelegate
- (void)tagsView:(DWTagsView *)tagsView didSelectTagAtIndex:(NSUInteger)index
{
    if (tagsView.tag == 88888) {
        //添加全部
        if ([self.newsTags[index] isEqualToString:@"全部"]) {
            for (int i = 0 ;i<self.newsTags.count;i++) {
                id str =self.newsTags[i];
                if (![self.hasTags containsObject:str]&&![str isEqualToString:@"全部"]) {
                    [self.hasTags addObject:str];
                }
                 [_newsTagsView selectTagAtIndex:i animate:YES];
            }
            
            return;
            
        }
        if ([self.hasTags containsObject:_newsTags[index]]) {
            [[ToolManager shareInstance] showAlertMessage:@"标签已存在！"];
            return;
        }
        
        [_hasTags addObject:_newsTags[index]];
        int hatags = 0;
        for (id str  in _hasTags) {
            if ([_newsTags containsObject:str]) {
                hatags++;
            }
        }
        if (hatags==self.newsTags.count-1) {
            [self.newsTagsView selectTagAtIndex:hatags animate:YES];
        }
        
    }
    
    else
    {
         seletedClassIndex = index;
        
        _saveIndustry_label = nil;
        [self.newsTags removeAllObjects];
        [self.newsTagsView removeAllTags];
        _saveIndustry_label = _industry_label[index][@"son"];
        for (NSDictionary *dic in _saveIndustry_label) {
            [self.newsTags addObject:dic[@"code"]];
            [self.newsTagsView addTag:dic[@"name"]];
        }
        //添加全选
        [self.newsTags addObject:@"全部"];
        [self.newsTagsView addTag:@"全部"];
        
        //已选
        int allSelected = 0;
        for (int i=0;i<self.newsTags.count;i++) {
            id object = self.newsTags[i];
            if ([object isKindOfClass:[NSString class]]) {
                if ([self.hasTags containsObject:object] ) {
                    allSelected++;
                    [_newsTagsView selectTagAtIndex:i animate:YES];
                }
                
            }
        }
        //全选选中
        if (allSelected ==self.newsTags.count-1) {
            [_newsTagsView selectTagAtIndex:allSelected animate:YES];
        }
        
    }
    
    [self resetFrame];
    [self hasClassSelected];
}
- (BOOL)tagsView:(DWTagsView *)tagsView shouldSelectTagAtIndex:(NSUInteger)index
{
    
    return YES;
    
}
- (void)tagsView:(DWTagsView *)tagsView didDeSelectTagAtIndex:(NSUInteger)index
{
    if (tagsView.tag==88888) {
        //取消全部
        if ([self.newsTags[index] isEqualToString:@"全部"]) {
            for (int i = 0 ;i<self.newsTags.count;i++) {
                id str =self.newsTags[i];
                if ([self.hasTags containsObject:str]) {
                    [self.hasTags removeObject:str];
                }
                [self.newsTagsView deSelectTagAtIndex:i animate:YES];
            }
            
            return;
            
        }
        if ([self.hasTags containsObject:self.newsTags[index]]) {
            [_hasTags removeObject:_newsTags[index]];
            [self.newsTagsView deSelectTagAtIndex:self.newsTags.count-1 animate:YES];
            return;
        }
    }
    [self hasClassSelected];
    
}
- (BOOL)tagsView:(DWTagsView *)tagsView shouldDeselectItemAtIndex:(NSUInteger)index
{
    if (tagsView.tag==88888) {
        return YES;
    }
    return NO;
}
#pragma mark
#pragma mark buttons Aticon
- (void)buttonAction:(UIButton *)sender
{
    PopView(self);
}
#pragma mark
#pragma mark 判断是否选的行业类别
- (void)hasClassSelected
{
    for (int i = 0; i<self.classNewsTags.count; i++) {
        DWTagCell *cell =(DWTagCell *) [self.newsClassTagsView.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        cell.tagLabel.textColor = BlackTitleColor;
        for (NSString *hasfix in self.hasTags) {
            if ([hasfix hasPrefix:self.classNewsTags[i]]) {
                cell.tagLabel.textColor = AppMainColor;
            }
        }
        if (i==seletedClassIndex) {
            cell.tagLabel.textColor = WhiteColor;
        }
        
    }

}

#pragma mark
#pragma mark  setframe
- (void)resetFrame
{

    _newsClassTagsView.frame = frame(15, 20 , APPWIDTH -30, [_newsClassTagsView.collectionView.collectionViewLayout collectionViewContentSize].height);
    
    _newsViews.frame = CGRectMake(0, 0, APPWIDTH, [_newsClassTagsView.collectionView.collectionViewLayout collectionViewContentSize].height + 40);
    
    _newsLb.frame =frame(0,CGRectGetMaxY(_newsViews.frame)+ 5, APPWIDTH, 40);
    
    _newsTagsView.frame = frame(15, CGRectGetMaxY(_newsLb.frame)+ 5 , APPWIDTH -30, [_newsTagsView.collectionView.collectionViewLayout collectionViewContentSize].height);
    
    scrView.contentSize=CGSizeMake(0, CGRectGetMaxY(self.newsTagsView.frame) + 10);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
