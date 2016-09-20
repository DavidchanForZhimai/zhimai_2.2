//
//  DiscoverViewController.m
//  Lebao
//
//  Created by David on 15/11/27.
//  Copyright © 2015年 David. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoverTabViewController.h"
#import "MyCollectionViewController.h"
#import "CoreArchive.h"
#define tabsTotal  4
#define tabsHeight  39.0

#define TabWidth APPWIDTH/tabsTotal
@interface DiscoverViewController ()<ViewPagerDataSource, ViewPagerDelegate>

@end

@implementation DiscoverViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view.
   [self navViewTitleAndBackBtn:@"精选文章"];
    UIImage *imageCollect =[UIImage imageNamed:@"icon_discover_collection"];
    UIButton *collect =[UIButton createButtonWithfFrame:frame(APPWIDTH - 20 - imageCollect.size.width, StatusBarHeight, 20  + imageCollect.size.width, 44) title:nil backgroundImage:nil iconImage:imageCollect highlightImage:nil tag:0 inView:self.view];
    [collect addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
    self.dataSource = self;
    self.delegate = self;
    self.ispageViewController = YES;
    
}
- (void)buttonAction:(UIButton *)sender
{
    PopView(self);
}
#pragma mark
#pragma mark - collect
- (void)collect:(UIButton *)sender
{
  
    PushView(self, allocAndInit(MyCollectionViewController));
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
        label.text = @"保险";
    }
    else if (index==1)
    {
        label.text = @"金融";
    }
    else if (index==2)
    {
        label.text = @"房产";
    }
    else if (index==3)
    {
        label.text = @"车行";
    }
  
    label.textColor = AppMainColor;
    
    return label;
}

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index
{
    [viewPager changeTitleColor];
    
    
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index
{
    DiscoverTabViewController *view = allocAndInit(DiscoverTabViewController);
    
    switch (index) {
        case 0:
            view.selected = IndustryTagInsurance;
            return view;
            break;
        case 1:
            view.selected = IndustryTagFinance;
            return view;
            break;
        case 2:
             view.selected = IndustryTagProperty;
            return view;
            break;
        case 3:
            view.selected =IndustryTagOther ;
            return view;
            break;
            
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
