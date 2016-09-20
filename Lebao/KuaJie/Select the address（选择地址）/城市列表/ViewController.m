//
//  ViewController.m
//  AddressInfo
//
//  Created by Alesary on 16/1/6.
//  Copyright © 2016年 Mr.Chen. All rights reserved.
//

#import "ViewController.h"
#import "ZWCollectionViewFlowLayout.h"
#import "Public.h"
#import "HeadView.h"
#import "CityViewCell.h"
#import "NBSearchResultController.h"
#import "NBSearchController.h"
#import "SearchResult.h"
#import "NSMutableArray+FilterElement.h"
#import "CoreArchive.h"
#import "XLDataService.h"
#import "NSArray+Extend.h"
#import "LoCationManager.h"

#define commonSelectan [NSString stringWithFormat:@"%@common/select-an",HttpURL]
#define HotCity @"HotCity"
@interface ViewController ()<UISearchControllerDelegate,UISearchResultsUpdating,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,NBSearchResultControllerDelegate,CityViewCellDelegate>
{
   UITableView *_tableView;
   HeadView    *_CellHeadView;
    
   NSMutableArray * _locationCity; //定位当前城市
    
   NSMutableArray *_dataArray; //定位，最近，热门数据原
    
    NSMutableArray *recentArray;
    NSMutableArray *hotCitys;
    
   NSMutableDictionary *_allCitysDictionary; //所有数据字典
   NSMutableArray *_keys; //城市首字母

}
@property (nonatomic, strong)NBSearchController *searchController; //搜索的控制器

@property (nonatomic, strong)NSMutableArray *searchList; //搜索结果的数组

@property (nonatomic, strong)NBSearchResultController *searchResultController; //搜索的结果控制器

@property(strong,nonatomic)NSMutableArray *allCityArray;  //所有城市数组


@end

@implementation ViewController

#pragma mark - 懒加载一些内容
-(NSMutableArray *)allCityArray
{
    
    if (!_allCityArray) {
        _allCityArray = [NSMutableArray array];
    }
    return _allCityArray;
}
- (NSMutableArray *)searchList
{
    if (!_searchList) {
        _searchList = [NSMutableArray array];
    }
    return _searchList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navView];
    
    
//    __weak ViewController *weakSelf =self;
//    [[ToolManager shareInstance] locationPositionBlock:^(NSString *locate) {
//    [_locationCity replaceObjectAtIndex:0 withObject:locate];
//     weakSelf.navTitle.text = [NSString stringWithFormat:@"当前位置-%@",locate];
//    [_tableView reloadData];
//    }];

    [self loadData];
    [self initTableView];
    [self initSearchController];

}
//- (void)viewWillAppear:(BOOL)animated
//{
//    
//    [super viewWillAppear:animated];
//    [self.selectedAddress setTitle:[CoreArchive strForKey:LocationAddress] forState:UIControlStateNormal];
//    [self resetSeletedAddressFrame];
//}
#pragma mark - Navi_View
- (void)navView
{
    [self navViewTitleAndBackBtn:@"选择城市" ];
    
    
}
#pragma mark
#pragma mark - buttonAction -
- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag ==NavViewButtonActionNavLeftBtnTag ) {
        self.returnBlock([CoreArchive strForKey:LocationAddress],[CoreArchive strForKey:AddressID]);
        PopView(self);
    }
    
}

-(void)loadData
{
    _dataArray=[NSMutableArray array];
    //定位城市
    NSMutableDictionary *_locationDic =allocAndInit(NSMutableDictionary);
    [_locationDic setValue:[CoreArchive strForKey:KLocationName] forKey:@"area"];
    [_locationDic setValue:[CoreArchive strForKey:KLocationId] forKey:@"id"];
    _locationCity=[NSMutableArray arrayWithObject:_locationDic];
    [_dataArray addObject:_locationCity];
    
    //最近访问
    NSMutableDictionary *all =allocAndInit(NSMutableDictionary);
    [all setValue:@"全国" forKey:@"area"];
    [all setValue:@"0" forKey:@"id"];
    recentArray=allocAndInit(NSMutableArray);
    if ([CoreArchive objectForKey:RecentCityData]) {
        NSMutableArray *arrays = [CoreArchive objectForKey:RecentCityData];
        for (NSMutableDictionary *dic in arrays) {
            [recentArray addObject:dic];
        }
        
        if (![recentArray containsObject:all]) {
            [recentArray removeLastObject];
            [recentArray addObject:all];
        }
        
    }
    else
    {
        [recentArray addObject:all];
    
    }
    [_dataArray addObject:recentArray];
    
    //热门城市
    hotCitys=allocAndInit(NSMutableArray);
    [_dataArray addObject:hotCitys];
    
    _allCitysDictionary = allocAndInit(NSMutableDictionary);
    _keys=[NSMutableArray array];

    //添加多余三个索引
   
     [_allCitysDictionary setObject:hotCitys forKey:@"Θ"];
     [_allCitysDictionary setObject:recentArray forKey:@"♡"];
     [_allCitysDictionary setObject:_locationCity forKey:@"◎"];
    
     [_keys addObject:@"◎" ];
     [_keys addObject:@"♡"];
     [_keys addObject:@"Θ"];
     [self loadCityData];
}
- (void)loadCityData
{
  
    if ([[CoreArchive objectForKey:AddressNewVersion] isEqualToString:[CoreArchive objectForKey:AddressOldVersion]]) {
        
        [self addCityDict:[CoreArchive objectForKey:commonSelectan] hotcity:[CoreArchive objectForKey:HotCity]];
    }
    else
    {
        NSMutableDictionary *parameter = [Parameter parameterWithSessicon];
        [[ToolManager shareInstance] showWithStatus];
        [XLDataService postWithUrl:commonSelectan param:parameter modelClass:nil responseBlock:^(id dataObj, NSError *error) {
//            NSLog(@"dataObj =%@",dataObj);
            if (dataObj) {
                if ([dataObj[@"rtcode"] intValue]==1) {
                    [[ToolManager shareInstance] dismiss];
                    
                    [CoreArchive setStr:[CoreArchive objectForKey:AddressNewVersion] key:AddressOldVersion];

                    [CoreArchive setobject:[[NSArray alloc]dictWithDiffrentArray:dataObj[@"allcity"]] key:commonSelectan];
                    
                    NSMutableArray *hotCity= allocAndInit(NSMutableArray);
                    for (NSDictionary *dic in dataObj[@"hot"]) {
                        NSMutableDictionary *city = allocAndInit(NSMutableDictionary);
                        [city setValue:dic[@"area"] forKey:@"area"];
                        [city setValue:dic[@"id"] forKey:@"id"];
                        [hotCity addObject:city];
                    }
                     [CoreArchive setobject:hotCity key:HotCity];
                    [self addCityDict:[[NSArray alloc]dictWithDiffrentArray:dataObj[@"allcity"]] hotcity:hotCity];
                    
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
}
- (void)addCityDict:(NSMutableDictionary *)dic hotcity:(NSMutableArray *)hotCity
{
    
    //索引城市
    [_allCitysDictionary addEntriesFromDictionary:dic];
   
    [hotCitys addObjectsFromArray:hotCity];
   
    //将所有城市放到一个数组里
    for (NSArray *array in _allCitysDictionary.allValues) {
        for (NSString *citys in array) {
            [self.allCityArray addObject:citys];
        }
    }
    
    NSMutableArray *_allkeys =allocAndInit(NSMutableArray);
    for (NSString *str in [_allCitysDictionary allKeys]) {
        if (![str isEqualToString:@"◎"]&&![str isEqualToString:@"♡"]&&![str isEqualToString:@"Θ"]) {
            [_allkeys addObject:str];
        }
    }
    [_keys addObjectsFromArray:[_allkeys sortedArrayUsingSelector:@selector(compare:)]];
   
    [_tableView reloadData];
}
-(void)initTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarHeight  +NavigationBarHeight, screen_width, screen_height -(StatusBarHeight  +NavigationBarHeight)) style:UITableViewStylePlain];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = RGB(150, 150, 150);
    [self.view addSubview:_tableView];
}
-(void)initSearchController //创建搜索控制器
{
    self.searchResultController=[[NBSearchResultController alloc]init];
    self.searchResultController.delegate=self;
    _searchController=[[NBSearchController alloc]initWithSearchResultsController:self.searchResultController];
    _searchController.delegate = self;
    _searchController.searchResultsUpdater=self;
    _searchController.searchBar.delegate = self;
    _tableView.tableHeaderView = self.searchController.searchBar;
    
    
}

//修改SearchBar的Cancel Button 的Title
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar;
{
    [_searchController.searchBar setShowsCancelButton:YES animated:YES];
    UIButton *btn=[_searchController.searchBar valueForKey:@"_cancelButton"];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section<=2) {
        return 1;
    }else{
        
        NSArray *array=[_allCitysDictionary objectForKey:[_keys objectAtIndex:section]];
        
        return array.count;
    }
  
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _keys.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section<=2) {
        
        return [CityViewCell getHeightWithCityArray:_dataArray[indexPath.section]];
    }else{
        
        return 47;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section<=2) {
        
        static NSString *identfire=@"Cell";
        
        CityViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identfire];
        
        if (!cell) {
            
            cell=[[CityViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfire];
        }
        
        cell.delegate=self;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell setContentView:_dataArray[indexPath.section]];
        return cell;
        
    }else{
    
        static NSString *identfire=@"cellID";
        
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identfire];
        
        if (!cell) {
            
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfire];
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        NSArray *array=[_allCitysDictionary objectForKey:[_keys objectAtIndex:indexPath.section]];
        
        cell.textLabel.text=array[indexPath.row][@"area"];
        return cell;
    }
    
   
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _CellHeadView=[[HeadView alloc]init];
    
    if (section==0) {
        
        _CellHeadView.TitleLable.text=@"当前城市";
    }else if (section==1){
      
        _CellHeadView.TitleLable.text=@"最近访问";
        
    }
    else if (section==2){
        
        _CellHeadView.TitleLable.text=@"热门城市";
        
    }else{
    
      _CellHeadView.TitleLable.text=_keys[section];
    }
    
    return _CellHeadView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array=[_allCitysDictionary objectForKey:[_keys objectAtIndex:indexPath.section]];
    [self popRootViewControllerWithName:array[indexPath.row][@"area"] cityID:array[indexPath.row][@"id"]];
}

-(void)SelectCityNameInCollectionBy:(NSString *)cityName cityID:(NSString *)cityID
{
  [self popRootViewControllerWithName:cityName cityID:cityID];
}
#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = [self.searchController.searchBar text];
    // 移除搜索结果数组的数据
    [self.searchList removeAllObjects];
    //过滤数据
    self.searchList= [SearchResult getSearchResultBySearchText:searchString dataArray:self.allCityArray];
    if (searchString.length==0&&self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    self.searchList = [self.searchList filterTheSameElement];
    NSMutableArray *dataSource = nil;
    if ([self.searchList count]>0) {
        dataSource = [NSMutableArray array];
        // 结局了数据重复的问题
        for (NSString *dic in self.searchList) {
            [dataSource addObject:dic];
        }
    }
    
    //刷新表格
    self.searchResultController.dataSource = dataSource;
    [self.searchResultController.tableView reloadData];
    [_tableView reloadData];
   
}
/**
 *  点击了搜索的结果的 cell
 *
 *  @param resultVC  搜索结果的控制器
 *  @param follow    搜索结果信息的模型
 */
- (void)resultViewController:(NBSearchResultController *)resultVC didSelectFollowCity:(NSString *)cityName cityID:(NSString *)cityID
{
    self.searchController.searchBar.text =@"";
    [self.searchController dismissViewControllerAnimated:NO completion:nil];
    [self popRootViewControllerWithName:cityName cityID:cityID];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.searchController.active?nil:_keys;
}
-(void)returnText:(ReturnCityName)block
{
    self.returnBlock=block;
}
- (void)popRootViewControllerWithName:(NSString *)cityName cityID:(NSString *)cityID
{
     [CoreArchive setStr:cityName key:LocationAddress];
     [CoreArchive setStr:cityID key:AddressID];

    NSMutableArray *recentArrayMore = allocAndInit(NSMutableArray);
    
    for (NSMutableDictionary *dic in recentArray) {
        [recentArrayMore addObject:dic];
    }
    
    NSMutableDictionary *locationDic =allocAndInit(NSMutableDictionary);
    [locationDic setValue:[CoreArchive strForKey:LocationAddress] forKey:@"area"];
    [locationDic setValue:[CoreArchive strForKey:AddressID] forKey:@"id"];
    if ([recentArrayMore containsObject:locationDic]) {
        [recentArrayMore removeObject:locationDic];
    }
   
    [recentArrayMore insertObject:locationDic atIndex:0];
    

    if (recentArrayMore.count>5) {
        
        [recentArrayMore removeLastObject];
    }
    
    
    [CoreArchive setobject:recentArrayMore key:RecentCityData];
     self.returnBlock(cityName,cityID);
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
