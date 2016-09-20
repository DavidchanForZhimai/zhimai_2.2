//
//  ReadMeMostDetailViewController.m
//  Lebao
//
//  Created by David on 16/5/17.
//  Copyright © 2016年 David. All rights reserved.
//

#import "ReadMeMostDetailViewController.h"
#import "XLDataService.h"
#import "NSString+Extend.h"

#define AttentionsourceURL [NSString stringWithFormat:@"%@statistics/attentionsource",HttpURL]

#define cellH 40

@implementation ReadMeMostDetailModal

+ (NSDictionary *)mj_objectClassInArray
{
    
    return @{
             @"datas":@"ReadMeMostDetailData",
             };
    
}
@end
@implementation ReadMeMostDetailUserinfo


@end
@implementation ReadMeMostDetailData


@end

@interface ReadMeMostDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ReadMeMostDetailViewController

{
    
    UITableView *_payattenionDetailView;
    NSMutableArray *_payattenionDetailArray;
    int _page;
    int _nowPage;
    
    ReadMeMostDetailModal *modal;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _page = 1;
    [self navView];
    [self addTableView];
    [self netWorkIsRefresh:NO isLoadMore:NO shouldClearData:YES];
    
}
#pragma mark - Navi_View
- (void)navView
{
    
    [self navViewTitleAndBackBtn:@"阅读来源"];
    
}
- (void)netWorkIsRefresh:(BOOL)isRefresh isLoadMore:(BOOL)isLoadMore shouldClearData:(BOOL)shouldClearData
{
    if (_payattenionDetailArray.count ==1) {
        
        [[ToolManager shareInstance] showWithStatus];
    }
    NSMutableDictionary *parameter = [Parameter parameterWithSessicon];
    [parameter setObject:_openID forKey:@"openid"];
    [parameter setObject:@(_page) forKey:@"page"];
    
    [XLDataService postWithUrl:AttentionsourceURL param:parameter modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        //        NSLog(@"dataObj =%@",dataObj);
        if (isRefresh) {
            [[ToolManager shareInstance] endHeaderWithRefreshing:_payattenionDetailView];
            
        }
        if (isLoadMore) {
            [[ToolManager shareInstance] endFooterWithRefreshing:_payattenionDetailView];
        }
        if (dataObj) {
            modal = [ReadMeMostDetailModal mj_objectWithKeyValues:dataObj];
            if (modal.rtcode ==1) {
                //
                [[ToolManager shareInstance] dismiss];
                if (shouldClearData) {
                    [_payattenionDetailArray removeAllObjects];
                    ReadMeMostDetailData *data = allocAndInit(ReadMeMostDetailData);
                    data.title = @"标题";
                    data.createdate = @"发布时间";
                    data.readnum = @"阅读数";
                    data.readtime = @"阅读时间";
                    [_payattenionDetailArray addObject:data];
                }
                
                for (ReadMeMostDetailData *data in modal.datas) {
                    [_payattenionDetailArray addObject:data];
                }
                [_payattenionDetailView reloadData];
                if (_payattenionDetailArray.count ==0) {
                    [self isShowEmptyStatus:YES];
                }
                else
                {
                    [self isShowEmptyStatus:NO];
                }
                
                
                _nowPage = modal.page;
                if (_nowPage ==1) {
                    [[ToolManager shareInstance] moreDataStatus:_payattenionDetailView];
                }
                if (modal.allpage ==_nowPage) {
                    [[ToolManager shareInstance] noMoreDataStatus:_payattenionDetailView];
                }
            }
            else
            {
                [[ToolManager shareInstance] showInfoWithStatus:modal.rtmsg];
            }
            
        }
        else
        {
            [[ToolManager shareInstance] showInfoWithStatus];
        }
    }];
}

#pragma mark
#pragma mark - addTableView -
- (void)addTableView
{
    _payattenionDetailArray = [NSMutableArray new];
    ReadMeMostDetailData *data = allocAndInit(ReadMeMostDetailData);
    data.title = @"标题";
    data.createdate = @"发布时间";
    data.readnum = @"阅读数";
    data.readtime = @"阅读时间";
    [_payattenionDetailArray addObject:data];
    
    _payattenionDetailView =[[UITableView alloc]initWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)) style:UITableViewStyleGrouped];
    
    _payattenionDetailView.delegate = self;
    _payattenionDetailView.dataSource = self;
    _payattenionDetailView.backgroundColor =[UIColor clearColor];
    _payattenionDetailView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_payattenionDetailView];
    
    __weak ReadMeMostDetailViewController *weakSelf =self;
    [[ToolManager shareInstance] scrollView:_payattenionDetailView   headerWithRefreshingBlock:^{
        _page =1;
        [weakSelf netWorkIsRefresh:YES isLoadMore:NO shouldClearData:YES];
        
        
    }];
    [[ToolManager shareInstance] scrollView:_payattenionDetailView footerWithRefreshingBlock:^{
        _page =_nowPage +1;
        [weakSelf netWorkIsRefresh:NO isLoadMore:YES shouldClearData:NO];
    }];
    
    
    
}

#pragma mark
#pragma mark - TableViewDelegate TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _payattenionDetailArray.count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 150.0*ScreenMultiple + 45;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headView = allocAndInitWithFrame(UIView, frame(0, 0, APPWIDTH, 150*ScreenMultiple + 45));
    headView.backgroundColor =[UIColor whiteColor];
    UIImageView *imageViewbg =allocAndInitWithFrame(UIImageView, frame(0, 0, APPWIDTH, 150*ScreenMultiple));
    
    [[ToolManager shareInstance] imageView:imageViewbg setImageWithURL:modal.userinfo.background placeholderType:PlaceholderTypeUserBg];
    
    [headView addSubview:imageViewbg];
    
    UIImageView * _icon = allocAndInitWithFrame(UIImageView, frame((frameWidth(headView) -60)/2.0, 20*ScreenMultiple, 60, 60));
    
    
    [[ToolManager shareInstance] imageView:_icon setImageWithURL:modal.userinfo.headimgurl placeholderType:PlaceholderTypeUserHead];
    
    [_icon setRound];
    [headView addSubview:_icon];
    
    [UILabel createLabelWithFrame:frame(0, CGRectGetMaxY(_icon.frame) + 7*ScreenMultiple, frameWidth(headView), 28*SpacedFonts) text:modal.userinfo.nickname fontSize:28*SpacedFonts textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter inView:headView];
    
    
    UIView *_recommendedView =allocAndInitWithFrame(UIView, frame(0, frameHeight(headView) - 40*ScreenMultiple -45, frameWidth(headView), 40*ScreenMultiple));
    _recommendedView.backgroundColor = [UIColor clearColor];
    [headView addSubview:_recommendedView];
    
    
    [UILabel createLabelWithFrame:frame(0, 0, frameWidth(headView)/2.0, 40*ScreenMultiple) text:[NSString stringWithFormat:@"总计阅读 %@ 篇",modal.userinfo.readcovercount] fontSize:24*SpacedFonts textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter inView:_recommendedView];
    
    UILabel *centerLine = allocAndInitWithFrame(UILabel, frame(frameWidth(headView)/2.0, 10*ScreenMultiple, 1.0, 20*ScreenMultiple));
    centerLine.backgroundColor =[UIColor whiteColor];
    [_recommendedView addSubview:centerLine];
    
    
    [UILabel createLabelWithFrame:frame(frameWidth(headView)/2.0, 0, frameWidth(headView)/2.0, 40*ScreenMultiple) text:[NSString stringWithFormat:@"总计看了 %@ 次",modal.userinfo.readcount] fontSize:24*SpacedFonts textColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter inView:_recommendedView];
    
    NSString *text = [NSString stringWithFormat:@"%@ 阅读的内容",modal.userinfo.nickname];
    UILabel *lookLb = [UILabel createLabelWithFrame:frame(10, 150*ScreenMultiple, frameWidth(headView)/2.0, 45) text:text fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentCenter inView:headView];
    if (![modal.userinfo.nickname isEqualToString:@""]&&modal.userinfo.nickname) {
//        NSLog(@"modal.userinfo.nickname %@",modal.userinfo.nickname);
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
        [str addAttribute:NSForegroundColorAttributeName value:AppMainColor range:[text rangeOfString:modal.userinfo.nickname]];
        lookLb.attributedText = str;
    }
    
    
    return headView;
    
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    return allocAndInit(UIView);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return cellH ;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID =@"ReadMeMostDetailCell";
    ReadMeMostDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ReadMeMostDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellHeight:cellH cellWidth:frameWidth(_payattenionDetailView
                                                                                                                                                     )];
        UIView *view = allocAndInit(UIView);
        view.backgroundColor = self.view
        .backgroundColor;
        cell.selectedBackgroundView =view;
        
    }
    ReadMeMostDetailData *data = _payattenionDetailArray[indexPath.row];
    BOOL isFirst;
    if (indexPath.row ==0) {
        isFirst = YES;
    }
    else
    {
        isFirst = NO;
    }
    [cell setModel:data isFirst:isFirst];
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark
#pragma mark - buttonAction -
- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag ==NavViewButtonActionNavLeftBtnTag ) {
        PopView(self);
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
@implementation ReadMeMostDetailCell
{
    
    UILabel    *_title;
    UILabel *_releaseTime;
    UILabel  *_readTime;
    UILabel  *_num;
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth;
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        UIView *cell = allocAndInitWithFrame(UIView, frame(10, 0, cellWidth - 20, cellHeight));
        [cell setBorder:LineBg width:0.5];
        [self addSubview:cell];
        _title =[UILabel createLabelWithFrame:frame(0, 0, frameWidth(cell)/4, cellHeight) text:@"" fontSize:22*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:cell];
        [_title setBorder:LineBg width:0.5];
        
        _releaseTime =[UILabel createLabelWithFrame:frame(CGRectGetMaxX(_title.frame),0, frameWidth(_title), cellHeight) text:@"" fontSize:22*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:cell];
        [_releaseTime setBorder:LineBg width:0.5];
        
        _readTime =[UILabel createLabelWithFrame:frame(CGRectGetMaxX(_releaseTime.frame),0 ,  frameWidth(_title) , cellHeight) text:@"" fontSize:22*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:cell];
        [_readTime setBorder:LineBg width:0.5];
        
        _num =[UILabel createLabelWithFrame:frame(CGRectGetMaxX(_readTime.frame),0,frameWidth(_title) , cellHeight) text:@"" fontSize:22*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:cell];
        [_num setBorder:LineBg width:0.5];
    }
    return self;
    
}
- (void)setModel:(ReadMeMostDetailData *)model  isFirst:(BOOL)isFirst
{
    if (isFirst) {
        _title.textColor = _readTime.textColor = _releaseTime.textColor = _num.textColor = BlackTitleColor;
        _readTime.text = model.readtime;
        _releaseTime.text = model.createdate;
    }
    else
    {
        _title.textColor = _readTime.textColor = _releaseTime.textColor = _num.textColor = LightBlackTitleColor;
        
        _readTime.text = [model.readtime timeformatString:@"yyyy-MM-dd"];
        _releaseTime.text = [model.createdate timeformatString:@"yyyy-MM-dd"];
    }
    _title.text = model.title;
    _num.text = model.readnum;
}


@end