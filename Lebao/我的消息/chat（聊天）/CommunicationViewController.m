//
//  CommunicationViewController.m
//  Lebao
//
//  Created by David on 15/12/28.
//  Copyright © 2015年 David. All rights reserved.
//

#import "CommunicationViewController.h"
#import "MessageModel.h"
#import "CellFrameModel.h"
#import "CommunityMessageCell.h"
#import "JJRDetailVC.h"
#import "XLDataService.h"
#import "DXAlertView.h"
//交流列表
#define CommunicatelistURL [NSString stringWithFormat:@"%@message/chat",HttpURL]
//发送交流
#define CommunicateURL [NSString stringWithFormat:@"%@message/send",HttpURL]

#define kToolBarH 44
#define kTextFieldH 30
@interface CommunicationViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@end

typedef NS_ENUM(NSUInteger,ButtonActionTag) {
    
    ButtonActionTagSend =2,
    
};
@implementation CommunicationViewController
{
    NSMutableArray *_cellFrameDatas;
    UITableView *_chatView;
    UIImageView *_toolBar;
    UITextField *_textField;
    UIScrollView *_mainSrollView;
    int _page;
    int _nowPage;
    UIButton *_sendBtn;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self navView];
 
    //0.加载数据
   [self netWork:NO isFooter:NO isShouldClear:NO isSend:YES sender:nil];
    
    //1.tableView
    [self addChatView];
    
    //2.工具栏
    [self addToolBar];
    
  
}
#pragma mark - Navi_View
- (void)navView
{
    
    [self navViewTitleAndBackBtn:@"交流" ];
}

/**
 *  添加TableView
 */
- (void)addChatView
{
    _cellFrameDatas =[NSMutableArray array];
    _mainSrollView = allocAndInitWithFrame(UIScrollView, CGRectMake(0, StatusBarHeight  +NavigationBarHeight, self.view.frame.size.width, frameHeight(self.view) -(StatusBarHeight  + NavigationBarHeight) ));
    _mainSrollView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:_mainSrollView];
    
    
    UITableView *chatView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, frameHeight(self.view) - kToolBarH -(StatusBarHeight  + NavigationBarHeight)) style:UITableViewStyleGrouped];
    
    chatView.backgroundColor = [UIColor clearColor];
    chatView.delegate = self;
    chatView.dataSource = self;
    chatView.separatorStyle = UITableViewCellSeparatorStyleNone;
    chatView.allowsSelection = NO;
    [chatView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)]];
    _chatView = chatView;
    
    [_mainSrollView addSubview:chatView];
    
    
    //初始化UIRefreshControl
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = AppMainColor;
    [chatView addSubview:refreshControl];
}
- (void)refresh:(id)sender
{
    _page = _nowPage+ 1;
    [self netWork:YES isFooter:NO isShouldClear:NO isSend:NO sender:sender];
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
    
//    UIButton *expressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//   
//    expressBtn.frame = CGRectMake(CGRectGetMaxX(_textField.frame), 0, 30, frameHeight(textView));
//    [expressBtn setImage:[UIImage imageNamed:@"chat_bottom_smile_nor"] forState:UIControlStateNormal];
//    [textView addSubview:expressBtn];
    
    
   _sendBtn = [UIButton createButtonWithfFrame:frame(CGRectGetMaxX(textView.frame)+15*ScreenMultiple, 8, 62*ScreenMultiple, 28) title:@"发送" backgroundImage:nil iconImage:nil highlightImage:nil tag:ButtonActionTagSend inView:bgView];
    _sendBtn.titleLabel.font = Size(28);
      [_sendBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    _sendBtn.layer.masksToBounds = YES;
    _sendBtn.layer.cornerRadius = 3.0;
    _sendBtn.backgroundColor = AppMainColor;
    [_sendBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

}

#pragma mark - tableView的数据源和代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellFrameDatas.count;
}

- (CommunityMessageCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    CommunityMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[CommunityMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.cellFrame = _cellFrameDatas[indexPath.row];
    
    cell.didClickIcon = ^(CellFrameModel * cellModal){
        MessageModel *message = cellModal.message;
        JJRDetailVC *jjrDetail = allocAndInit(JJRDetailVC);
        jjrDetail.jjrID = message.ID;
        PushView(self, jjrDetail);
    
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellFrameModel *cellFrame = _cellFrameDatas[indexPath.row];
    return cellFrame.cellHeght;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


- (void)endEdit
{
    [self.view endEditing:YES];
}

#pragma mark
#pragma mark - netWork-
- (void)netWork:(BOOL)isRefresh isFooter:(BOOL)isFooter isShouldClear:(BOOL)isShouldClear isSend:(BOOL)isSend sender:(id)sender
{
   
    NSMutableDictionary *param = [Parameter parameterWithSessicon];
    if (_chatType == ChatRedEnvelopePTpye) {
        [param setObject:_sourcetype forKey:@"sourcetype"];
        [param setObject:_sourceid forKey:@"sourceid"];
        [param setObject:_receiver forKey:@"receiver"];
    }
    if (_chatType == ChatMessageTpye) {
        [param setObject:_senderid forKey:@"senderid"];
    }
    if (_chatType == ChatCustomerTpye) {
        [param setObject:_senderid forKey:@"senderid"];
        [param setObject:_sourcetype forKey:@"sourcetype"];
    }
    [param setObject:@(_page) forKey:@"page"];
    if (_cellFrameDatas.count==0) {
         [[ToolManager shareInstance] showWithStatus];
    }
   
        [XLDataService postWithUrl:CommunicatelistURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
       
         if (isRefresh) {
             if (sender) {
                  [(UIRefreshControl *)sender endRefreshing];
             }

         }
    
          if (dataObj) {
                CommunityModal *modal=[CommunityModal mj_objectWithKeyValues:dataObj];
                if (modal.rtcode ==1) {
                    [[ToolManager shareInstance] dismiss];
                    if (isShouldClear) {
                        [_cellFrameDatas removeAllObjects];
                        
                    }
                    _nowPage = modal.page;
                   _receiver = modal.receiver;
                    for (CommunityDataModal *data  in modal.datas) {
                       
                        MessageModel *message = [MessageModel messageModelWithModal:data];
                        CellFrameModel *lastFrame = [_cellFrameDatas lastObject];
                        CellFrameModel *cellFrame = [[CellFrameModel alloc] init];
                        message.showTime = ![message.time isEqualToString:lastFrame.message.time];
                        cellFrame.message = message;
                        [_cellFrameDatas insertObject:cellFrame atIndex:0];
                        
                    }
                    
                        [_chatView reloadData];
                        if (isSend&&_cellFrameDatas.count>=1) {
                            //5.自动滚到最后一行
                            NSIndexPath *lastPath = [NSIndexPath indexPathForRow:_cellFrameDatas.count - 1 inSection:0];
                            [_chatView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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

#pragma mark - UITextField的代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    [self buttonAction:_sendBtn];
    return YES;
}
#pragma mark
#pragma mark - buttonAction -
- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag ==NavViewButtonActionNavLeftBtnTag ) {
        if (_isPopRoot) {
            PopRootView(self);
            return;
        }
       
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
       
        if (!_receiver) {
            [[ToolManager shareInstance] showInfoWithStatus:@"接受者不能为空"];
            return;
        }
        
        if (_chatType == ChatRedEnvelopePTpye) {
            [param setObject:_sourcetype forKey:@"sourcetype"];
            [param setObject:_sourceid forKey:@"sourceid"];
            [param setObject:_receiver forKey:@"receiverid"];
        }
        if (_chatType == ChatMessageTpye) {
           [param setObject:_receiver forKey:@"receiver"];
        }
        if (_chatType == ChatCustomerTpye) {
            [param setObject:_sourcetype forKey:@"sourcetype"];
            [param setObject:_receiver forKey:@"receiver"];
        }

        [param setObject:_textField.text forKey:@"content"];
        [XLDataService postWithUrl:CommunicateURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        
            if (dataObj) {
                if ([dataObj[@"rtcode"] intValue] ==1) {
                    [[ToolManager shareInstance] dismiss];
                    _textField.text = @"";
                    self.data = dataObj[@"datas"];
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
//
        
    }
}
- (void)setData:(NSDictionary *)data
{
    //NSLog(@"data = %@",data);
    CommunityDataModal *modal =[CommunityDataModal mj_objectWithKeyValues:data];
    MessageModel *message = [MessageModel messageModelWithModal:modal];
    CellFrameModel *lastFrame = [_cellFrameDatas lastObject];
    CellFrameModel *cellFrame = [[CellFrameModel alloc] init];
    message.showTime = ![message.time isEqualToString:lastFrame.message.time];
    cellFrame.message = message;
    [_cellFrameDatas addObject:cellFrame];
    [_chatView reloadData];
    
    if (_cellFrameDatas.count>=1) {
        //5.自动滚到最后一行
        NSIndexPath *lastPath = [NSIndexPath indexPathForRow:_cellFrameDatas.count - 1 inSection:0];
        [_chatView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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
