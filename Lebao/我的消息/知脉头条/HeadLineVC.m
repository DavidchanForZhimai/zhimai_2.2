//
//  HeadLineVC.m
//  Lebao
//
//  Created by adnim on 16/10/9.
//  Copyright © 2016年 David. All rights reserved.
//

#import "HeadLineVC.h"
#import "HeadLineOneCell.h"
#import "HeadLineTwoCell.h"
#import "XLDataService.h"
#import "NSString+Extend.h"
#import "DiscoverDetailViewController.h"
@class subtitleData;
@interface topModel : NSObject

@property(nonatomic,assign)int topId;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *upimgurl;
@property(nonatomic,strong)NSString *imgurl;
@end

@interface newsData : NSObject
@property(nonatomic,strong)topModel *top;
@property(nonatomic,assign)int datasId;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,strong)NSArray<subtitleData*> *subtitle;
@end

@interface subtitleData : NSObject

@property(nonatomic,assign)int subtitleId;
@property(nonatomic,strong)NSString *imgurl;
@property(nonatomic,strong)NSString *title;
@end

@interface newsModel : NSObject
@property(nonatomic,assign)int page;
@property(nonatomic,assign)int count;
@property(nonatomic,assign)int rtcode;
@property(nonatomic,strong)NSString *rtmsg;
@property(nonatomic,strong)NSArray<newsData *> *datas;
@end
@implementation newsModel

+ (NSDictionary *)objectClassInArray{
    return @{@"datas" : [newsData class]};
}
@end

@implementation newsData
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"datasId":@"id"};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"subtitle" : [subtitleData class]};
}
@end

@implementation subtitleData
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"subtitleId":@"id"};
}
@end
@implementation topModel
+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"topId":@"id"};
}
@end

@interface HeadLineVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *headLineTab;
}
@property(nonatomic,assign)int page;
@property(nonatomic,strong)NSMutableArray *headLineArr;
@end

@implementation HeadLineVC

-(NSMutableArray *)headLineArr
{
    if (!_headLineArr) {
        _headLineArr=[[NSMutableArray alloc]init];
    }
    return _headLineArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self navViewTitleAndBackBtn:@"知脉头条"];
    [self creadTab];
    _page = 1;
    if (self.headLineArr.count==0) {
        [[ToolManager shareInstance] showWithStatus];
    }
    
    
    [self netWorkRefresh:NO andIsLoadMoreData:NO isShouldClearData:NO];

}

-(void)creadTab{//创建tab
    headLineTab=[[UITableView alloc]initWithFrame:CGRectMake(0,StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT-(StatusBarHeight + NavigationBarHeight)) style:UITableViewStyleGrouped];
    headLineTab.delegate=self;
    headLineTab.dataSource=self;
    headLineTab.backgroundColor=AppViewBGColor;
    [[ToolManager shareInstance] scrollView:headLineTab headerWithRefreshingBlock:^{
        
        _page =1;
        [self netWorkRefresh:YES andIsLoadMoreData:NO isShouldClearData:YES];
        
    }];
    [[ToolManager shareInstance] scrollView:headLineTab footerWithRefreshingBlock:^{
        _page ++;
        [self netWorkRefresh:NO andIsLoadMoreData:YES isShouldClearData:NO];
    }];
    [self.view addSubview:headLineTab];
    if ([headLineTab respondsToSelector:@selector(setSeparatorInset:)]) {//设置cell线宽
        [headLineTab setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    }
    [headLineTab setSeparatorColor:AppViewBGColor];
}
#pragma mark 请求数据
-(void)netWorkRefresh:(BOOL)isRefresh andIsLoadMoreData:(BOOL)isMoreLoadMoreData isShouldClearData:(BOOL)isShouldClearData//加载数据
{
    NSMutableDictionary *param = [Parameter parameterWithSessicon];
    [param setObject:@(_page) forKey:@"page"];
    
    [XLDataService putWithUrl:HeadLineURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        
        if (isRefresh) {
            [[ToolManager shareInstance] endHeaderWithRefreshing:headLineTab];
        }
        if (isMoreLoadMoreData) {
            [[ToolManager shareInstance] endFooterWithRefreshing:headLineTab];
        }
        if (isShouldClearData) {
            [self.headLineArr removeAllObjects];
           

        }
        if (dataObj) {
//                NSLog(@"meetObj====%@",dataObj);
            newsModel *modal = [newsModel mj_objectWithKeyValues:dataObj];
           
            if (_page ==1) {
                [[ToolManager shareInstance] moreDataStatus:headLineTab];
            }
            if (!modal.datas||modal.datas.count==0) {
                [[ToolManager shareInstance] noMoreDataStatus:headLineTab];
            }
            if (modal.rtcode ==1) {
                [[ToolManager shareInstance] dismiss];
                for (newsData *data in modal.datas) {
                    [self.headLineArr addObject:data];
                }
                   
                    [headLineTab reloadData];
            }
            else
            {
                [[ToolManager shareInstance] showAlertMessage:modal.rtmsg];
            }
        
        }
        else
        {
            [[ToolManager shareInstance] showInfoWithStatus];
        }
        
    }];

}
#pragma mark UItabViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headView = [[UIView alloc]init];
    headView.backgroundColor = AppViewBGColor;
    headView.height = 50;
    newsData *data =  _headLineArr[section];
    UILabel *timelab=[[UILabel alloc]initWithFrame:CGRectMake((APPWIDTH-80)/2.0, (50-25)/2, 80, 25)];
    NSString *times=data.time;
    timelab.text= [times timeformatString:@"MM-dd hh:mm"];
    timelab.font=[UIFont systemFontOfSize:12];
    ;
    timelab.frame=CGRectMake((APPWIDTH-timelab.text.length*6-10)/2.0, (50-25)/2,[timelab.text sizeWithFont:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(APPWIDTH,12)].width+10, 25);
    timelab.textColor=[UIColor whiteColor];
    timelab.textAlignment=NSTextAlignmentCenter;
    timelab.layer.cornerRadius=3.0;
    timelab.clipsToBounds=YES;
    timelab.backgroundColor=[UIColor colorWithWhite:0.800 alpha:1.000];
    [headView addSubview:timelab];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return (APPWIDTH-20)/9.0*5+10;
    }else
        return 70;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    newsData *data = self.headLineArr[section];
    return 1 + data.subtitle.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.headLineArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{

    HeadLineOneCell *cellOne=[tableView dequeueReusableCellWithIdentifier:@"oneCell"];
    HeadLineTwoCell *cellTwo=[tableView dequeueReusableCellWithIdentifier:@"twoCell"];
    if (indexPath.row==0&&!cellOne) {
        cellOne=[[HeadLineOneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"oneCell"];
        cellOne.backgroundColor=[UIColor clearColor];
    }
        else if(indexPath.row>0&&!cellTwo){
        cellTwo=[[HeadLineTwoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"twoCell"];
        cellTwo.backgroundColor=[UIColor clearColor];
    }
    
    newsData *data =  _headLineArr[indexPath.section];
    if(indexPath.row==0){
        
        if (![data.top.upimgurl isEqualToString:@""]) {

            [[ToolManager shareInstance]imageView:cellOne.bgImgView setImageWithURL:data.top.upimgurl  placeholderType:PlaceholderTypeOther];

        }else if (![data.top.imgurl isEqualToString:@""]) {
            
             [[ToolManager shareInstance]imageView:cellOne.bgImgView setImageWithURL:data.top.imgurl  placeholderType:PlaceholderTypeOther];
        }
        
        cellOne.titleLab.text=data.top.title;
        return cellOne;
    }
        else {
            if (indexPath.row - 1<data.subtitle.count) {
                subtitleData *subData =data.subtitle[indexPath.row - 1];
            cellTwo.TitleLab.text=subData.title;
           [[ToolManager shareInstance]imageView:cellTwo.imgView setImageWithURL:subData.imgurl  placeholderType:PlaceholderTypeOther];
            }
        return cellTwo;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DiscoverDetailViewController *detail = allocAndInit(DiscoverDetailViewController);
   
    newsData *data =  _headLineArr[indexPath.section];
    if(indexPath.row==0){
        
        HeadLineOneCell *cellOne = [tableView cellForRowAtIndexPath:indexPath];
        detail.shareImage =cellOne.bgImgView.image;
        detail.ID =[NSString stringWithFormat:@"%d", data.top.topId];
        detail.Nav_title = data.top.title;
       
    }
    else {
        
        HeadLineTwoCell *cellTwo = [tableView cellForRowAtIndexPath:indexPath];
        if (indexPath.row - 1<data.subtitle.count) {
            subtitleData *subData =data.subtitle[indexPath.row - 1];
            detail.shareImage =cellTwo.imgView.image;
            detail.ID =[NSString stringWithFormat:@"%d", subData.subtitleId];
            detail.Nav_title = subData.title;
        }
        
    }

   
    PushView(self, detail);

}
- (void)buttonAction:(UIButton *)sender
{
    PopRootView(self);
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
