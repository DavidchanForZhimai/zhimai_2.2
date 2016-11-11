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
#define FocusIndustryURL [NSString stringWithFormat:@"%@user/focus-industry",HttpURL]
#define ViewStartX StatusBarHeight + NavigationBarHeight
@interface GzHyViewController ()<DWTagsViewDelegate>
@property(nonatomic,strong)DWTagsView *hasTagsView;//已关注标签
@property(nonatomic,copy)NSMutableArray *hasTags;//已关注标签
@property(nonatomic,strong)BaseButton *addHasLb;//添加关注标签

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
    [self.view addSubview:self.hasTagsView];
    [self.view addSubview:self.addHasLb];
    [self netWork];
    
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
    _hasTags = [[NSMutableArray alloc]init];
    return _hasTags;
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