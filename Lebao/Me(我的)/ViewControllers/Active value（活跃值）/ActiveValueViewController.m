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
    int _selected;
    int _page;
    int _nowpage;
    ActiveValueModal *modal;
}

@property(nonatomic,strong)BaseButton *scoredRecord;
@property(nonatomic,strong)BaseButton *instructions;
@property(nonatomic,strong)UILabel *scoredRecordLb;
@property(nonatomic,strong)UILabel *instructionsLb;
@property(nonatomic,strong)UITableView *myActiveValueView;
@property(nonatomic,strong)UITableView *myInstructionsView;


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


@implementation CurveView

- ( void )drawRect:(CGRect)rect
{
    UIColor *color = AppMainColor;
    [color set];  //设置线条颜色
    
    UIBezierPath* aPath = [UIBezierPath bezierPath];
    
    aPath.lineWidth = 5.0;
    aPath.lineCapStyle = kCGLineCapRound;  //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound;  //终点处理
    
    [aPath moveToPoint:CGPointMake(0, 104)];
    
    [aPath addQuadCurveToPoint:CGPointMake(APPWIDTH, 35) controlPoint:CGPointMake(APPWIDTH -80*ScreenMultiple, 100)];
    
    [aPath stroke];
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
    
    
    _myInstructionsView =[[UITableView alloc]initWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)) style:UITableViewStyleGrouped];
    _myInstructionsView.delegate = self;
    _myInstructionsView.dataSource = self;
    _myInstructionsView.backgroundColor =[UIColor clearColor];
    _myInstructionsView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_myInstructionsView];
    [[ToolManager shareInstance] scrollView:_myInstructionsView headerWithRefreshingBlock:^{
        _page = 1;
        [weakSelf netWork:YES isFooter:NO isShouldClear:YES];
        
    }];
    
    weakSelf.myActiveValueView.hidden = NO;
    weakSelf.myInstructionsView.hidden = YES;
    
}
- (UIView *)headerView
{
    UIView *headView = allocAndInitWithFrame(UIView, frame(0, 0, APPWIDTH, 225));
    headView.backgroundColor =hexColor(9dc7eb);
    
    UIView *bgView = allocAndInitWithFrame(UIView, frame(0, 0, APPWIDTH, 31));
    bgView.backgroundColor =hexColor(86b8e1);
    [headView addSubview:bgView];
    
    UIImageView *imageLevel = allocAndInitWithFrame(UIImageView, frame(13, 7, 34, 17));
    imageLevel.image = [UIImage imageNamed:@"me_Activevalue_level"];
    [bgView addSubview:imageLevel];
    
     [UILabel createLabelWithFrame:frame(17,3, 17, 20*SpacedFonts) text:[NSString stringWithFormat:@"%d",(int)modal.level] fontSize:20*SpacedFonts textColor:AppMainColor textAlignment:NSTextAlignmentLeft inView:imageLevel];
    ;
     [UILabel createLabelWithFrame:frame(CGRectGetMaxX(imageLevel.frame) + 10, 0, 200, frameHeight(bgView)) text:[NSString stringWithFormat:@"活跃值：%@",modal.num] fontSize:24*SpacedFonts textColor:WhiteColor textAlignment:NSTextAlignmentLeft inView:bgView];
    
    CurveView *curveView = allocAndInitWithFrame(CurveView, headView.frame);
    curveView.backgroundColor = [UIColor clearColor];
    [headView addSubview:curveView];
    
    UIImageView *userIcon = allocAndInitWithFrame(UIImageView, frame(38*ScreenMultiple, 84, 35, 35));
    [[ToolManager shareInstance] imageView:userIcon setImageWithURL:modal.imgurl placeholderType:PlaceholderTypeUserHead];
    [userIcon setRound];
    [userIcon setBorder:WhiteColor width:2.0];
    [headView addSubview:userIcon];
    
    [UILabel createLabelWithFrame:frame(frameX(userIcon), CGRectGetMaxY(userIcon.frame) + 5, frameWidth(userIcon), 22*SpacedFonts) text:[NSString stringWithFormat:@"我"] fontSize:22*SpacedFonts textColor:WhiteColor textAlignment:NSTextAlignmentCenter inView:bgView];
    
    UIImageView *secondIcon = allocAndInitWithFrame(UIImageView, frame(140*ScreenMultiple, 75, 40, 40));
    secondIcon.image = [UIImage imageNamed:@"me_Activevalue_levelNum"];
    [secondIcon setRound];
    [headView addSubview:secondIcon];
    
    if (modal.ac) {
   UILabel *secondLb = [UILabel createLabelWithFrame:frame(frameX(secondIcon) -10, CGRectGetMaxY(secondIcon.frame) , frameWidth(secondIcon) + 20, 40) text:[NSString stringWithFormat:@"%i级\n%@点",(int)modal.level +1,modal.ac[[NSString stringWithFormat:@"v%i",(int)modal.level +1]]] fontSize:22*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentCenter inView:bgView];
    secondLb.numberOfLines = 0;
    }
    
    UIImageView *thirdIcon = allocAndInitWithFrame(UIImageView, frame(240*ScreenMultiple, 50, 40, 40));
    thirdIcon.image = [UIImage imageNamed:@"me_Activevalue_levelNum"];
    [thirdIcon setRound];
    [headView addSubview:thirdIcon];
    
    if (modal.ac) {
        UILabel *thirdLb = [UILabel createLabelWithFrame:frame(frameX(thirdIcon) -10, CGRectGetMaxY(thirdIcon.frame) , frameWidth(thirdIcon) + 20, 40) text:[NSString stringWithFormat:@"%i级\n%@点",(int)modal.level +2,modal.ac[[NSString stringWithFormat:@"v%i",(int)modal.level +2]]] fontSize:22*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentCenter inView:bgView];
        thirdLb.numberOfLines = 0;
    }
    
    
    
    
//    
    UIView *segment = allocAndInitWithFrame(UIView, frame(0, frameHeight(headView) - 50, APPWIDTH, 40));
    segment.backgroundColor =WhiteColor;
    [headView addSubview:segment];
    
    __weak ActiveValueViewController *weakSelf =self;
    
    _scoredRecord = [[BaseButton alloc]initWithFrame:frame(0, 0, frameWidth(segment)/2.0, frameHeight(segment)) setTitle:@"获分记录" titleSize:26*SpacedFonts titleColor:WhiteColor textAlignment:NSTextAlignmentCenter backgroundColor:AppMainColor inView:segment];
    
    _instructions = [[BaseButton alloc]initWithFrame:frame(frameWidth(segment)/2.0, 0, frameWidth(segment)/2.0, frameHeight(segment)) setTitle:@"说明" titleSize:26*SpacedFonts titleColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter backgroundColor:WhiteColor inView:segment];
    _scoredRecordLb = allocAndInitWithFrame(UILabel, frame(0, 0, frameWidth(segment)/2.0, 4));
    
    [segment addSubview:_scoredRecordLb];
    
    _instructionsLb =allocAndInitWithFrame(UILabel, frame(frameWidth(segment)/2.0, 0, frameWidth(segment)/2.0, 4));
    [segment addSubview:_instructionsLb];
    
    if (_selected ==0) {
        [weakSelf.scoredRecord setTitleColor:AppMainColor forState:UIControlStateNormal];
        [weakSelf.scoredRecord setBackgroundColor:hexColor(dae9f7)];
        [weakSelf.instructions setTitleColor:LightBlackTitleColor forState:UIControlStateNormal];
        [weakSelf.instructions setBackgroundColor:WhiteColor];
        _instructionsLb.backgroundColor = WhiteColor;
        _scoredRecordLb.backgroundColor = AppMainColor;
    }
    else
    {
        [weakSelf.instructions setTitleColor:AppMainColor forState:UIControlStateNormal];
        [weakSelf.instructions setBackgroundColor:hexColor(dae9f7)];
        [weakSelf.scoredRecord setTitleColor:LightBlackTitleColor forState:UIControlStateNormal];
        [weakSelf.scoredRecord setBackgroundColor:WhiteColor];
        
        _instructionsLb.backgroundColor = AppMainColor;
        _scoredRecordLb.backgroundColor = WhiteColor;
    }
    
    
    _scoredRecord.didClickBtnBlock = ^
    {
        _selected = 0;
        [weakSelf.scoredRecord setTitleColor:AppMainColor forState:UIControlStateNormal];
        [weakSelf.scoredRecord setBackgroundColor:hexColor(dae9f7)];
        [weakSelf.instructions setTitleColor:LightBlackTitleColor forState:UIControlStateNormal];
        [weakSelf.instructions setBackgroundColor:WhiteColor];
        
        weakSelf.instructionsLb.backgroundColor = WhiteColor;
        weakSelf.scoredRecordLb.backgroundColor = AppMainColor;
        [weakSelf.myActiveValueView reloadData];
        [weakSelf.myInstructionsView reloadData];
        weakSelf.myActiveValueView.hidden = NO;
        weakSelf.myInstructionsView.hidden = YES;
        
        
    };
    
    
    _instructions.didClickBtnBlock = ^
    {
        _selected = 1;
        [weakSelf.instructions setTitleColor:AppMainColor forState:UIControlStateNormal];
        [weakSelf.instructions setBackgroundColor:hexColor(dae9f7)];
        [weakSelf.scoredRecord setTitleColor:LightBlackTitleColor forState:UIControlStateNormal];
        [weakSelf.scoredRecord setBackgroundColor:WhiteColor];
        
        weakSelf.instructionsLb.backgroundColor = AppMainColor;
        weakSelf.scoredRecordLb.backgroundColor = WhiteColor;
        
        [weakSelf.myActiveValueView  reloadData];
        [weakSelf.myInstructionsView reloadData];
        weakSelf.myInstructionsView.hidden = NO;
        weakSelf.myActiveValueView.hidden = YES;
        
    };
    
    UIView *lineView = allocAndInitWithFrame(UIView, frame(0, frameHeight(headView) - 10, APPWIDTH, 10));
    lineView.backgroundColor =AppViewBGColor;
    [headView addSubview:lineView];
    
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
            [[ToolManager shareInstance]endHeaderWithRefreshing
             :_myInstructionsView];
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
//                    data.imgurl = modal.imgurl;
                    [_myActiveValueArray addObject:data];
                }
                
                [_myActiveValueView reloadData];
                [_myInstructionsView reloadData];
                
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
    if (_selected ==0) {
        return _myActiveValueArray.count;
    }
    return 1;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 225;
    
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
    if (_selected ==0) {
        return 55;
    }
    UILabel * label = allocAndInit(UILabel);
    CGSize  size = [label sizeWithMultiLineContent:modal.desc rowWidth:APPWIDTH - 20 font:Size(24)];
    return size.height + 50 ;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selected ==0) {
        static NSString *cellID =@"ActiveValueCell";
        ActiveValueCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[ActiveValueCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellHeight:55 cellWidth:frameWidth(_myActiveValueView)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        ActiveValueDatas *data = _myActiveValueArray[indexPath.row];
        [cell dataModal:data];
        return cell;
    }
    
    static NSString *cellID =@"tableViewCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID ];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *title = [UILabel createLabelWithFrame:frame(10, 0, 48*SpacedFonts, 30) text:@"说明" fontSize:24*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:cell];
        
        UILabel *des=   [UILabel createLabelWithFrame:frame(frameX(title), 20, APPWIDTH - 2*frameX(title), 24*SpacedFonts) text:modal.desc fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:cell];
        
        CGSize  size = [des sizeWithMultiLineContent:modal.desc rowWidth:APPWIDTH - 20 font:Size(24)];
        ;
        des.frame =frame(frameX(title), 20, APPWIDTH - 2*frameX(title), size.height + 30);
        des.numberOfLines = 0;

    }
    
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
    UIImageView *_icon;
    UILabel   *_userName;
    UILabel *_time;
    UIView *_star;
    UILabel *_integral;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor =WhiteColor;
        self.selectionStyle =  UITableViewCellSelectionStyleNone;
        
        _icon = allocAndInitWithFrame(UIImageView, frame(15, (cellHeight- 30)/2.0, 30, 30));
        [_icon setRound];
        [self addSubview:_icon];
        
        _userName = [UILabel createLabelWithFrame:frame(CGRectGetMaxX(_icon.frame) + 10, 0, 110, 32) text:@"" fontSize:24*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:self];
        
        _star = allocAndInitWithFrame(UIView, frame(frameX(_userName), CGRectGetMaxY(_userName.frame), 100, 15));
        
        [self addSubview:_star];
        
        _time = [UILabel createLabelWithFrame:frame(cellWidth - 120, 0, 110, 35) text:@"" fontSize:20*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentRight inView:self];
        
        _integral = [UILabel createLabelWithFrame:frame(cellWidth - 100, CGRectGetMaxY(_time.frame), 90, 24*SpacedFonts) text:@"" fontSize:24*SpacedFonts textColor:AppMainColor textAlignment:NSTextAlignmentRight inView:self];
        
        
        
        [UILabel CreateLineFrame:frame(0, cellHeight - 0.5, cellWidth, 0.5) inView:self];
        
    }
    
    return self;
}
- (void)dataModal:(ActiveValueDatas *)modal {
    
    [[ToolManager shareInstance] imageView:_icon setImageWithURL:modal.imgurl placeholderType:PlaceholderTypeUserHead];
    _userName.text = modal.remark;
    _time.text = [modal.inputtime timeformatString:@"yyyy-MM-dd"];
    for (UIView *subView in _star.subviews) {
        [subView removeFromSuperview];
    }
    for (int i =0; i<[modal.score intValue]; i++) {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame(20*i, 0, 15, 15)];
        imageView.image = [UIImage imageNamed:@"me_Activevalue_star"];
        [_star addSubview:imageView];
        
    }
    _integral.text = [NSString stringWithFormat:@"%@分",modal.score];
}

@end


