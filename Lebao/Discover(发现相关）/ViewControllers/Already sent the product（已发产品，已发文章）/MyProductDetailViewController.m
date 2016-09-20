//
//  MyProductDetailViewController.m
//  Lebao
//
//  Created by David on 16/4/7.
//  Copyright © 2016年 David. All rights reserved.
//

#import "MyProductDetailViewController.h"
#import "ReleaseProductViewController.h"//编辑发布文章
#import "MyArticleDetailView.h"
#import "XLDataService.h"
#import "WetChatShareManager.h"
#import "FSComboListView.h"
#define Readdetail [NSString stringWithFormat:@"%@product/detailother",HttpURL]
#define SubcollectUrl  [NSString stringWithFormat:@"%@product/subcollect",HttpURL]
@interface MyProductDetailViewController ()
@property(nonatomic,strong)MyArticleDetailModal *modal;
@property(nonatomic,strong)BaseButton *next;
@property(nonatomic,strong)MyArticleDetailView *articleDetailView;
@property(nonatomic,assign)BOOL isGongxian;

@property(nonatomic,strong)BaseButton *joinBg;
@property(nonatomic,strong)UIScrollView *joinview;
@property(nonatomic,strong)BaseButton *sendBtn;
@property(nonatomic,strong)UITextField *userNameTextField;
@property(nonatomic,strong)FSComboListView *sexBox;
@property(nonatomic,strong)UITextField *phoneTextField;
@property(nonatomic,strong)UITextField *companyTextField;
@property(nonatomic,strong)UITextField *remarksTextField;
@property(nonatomic,strong)UITextField *jobTextField;
@end
typedef enum{
    
    ButtonActionTagAdd =2,
    
    
}ButtonActionTag;

@implementation MyProductDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navView];
    
    NSMutableDictionary *parame = [Parameter parameterWithSessicon];
    [parame setObject:_uid forKey:@"uid"];
    [parame setObject:_ID forKey:@"acid"];
    [self addMainView:parame];
    
}
#pragma mark - Navi_View
- (void)navView
{

    [self navViewTitleAndBackBtn:@"产品详情"];
    
}
- (void)addMainView:(NSMutableDictionary *)parame
{
    
    __weak MyProductDetailViewController *weakSelf =self;
    
    _articleDetailView = [[MyArticleDetailView alloc]initWithFrame:frame(0, NavigationBarHeight + StatusBarHeight + 10, APPWIDTH, APPHEIGHT - (60 + NavigationBarHeight + StatusBarHeight)) postWithUrl:Readdetail param:parame];
    _articleDetailView.ishasNextPage = NO;
    _articleDetailView.editBlock = ^(MyArticleDetailModal *modal)
    {
        
        ReleaseProductViewController *edit =allocAndInit(ReleaseProductViewController);
        ReleaseProduct *data = allocAndInit(ReleaseProduct);
        data.content = weakSelf.modal.datas.content;
        data.documentID = weakSelf.modal.datas.ID;
        data.isAddress = weakSelf.modal.datas.isaddress;
        data.iscollect = weakSelf.modal.datas.iscollect;
        data.iscross = weakSelf.modal.datas.iscross;
        data.currentImageurl =  weakSelf.imageurl;
        data.isgetclue = weakSelf.modal.datas.isgetclue;
        data.title =weakSelf.modal.datas.title;
        data.author =weakSelf.modal.datas.author;
        data.isreward =weakSelf.modal.datas.isreward;
        data.reward = weakSelf.modal.datas.reward;
        NSArray *array =[weakSelf.modal.datas.productpics componentsSeparatedByString:@","];
        data.imageurl = allocAndInit(NSMutableArray);
        if (array.count>0&&![weakSelf.modal.datas.productpics isEqualToString:@""]) {
            for (NSString *str  in array) {
                [data.imageurl addObject:str];
            }
            
        }
        NSArray *arrayselecteds =[weakSelf.modal.datas.fields componentsSeparatedByString:@","];
        data.selecteds = [NSMutableArray arrayWithObjects:@"0", @"0",@"0",@"0",@"0",@"0",nil];
        
        NSArray *arrayName = @[@"name",@"sex",@"tel",@"company",@"position",@"remark"];
        
        if (arrayselecteds.count>0) {
            for ( int i =0;i<arrayName.count;i++) {
                NSString *str = arrayName[i];
                if ([arrayselecteds containsObject:str]) {
                    [data.selecteds replaceObjectAtIndex:i withObject:str];
                }
                
            }
            
        }

        data.isEdit = YES;
        data.amount = weakSelf.modal.datas.amount;
        edit.data = data;
        
        PushView(weakSelf, edit);
    };
    _articleDetailView.modalBlock = ^(MyArticleDetailModal *modal)
    {
        
        
        weakSelf.modal =modal;
        
       [weakSelf addBotoomView:modal.datas.iscollect weakSelf:weakSelf];
        
        
    };
   
    _articleDetailView.isEdit = !_isNoEdit;
    //    articleDetailView.ishasNextPage = NO;
    [self.view addSubview:_articleDetailView];
}
- (void)addBotoomView:(BOOL)is weakSelf:(MyProductDetailViewController *)weakSelf
{
    UIView *_botoomView = allocAndInitWithFrame(UIView, frame(0, APPHEIGHT - 50, APPWIDTH, 50));
    _botoomView.backgroundColor = WhiteColor;
    [_botoomView setBorder:LineBg width:0.5];
    [self.view addSubview:_botoomView];
   
    UIColor *color = weakSelf.isGongxian?AppMainColor:LightBlackTitleColor;
    
    CGRect _nextframe;
    if (is) {
        _nextframe = frame(20, 8, 115*ScreenMultiple, 34);
        _next = [[BaseButton alloc]initWithFrame:frame(frameWidth(_botoomView) - CGRectGetMaxX(_nextframe) , 8, 115*ScreenMultiple, 34) setTitle: @"参加报名" titleSize:26*SpacedFonts titleColor:color textAlignment:NSTextAlignmentCenter backgroundColor:WhiteColor inView:_botoomView];
        [_next setBorder:color width:0.5];
        [_next setRoundWithfloat:frameWidth(_next)/8.0];
        _next.didClickBtnBlock = ^
        {
            __strong MyProductDetailViewController *strong = weakSelf;
            if (weakSelf.modal.datas.fields||weakSelf.modal.datas.fields.length>0) {
               
                if (!weakSelf.joinBg) {
                    weakSelf.joinBg = [[BaseButton alloc]initWithFrame:weakSelf.view.window.frame setTitle:@"" titleSize:0 titleColor:WhiteColor textAlignment:0 backgroundColor: rgba(0, 0, 0, 0.4) inView:weakSelf.view];
                    
                    
                    weakSelf.joinBg.didClickBtnBlock = ^
                    {
                        strong.joinBg.hidden = YES;
                    };
                    
                }
                else
                {
                    weakSelf.joinBg.hidden = NO;
                }
                if (!weakSelf.joinview) {
                    
                    NSArray *fields = [weakSelf.modal.datas.fields componentsSeparatedByString:@","];
                    float cellH = 90 + 50*fields.count;
                    weakSelf.joinview = allocAndInitWithFrame(UIScrollView, frame(20, (frameHeight(weakSelf.joinBg) - cellH)/2.0, frameWidth(weakSelf.joinBg) -40, cellH));
                    weakSelf.joinview.backgroundColor = WhiteColor;
                    [weakSelf.joinBg addSubview:weakSelf.joinview];
                    [UILabel createLabelWithFrame:frame(20, 0, frameWidth(weakSelf.joinview) - 20, 40) text:@"参与者信息" fontSize:28*SpacedFonts textColor:AppMainColor textAlignment:NSTextAlignmentLeft inView:weakSelf.joinview];
                    
                    float cellY = 40;
                    float cellX = 20;
                    float textFieldW = frameWidth(weakSelf.joinview) - 2*cellX;
                    float textFieldH = 50;
                    if ([fields containsObject:@"name"]) {
                        
                        _userNameTextField = [weakSelf textFieldWithframe:frame(cellX, cellY, textFieldW, textFieldH) name:@"姓名" place:@"请输入您的姓名" view:weakSelf.joinview];
                        cellY+=50;
                    }
                    if ([fields containsObject:@"sex"]) {
                      
                        UIView *bg =allocAndInitWithFrame(UIView, frame(cellX, cellY, textFieldW, textFieldH - 15));
                        [bg setRadius:4];
                        [bg setBorder:LineBg width:0.5];
                        [weakSelf.joinview addSubview:bg];
                        
                        UILabel *text = [UILabel createLabelWithFrame:frame(5, 0,2*24*SpacedFonts, bg.size.height) text:@"性别" fontSize:24*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:bg];
                        weakSelf.sexBox = [[FSComboListView alloc] initWithValues:@[@"男",@"女"]
                                                                      frame:frame(CGRectGetMaxX(text.frame) + 10 , 5, frameWidth(bg) -(CGRectGetMaxX(text.frame) + 20), 25)];
                        weakSelf.sexBox.Combotype = comboListTypePicker;
                        weakSelf.sexBox.valueLabel.layer.borderColor = WhiteColor.CGColor;
                        [bg addSubview:weakSelf.sexBox];
                         cellY+=50;
                    }
                    if ([fields containsObject:@"tel"]) {
                        
                        _phoneTextField = [weakSelf textFieldWithframe:frame(cellX, cellY, textFieldW, textFieldH) name:@"联系电话" place:@"请输入您常用的电话号码" view:weakSelf.joinview];
                        
                         cellY+=50;
                    }
                    if ([fields containsObject:@"company"]) {
                       
                        _companyTextField = [weakSelf textFieldWithframe:frame(cellX, cellY, textFieldW, textFieldH) name:@"公司名称" place:@"请输入您的公司名称" view:weakSelf.joinview];
                      
                        cellY+=50;
                    }
                    if ([fields containsObject:@"position"]) {
                       
                        _jobTextField = [weakSelf textFieldWithframe:frame(cellX, cellY, textFieldW, textFieldH) name:@"公司职位" place:@"请输入您的公司职位" view:weakSelf.joinview];
                        
                        cellY+=50;
                    }
                    if ([fields containsObject:@"remark"]) {
                        _remarksTextField = [weakSelf textFieldWithframe:frame(cellX, cellY, textFieldW, textFieldH) name:@"备注" place:@"请输入备注" view:weakSelf.joinview];
                    
                         cellY+=50;
                    }
                    
                    
                    weakSelf.sendBtn = [[BaseButton alloc]initWithFrame:frame((frameWidth(weakSelf.joinview) - 120)/2.0, cellY,120, 35) setTitle:@"提交订单" titleSize:28*SpacedFonts titleColor:WhiteColor textAlignment:NSTextAlignmentCenter backgroundColor:AppMainColor inView:weakSelf.joinview];
                    [weakSelf.sendBtn setRadius:5];
                    
                    weakSelf.sendBtn.didClickBtnBlock =
                    ^{
                        NSMutableDictionary *parameter = [Parameter parameterWithSessicon];
                       [parameter setValue:strong.modal.datas.ID forKey:@"acid"];
                        if ([fields containsObject:@"name"]) {
                            if (strong.userNameTextField.text.length==0||strong.userNameTextField.text.length>16) {
                                [[ToolManager shareInstance] showInfoWithStatus:@"请输入姓名(不能超过32个字节)"];
                                return ;
                            }
                            [parameter setValue:strong.userNameTextField.text forKey:@"name"];
                        
                        }
                        if ([fields containsObject:@"sex"]) {
                            
                            NSString *sex =@"1";
                            if ([strong.sexBox.valueLabel.text isEqualToString:@"男"]) {
                                sex =@"1";
                            }
                            else
                            {
                                sex =@"2";
                            }
                            [parameter setValue:sex forKey:@"sex"];
                        }
                        if ([fields containsObject:@"tel"]) {
                            
                            if (strong.phoneTextField.text.length==0) {
                                [[ToolManager shareInstance] showInfoWithStatus:@"请输入号码"];
                              
                                return ;
                            }
                            if (strong.phoneTextField.text.length!=11) {
                                [[ToolManager shareInstance] showInfoWithStatus:@"号码有误"];
                                
                                return ;
                            }
                            [parameter setValue:strong.phoneTextField.text forKey:@"tel"];
                        }
                        if ([fields containsObject:@"company"]) {
                            if (strong.companyTextField.text.length==0||strong.companyTextField.text.length>16) {
                                [[ToolManager shareInstance] showInfoWithStatus:@"请输入公司名称(不能超过32个字节)"];
                                return ;
                            }
                            [parameter setValue:strong.companyTextField.text forKey:@"company"];
                          
                        }
                        if ([fields containsObject:@"position"]) {
                            if (strong.jobTextField.text.length==0||strong.jobTextField.text.length>16) {
                                [[ToolManager shareInstance] showInfoWithStatus:@"请输入职位(不能超过32个字节)"];
                                return ;
                            }
                            [parameter setValue:strong.jobTextField.text forKey:@"position"];
                        }
                        if ([fields containsObject:@"remark"]) {
                            if (strong.remarksTextField.text.length==0) {
                                [[ToolManager shareInstance] showInfoWithStatus:@"请输入备注"];
                                return ;
                            }
                            [parameter setValue:strong.remarksTextField.text forKey:@"remark"];
                        }
//                         NSLog(@"parameter =%@",parameter);
                        [[ToolManager shareInstance] showWithStatus:@"报名中..."];
                        [XLDataService postWithUrl:SubcollectUrl param:parameter modelClass:nil responseBlock:^(id dataObj, NSError *error) {
//                            NSLog(@"dataObj =%@",dataObj);
                            if (dataObj) {
                                if ([dataObj[@"rtcode"] integerValue] ==1) {
                                    strong.joinBg.hidden = YES;
                                    [[ToolManager shareInstance] showSuccessWithStatus:@"参加成功"];
                                }
                                else
                                {
                                    [[ToolManager shareInstance] showInfoWithStatus:dataObj[@"rtmsg"]];
                                }
                            }
                            else
                            {
                                [[ToolManager shareInstance] showInfoWithStatus];
                            }
                        }];

                    
                    };
                };
//                NSLog(@"fields = %@",weakSelf.modal.datas.fields);
            }
            
            
        };
        
       
    }
    else
    {
       _nextframe = frame((frameWidth(_botoomView) - 115*ScreenMultiple)/2.0, 8, 115*ScreenMultiple, 34);
    }
    BaseButton *_share = [[BaseButton alloc]initWithFrame:_nextframe setTitle:@"分享" titleSize:26*SpacedFonts titleColor:BlackTitleColor textAlignment:NSTextAlignmentCenter backgroundColor:WhiteColor inView:_botoomView];
    [_share setBorder:LightBlackTitleColor width:0.5];
    [_share setRoundWithfloat:frameWidth(_share)/8.0];
    
    _share.didClickBtnBlock = ^{
        
        [[WetChatShareManager shareInstance] shareToWeixinApp:weakSelf.modal.datas.title desc:@"" image:weakSelf.shareImage  shareID:weakSelf.modal.datas.ID isWxShareSucceedShouldNotice:weakSelf.modal.datas.isreward isAuthen:weakSelf.modal.datas.isgetclue];
    };
    
    
}
- (UITextField *)textFieldWithframe:(CGRect)frame name:(NSString *)name place:(NSString *)place view:(UIView *)view
{
    
    UIView *bg =allocAndInitWithFrame(UIView, frame(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height - 15));
    [bg setRadius:4];
    [bg setBorder:LineBg width:0.5];
    [view addSubview:bg];
    
    UILabel *text = [UILabel createLabelWithFrame:frame(5, 0,name.length*24*SpacedFonts, bg.size.height) text:name fontSize:24*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:bg];
    
    UITextField *field = allocAndInitWithFrame(UITextField, frame(CGRectGetMaxX(text.frame)+ 10, 0, bg.size.width - (CGRectGetMaxX(text.frame)+ 20), bg.size.height));
    field.placeholder = place;
    field.font = Size(24);
    [bg addSubview:field];
    
    return field;
    

}
#pragma mark
#pragma mark - buttonAction -
- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag ==NavViewButtonActionNavLeftBtnTag ) {
        PopView(self);
    }
    else if (sender.tag ==ButtonActionTagAdd)
    {
        [[ToolManager shareInstance] addReleseDctView:self];
    }
    
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