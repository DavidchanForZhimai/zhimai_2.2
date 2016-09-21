//
//  ClueCommunityViewController.m
//  Lebao
//
//  Created by David on 16/5/23.
//  Copyright © 2016年 David. All rights reserved.
//

#import "ClueCommunityViewController.h"
#import "ClueCommunityCell.h"
#import "XLDataService.h"
#import "NSString+Extend.h"
#import "JJRDetailVC.h"
#import "MP3PlayerManager.h"

#define CommentlistURL [NSString stringWithFormat:@"%@demand/commentlist",HttpURL]
#define CommentURL [NSString stringWithFormat:@"%@demand/comment",HttpURL]
#define kToolBarH 44
#define kTextFieldH 30
@interface ClueCommunityViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIButton *_soundBtn;
    UIButton *_repeatBtn;
    UILabel *_timerLab;
    UILabel *_promptLab;
    NSTimer *timer;
     NSInteger addtm;
    NSInteger btnMark;
    double angle;
    UIView * bjV;
     NSInteger allTm;
    UIButton *_sendSound;
}
@property(nonatomic,strong)UITableView  *clueCommunityView;
@property(nonatomic,strong)NSMutableArray *clueCommunityArray;
@property (nonatomic,strong)CAShapeLayer *shapeLayer;
@end

typedef NS_ENUM(NSUInteger,ButtonActionTag) {
    
    ButtonActionTagSend =2,
    
    
};
@implementation ClueCommunityViewController
{
    UIImageView *_toolBar;
    UITextField *_textField;
    UIScrollView *_mainSrollView;
    int _page;
    int _nowpage;
    UIButton *_sendBtn;
    ClueCommunityModal *clueModal;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navViewTitleAndBackBtn:@"线索评论"];
    [self addTableView];
    [self addToolBar];
//    [self createLoundView];
    [self netWork:NO isFooter:NO isShouldClear:NO isSend:NO];
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchView)];
//    [self.clueCommunityView addGestureRecognizer:tap];
    
    
    
}
//-(void)touchView
//{
//    
//}
//-(void)createLoundView
//{
//    
//    bjV = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200)];
//    bjV.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:bjV];
//
//    _timerLab=[[UILabel alloc]init];//时间秒数
//    _timerLab.textColor= [UIColor colorWithRed:0.243 green:0.553 blue:1.000 alpha:1.000];
//    _timerLab.text=@"0\"";
//    _timerLab.font = [UIFont systemFontOfSize:18];
//    _timerLab.frame=CGRectMake(0, 20, SCREEN_WIDTH, 20);
//    _timerLab.textAlignment=NSTextAlignmentCenter;
//    [bjV addSubview:_timerLab];
//    
//    _promptLab=[[UILabel alloc]init];//最长时间秒数提示
//    _promptLab.text=@"最长可录音60s";
//    _promptLab.frame=CGRectMake(0, 50, SCREEN_WIDTH, 20);
//    _promptLab.textAlignment=NSTextAlignmentCenter;
//    _promptLab.font = [UIFont systemFontOfSize:13];
//    [bjV addSubview:_promptLab];
//    
//    _soundBtn=[UIButton buttonWithType:UIButtonTypeCustom];//语音按钮
//    _soundBtn.frame=CGRectMake(SCREEN_WIDTH/2-SCREEN_WIDTH/8, 85, SCREEN_WIDTH/4, SCREEN_WIDTH/4);
//    _soundBtn.layer.cornerRadius=SCREEN_WIDTH/8;
//    _soundBtn.backgroundColor=[UIColor colorWithRed:0.976 green:0.965 blue:0.969 alpha:1.000];
//    [_soundBtn setImage:[UIImage imageNamed:@"yuying@3x"] forState:UIControlStateNormal];
//    [_soundBtn setBackgroundImage:[UIImage imageNamed:@"yuan"] forState:UIControlStateNormal];
//    [_soundBtn addTarget:self action:@selector(soundBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    _soundBtn.tag=1001;
//    [bjV addSubview:_soundBtn];
//    
//    
//    //贝塞尔曲线属性
//    self.shapeLayer=[CAShapeLayer layer];
//    self.shapeLayer.frame=CGRectMake(0, 0, SCREEN_WIDTH/4-2, SCREEN_WIDTH/4-2);
//    self.shapeLayer.position=_soundBtn.center;
//    self.shapeLayer.fillColor=[UIColor clearColor].CGColor;//填充色
//    self.shapeLayer.lineWidth=3.0f;//线宽
//    self.shapeLayer.strokeColor=[UIColor orangeColor].CGColor;//线色
//    UIBezierPath *circlePath=[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, SCREEN_WIDTH/4-2, SCREEN_WIDTH/4-2)];//创建出圆形贝塞尔曲线
//    
//    self.shapeLayer.path=circlePath.CGPath;//让贝塞尔曲线与CAShapeLayer产生联系
//    self.shapeLayer.strokeStart=0;
//    self.shapeLayer.strokeEnd=0;
//    [bjV.layer addSublayer:self.shapeLayer];
//    
//    _repeatBtn=[UIButton buttonWithType:UIButtonTypeCustom];//重录按钮
//    _repeatBtn.frame=CGRectMake(SCREEN_WIDTH/2+SCREEN_WIDTH/4, _soundBtn.frame.origin.y/8*9.2, SCREEN_WIDTH/8, SCREEN_WIDTH/8);
//    _repeatBtn.layer.cornerRadius=SCREEN_WIDTH/16;
//    _repeatBtn.backgroundColor=[UIColor colorWithRed:0.976 green:0.965 blue:0.969 alpha:1.000];
//    [_repeatBtn setTitleColor:[UIColor colorWithWhite:0.655 alpha:1.000] forState:UIControlStateNormal];
//    _repeatBtn.titleLabel.font=[UIFont systemFontOfSize:14];
//    [_repeatBtn setTitle:@"重录" forState:UIControlStateNormal];
//    [_repeatBtn addTarget:self action:@selector(repeatAndSendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    _repeatBtn.userInteractionEnabled=NO;
//    _repeatBtn.tag=1101;
//    [bjV addSubview:_repeatBtn];
//    
//    _sendSound=[UIButton buttonWithType:UIButtonTypeCustom];//发送语音按钮
//    _sendSound.frame=CGRectMake(SCREEN_WIDTH/8, _soundBtn.frame.origin.y/8*9.2, SCREEN_WIDTH/8, SCREEN_WIDTH/8);
//    _sendSound.layer.cornerRadius=SCREEN_WIDTH/16;
//    _sendSound.backgroundColor=[UIColor colorWithRed:0.976 green:0.965 blue:0.969 alpha:1.000];
//    [_sendSound setTitleColor:[UIColor colorWithWhite:0.655 alpha:1.000] forState:UIControlStateNormal];
//    _sendSound.titleLabel.font=[UIFont systemFontOfSize:14];
//    [_sendSound setTitle:@"发送" forState:UIControlStateNormal];
//    [_sendSound addTarget:self action:@selector(repeatAndSendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    _sendSound.userInteractionEnabled=NO;
//    _sendSound.tag=1102;
//    [bjV addSubview:_sendSound];
//
//
//}


- (void)addTableView
{
    _clueCommunityArray = allocAndInit(NSMutableArray);
    
    _mainSrollView = allocAndInitWithFrame(UIScrollView, frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)));
    _mainSrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_mainSrollView];
                                                   
    _clueCommunityView = [[UITableView alloc]initWithFrame:frame(0, 0, frameWidth(_mainSrollView), frameHeight(_mainSrollView) - kToolBarH) style:UITableViewStyleGrouped];
    _clueCommunityView.delegate = self;
    _clueCommunityView.dataSource = self;
    _clueCommunityView.backgroundColor = [UIColor clearColor];
    _clueCommunityView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[ToolManager shareInstance] scrollView:_clueCommunityView footerWithRefreshingBlock:^{
         _page = _nowpage + 1;
         [self netWork:NO isFooter:YES isShouldClear:NO isSend:NO];
    }];
    [[ToolManager shareInstance] scrollView:_clueCommunityView headerWithRefreshingBlock:^{
        
        _page =  1;
        [self netWork:YES isFooter:NO isShouldClear:YES isSend:NO];
    }];
    [_mainSrollView addSubview:_clueCommunityView];
    
}
#pragma mark - netWork-
- (void)netWork:(BOOL)isRefresh isFooter:(BOOL)isFooter isShouldClear:(BOOL)isShouldClear isSend:(BOOL)isSend
{
    
    NSMutableDictionary *param = [Parameter parameterWithSessicon];
    [param setObject:_clueID forKey:@"id"];
    [param setObject:@(_page) forKey:@"page"];
    if (_clueCommunityArray.count ==0) {
         [[ToolManager shareInstance] showWithStatus];
    }
   
    [XLDataService postWithUrl:CommentlistURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        //NSLog(@"dataObj =%@",dataObj);
        if (isRefresh) {
            [[ToolManager shareInstance]endHeaderWithRefreshing
             :_clueCommunityView];
        }
        if (isFooter) {
            [[ToolManager shareInstance]endFooterWithRefreshing:_clueCommunityView];
        }
        
        if (dataObj) {
            clueModal=[ClueCommunityModal mj_objectWithKeyValues:dataObj];
            if (clueModal.rtcode ==1) {
                _nowpage = clueModal.page;
                if (_nowpage ==1) {
                    [[ToolManager shareInstance] moreDataStatus:_clueCommunityView];
                }
                if (_nowpage ==clueModal.allpage) {
                    [[ToolManager shareInstance] noMoreDataStatus:_clueCommunityView];;
                }
                [[ToolManager shareInstance] dismiss];
                if (isShouldClear) {
                    [_clueCommunityArray removeAllObjects];
                    
                }
                for (ClueCommunityData *data  in clueModal.datas) {
                    
                    [_clueCommunityArray addObject:data];
                    
                }
            
                [_clueCommunityView reloadData];
                

            }
            else
            {
                [[ToolManager shareInstance] showInfoWithStatus:clueModal.rtmsg];
            }
            
        }
        else
        {
            [[ToolManager shareInstance] showInfoWithStatus];
        }
        
    }];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _clueCommunityArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ClueCommunityData *data =_clueCommunityArray[indexPath.row];
    CGSize size = [data.content sizeWithFont:Size(24) maxSize:CGSizeMake(APPWIDTH - 92, 1000)];
    if (size.height>24*SpacedFonts) {
        
        return (62 -24*SpacedFonts) + size.height;
    }
    return 62;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 124;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = allocAndInitWithFrame(UIView, frame(0, 0, frameWidth(_clueCommunityView), 124));
    headView.backgroundColor = [UIColor clearColor];
    
    UIView *headViewLayer1 = allocAndInitWithFrame(UIView, frame(10, 10, frameWidth(headView) - 20, 67));
    headViewLayer1.backgroundColor = [UIColor colorWithRed:0.9686 green:0.9686 blue:0.9765 alpha:1.0];
    [headView addSubview:headViewLayer1];
    
    [UILabel createLabelWithFrame:frame(0, 0, frameWidth(headViewLayer1), 23) text:[[NSString stringWithFormat:@"%i",clueModal.createtime] timeformatString:@"HH:mm"] fontSize:20*SpacedFonts textColor:[UIColor colorWithRed:0.4353 green:0.4392 blue:0.4431 alpha:1.0] textAlignment:NSTextAlignmentCenter inView:headViewLayer1];
    
    UIView *headViewLayer2 = allocAndInitWithFrame(UIView, frame(10, 23, frameWidth(headViewLayer1) - 20, 36));
    headViewLayer2.backgroundColor = WhiteColor;
    [headViewLayer1 addSubview:headViewLayer2];
    
    [UILabel createLabelWithFrame:frame(5, 0, frameWidth(headViewLayer2) - 50, frameHeight(headViewLayer2)) text:clueModal.title fontSize:30*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:headViewLayer2];
    NSString *state = @"";
    if (clueModal.state ==99) {
        state =@"已结束";
    }
    [UILabel createLabelWithFrame:frame(frameWidth(headViewLayer2) - 50, 0, 40, frameHeight(headViewLayer2)) text:state fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentRight inView:headViewLayer2];
    
    UIView *headViewLayer3 = allocAndInitWithFrame(UIView, frame(10, frameHeight(headView) - 36, frameWidth(headView) - 20, 36));
    headViewLayer3.backgroundColor = WhiteColor;
    [headView addSubview:headViewLayer3];
    
    [UILabel createLabelWithFrame:frame(15, 0, frameWidth(headViewLayer3), frameHeight(headViewLayer3)) text:[NSString stringWithFormat:@"评论(%i)",clueModal.count] fontSize:30*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:headViewLayer3];
    
    [UILabel CreateLineFrame:frame(0, frameHeight(headViewLayer3) - 0.5, frameWidth(headViewLayer3), 0.5) inView:headViewLayer3];
    
    
    return headView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *cellID = @"ClueCommunityCell";
    
    ClueCommunityCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ClueCommunityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID  cellHeight:62 cellWidth:frameWidth(_clueCommunityView)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ClueCommunityData *data =_clueCommunityArray[indexPath.row];
    [cell setModal:data clueCommunityBlock:^(NSString *jjrID) {
        
        JJRDetailVC *jjrVC = allocAndInit(JJRDetailVC);
        jjrVC.jjrID = jjrID;
        PushView(self, jjrVC);
        
    }];
    return cell;
}
/**
 *  添加工具栏
 */
- (void)addToolBar
{
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.frame = CGRectMake(0, frameHeight(_mainSrollView) - kToolBarH, self.view.frame.size.width, kToolBarH);
    bgView.layer.borderWidth = 0.5;
    bgView.layer.borderColor= LineBg.CGColor;
    bgView.backgroundColor = WhiteColor ;
    bgView.userInteractionEnabled = YES;
    _toolBar = bgView;
    [_mainSrollView addSubview:bgView];
    
    UIView *textView = allocAndInitWithFrame(UIView,frame(10*ScreenMultiple, 8, APPWIDTH - 98*ScreenMultiple, 28));
    textView.userInteractionEnabled  =YES;
    textView.backgroundColor = WhiteColor;
    textView.layer.borderWidth = 0.5;
    textView.layer.borderColor= LineBg.CGColor;
    textView.layer.masksToBounds = YES;
    textView.layer.cornerRadius = 3.0;
    [_toolBar addSubview:textView];
    
    _textField = [[UITextField alloc] init];
    _textField.userInteractionEnabled  =YES;
    _textField.returnKeyType = UIReturnKeySend;
    _textField.enablesReturnKeyAutomatically = YES;
    
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.frame = frame(10, 0, frameWidth(textView) - 40, frameHeight(textView));
    _textField.placeholder = @"请输入";
    _textField.font = Size(28);
    _textField.delegate = self;
    [textView addSubview:_textField];
    
//    UIButton *liyinBtn=[UIButton buttonWithType:UIButtonTypeCustom];//想发语音按钮
//    liyinBtn.frame=frame(frameWidth(textView) -frameHeight(textView)-5, 2, frameHeight(textView)-4, frameHeight(textView)-4);
//    [liyinBtn setBackgroundImage:[UIImage imageNamed:@"liyin@3x"] forState:UIControlStateNormal];
//    [liyinBtn addTarget:self action:@selector(liyinBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [textView addSubview:liyinBtn];
//
    _sendBtn = [UIButton createButtonWithfFrame:frame(CGRectGetMaxX(textView.frame)+15*ScreenMultiple, 8, 62*ScreenMultiple, 28) title:@"发送" backgroundImage:nil iconImage:nil highlightImage:nil tag:ButtonActionTagSend inView:bgView];
    _sendBtn.titleLabel.font = Size(28);
    [_sendBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    _sendBtn.layer.masksToBounds = YES;
    _sendBtn.layer.cornerRadius = 3.0;
    _sendBtn.backgroundColor = AppMainColor;
    [_sendBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark
#pragma mark - buttonAction -
- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag ==NavViewButtonActionNavLeftBtnTag ) {
        PopView(self);
    }
    
    else if (sender.tag ==ButtonActionTagSend)
    {
        
        [_textField resignFirstResponder];
        
        [[ToolManager shareInstance] showWithStatus:@"发送中..."];
        
        if (_textField.text.length==0) {
            
            [[ToolManager shareInstance] showInfoWithStatus:@"请输入大于一个字符"];
            
            return;
        }
        
        NSMutableDictionary *param = [Parameter parameterWithSessicon];
        [param setObject:_clueID forKey:@"id"];
        [param setObject:_textField.text forKey:@"content"];
        [XLDataService postWithUrl:CommentURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
            
            if (dataObj) {
                if ([dataObj[@"rtcode"] intValue] ==1) {
                    [[ToolManager shareInstance] dismiss];
                    _textField.text = @"";
                    
                    _page =1;
                    [self netWork:YES isFooter:NO isShouldClear:YES isSend:YES];
                    
                }
                else
                {
                    [[ToolManager shareInstance]  showInfoWithStatus:dataObj[@"rtmsg"]];
                }
                
            }
            else
            {
                [[ToolManager shareInstance]  showInfoWithStatus];
            }
            
            
        }];
        
        
    }
}

-(void)liyinBtnAction:(UIButton *)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect=bjV.frame;
        rect.origin.y=SCREEN_HEIGHT-200;
        bjV.frame=rect;
    }];
    
    [_textField resignFirstResponder];
}

#pragma mark - UITextField的代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    [self buttonAction:_sendBtn];
    return YES;
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
