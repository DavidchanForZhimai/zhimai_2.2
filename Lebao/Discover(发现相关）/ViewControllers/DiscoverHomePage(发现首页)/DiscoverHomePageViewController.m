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
#import "AlreadysentproductViewController.h"//已发产品
#import "ReadMeMostViewController.h"//读我最多
#import "CoreArchive.h"
#import "ReleaseDocumentsPackagetViewController.h"//封装链接
#import "EditArticlesViewController.h"//编辑文章

#import "XLDataService.h"
@interface DiscoverHomePageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)NSMutableArray *collections;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UIView *fristSection;
@property(nonatomic,strong)UIView *secondSection;
@property(nonatomic,assign)BOOL isNewRedArticle;
@end

@implementation DiscoverHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navViewTitle:@"发现" ];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.fristSection];
    [self.view addSubview:self.secondSection];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![CoreArchive strForKey:@"rid"]) {
        [CoreArchive setStr:@"0" key:@"rid"];
    }
   
    _isNewRedArticle = NO;
    [XLDataService postWithUrl:[NSString stringWithFormat:@"%@library/home",HttpURL] param:[Parameter parameterWithSessicon] modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if ([dataObj[@"rtcode"] integerValue]==1) {
            _isNewRedArticle = ![[NSString stringWithFormat:@"%@",dataObj[@"rid"]]  isEqualToString:[CoreArchive strForKey:@"rid"]];
            [CoreArchive setStr:[NSString stringWithFormat:@"%@",dataObj[@"rid"]] key:@"rid"];
            [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]]];
        }
       
    }];

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
//    红包红点
    UIView *red= [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) - 3, imageView.y-3, 8, 8)];
    red.backgroundColor = [UIColor clearColor];
    [red setRound];
    [cell addSubview:red];
    if (_isNewRedArticle &&indexPath.section==0&&indexPath.row==1) {
        red.backgroundColor = [UIColor redColor];
    }
    else
    {
        red.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *vcStr =_collections[indexPath.section][indexPath.row][@"viewController"];
    if (NSClassFromString(vcStr)) {
        if([vcStr isEqualToString: @"EditArticlesViewController"]){
            EditArticlesViewController *release =allocAndInit(EditArticlesViewController);
            EditArticlesData *data = allocAndInit(EditArticlesData);
            data.content = @"";
            data.isAddress = YES ;
            data.isgetclue = YES;
            data.isRanking = YES;
            data.amount = @"0.00";
            data.isReleseArticle =YES;
            release.data = data;
            
            [self.navigationController pushViewController:release animated:NO];

        }
        else if ([vcStr isEqualToString: @"AlreadysentproductViewController"])
        {
            AlreadysentproductViewController *article =allocAndInit(AlreadysentproductViewController);
            [self.navigationController pushViewController:article animated:YES];
        }
        
        else
         PushView(self, allocAndInit(NSClassFromString(vcStr)));
    }
    else
    {
        [[ToolManager shareInstance] showAlertMessage:@"未知页面"];
    }
   
   
}
#pragma mark 
#pragma mark getters
- (NSMutableArray *)collections
{
    if (_collections) {
        return _collections;
        
    }
    _collections = [NSMutableArray new];
    NSArray *title1 = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"线索大厅",@"name",@"icon_discover_xiansuo",@"image",@"WBHomePageVC",@"viewController", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"红包转发",@"name",@"icon_discover_hongbao",@"image",@"RedpacketsforwardingViewController",@"viewController", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"封装链接",@"name",@"icon_discover_fengzhuanglianjie",@"image",@"ReleaseDocumentsPackagetViewController",@"viewController", nil], nil];

    NSArray *title2 =[NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"编辑文章",@"name",@"icon_discover_liaoku",@"image",@"EditArticlesViewController",@"viewController", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"我的内容",@"name",@"icon_discover_wodewnzhang",@"image",@"AlreadysentproductViewController",@"viewController", nil],[NSDictionary dictionaryWithObjectsAndKeys:@"读我最多",@"name",@"icon_discover_duwozuiduo",@"image",@"ReadMeMostViewController",@"viewController", nil], [NSDictionary dictionaryWithObjectsAndKeys:@"读者属性",@"name",@"icon_discover_shuju",@"image",@"ReaderAttributesViewController",@"viewController", nil],nil];
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
    _collectionView = [[UICollectionView alloc]initWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH,100 + 210*ScreenMultiple)collectionViewLayout:layout];
    //代理设置
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    //注册item类型 这里使用系统的类型
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"DiscoverHomePageView"];
    
    _collectionView.backgroundColor = WhiteColor;
    
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
