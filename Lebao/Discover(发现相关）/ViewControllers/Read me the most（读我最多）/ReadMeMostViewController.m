//
//  ReadMeMostViewController.m
//  Lebao
//
//  Created by David on 16/5/17.
//  Copyright © 2016年 David. All rights reserved.
//

#import "ReadMeMostViewController.h"
#import "ReadMeMostDetailViewController.h"
#import "XLDataService.h"
#define cellH 65
//关注我的 URL:appinterface/attention
#define AttentionURL [NSString stringWithFormat:@"%@statistics/attention",HttpURL]

@implementation ReadMeMostModal

+ (NSDictionary *)mj_objectClassInArray
{
    
    return @{
             @"datas":@"ReadMeMostData",
             };
    
}
@end
@implementation ReadMeMostData


@end

@interface ReadMeMostViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation ReadMeMostViewController

{
    
    UITableView *_payattentiontoMeView;
    NSMutableArray *_payattentiontoMeArray;
    int _page;
    int _nowPage;
    
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
    
    [self navViewTitleAndBackBtn:@"读我最多"];
    
}
- (void)netWorkIsRefresh:(BOOL)isRefresh isLoadMore:(BOOL)isLoadMore shouldClearData:(BOOL)shouldClearData
{
    if (_payattentiontoMeArray.count ==0) {
        
        [[ToolManager shareInstance] showWithStatus];
    }
    NSMutableDictionary *parameter = [Parameter parameterWithSessicon];
    [parameter setObject:@(_page) forKey:@"page"];
    [XLDataService postWithUrl:AttentionURL param:parameter modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        //        NSLog(@"dataObj =%@",dataObj);
        if (isRefresh) {
            [[ToolManager shareInstance] endHeaderWithRefreshing:_payattentiontoMeView];
            
        }
        if (isLoadMore) {
            [[ToolManager shareInstance] endFooterWithRefreshing:_payattentiontoMeView];
        }
        if (dataObj) {
            ReadMeMostModal *modal = [ReadMeMostModal mj_objectWithKeyValues:dataObj];
            if (modal.rtcode ==1) {
                
                [[ToolManager shareInstance] dismiss];
                if (shouldClearData) {
                    [_payattentiontoMeArray removeAllObjects];
                }
                
                for (ReadMeMostData *data in modal.datas) {
                    [_payattentiontoMeArray addObject:data];
                }
                [_payattentiontoMeView reloadData];
                if (_payattentiontoMeArray.count ==0) {
                    [self isShowEmptyStatus:YES];
                }
                else
                {
                    [self isShowEmptyStatus:NO];
                }
                
                
                _nowPage = modal.page;
                if (_nowPage ==1) {
                    [[ToolManager shareInstance] moreDataStatus:_payattentiontoMeView];
                }
                if (modal.allpage ==_nowPage) {
                    [[ToolManager shareInstance] noMoreDataStatus:_payattentiontoMeView];
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
    _payattentiontoMeArray = [NSMutableArray new];
    _payattentiontoMeView =[[UITableView alloc]initWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)) style:UITableViewStyleGrouped];
    
    _payattentiontoMeView.delegate = self;
    _payattentiontoMeView.dataSource = self;
    _payattentiontoMeView.backgroundColor =[UIColor clearColor];
    _payattentiontoMeView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    __weak ReadMeMostViewController *weakSelf =self;
    [[ToolManager shareInstance] scrollView:_payattentiontoMeView   headerWithRefreshingBlock:^{
        _page =1;
        [weakSelf netWorkIsRefresh:YES isLoadMore:NO shouldClearData:YES];
        
        
    }];
    [[ToolManager shareInstance] scrollView:_payattentiontoMeView footerWithRefreshingBlock:^{
        _page =_nowPage +1;
        [weakSelf netWorkIsRefresh:NO isLoadMore:YES shouldClearData:NO];
    }];
    [self.view addSubview:_payattentiontoMeView];
    
}

#pragma mark
#pragma mark - TableViewDelegate TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _payattentiontoMeArray.count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view =allocAndInitWithFrame(UIView, frame(0, 0, frameWidth(_payattentiontoMeView), 50));
    view.backgroundColor =[UIColor whiteColor];
    
    UIView *viewLine =allocAndInitWithFrame(UIView, frame(0, 0, frameWidth(_payattentiontoMeView), 10));
    viewLine.backgroundColor = AppViewBGColor;
    [view addSubview:viewLine];
    
    [UILabel createLabelWithFrame:frame(20*ScreenMultiple, 10,2*32*SpacedFonts, 40) text:@"昵称" fontSize:24*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:view];
    
    
    
    [UILabel createLabelWithFrame:frame(0, 10,APPWIDTH - 10*ScreenMultiple, 40) text:@"篇数" fontSize:24*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentRight inView:view];
    
    [UILabel CreateLineFrame:frame(0, 49.5, APPWIDTH, 0.5) inView:view];
    
    return view;
    
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
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
    
    static NSString *cellID =@"ReadMeMostCell";
    ReadMeMostCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ReadMeMostCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellHeight:cellH cellWidth:frameWidth(_payattentiontoMeView
                                                                                                                                                   )];
        UIView *view = allocAndInit(UIView);
        view.backgroundColor = self.view
        .backgroundColor;
        cell.selectedBackgroundView =view;
        
    }
    ReadMeMostData *data = _payattentiontoMeArray[indexPath.row];
    BOOL isLast;
    if (indexPath.row == _payattentiontoMeArray.count -1) {
        isLast =YES;
    }
    else
    {
        isLast = NO;
    }
    [cell setModel:data isLast:isLast];
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReadMeMostData *data = _payattentiontoMeArray[indexPath.row];
    ReadMeMostDetailViewController *payattenionDetailViewController =allocAndInit(ReadMeMostDetailViewController);
    payattenionDetailViewController.openID =data.openid;
    PushView(self,payattenionDetailViewController );
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

@implementation ReadMeMostCell
{
    UIImageView *_icon;
    UILabel *_name;
    UILabel  *_readTimes;
    DWLable *_desc;
    UILabel *line;
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth;
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _icon = allocAndInitWithFrame(UIImageView, frame(10, (cellHeight -50)/2.0, 50, 50));
        [_icon setRound];
        [self addSubview:_icon];
        
        _name =[UILabel createLabelWithFrame:frame(CGRectGetMaxX(_icon.frame) + 12.5, 0, cellWidth/2.0, cellHeight/2.0) text:@"" fontSize:24*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:self];
        
        
        _desc =[DWLable createLabelWithFrame:frame(frameX(_name) , CGRectGetMaxY(_name.frame), cellWidth - 40 - frameX(_name) , cellHeight/2.0) text:@"" fontSize:24*SpacedFonts textColor:lightGrayTitleColor textAlignment:NSTextAlignmentLeft inView:self];
        _desc.verticalAlignment = VerticalAlignmentTop;
        
        _readTimes =[UILabel createLabelWithFrame:frame(0 , 0, cellWidth - 10 , cellHeight) text:@"" fontSize:24*SpacedFonts textColor:AppMainColor textAlignment:NSTextAlignmentRight inView:self];
        
        line =  [UILabel CreateLineFrame:frame(70, cellHeight- 0.5, cellWidth -70, 0.5) inView:self];
        
    }
    return self;
    
}
- (void)setModel:(ReadMeMostData *)model isLast:(BOOL)isLast
{
    [[ToolManager shareInstance] imageView:_icon setImageWithURL:model.imgrul placeholderType:PlaceholderTypeUserHead];
    
    _name.text = model.nickname;
    _readTimes.text =model.number;
    _desc.text = [NSString stringWithFormat:@"最近阅读：%@", model.title];
    
    if (isLast) {
        line.hidden = YES;
    }
    else
    {
        line.hidden = NO;
    }
    
}

@end
