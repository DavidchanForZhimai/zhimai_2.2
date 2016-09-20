//
//  DiscoverHomePageViewController.m
//  Lebao
//
//  Created by David on 16/5/12.
//  Copyright © 2016年 David. All rights reserved.
//

#import "DiscoverHomePageViewController.h"
#import "DiscoverViewController.h"//精选文章
#import "RedpacketsforwardingViewController.h"//红包转发
#import "ReadhotViewController.h"//热门阅读
#import "AlreadysentproductViewController.h"//已发产品
#import "ReadMeMostViewController.h"//读我最多
#import "CoreArchive.h"

@interface DiscoverHomePageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)NSMutableArray *collections;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UIView *fristSection;
@property(nonatomic,strong)UIView *secondSection;

@end

@implementation DiscoverHomePageViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([CoreArchive strForKey:@"isread"]) {
        [self.homePageBtn setImage:[UIImage imageNamed:@"icon_dicover_me_selected"] forState:UIControlStateNormal];
    }
    else
    {
        
        [self.homePageBtn setImage:[UIImage imageNamed:@"icon_dicover_me"] forState:UIControlStateNormal];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    [self setTabbarIndex:3];
    [self navViewTitle:@"发现" ];

    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.fristSection];
    [self.view addSubview:self.secondSection];
}

#pragma mark
#pragma mark UICollectionDelegate
//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.collections.count;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *array = self.collections[section];
    return array.count;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//返回每个item
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"DiscoverHomePageView" forIndexPath:indexPath];
    cell.backgroundColor = WhiteColor;
    NSString *imagesName = _collections[indexPath.section][indexPath.row][@"image"];
    NSString *name = _collections[indexPath.section][indexPath.row][@"name"];
    UIImage *image =[UIImage imageNamed:imagesName];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((APPWIDTH/3.0 - image.size.width)/2.0, 5, image.size.width, image.size.height)];
    imageView.image = image;
    [cell addSubview:imageView];
    [UILabel createLabelWithFrame:frame(0, image.size.height + 20, APPWIDTH/3.0, 26*SpacedFonts) text:name fontSize:26*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentCenter inView:cell];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *vcStr =_collections[indexPath.section][indexPath.row][@"viewController"];
    if (NSClassFromString(vcStr)) {
         PushView(self, allocAndInit(NSClassFromString(vcStr)));
    }
    else
    {
        [[ToolManager shareInstance] showAlertMessage:@"未知页面"];
    }
   
    NSLog(@"indexPath.se = %ld  row = %ld",indexPath.section,indexPath.row);
}
#pragma mark 
#pragma mark getters
- (NSMutableArray *)collections
{
    if (_collections) {
        return _collections;
    }
    _collections = [NSMutableArray new];
    NSArray *title1 = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"线索大厅",@"name",@"icon_discover_xiansuo",@"image",@"WBHomePageVC",@"viewController", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"红包转发",@"name",@"icon_discover_hongbao",@"image",@"RedpacketsforwardingViewController",@"viewController", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"封装链接",@"name",@"icon_discover_fengzhuanglianjie",@"image",@"",@"viewController", nil], nil];
    NSArray *title2 =[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"编辑文章",@"name",@"icon_discover_liaoku",@"image",@"",@"viewController", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"我的内容",@"name",@"icon_discover_wodewnzhang",@"image",@"",@"viewController", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"读我最多",@"name",@"icon_discover_duwozuiduo",@"image",@"ReadMeMostViewController",@"viewController", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"文章数据",@"name",@"icon_discover_shuju",@"image",@"",@"viewController", nil],nil];
    [_collections  addObject:title1];
    [_collections addObject:title2];
    return _collections;
    
}
- (UICollectionView *)collectionView
{
    if (_collectionView) {
        return _collectionView;
    }
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小为
    layout.itemSize = CGSizeMake(APPWIDTH/3, 70*ScreenMultiple);
    layout.sectionInset = UIEdgeInsetsMake(50,0,0,0);
    //创建collectionView 通过一个布局策略layout来创建
    UICollectionView * collect = [[UICollectionView alloc]initWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH,100 + 210*ScreenMultiple)collectionViewLayout:layout];
    //代理设置
    collect.delegate=self;
    collect.dataSource=self;
    //注册item类型 这里使用系统的类型
    [collect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"DiscoverHomePageView"];
    
    collect.backgroundColor = WhiteColor;
    
    _collectionView = collect;
    return _collectionView;
}
- (UIView *)fristSection
{
    if (_fristSection) {
        return _fristSection;
    }
    _fristSection = [[UIView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, 50)];
    _fristSection.backgroundColor = self.view.backgroundColor;
   
    UIView *viewLb = [[UIView alloc]initWithFrame:CGRectMake(0,10, APPWIDTH, 40)];
    viewLb.backgroundColor = WhiteColor;
    [UILabel createLabelWithFrame:frame(20, 0, APPWIDTH - 20, 40) text:@"营销工具" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:viewLb];
    
    [_fristSection addSubview:viewLb];
    return _fristSection;
}
- (UIView *)secondSection
{
    if (_secondSection) {
        return _secondSection;
    }
    _secondSection = [[UIView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + NavigationBarHeight + 50 + 70*ScreenMultiple, APPWIDTH, 50)];
    _secondSection.backgroundColor = self.view.backgroundColor;
    
    UIView *viewLb = [[UIView alloc]initWithFrame:CGRectMake(0,10, APPWIDTH, 40)];
    viewLb.backgroundColor = WhiteColor;
    [UILabel createLabelWithFrame:frame(20, 0, APPWIDTH - 20, 40) text:@"自媒体" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:viewLb];
    
    [_secondSection addSubview:viewLb];
    return _secondSection;
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
