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

#define MininumTagWidth (APPWIDTH - 120)/5.0
#define MaxinumTagWidth (APPWIDTH - 20)

#define TagHeight 30
#define ViewStartX StatusBarHeight + NavigationBarHeight
@interface AddIndustryViewController ()<DWTagsViewDelegate>
{
    UIScrollView *scrView;
}
@property(nonatomic,strong)DWTagsView *hasTagsView;//已关注标签
@property(nonatomic,strong)NSMutableArray *hasTags;//已关注标签
@property(nonatomic,strong)DWTagsView *newsClassTagsView;//新热门标签 类型
@property(nonatomic,strong)DWTagsView *newsTagsView;//新热门标签
@property(nonatomic,copy)NSMutableArray *newsTags;//新标签
@property(nonatomic,copy)NSMutableArray *classNewsTags;//新标签 类型
@property(nonatomic,strong)UILabel *newsLb;//新标签
@property(nonatomic,strong)BaseButton *finishBtn;//完成

@property(nonatomic,strong)UIScrollView *bottomScrollView;//底层
@property(nonatomic,strong)UILabel *message1Lab;//提醒字样
@property(nonatomic,strong)UILabel *message2Lab;//提醒字样

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
    self.view.backgroundColor = WhiteColor;
    [self navViewTitleAndBackBtn:@"选择关注行业"];
    [self.view addSubview:self.finishBtn];
    if (_isShouldLoadData) {
         [self netWorkIsSave:NO];
    }
   
   
}
#pragma mark
#pragma mark netWork
- (void)netWorkIsSave:(BOOL )isSave
{
    NSMutableDictionary *parame = [Parameter parameterWithSessicon];
    NSString *url =@"";
    NSMutableArray *industry;
    NSMutableArray *industryname;
    if (isSave) {
        url = SaveFocusIndustryURL;
        industry = [NSMutableArray new];
        industryname = [NSMutableArray new];
        for (id dic in industrys) {
            if ([dic isKindOfClass:[NSDictionary class]]) {
                for (NSString *str in _hasTags) {
                    if ([dic[@"name"] isEqualToString:str]) {
                        [industry addObject:dic[@"full_number"]];
                        [industryname addObject:dic[@"name"]];
                    }
                }
                
            }
        }
    
        [parame setValue:[industry componentsJoinedByString:@"/"] forKey:@"focus_industrys"];
        [[ToolManager shareInstance] showWithStatus:@"保存行业..."];
    }
    else
    {
        url = FocusIndustryURL;
        [[ToolManager shareInstance] showWithStatus];
        
    }
    
    [XLDataService postWithUrl:url param:parame modelClass:nil responseBlock:^(id dataObj, NSError *error) {

        if (dataObj) {
            if ([dataObj[@"rtcode"] intValue] ==1) {
                [[ToolManager shareInstance] dismiss];
                
                if (isSave) {
                    if (self.addTagsfinishBlock) {
                        self.addTagsfinishBlock(industry,industryname);
                    }
                    PopView(self);
                }
                else{
                    self.data = dataObj;
                   
                }
                
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
            focus_industrys = [data[@"focus_industrys"] componentsSeparatedByString:@"/"];
        }
        for (id Value in industrys) {
            if ([Value isKindOfClass:[NSDictionary class]]) {
                
                if ([focus_industrys containsObject:Value[@"full_number"]] ) {
                    [self.hasTags addObject:Value[@"name"]];
                }
            }
        }
        
        for (id value in industryDic) {
            if ([value isKindOfClass:[NSDictionary class]]) {
                
                [self.industry_label  addObject:value];
                [self.classNewsTags addObject:value[@"name"]];
            }
        }
        
        self.hasTagsView.tagsArray = self.hasTags;
        self.newsClassTagsView.tagsArray = self.classNewsTags;
    
        scrView=[[UIScrollView alloc]init];
        scrView.frame=CGRectMake(0,NavigationBarHeight+StatusBarHeight, APPWIDTH, APPHEIGHT-(NavigationBarHeight+StatusBarHeight));
        scrView.contentSize=CGSizeMake(0, CGRectGetMaxY(self.newsTagsView.frame));
    
        [scrView addSubview:self.hasTagsView];
        [scrView addSubview:self.newsLb];
        [scrView addSubview:self.newsClassTagsView];
        [scrView addSubview:self.newsTagsView];
        [scrView addSubview:self.message1Lab];
        [scrView addSubview:self.message2Lab];
        [self.view addSubview:scrView];
        [self resetFrame];
        
    
}

-(UILabel *)message1Lab{
    if (_message1Lab) {
        return _message1Lab;
    }
    _message1Lab=[UILabel new];
    _message1Lab.font=[UIFont systemFontOfSize:14];
    _message1Lab.frame=CGRectMake(10, CGRectGetMaxY(_newsTagsView.frame) + 20, APPWIDTH -20, 17);
    _message1Lab.numberOfLines = 0;
    _message1Lab.text=@"关注行业说明";
    return _message1Lab;
}
-(UILabel *)message2Lab{
    if (_message2Lab) {
        return _message2Lab;
    }
    _message2Lab=[UILabel new];
    _message2Lab.font=[UIFont systemFontOfSize:13];
    _message2Lab.textColor=[UIColor grayColor];
    _message2Lab.frame=CGRectMake(0, CGRectGetMaxY(_message1Lab.frame), APPWIDTH, 17);
    
    _message2Lab.text=@"1.首页“可添加人脉”和“动态”的数据与个人所关注的行业有关,关注的行业越多,其显示的数据越多\n2.用户没有关注任何行业时,“可添加人脉”和“动态”里默认显示全部的行业数据";
    _message2Lab.numberOfLines = 0;
    
    
    return _message2Lab;
    
    
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
      [weakSelf netWorkIsSave:YES];
      PopView(weakSelf);
    };
    return _finishBtn;
}

- (DWTagsView *)hasTagsView
{
    if (_hasTagsView) {
        return _hasTagsView;
    }
    _hasTagsView = allocAndInitWithFrame(DWTagsView, frame(10, 10 , APPWIDTH -20, 70));
    _hasTagsView.contentInsets = UIEdgeInsetsZero;
    _hasTagsView.tagInsets = UIEdgeInsetsMake(5, 15, 5, 15);
    _hasTagsView.tagBorderWidth = 0.5;
    _hasTagsView.tagcornerRadius = 5;
    _hasTagsView.mininumTagWidth = MininumTagWidth;
    _hasTagsView.maximumTagWidth = MaxinumTagWidth;
    _hasTagsView.tagHeight  = TagHeight;
    _hasTagsView.tagBorderColor = LineBg;
    _hasTagsView.tagSelectedBorderColor = LineBg;
    _hasTagsView.tagBackgroundColor = [UIColor whiteColor];
    _hasTagsView.lineSpacing = 5;
    _hasTagsView.interitemSpacing = 5;
    _hasTagsView.tagFont = [UIFont systemFontOfSize:14];
    _hasTagsView.tagTextColor = BlackTitleColor;
    _hasTagsView.tagSelectedBackgroundColor = _newsTagsView.tagBackgroundColor;
    _hasTagsView.tagSelectedTextColor = _hasTagsView.tagTextColor;
    _hasTagsView.tag = 888;
    _hasTagsView.delegate = self;
   
    
    return _hasTagsView;
    
}
- (UILabel *)newsLb
{
    if (_newsLb) {
        return _newsLb;
    }
    _newsLb = [UILabel createLabelWithFrame:frame(0, _hasTagsView.height + _hasTagsView.y +10, APPWIDTH, 40) text:@"---------点击添加新的关注行业--------" fontSize:28*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:nil];
    return _newsLb;
}

- (DWTagsView *)newsClassTagsView
{
    if (_newsClassTagsView) {
        return _newsClassTagsView;
    }
    _newsClassTagsView = allocAndInitWithFrame(DWTagsView, frame(10, CGRectGetMaxY(_newsLb.frame) , APPWIDTH -20, 70));
    _newsClassTagsView.contentInsets = UIEdgeInsetsZero;
    _newsClassTagsView.tagInsets = UIEdgeInsetsMake(5, 15, 5, 15);
    _newsClassTagsView.tagBorderWidth = 0.5;
    _newsClassTagsView.tagcornerRadius = 5;
    _newsClassTagsView.mininumTagWidth = MininumTagWidth;
    _newsClassTagsView.maximumTagWidth = MaxinumTagWidth;
    _newsClassTagsView.tagHeight  = TagHeight;
    _newsClassTagsView.tagBorderColor = LineBg;
    _newsClassTagsView.tagSelectedBorderColor = LineBg;
    _newsClassTagsView.tagBackgroundColor = [UIColor whiteColor];
    _newsClassTagsView.lineSpacing = 5;
    _newsClassTagsView.interitemSpacing = 5;
    _newsClassTagsView.tagFont = [UIFont systemFontOfSize:14];
    _newsClassTagsView.tagTextColor = BlackTitleColor;
    _newsClassTagsView.tagSelectedBackgroundColor = _newsClassTagsView.tagBackgroundColor;
    _newsClassTagsView.tagSelectedTextColor = _newsClassTagsView.tagTextColor;
    _newsClassTagsView.delegate = self;
    _newsClassTagsView.tag = 8888;
    return _newsClassTagsView;
}

- (DWTagsView *)newsTagsView
{
    if (_newsTagsView) {
        return _newsTagsView;
    }
    _newsTagsView = allocAndInitWithFrame(DWTagsView, frame(10, CGRectGetMaxY(_newsClassTagsView.frame) + 20, APPWIDTH -20, 70));
    _newsTagsView.contentInsets = UIEdgeInsetsZero;
    _newsTagsView.tagInsets = UIEdgeInsetsMake(5, 15, 5, 15);
    _newsTagsView.tagBorderWidth = 0.5;
    _newsTagsView.tagcornerRadius = 5;
    _newsTagsView.mininumTagWidth = MininumTagWidth;
    _newsTagsView.maximumTagWidth = MaxinumTagWidth;
    _newsTagsView.tagHeight  = TagHeight;
    _newsTagsView.tagBorderColor = LineBg;
    _newsTagsView.tagSelectedBorderColor = LineBg;
    _newsTagsView.tagBackgroundColor = [UIColor whiteColor];
    _newsTagsView.lineSpacing = 5;
    _newsTagsView.interitemSpacing = 5;
    _newsTagsView.tagFont = [UIFont systemFontOfSize:14];
    _newsTagsView.tagTextColor = LightBlackTitleColor;
    _newsTagsView.tagSelectedBackgroundColor = _newsTagsView.tagBackgroundColor;
    _newsTagsView.tagSelectedTextColor = _newsTagsView.tagTextColor;
    _newsTagsView.delegate = self;
    _newsTagsView.tagsArray = self.newsTags;
     _newsTagsView.tag = 88888;
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
       
        if ([_hasTags containsObject:_newsTags[index]]) {
            [[ToolManager shareInstance] showAlertMessage:@"标签已存在！"];
            return;
        }
        [_hasTagsView addTag:_newsTags[index]];
        [_hasTags addObject:_newsTags[index]];
    }
    else if (tagsView.tag == 888)
    {
        
        [_hasTagsView removeTagAtIndex:index];
        [_hasTags removeObjectAtIndex:index];
    }
    else
    {
   
        _saveIndustry_label = nil;
        [self.newsTags removeAllObjects];
        [_newsTagsView removeAllTags];
        _saveIndustry_label = _industry_label[index][@"son"];
        for (NSDictionary *dic in _saveIndustry_label) {
            [self.newsTags addObject:dic[@"name"]];
            [_newsTagsView addTag:dic[@"name"]];
        }

    }
   
    
    [self resetFrame];
    
}
- (BOOL)tagsView:(DWTagsView *)tagsView shouldSelectTagAtIndex:(NSUInteger)index
{

    return YES;
    
}
#pragma mark
#pragma mark buttons Aticon
- (void)buttonAction:(UIButton *)sender
{
    PopView(self);
}
#pragma mark
#pragma mark  setframe
- (void)resetFrame
{
    _hasTagsView.frame =frame(10, 10 , APPWIDTH -20, [_hasTagsView.collectionView.collectionViewLayout collectionViewContentSize].height);
    _newsLb.frame =frame(0, _hasTagsView.height + _hasTagsView.y +10, APPWIDTH, 40);
    
     _newsClassTagsView.frame = frame(10, CGRectGetMaxY(_newsLb.frame) , APPWIDTH -20, [_newsClassTagsView.collectionView.collectionViewLayout collectionViewContentSize].height);
    
    _newsTagsView.frame = frame(10, CGRectGetMaxY(_newsClassTagsView.frame) +20 , APPWIDTH -20, [_newsTagsView.collectionView.collectionViewLayout collectionViewContentSize].height);
    
    _message1Lab.frame = CGRectMake(10, CGRectGetMaxY(_newsTagsView.frame) + 20, APPWIDTH-20, 17);
    _message2Lab.frame=CGRectMake(10, CGRectGetMaxY(_message1Lab.frame) , APPWIDTH-20, [_message2Lab.text sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(APPWIDTH-20,1000)].height+10);

    scrView.contentSize=CGSizeMake(0, CGRectGetMaxY(self.message2Lab.frame) + 10);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
