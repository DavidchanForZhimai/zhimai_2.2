//
//  EarnestRecodeViewController.m
//  Lebao
//
//  Created by David on 16/1/27.
//  Copyright © 2016年 David. All rights reserved.
//

#import "EarnestRecodeViewController.h"
#import "EarnestRecodeAllViewController.h"
#define tabsTotal  3
#define tabsHeight  39.0
#define TabWidth APPWIDTH/tabsTotal


@interface EarnestRecodeViewController ()<ViewPagerDataSource,ViewPagerDelegate>

@end

@implementation EarnestRecodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self navView];
    self.dataSource = self;
    self.delegate = self;
    self.ispageViewController = YES;

}
- (void)navView
{
    [self navViewTitleAndBackBtn:@"钱包记录" ];
    
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
#pragma mark  ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager
{
    return tabsTotal;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index
{
    
    UILabel *label = [[UILabel alloc] init];
    [label setFrame:CGRectMake(0, StatusBarHeight+44,TabWidth, tabsHeight)];
    label.backgroundColor = [UIColor whiteColor];
    label.font = Size(24);
    label.textAlignment = NSTextAlignmentCenter;
    if (index==0)
    {
        label.text = @"全部";
    }
    else if (index==1)
    {
        label.text = @"已收入";
    }
    else if (index==2)
    {
        label.text = @"已支出";
    }
//    else if (index==3)
//    {
//        label.text = @"冻结中";
//    }
    
    label.textColor = AppMainColor;
    
    return label;
}

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index
{
    [viewPager changeTitleColor];
    
    
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index
{
    EarnestRecodeAllViewController *view = allocAndInit(EarnestRecodeAllViewController);
    
    switch (index) {
        case 0:
            view.recodeType = EarnestRecodeAll;
            return view;
            break;
        case 1:
           view.recodeType = EarnestRecodeIncome;
            return view;
            break;
        case 2:
            view.recodeType = EarnestRecodePay;
            return view;
            break;
//        case 3:
//   
//            return view;
//            break;
            
        default:
            break;
    }
    return view;
    
    
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value
{
    switch (option) {
        case ViewPagerOptionStartFromThisTab:
            return 0;
            break;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
            break;
        case ViewPagerOptionTabLocation:
            return 0.0;
            break;
        case ViewPagerOptionTabWidth:
            return TabWidth;
            break;
        case ViewPagerOptionTabHeight:
            return tabsHeight + 5;
            break;
            
            
        default:
            break;
    }
    
    return value;
}

- (UIColor *)viewPager:(ViewPagerController *)viewPager colorForComponent:(ViewPagerComponent)component withDefault:(UIColor *)color
{
    switch (component)
    {
        case ViewPagerIndicator:
            return AppMainColor;
            break;
        case ViewPagerTabsView:
            return WhiteColor;
            break;
        default:
            break;
    }
    
    return color;
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
