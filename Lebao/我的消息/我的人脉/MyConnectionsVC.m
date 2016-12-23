//
//  MyConnectionsVC.m
//  Lebao
//
//  Created by adnim on 16/9/19.
//  Copyright © 2016年 David. All rights reserved.
//

#import "MyConnectionsVC.h"
#import "MJRefresh.h"
#import "MeettingTableViewCell.h"
#import "CoreArchive.h"
#import "ViewController.h"
#import "XLDataService.h"
#import "Parameter.h"
#import "LoCationManager.h"
#import "EjectView.h"
#import "MeetPaydingVC.h"
#import "NSString+Extend.h"
#import "GJGCChatFriendViewController.h"
#import "MyDetialViewController.h"
#import "FnyApplyForVC.h"//我的申请
#import "SearchAndAddTagsViewController.h"
#import "RecommendView.h"
#import "UIView+Boom.h"
#import "JiKeScrollView.h"
@interface MyConnectionsVC ()<UITableViewDelegate,UITableViewDataSource,MeettingTableViewDelegate,UIAlertViewDelegate,UISearchBarDelegate,RecommendViewDelegate>
{
    BOOL audioMark;
}
@property (nonatomic,strong)UITableView *yrTab;
@property (nonatomic,assign)int page;
@property (nonatomic,strong)NSMutableArray *nearByManArr;
@property (nonatomic,assign)BOOL isopen;
@property(nonatomic,strong) UISearchBar * bar;
@property(nonatomic,copy)NSString *keyword;
@property (nonatomic,strong)NSMutableArray *precommendArr;
@property (nonatomic,strong)RecommendView *reView1;
@property (nonatomic,strong)RecommendView *reView2;
@property (nonatomic,strong)RecommendView *reView3;
@property (nonatomic,strong)UIView *recommendView;
@property (nonatomic,strong)UILabel *recommendLab;
@property (nonatomic,strong)BaseButton *recommendBtn;
@property (nonatomic,strong)UIView *mainRecommendV;
@property (nonatomic,strong)UIButton *smallHeadV1;
@property (nonatomic,strong)UIButton *smallHeadV2;
@property (nonatomic,strong)UIButton *smallHeadV3;
@property (nonatomic,strong) JiKeScrollView *myJikeScrollView;
//模拟数据
@property (nonatomic,strong) NSArray *tempImageLinkDataArray;
@property (nonatomic,strong) NSArray *tempImageDesDataArray;
@property (nonatomic,strong) NSArray *tempImageDesDataArray1;
@end

@implementation MyConnectionsVC
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    audioMark=NO;
    
}
-(NSMutableArray *)precommendArr
{
    if (!_precommendArr) {
        _precommendArr=[NSMutableArray new];
    }
    return _precommendArr;
}
-(NSMutableArray *)nearByManArr
{
    if (!_nearByManArr) {
        _nearByManArr=[[NSMutableArray alloc]init];
    }
    return _nearByManArr;
}
-(RecommendView *)reView1
{
    if (!_reView1) {
        _reView1=[RecommendView new];
    }
    return _reView1;
}
-(RecommendView *)reView2
{
    if (!_reView2) {
        _reView2=[RecommendView new];
    }
    return _reView2;
}
-(RecommendView *)reView3
{
    if (!_reView3) {
        _reView3=[RecommendView new];
    }
    return _reView3;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self navViewTitleAndBackBtn:@""];
    self.view.backgroundColor=AppViewBGColor;
    [self addRecommendConnections];
    [self networkForRecommend];
    [self addTabView];
    _keyword =@"";
    _page = 1;
    _isopen=NO;
    [[ToolManager shareInstance]showWithStatus];
    [self netWorkRefresh:NO andIsLoadMoreData:NO isShouldClearData:NO];
    
    UIButton *applyForBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    applyForBtn.frame=CGRectMake(APPWIDTH-60, StatusBarHeight, 50, NavigationBarHeight);
    [applyForBtn setTitle:@"申请" forState:UIControlStateNormal];
    applyForBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    [applyForBtn setTitleColor:BlackTitleColor forState:UIControlStateNormal];
    [applyForBtn addTarget:self action:@selector(applyForBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:applyForBtn];
    

    [self.view addSubview:self.bar];
    
}
#pragma mark getter
- (UISearchBar *)bar
{
    if (!_bar) {
        _bar = [[UISearchBar alloc]initWithFrame:frame(80, StatusBarHeight + 7,APPWIDTH-160, NavigationBarHeight - 14)];
        _bar.backgroundColor = WhiteColor;
        _bar.barStyle = UIBarStyleDefault;
        _bar.tintColor = LineBg;
        _bar.translucent = YES;
        [_bar setBorder:LineBg width:0.5];
        [_bar setRadius:_bar.height/2.0];
        _bar.delegate = self;
        _bar.placeholder=@"搜索关键字找到我的好友";
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if ([_bar respondsToSelector:@selector(barTintColor)]) {
            float iosversion7_1 = 7.1;
            
            if (version >= iosversion7_1)        {
                
                [[[[_bar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
                [_bar setBackgroundColor:[UIColor clearColor]];
            }
            else {            //iOS7.0
                
                [_bar setBarTintColor:[UIColor clearColor]];
                [_bar setBackgroundColor:[UIColor clearColor]];
            }
        }
    }
    return _bar;
}

//我的申请人脉点击事件
-(void)applyForBtnClicked:(UIButton *)sender
{
    PushView(self, allocAndInit(FnyApplyForVC));
}
- (void)buttonAction:(UIButton *)sender
{
    PopView(self);
}
- (void)netWorkRefresh:(BOOL)isRefresh andIsLoadMoreData:(BOOL)isMoreLoadMoreData isShouldClearData:(BOOL)isShouldClearData//加载数据
{
    NSMutableDictionary *param = [Parameter parameterWithSessicon];
    [param setObject:@(_page) forKey:@"page"];
    [param setObject:_keyword forKey:@"keyword"];

//    NSLog(@"param====%@",param);
    [XLDataService putWithUrl:myConnectionsURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (isRefresh) {
            [[ToolManager shareInstance] endHeaderWithRefreshing:_yrTab];
        }
        if (isMoreLoadMoreData) {
            [[ToolManager shareInstance] endFooterWithRefreshing:_yrTab];
        }
        if (dataObj) {
//            NSLog(@"Mydataobj====%@",dataObj);
            MeetingModel *modal = [MeetingModel mj_objectWithKeyValues:dataObj];
            if (_page ==1) {
                [[ToolManager shareInstance] moreDataStatus:_yrTab];
            }
            if (!modal.datas||modal.datas.count==0) {
                
                [[ToolManager shareInstance] noMoreDataStatus:_yrTab];
            }
            if (modal.rtcode ==1) {
                if (isShouldClearData) {
                    [self.nearByManArr removeAllObjects];
                }
                for (MeetingData *data in modal.datas) {
                    [self.nearByManArr addObject:[[MeetingCellLayout alloc]initCellLayoutWithModel:data andMeetBtn:NO andMessageBtn:YES andOprationBtn:NO andTime:NO andReward:NO]];
                    
                                  }
                [_yrTab reloadData];
                [[ToolManager shareInstance] dismiss];
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

-(void)addTabView
{
    if (!_yrTab) {
            _yrTab=[[UITableView alloc]initWithFrame:CGRectMake(0,StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT-(StatusBarHeight + NavigationBarHeight)) style:UITableViewStyleGrouped];
    _yrTab.delegate=self;
    _yrTab.dataSource=self;
    _yrTab.backgroundColor=[UIColor clearColor];
    _yrTab.tableFooterView=[[UIView alloc]init];
    _yrTab.separatorStyle=UITableViewCellSeparatorStyleNone;//去掉cell间的白线
    [[ToolManager shareInstance] scrollView:_yrTab headerWithRefreshingBlock:^{
        _page =1;
        [self netWorkRefresh:YES andIsLoadMoreData:NO isShouldClearData:YES];
        [self networkForRecommend];
    }];
    [[ToolManager shareInstance] scrollView:_yrTab footerWithRefreshingBlock:^{
        _page ++;
        [self netWorkRefresh:NO andIsLoadMoreData:YES isShouldClearData:NO];
        
    }];
    [self.view addSubview:_yrTab];
}
    if (self.precommendArr.count>=3) {
        _yrTab.frame=CGRectMake(0,StatusBarHeight + NavigationBarHeight+51, APPWIDTH, APPHEIGHT-(StatusBarHeight + NavigationBarHeight+51));
        _yrTab.tableHeaderView=self.mainRecommendV;
    }else{
        _yrTab.frame=CGRectMake(0,StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT-(StatusBarHeight + NavigationBarHeight));
        _yrTab.tableHeaderView=nil;
    }
}
#pragma mark - 推荐人脉
-(void)networkForRecommend
{
    [self.precommendArr removeAllObjects];
    NSMutableDictionary *param = [Parameter parameterWithSessicon];
//    NSLog(@"param====%@",param);
    [XLDataService postWithUrl:connetionReplacementURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (dataObj) {
//            NSLog(@"Mydataobj====%@",dataObj);
            MeetingModel *modal = [MeetingModel mj_objectWithKeyValues:dataObj];
            if (modal.rtcode ==1) {
                
                for (MeetingData* data in modal.datas) {
                    [self.precommendArr addObject:data];
                }
                if (self.precommendArr.count>=3) {
                    _recommendView.hidden=NO;
                    _recommendLab.hidden=NO;
                    _recommendBtn.hidden=NO;
                    MeetingData *data1=self.precommendArr[0];
                    [[ToolManager shareInstance]imageView:self.smallHeadV1 setImageWithURL:data1.imgurl placeholderType:PlaceholderTypeUserHead];
                    self.smallHeadV1.tag=[data1.meetId intValue];
                    MeetingData *data2=self.precommendArr[1];
                    [[ToolManager shareInstance]imageView:self.smallHeadV2 setImageWithURL:data2.imgurl placeholderType:PlaceholderTypeUserHead];
                    self.smallHeadV2.tag=[data2.meetId intValue];
                    MeetingData *data3=self.precommendArr[2];
                    [[ToolManager shareInstance]imageView:self.smallHeadV3 setImageWithURL:data3.imgurl placeholderType:PlaceholderTypeUserHead];
                    self.smallHeadV3.tag=[data3.meetId intValue];
                    
                    [self btnOnClick];
                    [self addTabView];
                }else{
                    _recommendView.hidden=YES;
                    _recommendLab.hidden=YES;
                    _recommendBtn.hidden=YES;
                    _smallHeadV1.alpha=0;
                    _smallHeadV2.alpha=0;
                    _smallHeadV3.alpha=0;
                }
            }else{
                _recommendBtn.userInteractionEnabled=YES;
            }
        }
    }];

}

-(void)addRecommendConnections
{
    if (!_recommendView) {
        _recommendView=[[UIView alloc]init];
    }
    _recommendView.frame=CGRectMake(0, NavigationBarHeight+StatusBarHeight, APPWIDTH, 50);
    _recommendView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_recommendView];
    
    _recommendLab=[[UILabel alloc]initWithFrame:CGRectMake(10, 17, APPWIDTH/2.0, 16)];
    _recommendLab.font=[UIFont systemFontOfSize:16];
    _recommendLab.text=@"推荐人脉";
    [_recommendView addSubview:_recommendLab];
    
    _smallHeadV1 = [[UIButton alloc]initWithFrame:CGRectMake(90, 10, 30, 30)];
    [_smallHeadV1 addTarget:self action:@selector(smallHeadVBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_recommendView addSubview:_smallHeadV1];

    _smallHeadV2 = [[UIButton alloc]initWithFrame:CGRectMake(130, 10, 30, 30)];
    [_smallHeadV2 addTarget:self action:@selector(smallHeadVBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_recommendView addSubview:_smallHeadV2];
    
    _smallHeadV3 = [[UIButton alloc]initWithFrame:CGRectMake(170, 10, 30, 30)];
    [_smallHeadV3 addTarget:self action:@selector(smallHeadVBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_recommendView addSubview:_smallHeadV3];
    
    _smallHeadV1.alpha=0;
    _smallHeadV2.alpha=0;
    _smallHeadV3.alpha=0;
    UIImage *image= [UIImage imageNamed:@"Fny_shuaxin"];
    _recommendBtn=[[BaseButton alloc]initWithFrame:frame(APPWIDTH-90, 10, 70, 30) setTitle:@"换一换" titleSize:24*SpacedFonts titleColor:BlackTitleColor backgroundImage:nil iconImage:image highlightImage: image setTitleOrgin:CGPointMake((30 - 24*SpacedFonts)/2.0,11) setImageOrgin:CGPointMake((30 - image.size.height)/2.0,7) inView:_recommendView];
    _recommendBtn.layer.borderWidth=0.5;
    _recommendBtn.layer.cornerRadius=15;
    _recommendBtn.layer.borderColor=[UIColor lightGrayColor].CGColor;
    __weak typeof(self) weakSelf = self;
    _recommendBtn.didClickBtnBlock=^{
        [weakSelf addAnimal:weakSelf.recommendBtn.imageView];
        [weakSelf networkForRecommend];
        weakSelf.recommendBtn.userInteractionEnabled=NO;
        
    };
    
}
-(void)smallHeadVBtnClick:(UIButton *)btn
{
    MyDetialViewController *myDetialViewCT=allocAndInit(MyDetialViewController);
    myDetialViewCT.userID=[NSString stringWithFormat:@"%ld", btn.tag];
    [self.navigationController pushViewController:myDetialViewCT animated:YES];

}

-(UIView *)mainRecommendV
{
    if(!_mainRecommendV){
    _mainRecommendV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, APPWIDTH, (APPWIDTH/2-50)/2.0+106)];
    _mainRecommendV.backgroundColor=[UIColor whiteColor];
    
    _reView1=[[RecommendView alloc]initWithFrame:CGRectMake(15, 15, (APPWIDTH-60)/3.0, _mainRecommendV.height-30)];
    _reView2=[[RecommendView alloc]initWithFrame:CGRectMake(15+(APPWIDTH -60)/3.0+15, 15, (APPWIDTH-60)/3.0, _mainRecommendV.height-30)];
    _reView3=[[RecommendView alloc]initWithFrame:CGRectMake(15+2*(APPWIDTH -60)/3.0+15*2, 15, (APPWIDTH-60)/3.0, _mainRecommendV.height-30)];
//
        _reView1.delegate=self;
        _reView2.delegate=self;
        _reView3.delegate=self;
        _reView1.data = self.precommendArr[0];
        _reView2.data = self.precommendArr[1];
        _reView3.data = self.precommendArr[2];

        _myJikeScrollView = ({
            JiKeScrollView *scrollView = [[JiKeScrollView alloc] initWithFrame:CGRectMake(0,15,APPWIDTH,_mainRecommendV.height-30)];
            [self.mainRecommendV addSubview:scrollView];
            scrollView;
        });
        MeetingData *data1=self.precommendArr[0];
        MeetingData *data2=self.precommendArr[1];
        MeetingData *data3=self.precommendArr[2];
        _myJikeScrollView.myFirstShowImageLinkArray = @[
                                                        @[data1.imgurl,data1.imgurl],
                                                        @[data2.imgurl,data2.imgurl],
                                                        @[data3.imgurl,data3.imgurl]
                                                        ];
        _myJikeScrollView.myFirstShowLabelDesArray = @[
                                                       @[data1.realname,data1.realname],
                                                       @[data2.realname,data2.realname],
                                                       @[data3.realname,data3.realname]
                                                       ];
        _myJikeScrollView.mySecondShowLabelDesArray = @[
                                                       @[data1.position,data1.position],
                                                       @[data2.position,data2.position],
                                                       @[data3.position,data3.position]
                                                       ];
//        [self btnOnClick];
        [_mainRecommendV addSubview:_reView1];
        [_mainRecommendV addSubview:_reView2];
        [_mainRecommendV addSubview:_reView3];
    }
    return _mainRecommendV;
    
}
- (void)btnOnClick {
    MeetingData *data1=self.precommendArr[0];
    MeetingData *data2=self.precommendArr[1];
    MeetingData *data3=self.precommendArr[2];
    _reView1.data = self.precommendArr[0];
    _reView2.data = self.precommendArr[1];
    _reView3.data = self.precommendArr[2];
    _tempImageLinkDataArray = @[
                                @[data1.imgurl,data2.imgurl,data3.imgurl],
                                ];
    _tempImageDesDataArray = @[
                               @[data1.realname,data2.realname,data3.realname],
                               ];
    _tempImageDesDataArray1 = @[
                                @[data1.position,data2.position,data3.position],
                                ];
    _myJikeScrollView.myNextShowImageLinkArray = self.tempImageLinkDataArray[0];
    _myJikeScrollView.myNextShowLabelDesArray = self.tempImageDesDataArray[0];
    _myJikeScrollView.myNextSecondShowLabelDesArray=self.tempImageDesDataArray1[0];


    _recommendBtn.userInteractionEnabled=YES;
}
-(void)addAnimal:(UIView*)aview
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1;
    
    [aview.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

#pragma mark -MeetHeadV 代理方法
- (void)pushView:(UIViewController *)viewC userInfo:(id)userInfo
{
    PushView(self, viewC);
    
}

- (CGFloat)randomRange:(NSInteger)range offset:(NSInteger)offset {
    
    return (CGFloat)(arc4random()%range + offset);
}
#pragma mark----tableview代理
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    MeetingCellLayout*layout =(MeetingCellLayout*)_nearByManArr[indexPath.row];
    
    return layout.cellHeight;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.nearByManArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * cellID =@"MeettingTableViewCellID";
    
    MeettingTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell=[[MeettingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor=[UIColor clearColor];
        
    }
    
    MeetingCellLayout *layout=self.nearByManArr[indexPath.row];
    [cell setCellLayout:layout];
    [cell setIndexPath:indexPath];
    MeetingData *data=layout.model;
    
    if(data.isappoint==1){
        [cell.meetingBtn setTitle:@"等待中" forState:UIControlStateNormal];
        cell.meetingBtn.titleLabel.font=[UIFont systemFontOfSize:13];
        [cell.meetingBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        cell.meetingBtn.backgroundColor=AppViewBGColor;
        cell.meetingBtn.userInteractionEnabled=NO;
    }else{
        cell.meetingBtn.backgroundColor=AppMainColor;
        [cell.meetingBtn setTitle:@"约见" forState:UIControlStateNormal];
        [cell.meetingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cell.meetingBtn.userInteractionEnabled=YES;
        cell.meetingBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    }
    
    [cell setDelegate:self];
    
    return cell;
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath//高亮
{
    return NO;
}

#pragma mark - MeettingTableViewCellDelegate 头像按钮点击
-(void)tableViewCellDidSeleteHeadImg:(LWImageStorage *)imageStoragen layout:(MeetingCellLayout *)layout
{
    MyDetialViewController *myDetialViewCT=allocAndInit(MyDetialViewController);
    MeetingData *data = layout.model;
    myDetialViewCT.userID=data.userid;
    [self.navigationController pushViewController:myDetialViewCT animated:YES];
}

//对话按钮的点击
- (void)tableViewCellDidSeleteMessageBtn:(UIButton *)btn andIndexPath:(NSIndexPath *)indexPath{
    GJGCChatFriendTalkModel *talk = [[GJGCChatFriendTalkModel alloc]init];
    talk.talkType = GJGCChatFriendTalkTypePrivate;
    MeetingCellLayout *layout=self.nearByManArr[indexPath.row];
    MeetingData *data =layout.model;
    
    talk.toId = data.userid;
    talk.toUserName = data.realname;
    
    GJGCChatFriendViewController *privateChat = [[GJGCChatFriendViewController alloc]initWithTalkInfo:talk];
    privateChat.type = MessageTypeNormlPage;
    [self.navigationController pushViewController:privateChat animated:YES];

}
#pragma mark - 删除人脉
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableDictionary *param = [Parameter parameterWithSessicon];
            [param setObject:@"relivev" forKey:@"conduct"];
        MeetingCellLayout *layout1=self.nearByManArr[indexPath.row];
        MeetingData *data=layout1.model;
        [param setObject:data.meetId forKey:@"id"];
        [[ToolManager shareInstance] showWithStatus];
        [XLDataService putWithUrl:conductConnectionsURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
            if (dataObj) {
                MeetingModel *model=[MeetingModel mj_objectWithKeyValues:dataObj];
                
                if (model.rtcode==1) {
                    
                    [self.nearByManArr removeObjectAtIndex:indexPath.row];
                    // Delete the row from the data source.
                    [_yrTab deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [[ToolManager shareInstance] showAlertMessage:@"删除人脉成功"];
                }
                else
                {
                    [[ToolManager shareInstance] showAlertMessage:model.rtmsg];
                }
            }else
            {
                [[ToolManager shareInstance] showInfoWithStatus];
                
            }
            
            
        }];

        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
#pragma mark - 推荐人脉点击
-(void)didSelectRecommendViewWithModel:(MeetingData *)data
{
    MyDetialViewController *myDetialViewCT=[MyDetialViewController new];
    myDetialViewCT.userID=data.meetId;
    [self.navigationController pushViewController:myDetialViewCT animated:YES];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    _keyword= searchBar.text;
    [_bar resignFirstResponder];
    [self netWorkRefresh:NO andIsLoadMoreData:NO isShouldClearData:YES];
    
}
#pragma mark - 推荐人脉动画效果
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_bar resignFirstResponder];
    if(_recommendView.hidden==YES){
        return;
    }
    if (scrollView.contentOffset.y>_mainRecommendV.height/2.0)   {
            [UIView animateWithDuration:1
                             animations:^{
                                 _smallHeadV1.alpha=1;
                                 _smallHeadV2.alpha=1;
                                 _smallHeadV3.alpha=1;

                             }completion:^(BOOL finished) {
                             }];
    }
    else if (scrollView.contentOffset.y<_mainRecommendV.height/2.0)
    {
            [UIView animateWithDuration:1
                             animations:^{
                                 _smallHeadV1.alpha=0;
                                 _smallHeadV2.alpha=0;
                                 _smallHeadV3.alpha=0;
                             }completion:^(BOOL finished) {
                                 
                             }];
        }
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
