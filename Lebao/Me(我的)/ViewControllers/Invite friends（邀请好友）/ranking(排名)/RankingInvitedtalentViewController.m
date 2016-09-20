//
//  RankingInvitedtalentViewController.m
//  Lebao
//
//  Created by David on 16/4/15.
//  Copyright © 2016年 David. All rights reserved.
//

#import "RankingInvitedtalentViewController.h"
#import "XLDataService.h"
#import "UIImage+Extend.h"
#define cellH 40
//排名
#define RankURL [NSString stringWithFormat:@"%@user/rank",HttpURL]
@interface RankingInvitedtalentViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *rangkingView;
@property(nonatomic,strong)NSMutableArray *rankingArray;
@property(nonatomic,assign)int page;
@property(nonatomic,assign)int nowpage;
@property(nonatomic,strong)RankingInvitedtalentModal *modal;
@end


@implementation RankingInvitedtalentModal

+ (NSDictionary *)objectClassInArray{
    return @{@"activity" : [RankingActivity class]};
}

@end
@implementation RankingActivity

@end
@implementation RankingInvitedtalentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navViewTitleAndBackBtn:@"邀请达人"];
    [self addTableView];
   
    [self netWork:NO isFooter:NO isShouldClear:NO];
}
#pragma mark
#pragma mark - buttonAction -
- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag ==NavViewButtonActionNavLeftBtnTag ) {
        PopView(self);
    }
    
}
#pragma mark
#pragma mark - addTableView -
- (void)addTableView
{
    _rankingArray = [NSMutableArray new];
    _rangkingView =[[UITableView alloc]initWithFrame:frame(0,StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)) style:UITableViewStyleGrouped];
    _rangkingView.delegate = self;
    _rangkingView.dataSource = self;
    _rangkingView.backgroundColor =[UIColor clearColor];
    _rangkingView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_rangkingView];
    
//    __weak RankingInvitedtalentViewController *weakSelf =self;
//    [[ToolManager shareInstance] scrollView:_rangkingView headerWithRefreshingBlock:^{
//        _page = 1;
//        [weakSelf netWork:YES isFooter:NO isShouldClear:YES];
//        
//    }];

    
    
}
#pragma mark
#pragma mark - netWork-
- (void)netWork:(BOOL)isRefresh isFooter:(BOOL)isFooter isShouldClear:(BOOL)isShouldClear
{
 
    NSMutableDictionary *param = [Parameter parameterWithSessicon];
    
    if (_rankingArray.count==0) {
        [[ToolManager shareInstance] showWithStatus];
    }
    [XLDataService postWithUrl:RankURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (isFooter) {
            [[ToolManager shareInstance] endFooterWithRefreshing:_rangkingView];
        }
        if(isRefresh)
        {
            [[ToolManager shareInstance] endHeaderWithRefreshing:_rangkingView];
        }
        if (dataObj) {
            if (isShouldClear) {
                [_rankingArray removeAllObjects];
            }
            _modal = [RankingInvitedtalentModal mj_objectWithKeyValues:dataObj];
            if (_modal.aclink) {
                if (_geturlBlock) {
                    _geturlBlock(_modal.aclink);
                }
            }
            if (_modal.rtcode==1) {
                [[ToolManager shareInstance] dismiss];
                
                for (RankingActivity *data in _modal.activity) {
                    [_rankingArray addObject:data];
                }
                  [_rangkingView reloadData];
            }
            else
            {
                [[ToolManager shareInstance] showInfoWithStatus:_modal.rtmsg];
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
    
    return _rankingArray.count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 90.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = allocAndInitWithFrame(UIView, frame(0, 0, APPWIDTH, 90));
    view.backgroundColor = AppViewBGColor;
    
    UILabel *desc = [UILabel createLabelWithFrame:frame(0, 10, APPWIDTH, 40) text:@"前十名单\n奖金剩余金额0元" fontSize:28*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:view];
    desc.numberOfLines = 0;
    if (_modal.surplus) {
        desc.text = [NSString stringWithFormat:@"前十名单\n奖金剩余金额%@元",_modal.surplus];
    }
    
    UILabel *ranking = [UILabel createLabelWithFrame:frame(0, CGRectGetMaxY(desc.frame), APPWIDTH/5.0, 40) text:@"排名" fontSize:28*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:view];
     UILabel *icon = [UILabel createLabelWithFrame:frame(CGRectGetMaxX(ranking.frame), frameY(ranking), frameWidth(ranking), frameHeight(ranking)) text:@"头像" fontSize:28*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:view];
    
     UILabel *individual = [UILabel createLabelWithFrame:frame(CGRectGetMaxX(icon.frame), frameY(icon), frameWidth(icon), frameHeight(icon))  text:@"邀请达人" fontSize:28*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:view];
    
     UILabel *authen = [UILabel createLabelWithFrame:frame(CGRectGetMaxX(individual.frame), frameY(individual), frameWidth(individual), frameHeight(individual)) text:@"认证／总" fontSize:28*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:view];
    
     UILabel *jiangjin=[UILabel createLabelWithFrame:frame(CGRectGetMaxX(authen.frame), frameY(authen), frameWidth(authen), frameHeight(authen)) text:@"奖金" fontSize:28*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:view];
    
    ranking.backgroundColor =icon.backgroundColor =individual.backgroundColor =authen.backgroundColor =
    jiangjin.backgroundColor = WhiteColor;
    return view;
    
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 0.01;
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
    
    static NSString *cellID =@"RankingInvitedtalentView";
    RankingInvitedtalentView *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[RankingInvitedtalentView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellHeight:cellH cellWidth:frameWidth(_rangkingView)];
        cell.selectionStyle = 0;
        
    }
    
    [cell setmodal:_rankingArray[indexPath.row]];
    return cell;

    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

@implementation RankingInvitedtalentView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(CGFloat)cellHeight cellWidth:(CGFloat)cellWidth
{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _ranking = [UILabel createLabelWithFrame:frame(0, 0, cellWidth/5.0, cellHeight) text:@"" fontSize:28*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:self];
//        UILabel *icon = [UILabel createLabelWithFrame:frame(CGRectGetMaxX(ranking.frame), frameY(ranking), frameWidth(ranking), frameHeight(ranking)) text:@"头像" fontSize:28*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:view];
        _icon = allocAndInitWithFrame(UIImageView, frame(CGRectGetMaxX(_ranking.frame) + (cellWidth/5.0 -35)/2.0, 2.5, 35, 35));
        [_icon setRound];
        [self addSubview:_icon];
        
        _individual = [UILabel createLabelWithFrame:frame(2*CGRectGetMaxX(_ranking.frame), frameY(_ranking), frameWidth(_ranking), frameHeight(_ranking))  text:@"" fontSize:28*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:self];
        
        _authen = [UILabel createLabelWithFrame:frame(CGRectGetMaxX(_individual.frame), frameY(_individual), frameWidth(_individual), frameHeight(_individual)) text:@"" fontSize:28*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter inView:self];
        
        _jiangjin=[UILabel createLabelWithFrame:frame(CGRectGetMaxX(_authen.frame), frameY(_authen), frameWidth(_authen), frameHeight(_authen)) text:@"" fontSize:28*SpacedFonts textColor:AppMainColor textAlignment:NSTextAlignmentCenter inView:self];
        
        [UILabel CreateLineFrame:frame(CGRectGetMaxX(_icon.frame), cellHeight - 0.5, cellWidth -CGRectGetMaxX(_icon.frame), 0.5) inView:self];
    }
    
    return self;
}
- (void)setmodal:(RankingActivity *)data 
{
    _ranking.text =  [NSString stringWithFormat:@"%i",(int)data.ranking];
    if (data.ranking<4) {
        _ranking.textColor = AppMainColor;
    }
    else
    {
        _ranking.textColor = LightBlackTitleColor;
    }
   
    [[ToolManager shareInstance] imageView:_icon setImageWithURL:data.imgurl placeholderType:PlaceholderTypeUserHead];
    if (!data.imgurl||[data.imgurl isEqualToString:@""]) {
        
        if (data.sex ==2) {
            _icon.image = [[UIImage imageNamed:@"defaulthead_nv"] imageByScalingAndCroppingForSize:CGSizeMake(35, 35)];
        }
    }
    _individual.text = data.realname;
    _authen.text = data.num;
    _jiangjin.text = [NSString stringWithFormat:@"%i",(int)data.money];
}
@end



