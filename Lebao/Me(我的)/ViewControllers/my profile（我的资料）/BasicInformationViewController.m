//
//  BasicInformationViewController.m
//  Lebao
//
//  Created by David on 16/1/28.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BasicInformationViewController.h"
#import "EditNameViewController.h"
#import "XLDataService.h"
#import "DWOptionView.h"
#import "GWLCustomPikerView.h"
#import "ProvinceModel.h"
#import "UpLoadImageManager.h"//上传头像和背景
#import "NSString+File.h"
#import "CoreArchive.h"
#import "DWTagsView.h"
#define TagHeight 22
#define MininumTagWidth (APPWIDTH - 120)/5.0
#define MaxinumTagWidth (APPWIDTH - 20)


//获取位置详情 URL:appinterface/areainfo
#define AreainfoURL [NSString stringWithFormat:@"%@common/area-ios",HttpURL]
//我的URL ：appinterface/personal
#define MemberURL [NSString stringWithFormat:@"%@user/member",HttpURL]
#define SaveMemberURL [NSString stringWithFormat:@"%@user/save-member",HttpURL]
@interface BasicInformationViewController ()<UITableViewDataSource,UITableViewDelegate,GWLCustomPikerViewDataSource, GWLCustomPikerViewDelegate,DWTagsViewDelegate>
@property(nonatomic,strong)BaseButton *saveBtn;
@property(nonatomic,strong)BasicInfoModal *modal;
@property(nonatomic,strong)UITableView    *basicInfoTableView;
@property (nonatomic,strong ) GWLCustomPikerView *customPikerView;

@property (strong, nonatomic) NSArray            *citiesData;
@property (nonatomic,assign ) NSInteger          selectedProvince;
@property (nonatomic,assign ) NSInteger          selectedCity;
@property (strong, nonatomic) NSMutableArray            *personArray;
@property (strong, nonatomic) NSMutableArray            *personAndoptionalArray;
@property (strong, nonatomic) NSMutableArray            *recommendArray;
@property (strong, nonatomic) NSMutableArray            *optionalArray;


@property(nonatomic,strong)UIView * tagsView;//所有标签的父视图
@property(nonatomic,strong)DWTagsView *productTagsView;//产品标签
@property(nonatomic,strong)DWTagsView *resourseTagsView;//资源标签
@property(nonatomic,copy)NSMutableArray *productsTags;//产品标签array
@property(nonatomic,copy)NSMutableArray *resourseaTags;//资源标签array
@property(nonatomic,strong)DWTagsView *personsTagsView;//个人标签
@property(nonatomic,copy)NSMutableArray *personsTags;//个人标签array
@property(nonatomic,strong)UILabel *productTagsLb;//产品标签
@property(nonatomic,strong)UILabel *resourseTagsLb;//资源标签
@property(nonatomic,strong)UILabel *personsTagsLb;//个人标签
@property(nonatomic,strong)UIView *line1;//间隔

@property(nonatomic,strong)BaseButton *addTagsBgView;//背景
@property(nonatomic,strong)UIView * addTagsView;//所有add标签的父视图
@property(nonatomic,strong)DWTagsView *addHasTagsView;//添加标签
@property(nonatomic,strong)DWTagsView *addDefalutTagsView;//默认选择标签
@property(nonatomic,strong)UILabel *addTagsLb;//点击添加新的关注行业

@property(nonatomic,copy)NSMutableArray *addTags;//添加的标签
@property(nonatomic,copy)NSMutableArray *addDefalutTags;//默认的标签

@property(nonatomic,strong)UITextField *addTextField;//添加标签输入框
@property(nonatomic,strong)BaseButton *addSure;//确定按钮

@property(nonatomic,strong)DWTagsView *currentTagsView;//当前的标签
@property(nonatomic,copy)NSMutableArray *currentTagsArray;//当前的标签数组
@property(nonatomic,copy)NSMutableArray *currentDefalutTagsArray;//当前的选择标签数组
@end

@implementation BasicInfoModal


@end
@implementation BasicInformationViewController
{
    float footerHeight;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    footerHeight = 220;
    [self navView];
    [self mainView];
}

#pragma mark - Navi_View
- (void)navView
{
    [self navViewTitleAndBackBtn:@"个人资料"];
    _saveBtn = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 50, StatusBarHeight, 50, NavigationBarHeight) setTitle:@"保存" titleSize:28*SpacedFonts titleColor:BlackTitleColor textAlignment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] inView:self.view];
    _saveBtn.hidden = YES;
    __weak BasicInformationViewController *weakSelf = self;
    _saveBtn.didClickBtnBlock = ^
    {
        [weakSelf modity:weakSelf];
        
        
    };
}
#pragma mark
#pragma mark - DWTagsViewDelegate

- (BOOL)tagsView:(DWTagsView *)tagsView shouldSelectTagAtIndex:(NSUInteger)index
{
    return YES;
}
- (void)tagsView:(DWTagsView *)tagsView didSelectTagAtIndex:(NSUInteger)index
{
    switch (tagsView.tag) {
        case 88:
        {
            if (index==_productsTags.count-1) {
                NSLog(@"产品标签++");
                [self addTagsWithType:tagsView andDataSource:_productsTags andDefalutDataSource:self.addDefalutTags];
            }
            else
            {
             
                [_productsTags removeObjectAtIndex:index];
                [_productTagsView removeTagAtIndex:index];
              
            }
        }
            break;
        case 888:
        {
            if (index==_resourseaTags.count-1) {
                NSLog(@"资源特点++");
                [self addTagsWithType:tagsView andDataSource:_resourseaTags andDefalutDataSource:self.addDefalutTags];
            }
            else
            {
                [_resourseaTags removeObjectAtIndex:index];
                [_resourseTagsView removeTagAtIndex:index];
            }
            
        }
            break;
        case 8888:
        {
            if (index==_personsTags.count-1) {
                NSLog(@"个人标签++");
                 [self addTagsWithType:tagsView andDataSource:_personsTags andDefalutDataSource:self.addDefalutTags];
            }
            else
            {
                [_personsTags removeObjectAtIndex:index];
                [_personsTagsView removeTagAtIndex:index];
            }
            
        }
        case 88888:
        {
           
        }
            break;
        case 888888:
        {
            if ([_currentTagsArray containsObject:_currentDefalutTagsArray[index]]) {
                [[ToolManager shareInstance] showInfoWithStatus:@"标签已存在"];
                return;
            }
            [_currentTagsArray insertObject:_currentDefalutTagsArray[index] atIndex:_currentTagsArray.count-1];
            [_currentTagsView insertTag:_currentDefalutTagsArray[index] AtIndex:_currentTagsArray.count-2];
            [_addHasTagsView addTag:_currentDefalutTagsArray[index]];
            
        }
            break;
        default:
            break;
    }
}
- (BOOL)tagsView:(DWTagsView *)tagsView shouldDeselectItemAtIndex:(NSUInteger)index
{
    if (tagsView.tag ==888888) {
        
        return YES;
    }
    else
    {
        return NO;
    }
    

}
- (void)tagsView:(DWTagsView *)tagsView didDeSelectTagAtIndex:(NSUInteger)index
{
   
    if (tagsView.tag ==888888) {

        [_currentTagsView removeTagWithName:_currentDefalutTagsArray[index]];
        [_addHasTagsView removeTagWithName:_currentDefalutTagsArray[index]];
        [_currentTagsArray removeObject:_currentDefalutTagsArray[index]];
     
        
    }
    
}
#pragma mark
#pragma mark add Tags View
- (void)addTagsWithType:(DWTagsView *)type andDataSource:(NSMutableArray *)dataSource andDefalutDataSource:(NSMutableArray *)defalutDataSource;
{
   
    [self.view addSubview:self.addTagsBgView];
    [self.view addSubview:self.addTagsView];
    __weak typeof(self) weakSelf = self;
    self.addTagsBgView.didClickBtnBlock = ^
    {
        [weakSelf.addTextField resignFirstResponder];
        [weakSelf.addTagsBgView removeFromSuperview];
         weakSelf.addTagsBgView = nil;
       
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.addTagsView.frame = frame(0, APPHEIGHT, APPWIDTH, weakSelf.addTagsView.height);
        } completion:^(BOOL finished) {
            
        [weakSelf.addHasTagsView removeFromSuperview];
        weakSelf.addHasTagsView = nil;
        [weakSelf.addTagsLb removeFromSuperview];
         weakSelf.addTagsLb = nil;
        [weakSelf.addTextField removeFromSuperview];
        weakSelf.addTextField = nil;
        [weakSelf.addSure removeFromSuperview];
        weakSelf.addSure = nil;
        [weakSelf.addDefalutTagsView removeFromSuperview];
        weakSelf.addDefalutTagsView = nil;
        [weakSelf.addTagsView removeFromSuperview];
        weakSelf.addTagsView = nil;
            
        }];
     
        
    };
    [self.addTagsView addSubview:self.addHasTagsView];
    [dataSource removeObject:@"+"];
    _addHasTagsView.tagsArray = dataSource;
     [dataSource addObject:@"+"];
    [self.addTagsView addSubview:self.addTagsLb];
    [self.addTagsView addSubview:self.addTextField];
    [self.addTagsView addSubview:self.addSure];
    self.addSure.didClickBtnBlock = ^{
       
        if ([weakSelf.addTextField.text isEqualToString:@""]) {
            [[ToolManager shareInstance] showInfoWithStatus:@"标签不能为空"];
            return;
        }
        if ([dataSource containsObject:weakSelf.addTextField.text]) {
            [[ToolManager shareInstance] showInfoWithStatus:@"标签已存在"];
            return;
        }

        [dataSource insertObject:weakSelf.addTextField.text atIndex:dataSource.count-1];
        
        [type insertTag:weakSelf.addTextField.text AtIndex:dataSource.count-2];
        [weakSelf.addHasTagsView addTag:weakSelf.addTextField.text];
         weakSelf.addTextField.text=@"";
        [weakSelf.addTextField resignFirstResponder];
    };
    [self.addTagsView addSubview:self.addDefalutTagsView];
    _addDefalutTagsView.tagsArray = defalutDataSource;

    [self addTagsViewReSetFrame];

    _currentTagsView = type;
    _currentTagsArray = dataSource;
    _currentDefalutTagsArray = defalutDataSource;
}
#pragma mark
#pragma mark getter addtagsView
- (BaseButton *)addTagsBgView
{
    if (_addTagsBgView) {
        return _addTagsBgView;
    }
    _addTagsBgView = [[BaseButton alloc]initWithFrame:self.view.frame backgroundImage:nil iconImage:nil highlightImage:nil inView:nil];
    _addTagsBgView.backgroundColor = rgba(0, 0, 0, 0.3);
   
    return _addTagsBgView;
}
- (UIView *)addTagsView
{
    if (_addTagsView) {
        return _addTagsView;
    }
    _addTagsView = [[UIView alloc]initWithFrame:frame(0, APPHEIGHT, APPWIDTH, 0)];
    _addTagsView.backgroundColor = WhiteColor;
    return _addTagsView;
    
}
- (DWTagsView *)addHasTagsView
{
    if (_addHasTagsView) {
        return _addHasTagsView;
    }
    _addHasTagsView = allocAndInitWithFrame(DWTagsView, CGRectZero);
    _addHasTagsView.contentInsets = UIEdgeInsetsZero;
    _addHasTagsView.tagInsets = UIEdgeInsetsMake(5, 15, 5, 15);
    _addHasTagsView.tagcornerRadius = 2;
    _addHasTagsView.mininumTagWidth = MininumTagWidth;
    _addHasTagsView.maximumTagWidth = MaxinumTagWidth;
    _addHasTagsView.tagHeight  = TagHeight;
    _addHasTagsView.tag = 88888;
    _addHasTagsView.tagBackgroundColor = AppMainColor;
    _addHasTagsView.lineSpacing = 10;
    _addHasTagsView.interitemSpacing = 20;
    _addHasTagsView.tagFont = [UIFont systemFontOfSize:14];
    _addHasTagsView.tagTextColor = WhiteColor;
    _addHasTagsView.tagSelectedBackgroundColor = _addHasTagsView.tagBackgroundColor;
    _addHasTagsView.tagSelectedTextColor = _addHasTagsView.tagTextColor;
    
    _addHasTagsView.delegate = self;

    
    return _addHasTagsView;
    
}
- (UILabel *)addTagsLb
{
    if (_addTagsLb) {
        return  _addTagsLb;
    }
    _addTagsLb =[UILabel createLabelWithFrame:CGRectZero text:@"-----点击添加自定义标签-----" fontSize:14 textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:nil];
    
    return  _addTagsLb;
    
}
- (UITextField *)addTextField
{
    if (_addTextField) {
        return _addTextField;
    }
    _addTextField = [[UITextField alloc]initWithFrame:CGRectZero];
    _addTextField.backgroundColor = WhiteColor;
    _addTextField.placeholder = @"请输入自定义标签";
    _addTextField.font = [UIFont systemFontOfSize:14.0];
    [_addTextField setBorder:LineBg width:0.5];
    [_addTextField setRadius:2.0];
    
    return _addTextField;
}
- (BaseButton *)addSure
{
    if (_addSure) {
        return _addSure;
    }
    _addSure = [[BaseButton alloc]initWithFrame:CGRectZero setTitle:@"确定" titleSize:14 titleColor:WhiteColor textAlignment:NSTextAlignmentCenter backgroundColor:AppMainColor inView:nil];
    [_addSure setRadius:2.0];
    
    return  _addSure;
}
- (DWTagsView *)addDefalutTagsView
{
    if (_addDefalutTagsView) {
        return _addDefalutTagsView;
    }
    _addDefalutTagsView = allocAndInitWithFrame(DWTagsView, CGRectZero);
    _addDefalutTagsView.contentInsets = UIEdgeInsetsZero;
    _addDefalutTagsView.tagInsets = UIEdgeInsetsMake(5, 15, 5, 15);
    _addDefalutTagsView.tagcornerRadius = 2;
    _addDefalutTagsView.mininumTagWidth =MininumTagWidth;
    _addDefalutTagsView.maximumTagWidth = MaxinumTagWidth;
    _addDefalutTagsView.tagHeight  = TagHeight;
    _addDefalutTagsView.tag = 888888;
    _addDefalutTagsView.tagBackgroundColor =[UIColor colorWithRed:0.902 green:0.9059 blue:0.9137 alpha:1.0] ;
    _addDefalutTagsView.lineSpacing = 10;
    _addDefalutTagsView.interitemSpacing = 20;
    _addDefalutTagsView.tagFont = [UIFont systemFontOfSize:14];
    _addDefalutTagsView.tagTextColor = WhiteColor;
    _addDefalutTagsView.tagSelectedBackgroundColor = AppMainColor;
    _addDefalutTagsView.tagSelectedTextColor = _addDefalutTagsView.tagTextColor;
    
    _addDefalutTagsView.delegate = self;
    _addDefalutTagsView.allowsMultipleSelection = YES;
    
    return _addDefalutTagsView;
}
- (NSMutableArray *)addDefalutTags
{
    if (_addDefalutTags) {
        return _addDefalutTags;
    }
    _addDefalutTags = [[NSMutableArray alloc]initWithObjects:@"商务4",@"开发",@"产品",@"经理",@"老板",@"业务", nil];
    return _addDefalutTags;
}
#pragma mark
#pragma mark resetFrame
- (void)addTagsViewReSetFrame
{
    
    _addHasTagsView.frame = CGRectMake(20, 10, APPWIDTH - 40, 2*(TagHeight+10));
    
    _addTagsLb.frame = CGRectMake(0, CGRectGetMaxY(_addHasTagsView.frame), APPWIDTH, 40);
    _addTextField.frame = CGRectMake(20, CGRectGetMaxY(_addTagsLb.frame), 220*ScreenMultiple, 30);
    _addSure.frame = CGRectMake(CGRectGetMaxX(_addTextField.frame) + 15,  CGRectGetMaxY(_addTagsLb.frame) + 2, 52*ScreenMultiple, _addTextField.height - 4);
    
    _addDefalutTagsView.frame = CGRectMake(20, CGRectGetMaxY(_addTextField.frame) + 20, APPWIDTH -40, 2*(TagHeight+10));
    
    [UIView animateWithDuration:0.3 animations:^{
         _addTagsView.frame =CGRectMake(0,APPHEIGHT -  CGRectGetMaxY(_addDefalutTagsView.frame) -20, APPWIDTH , CGRectGetMaxY(_addDefalutTagsView.frame) + 20);
    }];
   
    
}

#pragma mark
#pragma mark getter tagsView

- (UIView *)tagsView
{
    if (_tagsView) {
        return _tagsView;
    }
    
    _tagsView = [[UIView alloc]initWithFrame:CGRectZero];
    _tagsView.backgroundColor = WhiteColor;
    
    UIView * line = [[UIView alloc]initWithFrame:frame(0, 0, APPWIDTH, 10)];
    line.backgroundColor = self.view.backgroundColor;
    [_tagsView addSubview:line];
    
    //产品标签
    [self.tagsView addSubview:self.productTagsLb];

    [self.tagsView addSubview:self.productTagsView];
    
    // 资源特点
    [self.tagsView addSubview:self.resourseTagsLb];;
    [self.tagsView addSubview:self.resourseTagsView];
    
    // 个人特点
    [self.tagsView addSubview:self.line1];
    
    [self.tagsView addSubview:self.personsTagsLb];
    [self.tagsView addSubview:self.personsTagsView];
    //设置位置
    [self tagsViewReSetFrame];
    return _tagsView;
}
- (UILabel *)productTagsLb
{
    if (_productTagsLb) {
        return  _productTagsLb;
    }
    _productTagsLb =[UILabel createLabelWithFrame:CGRectMake(20, 10, APPWIDTH - 40, 35) text:@"产品标签" fontSize:14 textColor:AppMainColor textAlignment:NSTextAlignmentLeft inView:nil];
    
    return  _productTagsLb;
    
}
- (DWTagsView *)productTagsView
{
    if (_productTagsView) {
        return _productTagsView;
    }
    _productTagsView = allocAndInitWithFrame(DWTagsView, CGRectZero);
    _productTagsView.contentInsets = UIEdgeInsetsZero;
    _productTagsView.tagInsets = UIEdgeInsetsMake(5, 15, 5, 15);
    _productTagsView.tagcornerRadius = 2;
    _productTagsView.mininumTagWidth = MininumTagWidth;
    _productTagsView.maximumTagWidth = MaxinumTagWidth;
    _productTagsView.tagHeight  = TagHeight;
    _productTagsView.tag = 88;
    _productTagsView.tagBackgroundColor = AppMainColor;
    _productTagsView.lineSpacing = 10;
    _productTagsView.interitemSpacing = 20;
    _productTagsView.tagFont = [UIFont systemFontOfSize:14];
    _productTagsView.tagTextColor = WhiteColor;
    _productTagsView.tagSelectedBackgroundColor = _productTagsView.tagBackgroundColor;
    _productTagsView.tagSelectedTextColor = _productTagsView.tagTextColor;
    
    _productTagsView.delegate = self;
    _productTagsView.tagsArray = self.productsTags;
    
    return _productTagsView;

}
- (UILabel *)resourseTagsLb
{
    if (_resourseTagsLb) {
        return  _resourseTagsLb;
    }
    _resourseTagsLb =[UILabel createLabelWithFrame:CGRectZero text:@"资源特点" fontSize:14 textColor:[UIColor colorWithRed:0.9843 green:0.5137 blue:0.3412 alpha:1.0] textAlignment:NSTextAlignmentLeft inView:self.tagsView];
    
    return  _resourseTagsLb;
    
}

- (DWTagsView *)resourseTagsView
{
    if (_resourseTagsView) {
        return _resourseTagsView;
    }
    _resourseTagsView = allocAndInitWithFrame(DWTagsView, CGRectZero);
    _resourseTagsView.contentInsets = UIEdgeInsetsZero;
    _resourseTagsView.tagInsets = UIEdgeInsetsMake(5, 15, 5, 15);
    _resourseTagsView.tagcornerRadius = 2;
    _resourseTagsView.tag = 888;
    _resourseTagsView.mininumTagWidth = MininumTagWidth;
    _resourseTagsView.maximumTagWidth = MaxinumTagWidth;
    _resourseTagsView.tagHeight  = TagHeight;
    
    _resourseTagsView.tagBackgroundColor = [UIColor colorWithRed:0.9843 green:0.451 blue:0.2549 alpha:1.0];
    _resourseTagsView.lineSpacing = 10;
    _resourseTagsView.interitemSpacing = 20;
    _resourseTagsView.tagFont = [UIFont systemFontOfSize:14];
    _resourseTagsView.tagTextColor = WhiteColor;
    _resourseTagsView.tagSelectedBackgroundColor = _resourseTagsView.tagBackgroundColor;
    _resourseTagsView.tagSelectedTextColor = _resourseTagsView.tagTextColor;
    
    _resourseTagsView.delegate = self;
    _resourseTagsView.tagsArray = self.resourseaTags;
    
    return _resourseTagsView;
    
}
- (UIView *)line1
{
    if (_line1) {
        return _line1;
    }
    _line1 = [[UIView alloc]initWithFrame:CGRectZero];
    _line1.backgroundColor = self.view.backgroundColor;
    return _line1;
}
- (UILabel *)personsTagsLb
{
    if (_personsTagsLb) {
        return  _personsTagsLb;
    }
    _personsTagsLb =[UILabel createLabelWithFrame:CGRectZero text:@"个人特点" fontSize:14 textColor:AppMainColor textAlignment:NSTextAlignmentLeft inView:self.tagsView];
    
    return  _personsTagsLb;
    
}

- (DWTagsView *)personsTagsView
{
    if (_personsTagsView) {
        return _personsTagsView;
    }
    _personsTagsView = allocAndInitWithFrame(DWTagsView, CGRectZero);
    _personsTagsView.contentInsets = UIEdgeInsetsZero;
    _personsTagsView.tagInsets = UIEdgeInsetsMake(5, 15, 5, 15);
    _personsTagsView.tagcornerRadius = 2;
    _personsTagsView.tag = 8888;
    _personsTagsView.mininumTagWidth =MininumTagWidth;
    _personsTagsView.maximumTagWidth = MaxinumTagWidth;
    _personsTagsView.tagHeight  = TagHeight;
    
    _personsTagsView.tagBackgroundColor = AppMainColor;
    _personsTagsView.lineSpacing = 10;
    _personsTagsView.interitemSpacing = 20;
    _personsTagsView.tagFont = [UIFont systemFontOfSize:14];
    _personsTagsView.tagTextColor = WhiteColor;
    _personsTagsView.tagSelectedBackgroundColor = _personsTagsView.tagBackgroundColor;
    _personsTagsView.tagSelectedTextColor = _personsTagsView.tagTextColor;
    
    _personsTagsView.delegate = self;
    _personsTagsView.tagsArray = self.personsTags;
    
    return _personsTagsView;
    
}
- (NSMutableArray *)productsTags
{
    if (_productsTags) {
        return _productsTags;
    }
    _productsTags = [[NSMutableArray alloc]initWithObjects:@"商务1",@"开发",@"产品",@"经理",@"老板",@"业务",@"+", nil];
    return _productsTags;
}
- (NSMutableArray *)resourseaTags
{
    if (_resourseaTags) {
        return _resourseaTags;
    }
    _resourseaTags = [[NSMutableArray alloc]initWithObjects:@"商务2",@"开发",@"产品",@"经理",@"老板",@"业务",@"+", nil];
    return _resourseaTags;
}
- (NSMutableArray *)personsTags
{
    if (_personsTags) {
        return _personsTags;
    }
    _personsTags = [[NSMutableArray alloc]initWithObjects:@"商务3",@"开发",@"产品",@"经理",@"老板",@"业务",@"+", nil];
    return _personsTags;
}
#pragma mark
#pragma mark resetFrame
- (void)tagsViewReSetFrame
{
    
    _productTagsView.frame = CGRectMake(20, 45, APPWIDTH - 40, 2*(TagHeight+10));
    _resourseTagsLb.frame = CGRectMake(20, CGRectGetMaxY(_productTagsView.frame), APPWIDTH, 35);
    _resourseTagsView.frame = CGRectMake(20, CGRectGetMaxY(_resourseTagsLb.frame), APPWIDTH - 40,2*(TagHeight+10));
    _line1.frame = CGRectMake(0, CGRectGetMaxY(_resourseTagsView.frame), APPWIDTH, 10);
    _personsTagsLb.frame = CGRectMake(20, CGRectGetMaxY(_line1.frame), APPWIDTH, 35);
    _personsTagsView.frame =CGRectMake(20, CGRectGetMaxY(_personsTagsLb.frame), APPWIDTH - 40, 2*(TagHeight+10));
    _tagsView.frame = frame(0, 0, APPWIDTH, CGRectGetMaxY(_personsTagsView.frame) + 10);

    
}

#pragma mark
#pragma mark - buttonAction -
- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag ==NavViewButtonActionNavLeftBtnTag ) {
        PopView(self);
    }
    
}

#pragma mark
#pragma mark - mainView
- (void)mainView
{
    _personArray = allocAndInit(NSMutableArray);
    _personAndoptionalArray = allocAndInit(NSMutableArray);
    _optionalArray = allocAndInit(NSMutableArray);
    _recommendArray = allocAndInit(NSMutableArray);
    
    _basicInfoTableView =[[UITableView alloc]initWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - StatusBarHeight -NavigationBarHeight) style:UITableViewStyleGrouped];
    _basicInfoTableView.delegate = self;
    _basicInfoTableView.dataSource = self;
    _basicInfoTableView.backgroundColor =[UIColor clearColor];
    _basicInfoTableView.tableFooterView = self.tagsView;
    [self.view addSubview:_basicInfoTableView];
    
    [[ToolManager shareInstance] showWithStatus:@"获取信息..."];
    NSMutableDictionary *parame = [Parameter parameterWithSessicon];
    [parame setObject:@"info" forKey:Conduct];
    [XLDataService postWithUrl:MemberURL param:parame modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        
        if (dataObj) {
            _modal = [BasicInfoModal mj_objectWithKeyValues:dataObj];
            if (![_modal.mylabels isEqualToString:@""]) {
                [_personArray addObjectsFromArray:[_modal.mylabels componentsSeparatedByString:@","]];
                
            }
            if (![_modal.filllabels isEqualToString:@""]) {
                [_optionalArray addObjectsFromArray:[_modal.filllabels componentsSeparatedByString:@","]];
                
            }
            if (![_modal.relabls isEqualToString:@""]) {
                [_recommendArray addObjectsFromArray:[_modal.relabls componentsSeparatedByString:@","]];
                
            }
            
            [_personAndoptionalArray addObjectsFromArray:_personArray];
            [_personAndoptionalArray addObjectsFromArray:_optionalArray];
            if (![_personAndoptionalArray containsObject:@"+标签"]) {
                [_personAndoptionalArray addObject:@"+标签"];
            }
            if (_modal.rtcode ==1) {
                
                NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                
                NSString *createPath = [NSString stringWithFormat:@"%@/%@.plist",pathDocuments,[CoreArchive  strForKey:AddressNewVersion]];
                NSString *createDir = [NSString stringWithFormat:@"%@/%@_code.plist",pathDocuments,[CoreArchive  strForKey:AddressNewVersion]];
                // 判断文件夹是否存在，如果不存在，则创建
                
                if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
                    
                    NSDictionary *param = [Parameter parameterWithSessicon];
                    [XLDataService postWithUrl:AreainfoURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
                        
                        if (dataObj) {
                            [[ToolManager shareInstance] dismiss];
                            if ([dataObj[@"rtcode"] intValue] ==1) {
                                
                                NSDictionary *code_datas = [NSDictionary new];
                                code_datas = dataObj[@"code_datas"];
                                BOOL fl = [code_datas writeToFile:createDir atomically:YES]; //写入
                                NSMutableArray * datas =[NSMutableArray new];
                                datas = dataObj[@"datas"];
                                BOOL fll = [datas writeToFile:createPath atomically:YES];
                                if (!fl&&!fll) {
                                    [[ToolManager shareInstance] showInfoWithStatus:@"地址数据获取失败"];
                                }
                                else
                                {
                                    [_basicInfoTableView reloadData];
                                }
                                
                            }
                            else
                            {
                                [[ToolManager shareInstance] showInfoWithStatus:dataObj[@"rtmsg"]];
                            }
                        }
                        else
                        {
                            [[ToolManager shareInstance] showInfoWithStatus:@"地址数据获取失败"];
                        }
                        
                    }];
                    
                    
                } else {
                    [[ToolManager shareInstance] dismiss];
                    [_basicInfoTableView reloadData];
                }
                
                
            }
            else
            {
                
                [[ToolManager shareInstance] showInfoWithStatus:_modal.rtmsg];;
            }
            
        }
        else{
            
            [[ToolManager shareInstance] showInfoWithStatus];
            
        }
        
        
        
    }];
    
}

#pragma mark
#pragma mark - TableViewDelegate TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 5;
    }
    return 4;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10.0f;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return allocAndInit(UIView);
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
 
    return 0.1;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{

    return allocAndInit(UIView);
   
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0&&indexPath.section==0) {
        return 50.0f;
    }
    else
    {
        return 40.0f;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID =@"BasicInformationView";
    BasicInformationView *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    float cellH;
    if (indexPath.row ==0&&indexPath.section==0) {
        cellH = 50.0f;
    }
    else
    {
        cellH = 40.0f;
    }
    if (!cell) {
        
        cell = [[BasicInformationView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellHeight:cellH cellWidth:frameWidth(_basicInfoTableView)];
    }
    if (indexPath.section ==0) {
        switch (indexPath.row) {
            case 0:
                if (!_modal.imgurl) {
                    _modal.imgurl =@"";
                }
                
                [cell  showTitle:@"头像" icon:_modal.imgurl bg:nil detail:nil canEdit:YES];
                break;
            case 1:
                [cell  showTitle:@"姓名" icon:nil bg:nil detail:_modal.realname canEdit:YES];
                break;
            case 2:
                if ([_modal.sex isEqualToString:@"1"]) {
                    [cell  showTitle:@"性别" icon:nil bg:nil detail:@"男" canEdit:YES];
                }
                else
                {
                    [cell  showTitle:@"性别" icon:nil bg:nil detail:@"女" canEdit:YES];
                }
                
                break;
            case 3:
                [cell  showTitle:@"手机" icon:nil bg:nil detail:_modal.tel  canEdit:NO];
                break;
            case 4:
                
            {
                NSString *address = _modal.area;
                if (!address||[address isEqualToString:@""]) {
                    address =@"";
                }
                else
                {
                    NSString *pro;
                    NSString *city;
                    NSArray *addressArray = [address componentsSeparatedByString:@"-"];
                    if (addressArray.count>1) {
                        
                        NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                        NSString *createPath = [NSString stringWithFormat:@"%@/%@_code.plist",pathDocuments,[CoreArchive  strForKey:AddressNewVersion]];
                        
                        NSDictionary *citiesArray                 = [NSDictionary dictionaryWithContentsOfFile:createPath];
                        city = citiesArray[@"city"][[NSString stringWithFormat:@"%@",addressArray[1]]];
                        pro = citiesArray[@"province"][[NSString stringWithFormat:@"%@",addressArray[0]]];
                        address = [NSString stringWithFormat:@"%@-%@",pro,city];
                    }
                    
                }
                [cell  showTitle:@"地区" icon:nil bg:nil detail:address canEdit:YES];
            }
                break;
            default:
                break;
    }
    }
    else{
        
    switch (indexPath.row) {
    
    case 0:
        
        [cell  showTitle:@"公司" icon:nil bg:nil detail:_modal.synopsis canEdit:YES];
        break;
    case 1:
        
        [cell  showTitle:@"职业" icon:nil bg:nil detail:_modal.address canEdit:YES];
        break;
            
    case 2:
            
        [cell  showTitle:@"行业" icon:nil bg:nil detail:_modal.address canEdit:YES];
            break;
    case 3:
        
        [cell  showTitle:@"从业年限" icon:nil bg:nil detail:_modal.workyears canEdit:YES];
        break;

        
    }

    
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *parame = [Parameter parameterWithSessicon];
    [parame setObject:@"edit" forKey:Conduct];
    __weak BasicInformationViewController *weakSelf= self;
    if (indexPath.row ==0) {
        [[ToolManager shareInstance] seleteImageFormSystem:self seleteImageFormSystemBlcok:^(UIImage *image) {
            NSString *type;
            type =@"head";
            [[UpLoadImageManager shareInstance] upLoadImageType:type image:image imageBlock:^(UpLoadImageModal * upLoadImageModal) {
                weakSelf.saveBtn.hidden = NO;
                _modal.imgurl = upLoadImageModal.abbr_imgurl;
                [_basicInfoTableView reloadData];
                
            }];
        }];
        
        
    }
    else
    {
        EditNameViewController *edit = allocAndInit(EditNameViewController);
        
        switch (indexPath.row) {
            case 1:
            {
                weakSelf.saveBtn.hidden = NO;
                
                edit.editPageTag =EditNamePageTag;
                edit.textView =  _modal.realname;
                edit.editBlock = ^(NSString *text)
                {
                    
                    _modal.realname = text;
                    [_basicInfoTableView reloadData];
                    
                };
                PushView(self, edit);
            }
                break;
            case 2:
            {
                DWOptionView  *view =[[DWOptionView alloc]initWithFrame:self.view.window.bounds block:^(BOOL isBoy) {
                    weakSelf.saveBtn.hidden = NO;
                    int tag;
                    if (isBoy) {
                        tag = 1;
                    }
                    else
                    {
                        tag =2;
                    }
                    
                    _modal.sex = [NSString stringWithFormat:@"%i",tag];
                    [_basicInfoTableView reloadData];
                    view.tag = 88;
                }];
                
            }
                break;
                
            case 4:
            {
                [self configureCustomPikerView];
            }
                break;
                
            case 5:
            {
                weakSelf.saveBtn.hidden = NO;
                
                edit.editPageTag =EditIntroducePageTag;
                edit.textView =  _modal.synopsis;
                edit.editBlock = ^(NSString *text)
                {
                    
                    _modal.synopsis = text;
                    [_basicInfoTableView reloadData];
                    
                };
                PushView(self, edit);
            }
                break;
            case 6:
            {
                weakSelf.saveBtn.hidden = NO;
                
                edit.editPageTag =EditCompanyTag;
                edit.textView =  _modal.address;
                edit.editBlock = ^(NSString *text)
                {
                    
                    _modal.address = text;
                    [_basicInfoTableView reloadData];
                    
                };
                PushView(self, edit);
            }
                break;
                
            case 7:
            {
                weakSelf.saveBtn.hidden = NO;
                
                edit.editPageTag =EditWorkYearsPageTag;
                edit.textView =  _modal.workyears;
                edit.editBlock = ^(NSString *text)
                {
                    
                    _modal.workyears = text;
                    [_basicInfoTableView reloadData];
                    
                };
                PushView(self, edit);
            }
                break;
                
            default:
                break;
        }
        
        
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)modity:(BasicInformationViewController *)weakSelf;
{
    
    [[ToolManager shareInstance] showWithStatus:@"修改中.."];
    NSMutableDictionary *parame =[Parameter parameterWithSessicon];
    [parame setObject:_modal.imgurl forKey:@"imgurl"];
    [parame setObject:_modal.sex forKey:@"sex"];
    [parame setObject:_modal.area forKey:@"area"];
    [parame setObject:_modal.realname forKey:@"realname"];
    [parame setObject:_modal.synopsis forKey:@"synopsis"];
    [parame setObject:_modal.tel forKey:@"tel"];
    [parame setObject:_modal.address forKey:@"address"];
    [parame setObject:_modal.workyears forKey:@"workyears"];
    
    if ([_personArray mj_JSONString]) {
        [parame setObject:[_personArray mj_JSONString] forKey:@"mylabels"];
    }
    if ([_optionalArray mj_JSONString]) {
        [parame setObject:[_optionalArray mj_JSONString] forKey:@"filllabels"];
    }
    
    //    NSLog(@"parame =%@",parame);
    [XLDataService postWithUrl:SaveMemberURL param:parame modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (dataObj) {
            if ([dataObj[@"rtcode"] intValue] ==1) {
                weakSelf.saveBtn.hidden = YES;
                [[ToolManager shareInstance] showSuccessWithStatus:@"修改成功"];
                PopView(weakSelf);
            }
            else
            {
                weakSelf.saveBtn.hidden = NO;
                [[ToolManager shareInstance] showInfoWithStatus:dataObj[@"rtmsg"]];
            }
            
        }
        else
        {
            weakSelf.saveBtn.hidden = NO;
            [[ToolManager shareInstance] showInfoWithStatus];
        }
        
        
        
    }];
}

- (void)configureCustomPikerView {
    
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *createPath = [NSString stringWithFormat:@"%@/%@.plist",pathDocuments, [CoreArchive  strForKey:AddressNewVersion]];
    
    if (!_citiesData) {
        
        NSArray *citiesArray                 = [NSArray arrayWithContentsOfFile:createPath];
        
        if (!citiesArray) {
            
            [[ToolManager shareInstance] showInfoWithStatus:@"获取不到数据，请稍等再试！！"];
            
            return;
        }
        
        NSMutableArray *provinceModelArrayM  = [NSMutableArray array];
        for (NSDictionary *dict in citiesArray) {
            ProvinceModel *provinceModel         = [ProvinceModel provinceModelWithDict:dict];
            [provinceModelArrayM addObject:provinceModel];
        }
        _citiesData                          = provinceModelArrayM;
        //        NSLog(@"_citiesData =%@",_citiesData);
    }
    
    
    if (!self.customPikerView) {
        self.customPikerView   = [[GWLCustomPikerView alloc]init];
        self.customPikerView.frame = CGRectMake(0, APPHEIGHT, self.view.bounds.size.width, 220);
        [UIView animateWithDuration:0.5 animations:^{
            self.customPikerView.frame = CGRectMake(0, APPHEIGHT  -220, self.view.bounds.size.width, 220);
        }];
        
        self.customPikerView.dataSource           = self;
        self.customPikerView.delegate             = self;
        self.customPikerView.titleLabelText       = @"请选择地址";
        self.customPikerView.titleLabelColor      = AppMainColor;
        self.customPikerView.titleButtonText      = @"确定";
        self.customPikerView.titleButtonTextColor = AppMainColor;
        self.customPikerView.indicatorColor       = AppMainColor;
        [self.view addSubview:self.customPikerView];
    }
    else
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.customPikerView.frame = CGRectMake(0, APPHEIGHT  -220, self.view.bounds.size.width, 220);
        }];
        
    }
    
}

#pragma mark - GWLCustomPikerViewDataSource
- (NSInteger)numberOfComponentsInCustomPikerView:(GWLCustomPikerView *)customPickerView {
    return 2;
}

- (NSInteger)customPickerView:(GWLCustomPikerView *)customPickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.citiesData.count;
    }else {
        ProvinceModel *provinceModel         = self.citiesData[_selectedProvince];
        return provinceModel.citys.count;
    }
}

- (NSString *)customPickerView:(GWLCustomPikerView *)customPickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        ProvinceModel *provinceModel         = self.citiesData[row];
        return provinceModel.name;
    }else {
        ProvinceModel *provinceModel         = self.citiesData[_selectedProvince];
        return provinceModel.citys[row][@"name"];
    }
}


#pragma mark - GWLCustomPikerViewDelegate
- (void)customPikerViewDidSelectedComponent:(NSInteger)component row:(NSInteger)row {
    if (component == 0) {
        _selectedProvince                    = row;
        [self.customPikerView reloadComponent:1];
        _selectedCity                        = 0;
    }else if (component == 1) {
        _selectedCity                        = row;
    }
    
    
}

- (void)customPikerViewCompleteSelectedRows:(NSArray *)rows {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.customPikerView.frame = CGRectMake(0, APPHEIGHT, self.view.bounds.size.width, 220);
    }];
    ProvinceModel *provinceModel         = self.citiesData[[rows[0] integerValue]];
    
    _modal.area = [NSString stringWithFormat:@"%@-%@",provinceModel.code,provinceModel.citys[[rows[1] integerValue]][@"code"]];
    _saveBtn.hidden = NO;
    [_basicInfoTableView reloadData];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end


@implementation BasicInformationView
{
    UIImageView *assorry;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _title =[UILabel createLabelWithFrame:frame(15, 0, cellWidth/2.0, cellHeight) text:@"" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:self];
        
        _detailTitle =[UILabel createLabelWithFrame:frame(100*ScreenMultiple, 0, cellWidth -100*ScreenMultiple - 35, cellHeight) text:@"" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentRight inView:self];
        _detailTitle.hidden = YES;
        
        _userIcon = allocAndInitWithFrame(UIImageView, frame(cellWidth - 73, 6, 38, 38));
        _userIcon.layer.masksToBounds = YES;
        _userIcon.layer.cornerRadius = frameWidth(_userIcon)/2.0;
        _userIcon.hidden = YES;
        _userIcon.image = [UIImage imageNamed:@"ditu"];
        [self addSubview:_userIcon];
        
        _userBg = allocAndInitWithFrame(UIImageView, frame(cellWidth - 85, 6, 50, 38));
        _userBg.hidden = YES;
        _userBg.image = [UIImage imageNamed:@"defaulthead"];
        [self addSubview:_userBg];
        
        UIImage *image =[UIImage imageNamed:@"option"];
        assorry =allocAndInitWithFrame(UIImageView, frame(cellWidth - 13 - image.size.width, (cellHeight - image.size.width)/2.0, image.size.width, image.size.height));
        assorry.image = image;
        assorry.hidden = YES;
        [self addSubview:assorry];
        
        //        [UILabel CreateLineFrame:frame(0, cellHeight , cellWidth, 0.5) inView:self];
        
        
    }
    
    return self;
}
- (void)showTitle:(NSString *)title icon:(NSString *)icon bg:(NSString *)bg detail:(NSString *)detail canEdit:(BOOL)canEdit
{
    assorry.hidden = !canEdit;
    
    if (title) {
        _title.text =title;
        _title.hidden = NO;
    }
    else
    {
        _title.hidden = YES;
    }
    if (icon) {
        
        [[ToolManager shareInstance] imageView:_userIcon setImageWithURL:icon placeholderType:PlaceholderTypeUserHead];
        _userIcon.hidden = NO;
    }
    else
    {
        _userIcon.hidden = YES;
    }
    if (bg) {
        
        [[ToolManager shareInstance] imageView:_userBg setImageWithURL:bg placeholderType:PlaceholderTypeUserBg];
        _userBg.hidden = NO;
    }
    else
    {
        _userBg.hidden = YES;
    }
    if (detail) {
        _detailTitle.text =detail;
        _detailTitle.hidden = NO;
    }
    else
    {
        _detailTitle.hidden = YES;
    }
    
}
@end
