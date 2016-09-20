//
//  NBSearchController.m
//  NBSearchView
//
//  Created by Alesary on 15/11/17.
//  Copyright © 2015年 Alesary. All rights reserved.
//

#import "NBSearchController.h"
#import "NBSearchResultController.h"
#import "Public.h"

@interface NBSearchController ()
{
    NBSearchResultController *_resultViewController;
}
@end

@implementation NBSearchController

-(instancetype)initWithSearchResultsController:(UIViewController *)searchResultsController
{
    self=[super initWithSearchResultsController:searchResultsController];
    if (self) {
        
        UIView * _navView = [[UIView alloc]initWithFrame:frame(0, 0, APPWIDTH, StatusBarHeight + NavigationBarHeight)];
        _navView.backgroundColor = WhiteColor;
        UILabel *title = allocAndInitWithFrame(UILabel , frame(0,StatusBarHeight, APPWIDTH, NavigationBarHeight));
        title.backgroundColor = [UIColor clearColor];
        title.font = Size(32);
        title.textAlignment = NSTextAlignmentCenter;
        title.text = @"搜索城市";
        title.textColor = BlackTitleColor;
        [_navView addSubview:title];
        [self.view addSubview:_navView];
//       self.hidesNavigationBarDuringPresentation = YES;
        
        self.searchBar.frame = CGRectMake(self.searchBar.frame.origin.x, self.searchBar.frame.origin.y, self.searchBar.frame.size.width, 44.0);
        self.searchBar.placeholder = @"城市/行政区/拼音";
        self.searchBar.searchBarStyle = UISearchBarStyleProminent;
        self.searchBar.returnKeyType = UIReturnKeyDone;
    }
    
   
    
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
