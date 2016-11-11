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
#import "XLDataService.h"
#import "NSString+Extend.h"
#define FocusIndustryURL [NSString stringWithFormat:@"%@user/focus-industry",HttpURL]
#define ViewStartX StatusBarHeight + NavigationBarHeight
@interface GzHyViewController ()<DWTagsViewDelegate>
@property(nonatomic,strong)DWTagsView *hasTagsView;//已关注标签
@property(nonatomic,copy)NSMutableArray *hasTags;//已关注标签
@property(nonatomic,strong)BaseButton *addHasLb;//添加关注标签
@property(nonatomic,strong)UIScrollView *bottomScrollView;//底层
@property(nonatomic,strong)UILabel *message1Lab;//提醒字样
@property(nonatomic,strong)UILabel *message2Lab;//提醒字样
@property(nonatomic,strong)id data;//数据
@end

@implementation GzHyViewController
{
    ;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.backgroundColor = WhiteColor;
    [self navViewTitleAndBackBtn:@"关注行业"];
     [self.view addSubview:self.addHasLb];
    [self.view addSubview:self.bottomScrollView];
    [self.bottomScrollView addSubview:self.hasTagsView];
   
    [self.bottomScrollView addSubview:self.message1Lab];
    [self.bottomScrollView addSubview:self.message2Lab];
    [self netWork];
    self.bottomScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(self.message2Lab.frame));
}

#pragma mark
#pragma mark netWork
- (void)netWork
{
    NSMutableDictionary *parame = [Parameter parameterWithSessicon];
    [[ToolManager shareInstance] showWithStatus];
    [XLDataService postWithUrl:FocusIndustryURL param:parame modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (dataObj) {
            if ([dataObj[@"rtcode"] intValue] ==1) {
                [[ToolManager shareInstance] dismiss];
                [self.hasTags removeAllObjects];
                [self.hasTagsView removeAllTags];
                
                
               NSMutableArray * industrys = [NSMutableArray arrayWithArray:dataObj[@"industrys"]];
                NSArray *focus_industrys;
                if (dataObj[@"focus_industrys"]&&[dataObj[@"focus_industrys"] isKindOfClass:[NSString class]]&&![dataObj[@"focus_industrys"] isEqualToString:@""]) {
                    focus_industrys = [dataObj[@"focus_industrys"] componentsSeparatedByString:@"/"];
                }
                for (id Value in industrys) {
                    if ([Value isKindOfClass:[NSDictionary class]]) {
                        
                        if ([focus_industrys containsObject:Value[@"full_number"]] ) {
                            [self.hasTags addObject:Value[@"name"]];
                            [self.hasTagsView addTag:Value[@"name"]];
                        }
                    }
                }
                [self resetFrame];
                _data = dataObj;
                self.addHasLb.hidden = NO;
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

#pragma mark getter
-(UIScrollView *)bottomScrollView
{
    if (_bottomScrollView) {
        return _bottomScrollView;
    }
    _bottomScrollView=[UIScrollView new];
    _bottomScrollView.frame=CGRectMake(0,NavigationBarHeight+StatusBarHeight, APPWIDTH, APPHEIGHT-(NavigationBarHeight+StatusBarHeight));
    return _bottomScrollView;

}
-(UILabel *)message1Lab{
    if (_message1Lab) {
        return _message1Lab;
    }
    _message1Lab=[UILabel new];
    _message1Lab.font=[UIFont systemFontOfSize:14];
    _message1Lab.frame=CGRectMake(10, CGRectGetMaxY(_hasTagsView.frame) + 20, APPWIDTH -20, 17);
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
- (BaseButton *)addHasLb
{
    if (_addHasLb) {
        return _addHasLb;
    }
    _addHasLb = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 50 ,StatusBarHeight,50, NavigationBarHeight) setTitle:@"添加" titleSize:28*SpacedFonts titleColor:BlackTitleColor textAlignment:NSTextAlignmentRight backgroundColor:[UIColor clearColor] inView:nil];
    _addHasLb.shouldAnmial = NO;
    _addHasLb.hidden = YES;
    __weak typeof(self) weakSelf = self;
    _addHasLb.didClickBtnBlock = ^
    {

        AddIndustryViewController *addIndustryVC = allocAndInit(AddIndustryViewController);
        addIndustryVC.data = weakSelf.data;
        addIndustryVC.addTagsfinishBlock = ^(NSMutableArray *tags,NSMutableArray*tagsName)
        {
           [weakSelf netWork];
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
    _hasTagsView = allocAndInitWithFrame(DWTagsView, frame(10,10 , APPWIDTH-20, APPHEIGHT - (10 + ViewStartX)));
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
    _hasTags = [[NSMutableArray alloc]init];
    return _hasTags;
}
- (void)resetFrame
{
    _hasTagsView.frame = CGRectMake(_hasTagsView.x, _hasTagsView.y, _hasTagsView.width, [_hasTagsView.collectionView.collectionViewLayout collectionViewContentSize].height);
    _message1Lab.frame = CGRectMake(10, CGRectGetMaxY(_hasTagsView.frame) + 20, APPWIDTH-20, 17);
    _message2Lab.frame=CGRectMake(10, CGRectGetMaxY(_message1Lab.frame) , APPWIDTH-20, [_message2Lab.text sizeWithFont:[UIFont systemFontOfSize:13] maxSize:CGSizeMake(APPWIDTH-20,1000)].height+10);
    
    _bottomScrollView.contentSize = CGSizeMake(_bottomScrollView.width, CGRectGetMaxY(_message2Lab.frame) + 20);
    
    
}
#pragma mark
#pragma mark buttons Aticon
- (void)buttonAction:(UIButton *)sender
{
    PopView(self);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end