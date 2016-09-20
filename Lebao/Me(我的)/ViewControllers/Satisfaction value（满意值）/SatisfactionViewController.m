//
//  SatisfactionViewController.m
//  Lebao
//
//  Created by David on 16/5/20.
//  Copyright © 2016年 David. All rights reserved.
//

#import "SatisfactionViewController.h"
#import "XLDataService.h"
#import "NSString+Extend.h"
#import "MyLQDetailVC.h"
#import "MyXSDetailVC.h"
#import "XianSuoDetailVC.h"
#define CellH 104
#define IntegralURL [NSString stringWithFormat:@"%@user/integral",HttpURL]
@implementation SatisfactionModal
+ (NSDictionary *)mj_objectClassInArray
{
    
    return @{
             @"datas":@"SatisfactionData",
             };
    
}

@end

@implementation SatisfactionData

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}
@end

@interface SatisfactionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *satisfactionView;
@property(nonatomic,strong)NSMutableArray *satisfactionArray;
@property(nonatomic,assign)int page;
@property(nonatomic,assign)int nowpage;
@end

@implementation SatisfactionViewController
{
    SatisfactionModal *modal;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navViewTitleAndBackBtn:@"满意度"];
    [self tableView];
    [self netWork:NO isFooter:NO isShouldClear:NO];
}
- (void)buttonAction:(UIButton *)sender
{
    PopView(self);
}

#pragma mark
#pragma mark - netWork-
- (void)netWork:(BOOL)isRefresh isFooter:(BOOL)isFooter isShouldClear:(BOOL)isShouldClear
{
    
    NSMutableDictionary *parame = [Parameter parameterWithSessicon];
    [parame setObject:@(_page) forKey:Page];
    if (_satisfactionArray.count ==0) {
        [[ToolManager shareInstance] showWithStatus];
    }
    [XLDataService postWithUrl:IntegralURL param:parame modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        
        if (isRefresh) {
            [[ToolManager shareInstance]endHeaderWithRefreshing
             :_satisfactionView];
            [[ToolManager shareInstance]endHeaderWithRefreshing
             :_satisfactionView];
        }
        if (isFooter) {
            
            [[ToolManager shareInstance]endFooterWithRefreshing:_satisfactionView];
        }
        
        if (dataObj) {
            modal = [SatisfactionModal mj_objectWithKeyValues:dataObj];
            
            
            if (modal.rtcode ==1) {
                if (isShouldClear) {
                    [_satisfactionArray removeAllObjects];
                }
                
                _nowpage = (int) modal.page ;
                
                if (_nowpage ==1) {
                    [[ToolManager shareInstance] moreDataStatus:_satisfactionView];
                }
                if (modal.allpage==_nowpage) {
                    
                    [[ToolManager shareInstance] noMoreDataStatus:_satisfactionView];
                }
                
                for (SatisfactionData *data in modal.datas) {
                
                    [_satisfactionArray addObject:data];
                }
                
                [_satisfactionView reloadData];
      
                
                [[ToolManager shareInstance] dismiss];
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

- (void)tableView
{
    _satisfactionArray = allocAndInit(NSMutableArray);
    _satisfactionView = [[UITableView alloc]initWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH,APPHEIGHT - (StatusBarHeight + NavigationBarHeight)) style:UITableViewStyleGrouped];
    _satisfactionView.delegate = self;
    _satisfactionView.dataSource = self;
    _satisfactionView.separatorStyle = 0;
    _satisfactionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_satisfactionView];
    
    __weak SatisfactionViewController *weakSelf = self;
    [[ToolManager shareInstance] scrollView:_satisfactionView footerWithRefreshingBlock:^{
        
        _page = _nowpage + 1;
        
        [weakSelf netWork:NO isFooter:YES isShouldClear:NO];
    }];
    
    [[ToolManager shareInstance] scrollView:_satisfactionView headerWithRefreshingBlock:^{
        _page = 1;
         [weakSelf netWork:YES isFooter:NO isShouldClear:YES];
    }];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return _satisfactionArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellH;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 200 - (56 - 56*ScreenMultiple);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = allocAndInitWithFrame(UIView, frame(0, 0, frameWidth(_satisfactionView), 200));
    headerView.backgroundColor = [UIColor whiteColor];
    UIView *header = allocAndInitWithFrame(UIView, frame(0, 0, frameWidth(headerView), 10));
    header.backgroundColor = AppViewBGColor;
    [headerView addSubview:header];
    
    UILabel *satisfactionValue = allocAndInitWithFrame(UILabel, frame(0, 44, frameWidth(headerView), 33));
    satisfactionValue.textAlignment = NSTextAlignmentCenter;
    satisfactionValue.text =modal.regrade?[NSString stringWithFormat:@"%i分",modal.regrade]:@"0分";
    satisfactionValue.textColor = [UIColor colorWithRed:0.9804 green:0.4353 blue:0.1765 alpha:1.0];
    satisfactionValue.font = [UIFont boldSystemFontOfSize:19.0];
    NSMutableAttributedString *satisfactionValuestr = [[NSMutableAttributedString alloc] initWithString:satisfactionValue.text];
    [satisfactionValuestr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:33.0] range:[satisfactionValue.text rangeOfString:modal.regrade?[NSString stringWithFormat:@"%i",modal.regrade]:@"0"]];
    satisfactionValue.attributedText = satisfactionValuestr;
    [headerView addSubview:satisfactionValue];
    
    [UILabel createLabelWithFrame:frame(0, CGRectGetMaxY(satisfactionValue.frame) + 10, frameWidth(headerView), 24*SpacedFonts) text:modal.satisfied?[NSString stringWithFormat:@"满意%@次      不满意%@次",modal.satisfied,modal.nosatisfied]:@"满意0次      不满意0次" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:headerView];
    
    UILabel *hasRelease = [UILabel createLabelWithFrame:frame(22*ScreenMultiple,24*SpacedFonts +  35 + CGRectGetMaxY(satisfactionValue.frame), 56*ScreenMultiple, 56*ScreenMultiple) text:modal.fcount?[NSString stringWithFormat:@"%@\n已发布",modal.fcount]:@"0\n已发布" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:headerView];
    [hasRelease setBorder:LineBg width:1.0];
    [hasRelease setRound];
    hasRelease.numberOfLines = 0;
    NSMutableAttributedString *hasReleasestr = [[NSMutableAttributedString alloc] initWithString:hasRelease.text];
    [hasReleasestr addAttribute:NSForegroundColorAttributeName value:BlackTitleColor range:[hasRelease.text rangeOfString:modal.fcount?[NSString stringWithFormat:@"%@",modal.fcount]:@"0"]];
    hasRelease.attributedText = hasReleasestr;
    
    UILabel *hasGet = [UILabel createLabelWithFrame:frame(CGRectGetMaxX(hasRelease.frame) + 53*ScreenMultiple, frameY(hasRelease), frameWidth(hasRelease), frameHeight(hasRelease)) text:modal.lcount?[NSString stringWithFormat:@"%@\n已领取",modal.lcount]:@"0\n已领取" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:headerView];
    [hasGet setBorder:LineBg width:1.0];
    [hasGet setRound];
    hasGet.numberOfLines = 0;
    NSMutableAttributedString *hasGetstr = [[NSMutableAttributedString alloc] initWithString:hasGet.text];
    [hasGetstr addAttribute:NSForegroundColorAttributeName value:BlackTitleColor range:[hasGet.text rangeOfString:modal.lcount?[NSString stringWithFormat:@"%@\n",modal.lcount]:@"0\n"]];
    hasGet.attributedText = hasGetstr;
    
    
    UILabel *hasSelected = [UILabel createLabelWithFrame:frame(CGRectGetMaxX(hasGet.frame) + 53*ScreenMultiple, frameY(hasGet), frameWidth(hasGet), frameHeight(hasGet)) text:modal.bcount?[NSString stringWithFormat:@"%@\n被选中",modal.bcount]:@"0\n被选中" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:headerView];
    [hasSelected setBorder:LineBg width:1.0];
    [hasSelected setRound];
    hasSelected.numberOfLines = 0;
    NSMutableAttributedString *hasSelectedstr = [[NSMutableAttributedString alloc] initWithString:hasSelected.text];
    [hasSelectedstr addAttribute:NSForegroundColorAttributeName value:BlackTitleColor range:[hasSelected.text rangeOfString:modal.bcount?[NSString stringWithFormat:@"%@\n",modal.bcount]:@"0\n" ]];
    hasSelected.attributedText = hasSelectedstr;
    
    
    BaseButton *headerViewEeven =[[BaseButton alloc]initWithFrame:frame(frameWidth(headerView) - 40, 10, 40, 40) backgroundImage:nil iconImage:[UIImage imageNamed:@"manyidushuoming"] highlightImage:nil inView:headerView];
   
    headerViewEeven.didClickBtnBlock = ^
    {
        [[ToolManager shareInstance] showAlertViewTitle:@"满意度说明" contentText:modal.desc? modal.desc:@"满意度说明" showAlertViewBlcok:^{
            
        }];
    };
    return headerView;
    
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"SatisfactionCell";
    SatisfactionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
   
    if (!cell) {
        cell = [[SatisfactionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellHight:CellH cellWidth:frameWidth(_satisfactionView)];
       
        cell.backgroundColor = [UIColor clearColor];
    }
    [cell setmodal:_satisfactionArray[indexPath.row]];
        return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SatisfactionData *data =  _satisfactionArray[indexPath.row];
    
    if (data.iscoop) {
        //跳转我的领取线索详情
        MyLQDetailVC* myLqV =  [[MyLQDetailVC alloc]init];
        myLqV.xiansuoID = data.ID;
        [self.navigationController pushViewController:myLqV animated:YES];
        return;
    }
    if (data.isself) {
        //跳转我的发布线索详情
        MyXSDetailVC* myxiansuoV =  [[MyXSDetailVC alloc]init];
        myxiansuoV.xiansuoID = data.ID;
        [self.navigationController pushViewController:myxiansuoV animated:YES];
        
        return;
    }
    XianSuoDetailVC * xiansuoV =  [[XianSuoDetailVC alloc]init];
    xiansuoV.xs_id = data.ID;
    [self.navigationController pushViewController:xiansuoV animated:YES];
    
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


@implementation SatisfactionCell
{
    UILabel *_satisfactionTitle;
    UILabel *_satisfactionAppraiser;
    UILabel *_satisfactionOrNot;
    UILabel *_satisfactionValue;
    UILabel *_satisfactionTime;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHight:(float)cellHight cellWidth:(float)cellWidth
{
    if ([self initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        UIView *cell =allocAndInitWithFrame(UIView, frame(10, 10, cellWidth - 20, cellHight - 10));
        cell.backgroundColor = WhiteColor;
        [self addSubview:cell];
        _satisfactionTitle = [UILabel createLabelWithFrame:frame(10, 0, cellWidth, 40) text:@"" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:cell];
        _satisfactionAppraiser = [UILabel createLabelWithFrame:frame(frameX(_satisfactionTitle),CGRectGetMaxY(_satisfactionTitle.frame) , 95*ScreenMultiple, 24*SpacedFonts) text:@"" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:cell];
        
        _satisfactionOrNot = [UILabel createLabelWithFrame:frame(CGRectGetMaxX(_satisfactionAppraiser.frame), frameY(_satisfactionAppraiser), 3*24*SpacedFonts, 24*SpacedFonts) text:@"" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:cell];
        
        _satisfactionValue = [UILabel createLabelWithFrame:frame(frameWidth(cell) - 40, 0, 20, 63) text:@"" fontSize:28*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentRight inView:cell];
        
        
        UIView *satisfactionBg = allocAndInitWithFrame(UIView, frame(0, frameHeight(cell) - 30, frameWidth(cell), 30));
        satisfactionBg.backgroundColor = [UIColor colorWithRed:0.9647 green:0.9647 blue:0.9725 alpha:1.0];
        [cell addSubview:satisfactionBg];
        
        _satisfactionTime = [UILabel createLabelWithFrame:frame(frameX(_satisfactionTitle), 0, frameWidth(cell)/2.0,  30) text:@"" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:satisfactionBg];
        
        [UILabel createLabelWithFrame:frame(frameWidth(satisfactionBg) - 4*24*SpacedFonts - 10, 0, 4*24*SpacedFonts,  30) text:@"查看详情" fontSize:24*SpacedFonts textColor:[UIColor colorWithRed:0.9765 green:0.4471 blue:0.1804 alpha:1.0] textAlignment:NSTextAlignmentRight inView:satisfactionBg];
        
        
        
    }
    
    return self;
}
- (void)setmodal:(SatisfactionData *)data
{
    _satisfactionTitle.text = data.title?data.title:@"";
    _satisfactionAppraiser.text = data.realname?[NSString stringWithFormat:@"评价人: %@",data.realname]:@"";
    _satisfactionOrNot.text = data.scord?@"满意":@"不满意";
    _satisfactionValue.text = data.scord?@"+1":@"-1";
    _satisfactionTime.text = data.createtime?[[NSString stringWithFormat:@"%i",data.createtime] timeformatString:@"yyyy-MM-dd HH:mm"]:@"";
    
}
@end