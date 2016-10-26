//
//  ActiveValueViewController.m
//  Lebao
//
//  Created by David on 15/12/23.
//  Copyright © 2015年 David. All rights reserved.
//

#import "ActiveValueViewController.h"
#import "XLDataService.h"
#import "NSString+Extend.h"
//我的URL ：appinterface/personal
#define PersonalURL [NSString stringWithFormat:@"%@user/active",HttpURL]
@interface ActiveValueViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    NSMutableArray *_myActiveValueArray;
    int _page;
    int _nowpage;
    ActiveValueModal *modal;
}

@property(nonatomic,strong)UITableView *myActiveValueView;


@end

@implementation ActiveValueModal

+ (NSDictionary *)mj_objectClassInArray
{
    
    return @{
             @"datas":@"ActiveValueDatas",
             };
    
}

@end

@implementation ActiveValueDatas
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}
@end

@implementation ActiveValueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    [self navView];
    [self addTableView];
    [self netWork:NO isFooter:NO isShouldClear:NO];
    
}
#pragma mark - Navi_View
- (void)navView
{
    
    [self navViewTitleAndBackBtn:@"活跃值"];
    
       
}

#pragma mark
#pragma mark - addTableView -
- (void)addTableView
{
    _myActiveValueArray = [NSMutableArray new];
    _myActiveValueView =[[UITableView alloc]initWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)) style:UITableViewStyleGrouped];
    _myActiveValueView.delegate = self;
    _myActiveValueView.dataSource = self;
    _myActiveValueView.backgroundColor =[UIColor clearColor];
    _myActiveValueView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myActiveValueView];
    
    
    __weak ActiveValueViewController *weakSelf =self;
    [[ToolManager shareInstance] scrollView:_myActiveValueView headerWithRefreshingBlock:^{
        _page = 1;
        [weakSelf netWork:YES isFooter:NO isShouldClear:YES];
        
    }];
    
    [[ToolManager shareInstance] scrollView:_myActiveValueView footerWithRefreshingBlock:^{
        
        _page = _nowpage + 1;
        [weakSelf netWork:NO isFooter:YES isShouldClear:NO];
        
        
    }];
    
    
    
}
- (UIView *)headerView
{
    UIView *headView = allocAndInitWithFrame(UIView, frame(0, 0, APPWIDTH, 212));
    headView.backgroundColor =[UIColor clearColor];
    
    UIImageView *bgView = allocAndInitWithFrame(UIImageView, frame(0, 0, APPWIDTH, 164));
    bgView.image = [UIImage imageNamed:@"wodeBG"];
    [headView addSubview:bgView];
    
    //等级
    NSInteger level = 0;
    if (modal.level&&modal.level>0) {
        level = modal.level;
    }
    [UILabel createLabelWithFrame:CGRectMake(15, 24, 60, 15) text:[NSString stringWithFormat:@"%ld级",level] fontSize:16 textColor:WhiteColor textAlignment:NSTextAlignmentLeft inView:headView];
    
    
    //中间部分
     NSString *num = @"0";
    if (modal.num&&modal.num.length>0) {
        num = modal.num;
    }
    NSString *residue = @"0";
    if (modal.ac&&[modal.ac isKindOfClass:[NSDictionary class]]) {
        if (modal.ac[[NSString stringWithFormat:@"v%li",level + 1]]) {
             residue = [NSString stringWithFormat:@"%d",[modal.ac[[NSString stringWithFormat:@"v%li",level + 1]] intValue] - [num intValue]];
        }
       
    }
    
    float W =  bgView.height - 32;
    UILabel *center =  [UILabel createLabelWithFrame:CGRectMake((APPWIDTH - W)/2.0, 15, W, W) text:[NSString stringWithFormat:@"%@\n还差%@点升级",num,residue] fontSize:85*SpacedFonts textColor:WhiteColor textAlignment:NSTextAlignmentCenter inView:headView];
    center.backgroundColor = [UIColor clearColor];
    center.numberOfLines = 0;
    [center setRadius:W/2.0];
    [center setBorder:rgba(255, 255, 255, 0.4) width:7];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:center.text];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:22*SpacedFonts] range:[center.text rangeOfString:[NSString stringWithFormat:@"还差%@点升级",residue]]];
    center.attributedText = string;
   
    //说明
    UIImage *image =[UIImage imageNamed:@"icon_shuoming"];
    BaseButton *shuoming = [[BaseButton alloc]initWithFrame:CGRectMake(APPWIDTH - image.size.width - 30,0, image.size.width + 30, image.size.height + 48) backgroundImage:nil iconImage:image highlightImage:image inView:headView];
    shuoming.didClickBtnBlock = ^
    {
        if (modal.desc&&modal.desc.length>0) {
            
            UIAlertView *alV = [[UIAlertView alloc]initWithTitle:@"活跃值说明" message:modal.desc delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alV show];
        }
        else
        {
            UIAlertView *alV = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"获取不到活跃值说明！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alV show];
        }
        
    };
    
    //获取记录
    UIView *huoqujilu = [[UIView alloc]initWithFrame:CGRectMake(0, headView.height - 37, APPWIDTH, 37)];
    huoqujilu.backgroundColor = WhiteColor;
    
    [UILabel createLabelWithFrame:CGRectMake(10, 0, 100, huoqujilu.height) text:@"获取记录" fontSize:16 textColor:AppMainColor textAlignment:NSTextAlignmentLeft inView:huoqujilu];
    [UILabel CreateLineFrame:CGRectMake(0,huoqujilu.height - 0.5, huoqujilu.width, 0.5) inView:huoqujilu];
    [headView addSubview:huoqujilu];
    return headView;
}
#pragma mark
#pragma mark - netWork-
- (void)netWork:(BOOL)isRefresh isFooter:(BOOL)isFooter isShouldClear:(BOOL)isShouldClear
{
    
    NSMutableDictionary *parame = [Parameter parameterWithSessicon];
    [parame setObject:@(_page) forKey:Page];
    if (_myActiveValueArray.count ==0) {
        [[ToolManager shareInstance] showWithStatus];
    }
    [XLDataService postWithUrl:PersonalURL param:parame modelClass:nil responseBlock:^(id dataObj, NSError *error) {
       // NSLog(@"data == %@",dataObj);
        if (isRefresh) {
            [[ToolManager shareInstance]endHeaderWithRefreshing
             :_myActiveValueView];
            
        }
        if (isFooter) {
            
            [[ToolManager shareInstance]endFooterWithRefreshing:_myActiveValueView];
        }
        
        if (dataObj) {
            modal = [ActiveValueModal mj_objectWithKeyValues:dataObj];
            
            
            if (modal.rtcode ==1) {
                if (isShouldClear) {
                    [_myActiveValueArray removeAllObjects];
                }
                
                _nowpage = (int) modal.page ;
                
                if (_nowpage ==1) {
                    [[ToolManager shareInstance] moreDataStatus:_myActiveValueView];
                }
                if (modal.allpage==_page) {
                    
                    [[ToolManager shareInstance] noMoreDataStatus:_myActiveValueView];
                }
                
                for (ActiveValueDatas *data in modal.datas) {
                    [_myActiveValueArray addObject:data];
                }
                
                [_myActiveValueView reloadData];
              
                
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
#pragma mark
#pragma mark - TableViewDelegate TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    return _myActiveValueArray.count;

    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 212;
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return [self headerView];
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
   
    return 50;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    static NSString *cellID =@"ActiveValueCell";
    ActiveValueCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[ActiveValueCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellHeight:50 cellWidth:frameWidth(_myActiveValueView)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        ActiveValueDatas *data = _myActiveValueArray[indexPath.row];
        [cell dataModal:data];
        return cell;
        
    return cell;
    

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
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
@implementation ActiveValueCell
{
   
    UILabel   *_userName;
    UILabel *_time;
    UILabel *_integral;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor =WhiteColor;
        self.selectionStyle =  UITableViewCellSelectionStyleNone;
        
        _userName = [UILabel createLabelWithFrame:frame(10, 10, APPWIDTH/2.0, 24*SpacedFonts) text:@"" fontSize:24*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:self];
    
        
        _time = [UILabel createLabelWithFrame:frame(_userName.x,cellHeight - 25, APPWIDTH, 25) text:@"" fontSize:22*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:self];
        
        _integral = [UILabel createLabelWithFrame:frame(0, 0, cellWidth - 10, cellHeight) text:@"" fontSize:34*SpacedFonts textColor:AppMainColor textAlignment:NSTextAlignmentRight inView:self];
        
        
        
        [UILabel CreateLineFrame:frame(_userName.x, cellHeight - 0.5, cellWidth -2*_userName.x, 0.5) inView:self];
        
    }
    
    return self;
}
- (void)dataModal:(ActiveValueDatas *)modal {
    
  
    _userName.text = modal.remark;
    _time.text = [modal.inputtime timeformatString:@"yyyy-MM-dd hh:mm"];
    _integral.text = [NSString stringWithFormat:@"%@ 点",modal.score];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:_integral.text];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:28*SpacedFonts] range:[_integral.text rangeOfString:@"点"]];
    _integral.attributedText = string;
    
}

@end


