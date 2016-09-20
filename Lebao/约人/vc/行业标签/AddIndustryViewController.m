//
//  AddIndustryViewController.m
//  Lebao
//
//  Created by David on 16/9/12.
//  Copyright © 2016年 David. All rights reserved.
//

#import "AddIndustryViewController.h"
#import "DWTagsView.h"
#define TagHeight 30
#define ViewStartX StatusBarHeight + NavigationBarHeight
@interface AddIndustryViewController ()<DWTagsViewDelegate>

@property(nonatomic,strong)DWTagsView *hasTagsView;//已关注标签
@property(nonatomic,strong)DWTagsView *newsTagsView;//新热门标签
@property(nonatomic,copy)NSMutableArray *newsTags;//新标签
@property(nonatomic,strong)UILabel *newsLb;//新标签
@property(nonatomic,strong)BaseButton *finishBtn;//完成
@end

@implementation AddIndustryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = WhiteColor;
    [self navViewTitleAndBackBtn:@"添加行业"];
    [self.view addSubview:self.finishBtn];
    [self.view addSubview:self.hasTagsView];
    [self.view addSubview:self.newsLb];
    [self.view addSubview:self.newsTagsView];
    [self resetFrame];
    
}


#pragma mark getter
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
        if (weakSelf.addTagsfinishBlock) {

            weakSelf.addTagsfinishBlock(weakSelf.hasTags);
        }
        PopView(weakSelf);
    };
    return _finishBtn;
}

- (DWTagsView *)hasTagsView
{
    if (_hasTagsView) {
        return _hasTagsView;
    }
    _hasTagsView = allocAndInitWithFrame(DWTagsView, frame(10, 10+ViewStartX , APPWIDTH -20, 70));
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
    _hasTagsView.tagSelectedBackgroundColor = _newsTagsView.tagBackgroundColor;
    _hasTagsView.tagSelectedTextColor = _hasTagsView.tagTextColor;
    
    _hasTagsView.delegate = self;
    _hasTagsView.tagsArray = self.hasTags;
    
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


- (DWTagsView *)newsTagsView
{
    if (_newsTagsView) {
        return _newsTagsView;
    }
    _newsTagsView = allocAndInitWithFrame(DWTagsView, frame(10, CGRectGetMaxY(_newsLb.frame) , APPWIDTH -20, 70));
    _newsTagsView.contentInsets = UIEdgeInsetsZero;
    _newsTagsView.tagInsets = UIEdgeInsetsMake(5, 15, 5, 15);
    _newsTagsView.tagBorderWidth = 0.5;
    _newsTagsView.tagcornerRadius = 5;
    _newsTagsView.mininumTagWidth = (APPWIDTH - 30)/3.0;
    _newsTagsView.tagHeight  = TagHeight;
    _newsTagsView.tagBorderColor = LineBg;
    _newsTagsView.tagSelectedBorderColor = LineBg;
    _newsTagsView.tagBackgroundColor = [UIColor whiteColor];
    _newsTagsView.lineSpacing = 5;
    _newsTagsView.interitemSpacing = 5;
    _newsTagsView.tagFont = [UIFont systemFontOfSize:14];
    _newsTagsView.tagTextColor = LightBlackTitleColor;
    _newsTagsView.tagSelectedBackgroundColor = _newsTagsView.tagBackgroundColor;
    _newsTagsView.tagSelectedTextColor = _hasTagsView.tagTextColor;
    _newsTagsView.allowsMultipleSelection = YES;
    _newsTagsView.delegate = self;
    _newsTagsView.tagsArray = self.newsTags;
    return _newsTagsView;
}

- (NSMutableArray *)newsTags
{
    if (_newsTags) {
        return _newsTags;
    }
    _newsTags = [[NSMutableArray alloc]initWithObjects:@"商务",@"开发",@"产品",@"经理",@"老板",@"业务", nil];
    return _newsTags;
}


#pragma mark
#pragma mark DWTagsViewDelegate
 - (void)tagsView:(DWTagsView *)tagsView didSelectTagAtIndex:(NSUInteger)index
{
    
    [_hasTagsView addTag:_newsTags[index]];
    [_hasTags addObject:_newsTags[index]];
    [self resetFrame];
    
}
- (BOOL)tagsView:(DWTagsView *)tagsView shouldSelectTagAtIndex:(NSUInteger)index
{
    if ([tagsView isEqual:_newsTagsView]) {
    return YES;
    };
    return NO;
}
 - (void)tagsView:(DWTagsView *)tagsView didDeSelectTagAtIndex:(NSUInteger)index
{

    [_hasTagsView removeTagAtIndex:index];
    [_hasTags removeObjectAtIndex:index];
     [self resetFrame];   

}
- (BOOL)tagsView:(DWTagsView *)tagsView shouldDeselectItemAtIndex:(NSUInteger)index
{
    if ([tagsView isEqual:_newsTagsView]) {
        return YES;
    };
    return NO;
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
    int hotRow = 0;
    if (_hasTags.count%3==0) {
        hotRow=(int)(_hasTags.count/3);
    }
    else
    {
        hotRow=(int)(_hasTags.count/3) + 1;
    }
    NSLog(@"hotRow =%d _hasTags.count=%ld",hotRow,_hasTags.count);
    _hasTagsView.frame =frame(10, 10+ViewStartX , APPWIDTH -20, (TagHeight + 5)*hotRow);
    _newsLb.frame =frame(0, _hasTagsView.height + _hasTagsView.y +10, APPWIDTH, 40);
    _newsTagsView.frame = frame(10, CGRectGetMaxY(_newsLb.frame) , APPWIDTH -20, APPHEIGHT - CGRectGetMaxY(_newsLb.frame));
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
