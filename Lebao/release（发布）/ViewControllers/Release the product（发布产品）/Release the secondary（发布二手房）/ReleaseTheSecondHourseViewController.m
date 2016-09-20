//
//  ReleaseTheSecondHourseViewController.m
//  Lebao
//
//  Created by David on 16/4/11.
//  Copyright © 2016年 David. All rights reserved.
//

#import "ReleaseTheSecondHourseViewController.h"
#import "UpLoadImageManager.h"
#import "XLDataService.h"
#import "AlreadysentproductViewController.h"
#define ImageURlText @"/product/default"
#define ImageURlDiagramText @"/diagram/product/default"
#define ImageDefault @"ImageDefault"
#define ImageDiagram @"ImageDiagram"
//保存产品和房源
#define Saveproduct [NSString stringWithFormat:@"%@product/saveestate",HttpURL]

//发布文章
#define CreatearticleUrl  [NSString stringWithFormat:@"%@release/create",HttpURL]
@interface ReleaseTheSecondHourseViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)BaseButton *selectedTag;
@property(nonatomic,strong)NSMutableArray *selecteds;
@property(nonatomic,strong)NSMutableArray *selectedItems;

@property(nonatomic,strong)BaseButton *selectedfloor;
@property(nonatomic,strong)NSMutableArray *selectedfloors;
@property(nonatomic,strong)NSMutableArray *selectedfloorsItems;
@property(nonatomic,strong)NSMutableArray *setImages;

@property(nonatomic,strong)BaseButton *feimianBtn;

@property(nonatomic,strong)UITextField *textFieldone;
@property(nonatomic,strong)UITextField *textFieldtwo;
@property(nonatomic,strong)UITextField *textFieldthree;
@property(nonatomic,strong)UITextField *titleTextField;
@property(nonatomic,strong)NSMutableDictionary *fengmianImageUrl;

@property(nonatomic,strong)UISwitch *infoSwitch;
@property(nonatomic,strong)UISwitch *collectSwitch;
@property(nonatomic,strong)UISwitch *redSwitch;
@property(nonatomic,strong)UISwitch *personalInformationSwitch;

@property(nonatomic,strong)UITextField *redTextField;
@end

typedef NS_ENUM(int,SwitchActionTag) {
    
    SwitchActionTagInfo  =2,
    SwitchActionTagCollect,
    SwitchActionTagRed,
    SwitchActionTagPersonalInformation
};
@implementation ReleaseTheSecondHourseViewController
{
   
    
    float redHight;
    UIView *_redViewBg;
   
    
    UIView *_info;
    
    UILabel *_personalInformationLb;
    UILabel *_infoLb;
    UILabel *_collectLb;
    UILabel *_redLb;
    UIView *_redView;
    
    BOOL isHaveDian;
    BaseButton *_nextBtn;
    
    UIView *setImageView;


}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navView];
    
    if (!_data.isEdit) {
        [[ToolManager shareInstance] showWithStatus];
        [XLDataService postWithUrl:CreatearticleUrl param:[Parameter parameterWithSessicon] modelClass:nil responseBlock:^(id dataObj, NSError *error) {
            if (dataObj) {
                if ([dataObj[@"rtcode"] intValue] ==1) {
                    [[ToolManager shareInstance] dismiss];
                    _data.amount =dataObj[@"amount"];
                    [self mainView];
                   
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
        
    }
    else
    {
        [self mainView];
       
    }

    
    
}
#pragma mark - Navi_View
- (void)navView
{
    
    [self navViewTitleAndBackBtn:@"二手房源"];
    
}

#pragma mark
#pragma mark - buttonAction -
- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag ==NavViewButtonActionNavLeftBtnTag ) {
        PopView(self);
    }
}
#pragma mark - mian_View
- (void)mainView
{
    _selecteds = [NSMutableArray new];
    _selectedItems = [NSMutableArray new];
    
    _selectedfloors = [NSMutableArray new];
    _selectedfloorsItems = [NSMutableArray new];
    _setImages = [NSMutableArray new];
    _fengmianImageUrl = [NSMutableDictionary new];
    
    if (_modal.datas.imgurl) {
        [_fengmianImageUrl setValue:_modal.datas.imgurl forKey:ImageDiagram];
        [_fengmianImageUrl setValue:_modal.datas.abbre_cover forKey:ImageDefault];
    }
    
    for (int i=0; i<8; i++) {
        NSMutableArray *array = [NSMutableArray new];
        for (int j =1; j<4; j++) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@%i.jpg",ImageURlText,i*3+j],ImageDefault,[NSString stringWithFormat:@"%@%i.jpg",ImageURlDiagramText,i*3+j],ImageDiagram, nil];
            [array addObject:dic];
            
        }
        [_setImages addObject:array];
    }
                 
    
    _mainScrollView = allocAndInitWithFrame(UIScrollView, frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)));
    _mainScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_mainScrollView];
    
    UILabel *line = allocAndInitWithFrame(UILabel , frame(10, 10, 3, 28*SpacedFonts));
    line.backgroundColor = AppMainColor;
    [_mainScrollView addSubview:line];
    
    [UILabel createLabelWithFrame:frame(CGRectGetMaxX(line.frame) + 4, frameY(line), 4*SpacedFonts*28,  28*SpacedFonts) text:@"选择标签" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:_mainScrollView];
    
//    [UILabel createLabelWithFrame:frame(CGRectGetMaxX(line.frame) + 8 + 4*SpacedFonts*28, frameY(line)+ 2, 6*SpacedFonts*24 ,  24*SpacedFonts) text:@"最多可选3项" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:_mainScrollView];
    //选择标签
    UIView *_selectedTagView = allocAndInitWithFrame(UIView, frame(0, CGRectGetMaxY(line.frame) + 3, APPWIDTH, 0));
    _selectedTagView.backgroundColor = WhiteColor;
    NSArray *titles = [NSArray arrayWithObjects:@"红包在手",@"无个税",@"复式",@"精装修",@"唯一住房",@"南北通透",@"学期房",@"自住满两年",@"学位房",@"钥匙房",@"地铁房",@"新房",@"别墅",@"海景房",nil];

    for (int i=0;i<titles.count;i++) {
        [_selecteds addObject:@"0"];
    }
    if (_modal.datas.labels&&![_modal.datas.labels isEqualToString:@""]) {
        NSArray *labels = [_modal.datas.labels componentsSeparatedByString:@","];
        for (NSString *str in labels) {
            [_data.labels addObject:str];
            
        }
        for (int i=0;i<titles.count;i++ ) {
            NSString *str = titles[i];
            if ([_data.labels containsObject:str]) {
                [_selecteds  replaceObjectAtIndex:i withObject:str];
            }
        }
    }
     float titleX = 10;
     float titleY = 15;
     float titleW  =0;
     float titleH = 27;
    float titleXW = 10;
    __weak ReleaseTheSecondHourseViewController *weakSelf = self;
    for (int i = 0; i<titles.count; i++) {
        NSString *tille =titles[i];
        titleW = tille.length*28*SpacedFonts + 10;
        titleXW =titleW+titleX+10;
        
        if (titleXW>APPWIDTH) {
            titleY +=(10+titleH);
            titleX =10;
            titleXW = 10;
        }
        UIColor *titleColor;
        UIColor  *setBorder;
        if ([_selecteds[i] isEqualToString:@"0"]) {
            titleColor = LightBlackTitleColor;
            setBorder = LineBg;
        }
        else
        {
            titleColor =setBorder= AppMainColor;
     
        }
        
        _selectedTag = [[BaseButton alloc]initWithFrame:frame(titleX, titleY, titleW, titleH) setTitle:tille titleSize:28*SpacedFonts titleColor:titleColor textAlignment:NSTextAlignmentCenter backgroundColor:WhiteColor inView:_selectedTagView];
        [_selectedTag setRadius:10];
        [_selectedTag setBorder:setBorder width:0.5];
        _selectedTag.didClickBtnBlock = ^
        {
            BaseButton *item = weakSelf.selectedItems[i];
            if ([weakSelf.selecteds[i] isEqualToString:@"0"]) {
                
                int tag =0;
                for (NSString *str  in weakSelf.selecteds) {
                    if (![str isEqualToString:@"0"]) {
                        tag ++;
                    }
                }
//                if (tag>=3) {
//                    [[ToolManager shareInstance] showInfoWithStatus:@"最多可选三个"];
//                    return;
//                }
                [weakSelf.selecteds replaceObjectAtIndex:i withObject:@"1"];
                
                if (![weakSelf.data.labels containsObject:titles[i]]) {
                    [weakSelf.data.labels addObject:titles[i]];
                }
                
                [item setTitleColor:AppMainColor forState:UIControlStateNormal];
                [item setBorder:AppMainColor width:0.5];
            }
            else
            {
                if ([weakSelf.data.labels containsObject:titles[i]]) {
                    [weakSelf.data.labels removeObject:titles[i]];
                }
                [weakSelf.selecteds replaceObjectAtIndex:i withObject:@"0"];
                [item setTitleColor:LightBlackTitleColor forState:UIControlStateNormal];
                [item setBorder:LineBg width:0.5];
            }
            
        };
        
        titleX +=titleW + 10;
        
        _selectedTagView.frame = frame(frameX(_selectedTagView), frameY(_selectedTagView), frameWidth(_selectedTagView), titleY + titleH + 10);
        [_selectedItems addObject:_selectedTag];
        _selectedTag = nil;
    }
    //卖点项目
    NSArray *array;
    if (_modal.datas.salespoint&&![_modal.datas.salespoint isEqualToString:@""]) {
        array = [_modal.datas.salespoint componentsSeparatedByString:@","];
    }
    UILabel *line1 = allocAndInitWithFrame(UILabel , frame(10, CGRectGetMaxY(_selectedTagView.frame)+10, 3, 28*SpacedFonts));
    line1.backgroundColor = AppMainColor;
    [_mainScrollView addSubview:line1];
    [UILabel createLabelWithFrame:frame(CGRectGetMaxX(line1.frame) + 4, frameY(line1), 4*SpacedFonts*28,  28*SpacedFonts) text:@"卖点项目" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:_mainScrollView];
    
    UIView *_projectView = allocAndInitWithFrame(UIView, frame(0, CGRectGetMaxY(line1.frame) + 3, APPWIDTH, 115));
    _projectView.backgroundColor = WhiteColor;
    
    _textFieldone = [self createframe:frame(10, 5, APPWIDTH - 20, (frameHeight(_projectView) - 20)/3.0) title:@"请输入卖点" inView:_projectView];
    if (array.count>0) {
        _textFieldone.text =array[0];
    }
    _textFieldtwo = [self createframe:frame(10, 10 + (frameHeight(_projectView) - 20)/3.0, APPWIDTH - 20, (frameHeight(_projectView) - 20)/3.0) title:@"请输入卖点" inView:_projectView];
    if (array.count>1) {
        _textFieldtwo.text =array[1];
    }
    _textFieldthree = [self createframe:frame(10, 15 + 2*(frameHeight(_projectView) - 20)/3.0, APPWIDTH - 20, (frameHeight(_projectView) - 20)/3.0) title:@"请输入卖点" inView:_projectView];
    if (array.count>2) {
        _textFieldthree.text =array[2];
    }
    //楼书标题
    UILabel *line2 = allocAndInitWithFrame(UILabel , frame(10, CGRectGetMaxY(_projectView.frame)+10, 3, 28*SpacedFonts));
    line2.backgroundColor = AppMainColor;
    [_mainScrollView addSubview:line2];
    [UILabel createLabelWithFrame:frame(CGRectGetMaxX(line2.frame) + 4, frameY(line2), 4*SpacedFonts*28,  28*SpacedFonts) text:@"楼书标题" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:_mainScrollView];
    
    UIView *_titletView = allocAndInitWithFrame(UIView, frame(0, CGRectGetMaxY(line2.frame) + 3, APPWIDTH, 62));
    _titletView.backgroundColor = WhiteColor;
    
    _titleTextField = [self createframe:frame(10, 10, APPWIDTH - 20, (frameHeight(_titletView) - 20)) title:@"请输入楼书标题" inView:_titletView];
    _titleTextField.text = [NSString stringWithFormat:@"%@  %@室%@厅%@卫",_data.estatename,_data.room,_data.hall,_data.toilet];
    
    
    //楼书标题
    UILabel *line3 = allocAndInitWithFrame(UILabel , frame(10, CGRectGetMaxY(_titletView.frame)+10, 3, 28*SpacedFonts));
    line3.backgroundColor = AppMainColor;
    [_mainScrollView addSubview:line3];
    [UILabel createLabelWithFrame:frame(CGRectGetMaxX(line3.frame) + 4, frameY(line3), 4*SpacedFonts*28,  28*SpacedFonts) text:@"楼书封面" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:_mainScrollView];
    
    UIView *_floorView = allocAndInitWithFrame(UIView, frame(0, CGRectGetMaxY(line3.frame) + 3, APPWIDTH, 250));
    _floorView.backgroundColor = WhiteColor;
    
    NSArray *floors = [NSArray arrayWithObjects:@"庭院",@"公寓",@"海景",@"喜庆",@"温馨",@"居家",@"安逸",@"爱心",nil];
    for (int i =0; i<floors.count; i++) {
        
        if (i==0) {
            [_selectedfloors addObject:@"1"];
        }
        else
        {
            [_selectedfloors addObject:@"0"];
        }
        
    }
    float floorX =10;
    float floorY = 10;
    float floorW = (APPWIDTH - 50)/4.0;
    float floorH = 28;
    for (int i = 0; i<floors.count; i++) {
        
        _selectedfloor = [[BaseButton alloc]initWithFrame:frame(i%4*(floorW+10) +floorX, i/4*(floorH+10) +floorY, floorW, floorH) setTitle:floors[i] titleSize:28*SpacedFonts titleColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter backgroundColor:WhiteColor inView:_floorView];
        [_selectedfloor setRadius:10];
        [_selectedfloor setBorder:LineBg width:0.5];
        if (i==0) {
            [_selectedfloor setBorder:AppMainColor width:0.5];
            [_selectedfloor setTitleColor:AppMainColor forState:UIControlStateNormal];
            [self imageview:_setImages[0] inView:_floorView tag:0];
        }
        
        _selectedfloor.didClickBtnBlock = ^
        {
         
            if ([weakSelf.selectedfloors[i] isEqualToString:@"0"]) {
                
                for (int j = 0; j<weakSelf.selectedfloors.count; j++) {
                    BaseButton *btnj = weakSelf.selectedfloorsItems[j];
                    if (j ==i) {
                        [btnj setTitleColor:AppMainColor forState:UIControlStateNormal];
                        [btnj setBorder:AppMainColor width:0.5];
                        [weakSelf.selectedfloors replaceObjectAtIndex:j withObject:@"1"];
                          [weakSelf imageview:weakSelf.setImages[i] inView:_floorView tag:i];
                    }
                    else
                    {
                        [btnj setTitleColor:LightBlackTitleColor forState:UIControlStateNormal];
                        [btnj setBorder:LineBg width:0.5];
                        [weakSelf.selectedfloors replaceObjectAtIndex:j withObject:@"0"];
                    }
                    
                }

                
            }
            };
        
       
        [_selectedfloorsItems addObject:_selectedfloor];
        
    }
  
    
    
    
    float cellHeight = 40;
    //是否显示个人资料
    
    UIView *_personalInformation =allocAndInitWithFrame(UIView , frame(0, 10+CGRectGetMaxY(_floorView.frame), APPWIDTH, cellHeight));
    _personalInformation.backgroundColor =[UIColor whiteColor];
    [_mainScrollView addSubview:_personalInformation];
    
    
    _personalInformationLb = [UILabel createLabelWithFrame:frame(10, 0, 10*28*SpacedFonts, cellHeight) text:@"是否在个人资料中显示" fontSize:28*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:_personalInformation];
    
    _personalInformationSwitch =allocAndInitWithFrame(UISwitch, frame(frameWidth(_personalInformation) -60, 5, 50, 30));
    
    _personalInformationSwitch.onTintColor = AppMainColor;
    _personalInformationSwitch.tag = SwitchActionTagPersonalInformation;
    [_personalInformationSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [_personalInformation addSubview:_personalInformationSwitch];
    
    if (_data.iscross) {
        [_personalInformationSwitch setOn:YES animated:YES];
        [self switchAction:_personalInformationSwitch];
    }
    else
    {
        
        [_personalInformationSwitch setOn:NO animated:YES];
        [self switchAction:_personalInformationSwitch];
    }
    
    //    _collect to the original
    
    UIView *_collect =allocAndInitWithFrame(UIView , frame(0, CGRectGetMaxY(_personalInformation.frame)+0.5, APPWIDTH, cellHeight));
    _collect.backgroundColor =[UIColor whiteColor];
    [_mainScrollView addSubview:_collect];
    
    _collectLb = [UILabel createLabelWithFrame:frame(10, 0, 6*28*SpacedFonts, cellHeight) text:@"收集传播路径" fontSize:28*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:_collect];
    
    _collectSwitch =allocAndInitWithFrame(UISwitch, frame(frameWidth(_collect) -60, 5, 50, 30));
    _collectSwitch.tag = SwitchActionTagCollect;
    _collectSwitch.onTintColor = AppMainColor;
    [_collectSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [_collect addSubview:_collectSwitch];
    if (_data.isgetclue) {
        [_collectSwitch setOn:YES animated:YES];
        [self switchAction:_collectSwitch];
    }
    
    if (_data.isreward) {
        [_collectSwitch setEnabled:NO];
    }
    else
    {
        [_collectSwitch setEnabled:YES];
    }
    
    
    _info =allocAndInitWithFrame(UIView , frame(0, CGRectGetMaxY(_collect.frame)+0.5, APPWIDTH, cellHeight));
    _info.backgroundColor =[UIColor whiteColor];
    [_mainScrollView addSubview:_info];
    _infoLb = [UILabel createLabelWithFrame:frame(10, 0, 7*28*SpacedFonts, cellHeight) text:@"收集客户信息" fontSize:28*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:_info];
    
    _infoSwitch =allocAndInitWithFrame(UISwitch, frame(frameWidth(_collect) -60, 5, 50, 30));
    _infoSwitch.tag = SwitchActionTagInfo;
    _infoSwitch.onTintColor = AppMainColor;
    [_infoSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [_info addSubview:_infoSwitch];
    
    if (_data.iscollect) {
        [_infoSwitch setOn:YES animated:YES];
        [self switchAction:_infoSwitch];
        
    }
    
    //     to the original
    _redView =allocAndInitWithFrame(UIView , frame(0, CGRectGetMaxY(_info.frame)+0.5, APPWIDTH, cellHeight));
    _redView.backgroundColor =[UIColor whiteColor];
    [_mainScrollView addSubview:_redView];
    _redLb = [UILabel createLabelWithFrame:frame(10, 0, APPWIDTH/2.0, cellHeight) text:@"跨界红包设置" fontSize:28*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:_redView];
    
    if (_data.isreward) {
        
        _redLb.text = [NSString stringWithFormat:@"红包金额:%@(元)",_data.reward];
        [_redLb setTextColor:BlackTitleColor];
    }
    else
    {
        _redSwitch =allocAndInitWithFrame(UISwitch, frame(frameWidth(_collect) -60, 5, 50, 30));
        _redSwitch.tag = SwitchActionTagRed;
        _redSwitch.onTintColor = AppMainColor;
        [_redSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [_redView addSubview:_redSwitch];
        if (_data.isreward) {
            [_redSwitch setOn:YES animated:YES];
            [self switchAction:_redSwitch];
        }
        if (!_data.isgetclue) {
            [_collectSwitch setOn:NO animated:YES];
            [self switchAction:_collectSwitch];
            
        }
    }
    //输入红包
    _redViewBg = allocAndInitWithFrame(UIView, frame(0 , cellHeight, frameWidth(_mainScrollView), 42));
    _redViewBg.backgroundColor =AppViewBGColor;
    [_redView addSubview:_redViewBg];
    
    UIView * _redTextFieldView = allocAndInitWithFrame(UIView, frame(10 , 10, frameWidth(_redViewBg)-20, 42));
    _redTextFieldView.backgroundColor =WhiteColor;
    [_redTextFieldView setBorder:LineBg width:0.5];
    [_redTextFieldView setRadius:5.0];
    [_redViewBg addSubview:_redTextFieldView];
    
    _redTextField= allocAndInitWithFrame(UITextField, frame(10 ,0, frameWidth(_redTextFieldView)-20, 42));
    _redTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"请输入红包金额，最大可输入%@元",_data.amount] attributes:@{NSForegroundColorAttributeName:LightBlackTitleColor }];
    [_redTextFieldView addSubview:_redTextField];
    _redTextField.textColor = BlackTitleColor;
    _redTextField.font = Size(24);
    _redTextField.clearButtonMode =UITextFieldViewModeWhileEditing;
    _redTextField.backgroundColor = WhiteColor;
    _redTextField.delegate = self;
    //    _redTextField.text = _data.amount;
    UILabel *desc = [UILabel createLabelWithFrame:frame(10 ,CGRectGetMaxY(_redTextField.frame) + 10, frameWidth(_redTextFieldView), 0) text:@"跨界传播内容规范:\n1.标题不带有诱导分享的字眼，如转发就给红包、转发有现金等\n2.所发内容、产品、房源不含涉黄、涉暴、涉谣等信息\n3.鼓励发布有用的内容、真实的产品，内容中可以附带个人微名片\n4.所有带跨界传播设置的内容都需要知脉后台审核，审核通过后才可以发布到知脉首页中\n5.若内容被驳回，所扣红包金额全额退回到红包账户中" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:_redViewBg];
    desc.numberOfLines = 0;
    //    desc.backgroundColor = AppViewBGColor;
    CGSize size = [desc sizeWithMultiLineContent:desc.text rowWidth:frameWidth(desc) font:Size(24)];
    desc.frame = frame(frameX(desc), frameY(desc), frameWidth(desc), size.height);
    
    _redViewBg.frame = frame(frameX(_redViewBg), frameY(_redViewBg), APPWIDTH, size.height + 10 + frameHeight(_redViewBg));
    _redViewBg.hidden = YES;
    redHight = 40 + frameHeight(_redViewBg);
    
    [_mainScrollView addSubview:_selectedTagView];
    [_mainScrollView addSubview:_projectView];
     [_mainScrollView addSubview:_titletView];
    [_mainScrollView addSubview:_floorView];
    
    if (!_data.isgetclue) {
        _mainScrollView.contentSize = CGSizeMake(frameWidth(_mainScrollView), CGRectGetMaxY(_info.frame) + 60);
    }
    else
    {
        _mainScrollView.contentSize = CGSizeMake(frameWidth(_mainScrollView), CGRectGetMaxY(_redView.frame) + 60);
    }
    [_mainScrollView scrollRectToVisible:frame(frameX(_mainScrollView), 0, frameWidth(_mainScrollView), _mainScrollView.contentSize.height) animated:YES];
    
    //完成
    _nextBtn = [[BaseButton alloc]initWithFrame:frame(13*ScreenMultiple,_mainScrollView.contentSize.height - 50 , APPWIDTH - 26*ScreenMultiple, 40) setTitle:@"完成" titleSize:28*SpacedFonts  titleColor:WhiteColor textAlignment:NSTextAlignmentCenter  backgroundColor:AppMainColor inView:_mainScrollView];
    [_nextBtn
     setRoundWithfloat:4];
    _nextBtn.didClickBtnBlock =^
    {
        NSMutableDictionary *parameter = [Parameter parameterWithSessicon];
        [parameter setObject:@"estate" forKey:@"actype"];
        if (weakSelf.modal.datas.acid&&_data.isEdit) {
            [parameter setObject:weakSelf.modal.datas.acid forKey:@"acid"];
        }
        if (weakSelf.data.labels.count==0) {
            [[ToolManager shareInstance] showInfoWithStatus:@"请选择标签"];
            
            return ;
            
        }
         NSMutableArray *labels = [NSMutableArray new];
        for (NSString *string in weakSelf.data.labels) {
            [labels addObject:string];
        }
         [parameter setObject:[labels mj_JSONString] forKey:@"labels"];
        
        if (!weakSelf.titleTextField ||[weakSelf.titleTextField.text isEqualToString:@""]) {
            [[ToolManager shareInstance] showInfoWithStatus:@"请输入标题"];
            
            return ;
        }
        [parameter setObject:weakSelf.titleTextField.text forKey:@"title"];
        
        if (!weakSelf.fengmianImageUrl[ImageDiagram]) {
            [[ToolManager shareInstance] showInfoWithStatus:@"请选择封面"];
            
            return ;
        }
        [parameter setObject:weakSelf.fengmianImageUrl[ImageDiagram] forKey:@"abbre_cover"];
        [parameter setObject:weakSelf.fengmianImageUrl[ImageDefault] forKey:@"cover"];
        [parameter setObject:@(weakSelf.collectSwitch.isOn) forKey:@"isgetclue"];
        [parameter setObject:@(weakSelf.infoSwitch.isOn) forKey:@"iscollect"];
        [parameter setObject:@(weakSelf.personalInformationSwitch.isOn) forKey:@"iscross"];
        [parameter setObject:@(weakSelf.redSwitch.isOn) forKey:@"isreward"];
        NSMutableArray *maidian = [NSMutableArray new];
        if (weakSelf.textFieldone.text.length>0) {
            [maidian addObject:weakSelf.textFieldone.text];
            [maidian addObject:weakSelf.textFieldtwo.text];
            [maidian addObject:weakSelf.textFieldthree.text];
        }
        if (maidian.count>0) {
             [parameter setObject:[maidian mj_JSONString] forKey:@"salespoint"];
        }
        
         [parameter setObject:weakSelf.data.estatename forKey:@"estatename"];
         [parameter setObject:weakSelf.data.total  forKey:@"total"];
    
        if (weakSelf.data.acreage) {
            [parameter setObject:weakSelf.data.acreage forKey:@"acreage"];
        }
        if (weakSelf.data.room) {
            [parameter setObject:weakSelf.data.room forKey:@"room"];
        }
        if (weakSelf.data.hall) {
            [parameter setObject:weakSelf.data.hall forKey:@"hall"];
        }
        if (weakSelf.data.toilet) {
            [parameter setObject:weakSelf.data.toilet forKey:@"toilet"];
        }
        if (weakSelf.data.square) {
            [parameter setObject:weakSelf.data.square forKey:@"square"];
        }
        if (weakSelf.data.floorgrade) {
            [parameter setObject:weakSelf.data.floorgrade forKey:@"floorgrade"];
        }
        if (weakSelf.data.floor) {
             [parameter setObject:weakSelf.data.floor forKey:@"floor"];
        }

        if (weakSelf.data.face) {
            [parameter setObject:weakSelf.data.face forKey:@"face"];
        }
        
         [parameter setObject:[weakSelf.data.images mj_JSONString] forKey:@"imgarr"];
       
        if (weakSelf.redSwitch.isOn) {
            if ([_redTextField.text floatValue]<=0.01) {
                if (weakSelf.collectSwitch.isOn) {
                    [[ToolManager shareInstance] showInfoWithStatus:@"请输入红包金额"];
                    return ;
                }
                
            }
            [parameter setObject:weakSelf.redTextField.text forKey:@"reward"];
        }
        [[ToolManager shareInstance] showWithStatus:@"保存中..."];
//                 NSLog(@"parameter = %@",parameter);
        [XLDataService postWithUrl:Saveproduct param:parameter modelClass:nil responseBlock:^(id dataObj, NSError *error) {
//                        NSLog(@"dataObj = %@",dataObj);
            if (dataObj) {
                if ([dataObj[@"rtcode"] intValue]==1) {
                    [[ToolManager shareInstance] dismiss];
                    
                    if (weakSelf.data.isEdit) {
                        PopToPointView(weakSelf, @"AlreadysentproductViewController");
                    }
                    else
                    {
                        
                        AlreadysentproductViewController *article  = allocAndInit(AlreadysentproductViewController);
                        article.ispopToRoot = YES;
                        PushView(weakSelf, article);
                    }
                    
                    
                }
                else
                {
                    [[ToolManager shareInstance] showInfoWithStatus:dataObj[@"rtmsg"]];
                }
            }
            else
            {
                [[ToolManager shareInstance] showInfoWithStatus] ;
            }
        }];

        
    };
    
}
- (UIView *)imageview:(NSMutableArray *)images inView:(UIView *)view tag:(int)tag
{
    for (UIView *subView in setImageView.subviews) {
        [subView removeFromSuperview];
    }
    
    setImageView = allocAndInitWithFrame(UIView, frame(0, 95, APPWIDTH, 130));
    [view addSubview:setImageView];
    UIScrollView *setView = allocAndInitWithFrame(UIScrollView, frame(0, 0, APPWIDTH, 60));

    __weak ReleaseTheSecondHourseViewController *weakSelf =self;
    for (int i =0; i<images.count; i++) {
        
        BaseButton *btn = [[BaseButton alloc]initWithFrame:frame(10+i*70, 0, 60, 60) backgroundImage:nil iconImage:nil highlightImage:nil inView:setView];
        NSDictionary *imagesDic = images[i];
        if (![imagesDic[ImageDiagram] isEqualToString:@""]) {
            [[ToolManager shareInstance] imageView:btn setImageWithURL:imagesDic[ImageDiagram] placeholderType:PlaceholderTypeOther];
            
        }
        btn.didClickBtnBlock = ^
        {
            if (![imagesDic[ImageDiagram] isEqualToString:@""]) {
               
                [_fengmianImageUrl setValue:imagesDic[ImageDiagram] forKey:ImageDiagram];
                [_fengmianImageUrl setValue:imagesDic[ImageDefault] forKey:ImageDefault];
                [[ToolManager shareInstance] imageView:weakSelf.feimianBtn setImageWithURL:imagesDic[ImageDiagram] placeholderType:PlaceholderTypeOther];
                
            }
    
        };
        if (CGRectGetMaxX(btn.frame) + 10>frameWidth(setView)) {
            setView.contentSize = CGSizeMake(frameWidth(setView),CGRectGetMaxX(btn.frame) + 10);
        }
    }
    
    weakSelf.feimianBtn = [[BaseButton alloc]initWithFrame:frame(10, 70, 60, 60) backgroundImage:[UIImage imageNamed:@"addition"] iconImage:nil highlightImage:nil inView:setImageView];
    if (![_fengmianImageUrl[ImageDiagram] isEqualToString:@""]&&_fengmianImageUrl[ImageDiagram]) {
        [[ToolManager shareInstance] imageView:weakSelf.feimianBtn setImageWithURL:_fengmianImageUrl[ImageDiagram] placeholderType:PlaceholderTypeOther];
        
    }
    weakSelf.feimianBtn.didClickBtnBlock = ^
    {
        [[ToolManager shareInstance] seleteImageFormSystem:weakSelf seleteImageFormSystemBlcok:^(UIImage *image) {
            [[UpLoadImageManager shareInstance] upLoadImageType:UploadImagesTypeProperty image:image imageBlock:^(UpLoadImageModal * upLoadImageModal) {
              
                [_fengmianImageUrl setValue:upLoadImageModal.abbr_imgurl forKey:ImageDiagram];
                [_fengmianImageUrl setValue:upLoadImageModal.imgurl forKey:ImageDefault];
                
                [[ToolManager shareInstance] imageView:weakSelf.feimianBtn setImageWithURL:upLoadImageModal.abbr_imgurl placeholderType:PlaceholderTypeOther];
                
            }];
        }];
    };
    
    [setImageView addSubview:setView];
    
    
    return setImageView;
    
}

-(UITextField *)createframe:(CGRect)frame title:(NSString *)title inView:(UIView *)view
{
    UIView *texfFiledView = allocAndInitWithFrame(UIView, frame);
    texfFiledView.backgroundColor =[UIColor whiteColor];
    [texfFiledView setBorder:LineBg width:0.5];
    [texfFiledView setRadius:5.0];
    [view addSubview:texfFiledView];
    
    UITextField *textField = allocAndInitWithFrame(UITextField, frame(5 , 0, frameWidth(texfFiledView)-10, frameHeight(texfFiledView)));
    [texfFiledView addSubview:textField];
     textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:LightBlackTitleColor }];
    textField.textColor = BlackTitleColor;
    textField.font = Size(24);
//    textField.keyboardType = UIKeyboardTypeNumberPad;
    
    
    return textField;
    
}

#pragma mark
#pragma mark - switchAction
- (void)switchAction:(UISwitch *)sender
{
    
   if(sender.tag ==SwitchActionTagInfo)
    {
       
        if (sender.isOn) {
            _infoLb.textColor = BlackTitleColor;
            
            
        }
        else
        {
            _infoLb.textColor = LightBlackTitleColor;
            
        }
        
        
    }
   else if (sender.tag ==SwitchActionTagPersonalInformation)
   {
       if (sender.isOn) {
           _personalInformationLb.textColor = BlackTitleColor;
       }
       else
       {
           _personalInformationLb.textColor = LightBlackTitleColor;
       }
   }

    else if (sender.tag ==SwitchActionTagCollect)
    {
       
        _redView.hidden = !sender.isOn;
        
        if (sender.isOn) {
            
            _collectLb.textColor = BlackTitleColor;
            
            if (CGRectGetMaxY(_redView.frame) +60>frameWidth(_mainScrollView)) {
                
                _mainScrollView.contentSize =CGSizeMake(frameWidth(_mainScrollView), CGRectGetMaxY(_redView.frame) +60);
            }
            if (_redSwitch.isOn) {
                _redViewBg.hidden = NO;
            }
            else
            {
                _redViewBg.hidden = YES;
            }
            
            
        }
        else
        {
           
            _redViewBg.hidden = YES;
            _collectLb.textColor = LightBlackTitleColor;
            if (CGRectGetMaxY(_info.frame) +60>frameWidth(_mainScrollView)) {
                _mainScrollView.contentSize =CGSizeMake(frameWidth(_mainScrollView), CGRectGetMaxY(_info.frame) +60);
            }
            
        }
        
        [_mainScrollView scrollRectToVisible:frame(frameX(_mainScrollView), frameY(_mainScrollView), frameWidth(_mainScrollView), _mainScrollView.contentSize.height) animated:YES];
    }
    else if (sender.tag ==SwitchActionTagRed)
    {
        _redViewBg.hidden = !sender.isOn;
        
        if (sender.isOn) {
            
            _redLb.textColor = BlackTitleColor;
            
            _redView.frame = frame(frameX(_redView), frameY(_redView), frameWidth(_redView), redHight);
            
            
        }
        else
        {
            _redLb.textColor = LightBlackTitleColor;
            
            _redView.frame = frame(frameX(_redView), frameY(_redView), frameWidth(_redView), 40);
        }
        
        if (CGRectGetMaxY(_redView.frame) +60>frameWidth(_mainScrollView)) {
            
            _mainScrollView.contentSize =CGSizeMake(frameWidth(_mainScrollView), CGRectGetMaxY(_redView.frame) +60);
        }
        
        [_mainScrollView scrollRectToVisible:frame(frameX(_mainScrollView), frameY(_mainScrollView), frameWidth(_mainScrollView), _mainScrollView.contentSize.height) animated:YES];
        
    }
    _nextBtn.frame = frame(13*ScreenMultiple,_mainScrollView.contentSize.height - 50 , APPWIDTH - 26*ScreenMultiple, 40);
    
    
}
#pragma mark - UITextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    float money = [[NSString stringWithFormat:@"%@%@",textField.text,string] floatValue];
    
    if (money>[_data.amount floatValue]) {
        
        [[ToolManager shareInstance] showInfoWithStatus:[NSString stringWithFormat:@"最大金额%@",_data.amount]];
        return NO;
    }
    
    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        isHaveDian = NO;
    }
    if ([string length] > 0) {
        
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.') {//数据格式正确
            
            //首字母不能为0和小数点
            if([textField.text length] == 0){
                if(single == '.') {
                    
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
                ////                if (single == '0') {
                ////
                ////                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                ////                    return NO;
                ////                }
            }
            
            //输入的字符是否是小数点
            if (single == '.') {
                if(!isHaveDian)//text中还没有小数点
                {
                    isHaveDian = YES;
                    return YES;
                    
                }else{
                    
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }else{
                if (isHaveDian) {//存在小数点
                    
                    //判断小数点的位数
                    NSRange ran = [textField.text rangeOfString:@"."];
                    if (range.location - ran.location <= 2) {
                        return YES;
                    }else{
                        
                        return NO;
                    }
                }else{
                    return YES;
                }
            }
        }else{//输入的数据格式不正确
            
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    }
    else
    {
        return YES;
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

@implementation ReleaseTheSecond


@end
