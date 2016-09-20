//
//  OtherDynamicdViewController.m
//  Lebao
//
//  Created by David on 16/8/2.
//  Copyright © 2016年 David. All rights reserved.
//

#import "OtherDynamicdViewController.h"
#import "HomeInfo.h"
#import "CoreArchive.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "JJRDetailVC.h"

#import "LWImageBrowser.h"
#import "TableViewCell.h"
#import "GallopUtils.h"
#import "StatusModel.h"
#import "CellLayout.h"
#import "DynamicDetailsViewController.h"
#define kToolBarH 44
#define kTextFieldH 30
@interface OtherDynamicdViewController ()<UITableViewDelegate,UITableViewDataSource,TableViewCellDelegate,UIScrollViewDelegate,UITextFieldDelegate>
{
    UIScrollView * buttomScr;
    UIImageView *_toolBar;
    UITextField *_textField;
    int jjrpageNumb;
    UIButton  *_sendBtn;
    
}
@property (strong,nonatomic)NSMutableArray * jjrJsonArr;
@property (strong,nonatomic)UITableView *dtTab;
@property (nonatomic,strong) NSString* replayid;//评论中的rep_brokerid
@property (nonatomic,strong) NSString* dynamicID;//动态ID
@property (nonatomic,strong) NSString* commentType;//评论值为：comment； 回复值为：replay
@property (nonatomic,strong)TableViewCell *commentCell;
@property (nonatomic,strong)NSIndexPath *commentIndex;
@end


@implementation OtherDynamicdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navViewTitleAndBackBtn:_dynamicdName];
    
    jjrpageNumb =1;
    _jjrJsonArr = [[NSMutableArray alloc]init];
    [self setButtomScr];
    [self getjjrJson];
    //评论
    [self addToolBar];
    
}
/**
 *  最下层的scrollview
 */
-(void)setButtomScr
{
    buttomScr = [[UIScrollView alloc]initWithFrame:CGRectMake(0,StatusBarHeight + NavigationBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-(StatusBarHeight + NavigationBarHeight))];
     buttomScr.contentSize = CGSizeMake(SCREEN_WIDTH, frameHeight(buttomScr));
    buttomScr.backgroundColor = [UIColor clearColor];
    buttomScr.scrollEnabled = YES;
    buttomScr.delegate = self;
    buttomScr.alwaysBounceHorizontal = NO;
    buttomScr.alwaysBounceVertical = NO;
    buttomScr.showsHorizontalScrollIndicator = NO;
    buttomScr.showsVerticalScrollIndicator = NO;
//    buttomScr.pagingEnabled = YES;
    buttomScr.bounces = NO;
    [self.view addSubview:buttomScr];
    [self addTheTab];
}
/**
 *  添加工具栏
 */
- (void)addToolBar
{
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.frame = CGRectMake(0, frameHeight(buttomScr), APPWIDTH, kToolBarH);
    bgView.layer.borderWidth = 0.5;
    bgView.layer.borderColor= LineBg.CGColor;
    bgView.backgroundColor = WhiteColor ;
    bgView.userInteractionEnabled = YES;
    _toolBar = bgView;
    
    [buttomScr addSubview:bgView];
    
    UIView *textView = allocAndInitWithFrame(UIView,frame(10*ScreenMultiple, 8, APPWIDTH - 80*ScreenMultiple, 28));
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
    
    _sendBtn = [UIButton createButtonWithfFrame:frame(CGRectGetMaxX(textView.frame)+15*ScreenMultiple, 8, 40*ScreenMultiple, 28) title:@"发送" backgroundImage:nil iconImage:nil highlightImage:nil tag:0 inView:bgView];
    _sendBtn.titleLabel.font = Size(28);
    [_sendBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    _sendBtn.layer.masksToBounds = YES;
    _sendBtn.layer.cornerRadius = 3.0;
    _sendBtn.backgroundColor = AppMainColor;
    [_sendBtn addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)sendAction:(UIButton *)sender
{
    
    [self postComment];
}

-(void)addTheTab
{
    _dtTab = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, buttomScr.frame.size.height)];
    _dtTab.dataSource = self;
    _dtTab.delegate = self;
    
    _dtTab.tableFooterView = [[UIView alloc]init];
    _dtTab.backgroundColor = [UIColor clearColor];
    
    _dtTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dtTab.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        jjrpageNumb = 1;
        if (_jjrJsonArr.count >0) {
            [_jjrJsonArr removeAllObjects];
        }
        [_dtTab reloadData];
        [_dtTab.mj_header endRefreshing];
        
        [self getjjrJson];
    }];
    
    _dtTab.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreJJR)];

    [buttomScr addSubview:_dtTab];
    
}
-(void)loadMoreJJR
{
    jjrpageNumb ++;
    [self getjjrJson];
    [_dtTab.mj_footer endRefreshing];
}

#pragma mark
#pragma mark - buttonAction -
- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag ==0) {
        PopView(self);
    }
    
    
}
-(void)getjjrJson
{
    
    [[HomeInfo shareInstance]getHomePageDT:jjrpageNumb brokerid:_dynamicdID andcallBack:^(BOOL issucced, NSString* info, NSDictionary* jsonDic) {
        if (issucced == YES) {
            
            StatusModel *model = [StatusModel mj_objectWithKeyValues:jsonDic];
            [[ToolManager shareInstance]dismiss];
            if (model.datas.count > 0) {
                
                for (NSInteger i = 0; i < model.datas.count; i ++) {
                    StatusDatas *data = model.datas[i];
                    data.imgurl = [[ToolManager shareInstance] urlAppend:data.imgurl];
                    for (int i =0; i<data.pic.count;i++) {
                        StatusPic *pic = data.pic[i];
                        pic.imgurl = [[ToolManager shareInstance] urlAppend:pic.imgurl];
                        pic.abbre_imgurl = [[ToolManager shareInstance] urlAppend: pic.abbre_imgurl];
                        [data.pic replaceObjectAtIndex:i withObject:pic];
                        
                    }
                    for (int i =0; i<data.like.count;i++) {
                        StatusLike *like = data.like[i];
                        like.imgurl = [[ToolManager shareInstance] urlAppend:like.imgurl];
                        [data.like replaceObjectAtIndex:i withObject:like];
                    }
                    
                    data.type = @"image";
                    LWLayout* layout = [self layoutWithStatusModel:data index:i];
                    [self.jjrJsonArr addObject:layout];
                }
                [_dtTab reloadData];
            }else
            {
                [[ToolManager shareInstance] showAlertMessage:@"没有更多数据了"];
                
            }
            
        }else
        {
            [[ToolManager shareInstance] showAlertMessage:info];
            
        }
        
    }];
}

/****************************************************************************/
/**
 *  在这里生成LWAsyncDisplayView的模型。
 */
/****************************************************************************/

- (CellLayout *)layoutWithStatusModel:(StatusDatas *)statusModel index:(NSInteger)index {
    //生成Layout
    CellLayout* layout = [[CellLayout alloc] initWithStatusModel:statusModel index:index isDetail:NO];
    return layout;
}

#pragma mark----tableview代理和资源方法
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.jjrJsonArr.count >= indexPath.row) {
        CellLayout* layout = self.jjrJsonArr[indexPath.row];
        return layout.cellHeight;
    }
    return 0;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _jjrJsonArr.count;
    
}
-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString* cellIdentifier = @"cellIdentifier";
    TableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    if (self.jjrJsonArr.count >= indexPath.row) {
        CellLayout* cellLayout = self.jjrJsonArr[indexPath.row];
        cell.cellLayout = cellLayout;
    }
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"didSelectRowAtIndexPath");
    if (tableView ==_dtTab) {
        CellLayout* cellLayout = self.jjrJsonArr[indexPath.row];
        DynamicDetailsViewController*dynamicDetailsViewController = allocAndInit(DynamicDetailsViewController);
        dynamicDetailsViewController.dynamicdID = [NSString stringWithFormat:@"%ld",cellLayout.statusModel.ID];
        PushView(self, dynamicDetailsViewController);
        
        
    }
    
}
//点击进入动态详情
- (void)tableViewCell:(TableViewCell *)cell didClickedLikeButtonWithDTID:(NSString *)DTID atIndexPath:(NSIndexPath *)indexPath
{
    DynamicDetailsViewController*dynamicDetailsViewController = allocAndInit(DynamicDetailsViewController);
    dynamicDetailsViewController.dynamicdID = DTID;
    dynamicDetailsViewController.jjrJsonArr = allocAndInit(NSMutableArray);
    [dynamicDetailsViewController.jjrJsonArr addObject:_jjrJsonArr[indexPath.row]];
    dynamicDetailsViewController.deleteDynamicDetailSucceed = ^(BOOL succeed,CellLayout *cellLayout)
    {
        if (succeed) {
            [_jjrJsonArr removeObjectAtIndex:indexPath.row];
            [_dtTab reloadData];
        }
        else
        {
            
            CellLayout *currentLayout =_jjrJsonArr[indexPath.row];
            [_jjrJsonArr replaceObjectAtIndex:indexPath.row withObject:[self layoutWithStatusModel:currentLayout.statusModel index:indexPath.row]];
            [_dtTab reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
        
    };
    
    PushView(self, dynamicDetailsViewController);
}

/***  点击评论 ***/
- (void)tableViewCell:(TableViewCell *)cell didClickedCommentWithCellLayout:(CellLayout *)layout
          atIndexPath:(NSIndexPath *)indexPath {
    [_textField becomeFirstResponder];
    _textField.placeholder =@"评论";
    _dynamicID =[NSString stringWithFormat:@"%ld",layout.statusModel.ID];
    _commentType = @"comment";
    _replayid = @"0";
    _commentCell =cell;
    _commentIndex = indexPath;
}
#pragma mark - UITextField的代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    
    [self postComment];
    return YES;
}
/***  发表评论 ***/
- (void)postComment {
    
    /* 由于是异步绘制，而且为了减少View的层级，整个显示内容都是在同一个UIView上面，所以会在刷新的时候闪一下，这里可以先把原先Cell的内容截图覆盖在Cell上，
     延迟0.25s后待刷新完成后，再将这个截图从Cell上移除 */
    
    UIImage* screenshot = [GallopUtils screenshotFromView:_commentCell];
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:[self.dtTab convertRect:_commentCell.frame toView:self.dtTab]];
    imgView.image = screenshot;
    [self.dtTab addSubview:imgView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [imgView removeFromSuperview];
    });
    
    
    if (_textField.text.length==0) {
        
        [[ToolManager shareInstance] showInfoWithStatus:@"输入必须大于一个字符"];
        return;
    }
    CellLayout* layout =  _commentCell.cellLayout;
    NSMutableArray* newCommentLists = [[NSMutableArray alloc] initWithArray:layout.statusModel.comment];
    [[HomeInfo shareInstance] addDynamicComment:_dynamicID replayid:_replayid type:_commentType content:_textField.text andcallBack:^(BOOL issucced, NSString *info, NSDictionary *jsonDic) {
        _textField.text = @"";
        [_textField resignFirstResponder];
        if (issucced) {
            if (jsonDic[@"datas"]) {
                StatusComment *newComment = allocAndInit(StatusComment);
                newComment.ID = [jsonDic[@"datas"][@"id"] integerValue];
                newComment.me = [jsonDic[@"datas"][@"self"] boolValue];
                StatusInfo *info = allocAndInit(StatusInfo);
                info.brokerid = [jsonDic[@"datas"][@"brokerid"] integerValue];
                info.realname = jsonDic[@"datas"][@"realname"];
                info.rep_brokerid = [jsonDic[@"datas"][@"rep_brokerid"] integerValue];
                info.rep_realname = jsonDic[@"datas"][@"rep_realname"];
                info.content = jsonDic[@"datas"][@"content"];
                newComment.info = info;
                [newCommentLists addObject:newComment];
                
                StatusDatas* statusModel = layout.statusModel;
                statusModel.comment = newCommentLists;
                
                
                [self.jjrJsonArr replaceObjectAtIndex:_commentIndex.row withObject:[self layoutWithStatusModel:statusModel index:_commentIndex.row]];
                
                [self.dtTab reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_commentIndex.row inSection:0]]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
        }
        else
        {
            [[ToolManager shareInstance] showInfoWithStatus:info];
        }
        
    }];
    
    
}
/***  点赞 ***/
- (void)tableViewCell:(TableViewCell *)cell didClickedLikeWithCellLayout:(CellLayout *)layout atIndexPath:(NSIndexPath *)indexPath {
    
    /* 由于是异步绘制，而且为了减少View的层级，整个显示内容都是在同一个UIView上面，所以会在刷新的时候闪一下，这里可以先把原先Cell的内容截图覆盖在Cell上，
     延迟0.25s后待刷新完成后，再将这个截图从Cell上移除 */
    UIImage* screenshot = [GallopUtils screenshotFromView:cell];
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:[self.dtTab convertRect:cell.frame toView:self.dtTab]];
    imgView.image = screenshot;
    [self.dtTab addSubview:imgView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [imgView removeFromSuperview];
    });
    self.view.userInteractionEnabled = NO;
    [[HomeInfo shareInstance ]dynamicIsLike:[NSString stringWithFormat:@"%li",layout.statusModel.ID] islike:layout.statusModel.islike andcallBack:^(BOOL issucced, NSString *info, NSDictionary *jsonDic) {
        self.view.userInteractionEnabled = YES;
        if (issucced == YES) {
            if (jsonDic[@"datas"]) {
                
                StatusLike *like = [[StatusLike alloc]init];
                like.brokerid = [jsonDic[@"datas"][@"brokerid"] integerValue];
                like.sex = [jsonDic[@"datas"][@"sex"] boolValue];
                like.imgurl = jsonDic[@"datas"][@"imgurl"];
                NSString * urlpic = like.imgurl;
                if (![urlpic hasPrefix:@"http"]) {
                    urlpic = [NSString stringWithFormat:@"%@%@",ImageURLS,urlpic];
                }
                like.imgurl =urlpic;
                
                if (!layout.statusModel.islike) {
                    [[ToolManager shareInstance] showSuccessWithStatus:@"点赞成功"];
                    NSMutableArray* newLikeList = [[NSMutableArray alloc] initWithArray:layout.statusModel.like];
                    if (![newLikeList containsObject:like]) {
                        [newLikeList insertObject:like atIndex:0];
                    }
                    
                    StatusDatas* statusModel =layout.statusModel;
                    statusModel.like = newLikeList;
                    statusModel.islike = [jsonDic[@"datas"][@"islike"] boolValue];
                    statusModel.ID =[jsonDic[@"datas"][@"id"] integerValue];
                    
                    [self.jjrJsonArr replaceObjectAtIndex:indexPath.row withObject:[self layoutWithStatusModel:statusModel index:indexPath.row]];
                    [self.dtTab reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
                } else {
                    [[ToolManager shareInstance] showSuccessWithStatus:@"取消赞成功"];
                    NSMutableArray* newLikeList = [[NSMutableArray alloc] initWithArray:layout.statusModel.like];
                    for (StatusLike *statusLike in layout.statusModel.like) {
                        if (statusLike.brokerid ==like.brokerid) {
                            [newLikeList removeObject:statusLike];
                        }
                    }
                    
                    StatusDatas* statusModel = layout.statusModel;
                    statusModel.like = newLikeList;
                    statusModel.islike = [jsonDic[@"datas"][@"islike"] boolValue];
                    statusModel.ID =[jsonDic[@"datas"][@"id"] integerValue];
                    
                    [self.jjrJsonArr replaceObjectAtIndex:indexPath.row withObject:[self layoutWithStatusModel:statusModel index:indexPath.row]];
                    [self.dtTab reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                }
            }
            
            
        }else
        {
            [[ToolManager shareInstance]showAlertMessage:info];
        }
        
        
    }];
}

/***  点击图片 ***/
- (void)tableViewCell:(TableViewCell *)cell didClickedImageWithCellLayout:(CellLayout *)layout atIndex:(NSInteger)index {
    
    NSMutableArray* tmp = [[NSMutableArray alloc] initWithCapacity:layout.imagePostionArray.count];
    for (NSInteger i = 0; i < layout.imagePostionArray.count; i ++) {
        
        LWImageBrowserModel* imageModel = [[LWImageBrowserModel alloc] initWithplaceholder:nil
                                                                              thumbnailURL:[NSURL URLWithString:layout.statusModel.pic[i].abbre_imgurl]
                                                                                     HDURL:[NSURL URLWithString:layout.statusModel.pic[i].imgurl]
                                                                        imageViewSuperView:cell.contentView
                                                                       positionAtSuperView:CGRectFromString(layout.imagePostionArray[i])
                                                                                     index:index];
        [tmp addObject:imageModel];
    }
    LWImageBrowser* imageBrowser = [[LWImageBrowser alloc] initWithParentViewController:self
                                                                            imageModels:tmp
                                                                           currentIndex:index];
    imageBrowser.view.backgroundColor = [UIColor blackColor];
    [imageBrowser show];
}
/***  点击链接 ***/
- (void)tableViewCell:(TableViewCell *)cell  cellLayout:(CellLayout *)layout  atIndexPath:(NSIndexPath *)indexPath didClickedLinkWithData:(id)data {
    
    if ([data isKindOfClass:[StatusComment class]]) {
        
        StatusComment* commentModel = (StatusComment *)data;
        if (commentModel.me) {
            
            [[ToolManager shareInstance] showAlertViewTitle:@"删除？" contentText:@"删除此评论？" showAlertViewBlcok:^{
                
                /* 由于是异步绘制，而且为了减少View的层级，整个显示内容都是在同一个UIView上面，所以会在刷新的时候闪一下，这里可以先把原先Cell的内容截图覆盖在Cell上，
                 延迟0.25s后待刷新完成后，再将这个截图从Cell上移除 */
                UIImage* screenshot = [GallopUtils screenshotFromView:cell];
                UIImageView* imgView = [[UIImageView alloc] initWithFrame:[self.dtTab convertRect:cell.frame toView:self.dtTab]];
                imgView.image = screenshot;
                [self.dtTab addSubview:imgView];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [imgView removeFromSuperview];
                });
                self.view.userInteractionEnabled = NO;
                [[HomeInfo shareInstance ] deleteDynamicComment:[NSString stringWithFormat:@"%ld",commentModel.ID] andcallBack:^(BOOL issucced, NSString *info, NSDictionary *jsonDic) {
                    
                    self.view.userInteractionEnabled = YES;
                    if (issucced == YES) {
                        
                        NSMutableArray* newcommentList = [[NSMutableArray alloc] initWithArray:layout.statusModel.comment];
                        for (StatusComment*statusComment in layout.statusModel.comment) {
                            if (statusComment.ID ==commentModel.ID) {
                                [newcommentList removeObject:statusComment];
                            }
                            
                            StatusDatas* statusModel = layout.statusModel;
                            statusModel.comment = newcommentList;
                            
                            [self.jjrJsonArr replaceObjectAtIndex:indexPath.row withObject:[self layoutWithStatusModel:statusModel index:indexPath.row]];
                            [self.dtTab reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:0]]withRowAnimation:UITableViewRowAnimationAutomatic];
                            
                            
                        }
                        
                        
                    }else
                    {
                        [[ToolManager shareInstance]showAlertMessage:info];
                    }
                    
                    
                }];
                
                
            }];
        }
        else
        {
            [_textField becomeFirstResponder];
            _textField.placeholder =[NSString stringWithFormat:@"回复%@:",commentModel.info.realname];
            _dynamicID =[NSString stringWithFormat:@"%ld",layout.statusModel.ID];
            _commentType = @"replay";
            _replayid = [NSString stringWithFormat:@"%ld",commentModel.info.brokerid];
            _commentCell =cell;
            _commentIndex = indexPath;
        }
        
    } else {
        if ([data isKindOfClass:[NSString class]]) {
            /**
             *  点击关闭
             */
            if ([data isEqualToString:@"*closeStorage*"]) {
                
                CellLayout* layout =  [self.jjrJsonArr objectAtIndex:indexPath.row];
                StatusDatas* model = layout.statusModel;
                CellLayout* newLayout = [[CellLayout alloc] initWithStatusModel:model index:indexPath.row isDetail:NO];
                [self.jjrJsonArr replaceObjectAtIndex:indexPath.row withObject:newLayout];
                [self.dtTab beginUpdates];
                [self.dtTab reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.dtTab endUpdates];
                return;
            }
            /**
             *  点击展开
             */
            if ([data isEqualToString:@"*openStorage*"]) {
                
                CellLayout* layout =  [self.jjrJsonArr objectAtIndex:indexPath.row];
                StatusDatas* model = layout.statusModel;
                CellLayout* newLayout = [[CellLayout alloc] initContentOpendLayoutWithStatusModel:model index:indexPath.row isDetail:NO];
                [self.jjrJsonArr replaceObjectAtIndex:indexPath.row withObject:newLayout];
                [self.dtTab beginUpdates];
                [self.dtTab reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.dtTab endUpdates];
                
                return;
            }
            
            JJRDetailVC * jjrV = [[JJRDetailVC alloc]init];
            jjrV.jjrID = data;
            [self.navigationController pushViewController:jjrV animated:YES];
            
        }
        else if ([data isKindOfClass:[NSDictionary class]])
        {
            if ([data[@"key"] isEqualToString:@"查看更多"]) {
                
                DynamicDetailsViewController*dynamicDetailsViewController = allocAndInit(DynamicDetailsViewController);
                dynamicDetailsViewController.dynamicdID = data[@"id"];
                dynamicDetailsViewController.jjrJsonArr = allocAndInit(NSMutableArray);
                [dynamicDetailsViewController.jjrJsonArr addObject:_jjrJsonArr[indexPath.row]];
                dynamicDetailsViewController.deleteDynamicDetailSucceed = ^(BOOL succeed,CellLayout *cellLayout)
                {
                    if (succeed) {
                        [_jjrJsonArr removeObjectAtIndex:indexPath.row];
                        [_dtTab reloadData];
                    }
                    else
                    {
                        CellLayout *currentLayout =_jjrJsonArr[indexPath.row];
                        
                        [_jjrJsonArr replaceObjectAtIndex:indexPath.row withObject:[self layoutWithStatusModel:currentLayout.statusModel index:indexPath.row]];
                        [_dtTab reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    }
                    
                    
                };
                
                
                PushView(self, dynamicDetailsViewController);
            }
        }

    }
}
//点击点赞头像
- (void)tableViewCell:(TableViewCell *)cell didClickedLikeButtonWithJJRId:(NSString *)JJRId{
    
    JJRDetailVC * jjrV = [[JJRDetailVC alloc]init];
    jjrV.jjrID = JJRId;
    [self.navigationController pushViewController:jjrV animated:YES];
    
}
//更多按钮事件
- (void)tableViewCell:(TableViewCell *)cell didClickedLikeButtonWithIsSelf:(BOOL)isSelf andDynamicID:(NSString *)andDynamicID atIndexPath:(NSIndexPath *)indexPath andIndex:(NSInteger)index
{
    
    if (isSelf) {
        self.view.userInteractionEnabled = NO;
        [[HomeInfo shareInstance ]deleteDynamic:andDynamicID andcallBack:^(BOOL issucced, NSString *info, NSDictionary *jsonDic) {
            self.view.userInteractionEnabled = YES;
            if (issucced == YES) {
                
                [self.jjrJsonArr removeObjectAtIndex:indexPath.row];
                
                [self.dtTab reloadData];
                
            }else
            {
                [[ToolManager shareInstance]showAlertMessage:info];
            }
            
            
        }];
        
        
    }
    else
    {
        if (index ==0) {
            
            CellLayout *cell = _jjrJsonArr[indexPath.row];
            [[HomeInfo shareInstance]guanzhuTargetID:cell.statusModel.brokerid andIsFollow:cell.statusModel.isfollow andcallBack:^(BOOL issucced, NSString *info, NSDictionary *jsonArr) {
                if (jsonArr) {
                    cell.statusModel.isfollow = [jsonArr[@"isfollow"] boolValue];
                    [_jjrJsonArr replaceObjectAtIndex:indexPath.row withObject:[self layoutWithStatusModel:cell.statusModel index:indexPath.row]];
                    [_dtTab reloadRowsAtIndexPaths:@[indexPath] withRowAnimation: UITableViewRowAnimationFade];
                }
                
                if (issucced == YES) {
                    
                    if (cell.statusModel.isfollow ) {
                        [[ToolManager shareInstance] showSuccessWithStatus:@"取消关注成功"];
                    }
                    else
                    {
                        [[ToolManager shareInstance] showSuccessWithStatus:@"关注成功"];
                    }
                    
                    
                    
                }else
                {
                    HUDText(info);
                }
                
            }];
            
        }
        else
        {
            [[ToolManager shareInstance] showSuccessWithStatus:@"举报成功"];
        }
        
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
