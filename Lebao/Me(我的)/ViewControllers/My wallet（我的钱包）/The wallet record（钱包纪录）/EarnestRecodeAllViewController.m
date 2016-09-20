//
//  EarnestRecodeAllViewController.m
//  Lebao
//
//  Created by David on 16/1/27.
//  Copyright © 2016年 David. All rights reserved.
//

#import "EarnestRecodeAllViewController.h"
#import "XLDataService.h"
#import "NSString+Extend.h"
#define cellH 53

@implementation EarnestRecodeAllData
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}


@end
@implementation EarnestRecodeAllModal
+ (NSDictionary *)mj_objectClassInArray
{
    
    return @{
             @"datas":@"EarnestRecodeAllData",
             };
    
}

@end
@interface EarnestRecodeAllViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation EarnestRecodeAllViewController

{
    UITableView *_earnestRecodeView;
    NSMutableArray *_earnestRecodeArray;
    int _page;
    int _nowpage;

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _page =1;
    [self addTableView];
    [self netWork:NO isFooter:NO isShouldClear:NO];
    
    
}

#pragma mark
#pragma mark - addTableView -
- (void)addTableView
{
    _earnestRecodeArray = allocAndInit(NSMutableArray);
    _earnestRecodeView =[[UITableView alloc]initWithFrame:frame(0, 0, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight + 35)) style:UITableViewStyleGrouped];
    _earnestRecodeView.delegate = self;
    _earnestRecodeView.dataSource = self;
    _earnestRecodeView.backgroundColor =[UIColor clearColor];
    _earnestRecodeView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_earnestRecodeView];
    
    
    __weak EarnestRecodeAllViewController *weakSelf =self;
    [[ToolManager shareInstance] scrollView:_earnestRecodeView headerWithRefreshingBlock:^{
        _page = 1;
        [[ToolManager shareInstance] moreDataStatus:_earnestRecodeView];
        [weakSelf netWork:YES isFooter:NO isShouldClear:YES];
        
    }];
    
    [[ToolManager shareInstance] scrollView:_earnestRecodeView footerWithRefreshingBlock:^{
        
        _page = _nowpage + 1;
        [weakSelf netWork:NO isFooter:YES isShouldClear:NO];
        
        
    }];
    
}
#pragma mark
#pragma mark - netWork-
- (void)netWork:(BOOL)isRefresh isFooter:(BOOL)isFooter isShouldClear:(BOOL)isShouldClear
{
    
    NSMutableDictionary *parame = [Parameter parameterWithSessicon];
    [parame setObject:@(_page) forKey:Page];
    NSString *url = [NSString stringWithFormat:@"%@user/record",HttpURL];
   
    if (_recodeType == EarnestRecodeAll)
    {
        [parame setObject:@"all" forKey:Type];
    }
    else if (_recodeType == EarnestRecodeIncome)
    {
        [parame setObject:@"income" forKey:Type];
    }
    else if (_recodeType == EarnestRecodePay)
    {
        [parame setObject:@"debit" forKey:Type];
    }
    
    if (_earnestRecodeArray.count==0) {
        [[ToolManager shareInstance] showWithStatus];
    }
    [XLDataService postWithUrl:url param:parame modelClass:nil responseBlock:^(id dataObj, NSError *error) {
       
        
        if (isRefresh) {
            [[ToolManager shareInstance]endHeaderWithRefreshing
             :_earnestRecodeView];
        }
        if (isFooter) {
            
            [[ToolManager shareInstance]endFooterWithRefreshing:_earnestRecodeView];
        }
        if (dataObj) {
            EarnestRecodeAllModal *modal = [EarnestRecodeAllModal mj_objectWithKeyValues:dataObj];
            if (modal.rtcode==1) {
                 [[ToolManager shareInstance] dismiss];
                if (isShouldClear) {
                    [_earnestRecodeArray removeAllObjects];
                }
                _nowpage = modal.page;
                
                if (_nowpage ==1) {
                    [[ToolManager shareInstance] moreDataStatus:_earnestRecodeView];
                }
                if (_nowpage == modal.allpage) {
                    
                    [[ToolManager shareInstance] noMoreDataStatus:_earnestRecodeView];
                }
                
                for (EarnestRecodeAllData *earnestRecodeAllData in modal.datas) {
                    
                    [_earnestRecodeArray addObject:earnestRecodeAllData];
                }
                [_earnestRecodeView reloadData];
                
 
            }
            else
            {
                [[ToolManager shareInstance] showInfoWithStatus:modal.rtmsg];
            }
            
           
        
            if (_earnestRecodeArray.count==0) {
                [self isShowEmptyStatus:YES];
            }
            else
            {
                [self isShowEmptyStatus:NO];
                
            }
            
            [_earnestRecodeView reloadData];
        }
        else
        {
            [[ToolManager shareInstance] showInfoWithStatus];
        }
        
    }];
    
    
    
}

#pragma mark
#pragma mark - TableViewDelegate TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _earnestRecodeArray.count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return allocAndInit(UIView);
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
   
    
    return cellH;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

        static NSString *cellID =@"EarnestRecodeAllView ";
        EarnestRecodeAllView *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[EarnestRecodeAllView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellHeight:cellH cellWidth:frameWidth(_earnestRecodeView)];
           
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
    
    [cell setmodal:_earnestRecodeArray[indexPath.row]];
        return cell;
    
    
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

@implementation EarnestRecodeAllView
{
    UILabel *title;
    UILabel *desc;
    UILabel *money;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        title = [UILabel createLabelWithFrame:frame(10, 5, cellWidth - 80, (cellHeight - 10)/2.0) text:@"" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:self];
        
        desc = [UILabel createLabelWithFrame:frame(frameX(title), CGRectGetMaxY(title.frame), frameWidth(title), frameHeight(title)) text:@"" fontSize:28*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:self];
        
        money = [UILabel createLabelWithFrame:frame(CGRectGetMaxX(desc.frame) + 5, 0,cellWidth - (CGRectGetMaxX(desc.frame) + 15),cellHeight) text:@"" fontSize:28*SpacedFonts textColor:AppMainColor textAlignment:NSTextAlignmentRight inView:self];
        [UILabel CreateLineFrame:frame(0, cellHeight - 0.5, cellWidth, 0.5) inView:self];
    }
    return self;
}
- (void)setmodal:(EarnestRecodeAllData *)modal
{
    title.text = modal.purpose;
    desc.text = [modal.actiontime timeformatString:@"yyyy-MM-dd HH:mm"];
    money.text = modal.money;
    
    
}
@end
    

