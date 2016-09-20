//
//  TheSecondCarDetailViewController.m
//  Lebao
//
//  Created by David on 16/4/14.
//  Copyright © 2016年 David. All rights reserved.
//

#import "TheSecondCarDetailViewController.h"
#import "NSDate+Extend.h"
#import "SelecteCarTypeViewController.h"
#import "SelectedCarDetailView.h"
#import "SelectedCarResultView.h"
#import "TheSecondCarResultViewController.h"
#import "UIImage+Color.h"
#define cellH 40.0
@interface TheSecondCarDetailViewController ()<UITextFieldDelegate>
@property(nonatomic,strong) BaseButton *pinpaiLable;
@property(nonatomic,strong) BaseButton *mainView;
@property(nonatomic,strong) UIView *rightView;
@property(nonatomic,strong) SelecteCarTypeViewController *selecteCarTypeViewController;
@property(nonatomic,strong) UITextField *shangpaiAddressView;
@property(nonatomic,strong) UITextField *runView;
@property(nonatomic,strong) UITextField *priceView;
@property(nonatomic,strong) UITextField *buyView;

@property(nonatomic,strong) NSString *keyID;
@property(nonatomic,strong) NSString *series_id;
@property(nonatomic,strong) NSString *model_id;
@end

@implementation TheSecondCarDetailViewController
{
    BOOL isHaveDian;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navView];
    [self addTableView];
}
#pragma mark - Navi_View
- (void)navView
{
    
    [self navViewTitleAndBackBtn:@"二手车源"];
    
}
#pragma mark
#pragma mark TableView
- (void)addTableView
{
    
    if (_modal.datas.keyid) {
        _keyID = _modal.datas.keyid;
    }
    if (_modal.datas.series_id) {
        _series_id = _modal.datas.series_id;
    }
    if (_modal.datas.model_id) {
        _model_id = _modal.datas.model_id;
    }
    _comboBoxColorArray = [NSMutableArray arrayWithObjects:@"黑",@"白",@"红", @"灰",@"银",@"蓝",@"黄",@"棕",@"绿",@"橙",@"紫",@"香槟",@"金",@"粉",@"其他",nil];
    _comboBoxMonArray = [NSMutableArray arrayWithObjects:@"1月",@"2月",@"3月", @"4月",@"5月",@"6月",@"7月",@"8月",@"9月",@"10月",@"11月",@"12月",nil];
    NSDate *now = [NSDate date];
//    NSLog(@"year =%li",now.components.year);
    _comboBoxYearArray = [NSMutableArray new];
    for (int i =0; i<16; i++) {
        
        [_comboBoxYearArray addObject:[NSString stringWithFormat:@"%i年",(int)now.components.year -i]];
    }
    _selecteds = allocAndInit(NSMutableArray);
    _mainScrollView = [[UIScrollView alloc]initWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT -(StatusBarHeight + NavigationBarHeight)) ];
    _mainScrollView.backgroundColor =[UIColor clearColor];
    
    UIView *_carView = allocAndInitWithFrame(UIView, frame(0, 10, APPWIDTH, cellH*7));
    _carView.backgroundColor = WhiteColor;
    [_mainScrollView addSubview:_carView];
    //线条
    float cellX =10;
    NSArray *titles = @[@"品牌",@"颜色",@"上牌时间",@"上牌地",@"行驶路程",@"价格",@"购入价格"];
    NSArray *titleDetails = @[@"万公里",@"万元",@"万元(税)"];
    for (int i=0;i<7;i++) {
        if (i<6) {
            [UILabel CreateLineFrame:frame(cellX,cellH*(i+1)-0.5, APPWIDTH - cellX, 0.5) inView:_carView];

        }
          [UILabel createLabelWithFrame:frame(cellX, cellH*i, 4*28*SpacedFonts, cellH) text:titles[i] fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:_carView];
        if (i>3) {
            [UILabel createLabelWithFrame:frame(APPWIDTH - 4*28*SpacedFonts - 10, cellH*i, 4*28*SpacedFonts, cellH) text:titleDetails[i - 4] fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentRight inView:_carView];
        }
        
    }
    //品牌
    UIImage *icon = [UIImage imageNamed:@"comboDownArrow.png"];
    icon = [icon imageWithTintColor:LineBg];
    _pinpaiLable = [[BaseButton alloc]initWithFrame:frame(2*cellX + 4*SpacedFonts*28, 0, APPWIDTH -(3*cellX + 4*SpacedFonts*28) , cellH) setTitle:@"请选择品牌" titleSize:28*SpacedFonts titleColor:LightBlackTitleColor backgroundImage:nil iconImage:icon highlightImage:icon setTitleOrgin:CGPointMake((cellH -28*SpacedFonts)/2.0  ,- icon.size.width) setImageOrgin:CGPointMake((cellH -icon.size.height)/2.0  ,APPWIDTH -(3*cellX + 4*SpacedFonts*28)- icon.size.width) inView:_carView];
//    NSLog(@"_modal.datas.brand =%@",_modal.datas.brand);
    if (_modal.datas.brand) {
        [_pinpaiLable setTitle:_modal.datas.brand forState:UIControlStateNormal];
    }
    __weak TheSecondCarDetailViewController *weakSelf =self;
    _pinpaiLable.didClickBtnBlock = ^
    {
        
        if (!weakSelf.rightView) {
            weakSelf.rightView = allocAndInitWithFrame(UIView, frame(-APPWIDTH, 0, APPWIDTH - 20, APPHEIGHT));
            [weakSelf.mainView addSubview:weakSelf.rightView];
        }
        float barg = 40;
        float time = 0.5;
        if (!weakSelf.mainView) {
            weakSelf.mainView = [[BaseButton alloc]initWithFrame:weakSelf.view.bounds backgroundImage:nil iconImage:nil highlightImage:nil inView:[UIApplication sharedApplication].keyWindow];
            weakSelf.mainView.backgroundColor = rgba(0, 0, 0, 0.4);
            
            weakSelf.rightView = allocAndInitWithFrame(UIView, frame(APPWIDTH, 0, APPWIDTH - barg, APPHEIGHT));
            weakSelf.rightView.backgroundColor = WhiteColor;
           [weakSelf.mainView addSubview:weakSelf.rightView];
            
            if (!weakSelf.selecteCarTypeViewController) {
                 weakSelf.selecteCarTypeViewController = allocAndInit(SelecteCarTypeViewController);
                 weakSelf.selecteCarTypeViewController.dimissBlock =^
                {
                    [UIView animateWithDuration:time animations:^{
                       
                        weakSelf.mainView.hidden = YES;
                        weakSelf.rightView.frame =  frame(APPWIDTH, 0, APPWIDTH - barg, APPHEIGHT);
                         }];
                };
                 weakSelf.selecteCarTypeViewController.resultBlock = ^(NSString *str,NSString *keyid,NSString *seriesid,NSString *model_id)
                {
                    _keyID = keyid;
                    _series_id = seriesid;
                    _model_id = model_id;
                    
                    [weakSelf.pinpaiLable setTitle:str forState:UIControlStateNormal];
                    
                    [UIView animateWithDuration:time animations:^{
                        weakSelf.mainView.hidden = YES;
                        weakSelf.rightView.frame =  frame(APPWIDTH, 0, APPWIDTH - barg, APPHEIGHT);
                        for (UIView *suView in weakSelf.selecteCarTypeViewController.view.subviews) {
                            if ([suView isKindOfClass:[SelectedCarDetailView class]]||[suView isKindOfClass:[SelectedCarResultView class]]) {
                                [suView removeFromSuperview];
                            }
                        }
                      
                    }];
                };
                [weakSelf.rightView addSubview:weakSelf.selecteCarTypeViewController.view];
                
            }
            
            weakSelf.mainView.didClickBtnBlock = ^
            {
                
                [UIView animateWithDuration:time animations:^{
            
                    weakSelf.mainView.hidden = YES;
                    weakSelf.rightView.frame =  frame(APPWIDTH, 0, APPWIDTH - barg, APPHEIGHT);
                    for (UIView *suView in weakSelf.selecteCarTypeViewController.view.subviews) {
                        if ([suView isKindOfClass:[SelectedCarDetailView class]]||[suView isKindOfClass:[SelectedCarResultView class]]) {
                            [suView removeFromSuperview];
                        }
                    }
                    
                }];
            };
            [UIView animateWithDuration:time animations:^{
                weakSelf.rightView.frame =  frame(barg, 0, APPWIDTH - barg, APPHEIGHT);
            }];
            
            
        }
        else
        {
            weakSelf.mainView.hidden = NO;
            [UIView animateWithDuration:time animations:^{
                weakSelf.rightView.frame =  frame(barg, 0, APPWIDTH - barg, APPHEIGHT);
            
            }];
            
        };
        
    };
    //颜色
    _comboBoxColor = [[FSComboListView alloc] initWithValues:_comboBoxColorArray
                                                  frame:frame(frameX(_pinpaiLable) ,CGRectGetMaxY(_pinpaiLable.frame) + 17.5, frameWidth(_pinpaiLable) + 5, frameHeight(_pinpaiLable))];
    _comboBoxColor.Combotype = comboListTypeTable;
    _comboBoxColor.backgroundColor = [UIColor clearColor];
    [_comboBoxColor.valueLabel setBorder:[UIColor clearColor] width:0];
    _comboBoxColor.valueLabel.textColor = LightBlackTitleColor;
    if (_comboBoxColorArray.count>[_modal.datas.color integerValue] -1) {
        _comboBoxColor.valueLabel.text =_comboBoxColorArray[[_modal.datas.color integerValue] -1];
    }
   
    _comboBoxColor.changedBlock = ^(FSComboListView *comboListView,NSString * toValue)
    {
//        NSLog(@"_comboBoxColor=%@",toValue);
     
    };
    [_mainScrollView addSubview:_comboBoxColor];
    
//    NSLog(@"_modal.datas.cartime =%@",_modal.datas.cartime);
    NSArray *timers;
    if (_modal.datas.cartime&&![_modal.datas.cartime isEqualToString:@""]) {
        
       timers= [_modal.datas.cartime componentsSeparatedByString:@"-"];
    }
    // 时间年
    _comboBoxYear = [[FSComboListView alloc] initWithValues:_comboBoxYearArray
                                                       frame:frame(frameX(_comboBoxColor) ,CGRectGetMaxY(_comboBoxColor.frame) + 15, frameWidth(_comboBoxColor)/2.0, frameHeight(_comboBoxColor))];
    _comboBoxYear.Combotype = comboListTypeTable;
    _comboBoxYear.backgroundColor = [UIColor clearColor];
    [_comboBoxYear.valueLabel setBorder:[UIColor clearColor] width:0];
    _comboBoxYear.valueLabel.textColor = LightBlackTitleColor;
    if (timers.count>0) {
        _comboBoxYear.valueLabel.text= [NSString stringWithFormat:@"%@年",timers[0]];
    }
    _comboBoxYear.changedBlock = ^(FSComboListView *comboListView,NSString * toValue)
    {
//        NSLog(@"_comboBoxYear=%@",toValue);
        
    };
    [_mainScrollView addSubview:_comboBoxYear];
    // 时间月
    _comboBoxMon = [[FSComboListView alloc] initWithValues:_comboBoxMonArray
                                                       frame:frame(CGRectGetMaxX(_comboBoxYear.frame) ,frameY(_comboBoxYear), frameWidth(_comboBoxYear), frameHeight(_comboBoxYear))];
    _comboBoxMon.Combotype = comboListTypeTable;
    _comboBoxMon.backgroundColor = [UIColor clearColor];
    [_comboBoxMon.valueLabel setBorder:[UIColor clearColor] width:0];
    _comboBoxMon.valueLabel.textColor = LightBlackTitleColor;
    
    if (timers.count>1) {
        _comboBoxMon.valueLabel.text= [NSString stringWithFormat:@"%@月",timers[1]];
    }
    _comboBoxMon.changedBlock = ^(FSComboListView *comboListView,NSString * toValue)
    {
//        NSLog(@"_comboBoxMon=%@",toValue);
        
    };
    _comboBoxColor.valueLabel.textAlignment =  _comboBoxYear.valueLabel.textAlignment = _comboBoxMon.valueLabel.textAlignment = NSTextAlignmentLeft;
      [_mainScrollView addSubview:_comboBoxMon];
    
    //上牌地
    _shangpaiAddressView = allocAndInitWithFrame(UITextField, frame(frameX(_pinpaiLable) , cellH*3, APPWIDTH - 2*(2*cellX + 4*SpacedFonts*28), cellH));
    [_carView addSubview:_shangpaiAddressView];
    _shangpaiAddressView.textColor = LightBlackTitleColor;
    _shangpaiAddressView.font = Size(28);
    _shangpaiAddressView.placeholder = @"请输入上牌地";
    _shangpaiAddressView.clearButtonMode = UITextFieldViewModeWhileEditing;
    if (_modal.datas.carvenue) {
        _shangpaiAddressView.text =_modal.datas.carvenue;
    }
    //行驶路程
    _runView = allocAndInitWithFrame(UITextField, frame(frameX(_shangpaiAddressView) , CGRectGetMaxY(_shangpaiAddressView.frame) , frameWidth(_shangpaiAddressView), cellH));
    [_carView addSubview:_runView];
     _runView.placeholder = @"请输入行驶路程";
    _runView.textColor = LightBlackTitleColor;
    _runView.font = Size(28);
    _runView.clearButtonMode = UITextFieldViewModeWhileEditing;
    if (_modal.datas.mileage) {
        _runView.text =[NSString stringWithFormat:@"%i",(int)_modal.datas.mileage];
    }
    //价格
    _priceView = allocAndInitWithFrame(UITextField, frame(frameX(_runView) , CGRectGetMaxY(_runView.frame) , frameWidth(_runView), cellH));
    [_carView addSubview:_priceView];
    _priceView.placeholder = @"请输入价格";
    _priceView.textColor = LightBlackTitleColor;
    _priceView.delegate = self;
    _priceView.font = Size(28);
    _priceView.clearButtonMode = UITextFieldViewModeWhileEditing;
    if (_modal.datas.price) {
        _priceView.text =_modal.datas.price;
    }
    //购入价格
    _buyView = allocAndInitWithFrame(UITextField, frame(frameX(_priceView), CGRectGetMaxY(_priceView.frame) , frameWidth(_priceView), cellH));
    [_carView addSubview:_buyView];
    _buyView.textColor = LightBlackTitleColor;
    _buyView.font = Size(28);
     _buyView.delegate = self;
    _buyView.placeholder = @"请输入购入价格";
    _buyView.clearButtonMode = UITextFieldViewModeWhileEditing;
    if (_modal.datas.buyprice) {
        _buyView.text =_modal.datas.buyprice;
    }
    
    BaseButton *_nextBtn = [[BaseButton alloc]initWithFrame:frame(13*ScreenMultiple, 20 + CGRectGetMaxY(_carView.frame), APPWIDTH - 26*ScreenMultiple, 40) setTitle:@"下一步" titleSize:28*SpacedFonts  titleColor:WhiteColor textAlignment:NSTextAlignmentCenter  backgroundColor:AppMainColor inView:_mainScrollView];
    [_nextBtn
     setRoundWithfloat:4];
    __weak TheSecondCarDetailViewController *weakself = self;
    _nextBtn.didClickBtnBlock =^
    {
        TheSecondCarResultViewController *result = allocAndInit(TheSecondCarResultViewController);
        TheSecondCarResult *data = allocAndInit(TheSecondCarResult);
       
        if (!_keyID ||!_series_id||!_model_id||[_keyID isEqualToString:@""]||[_series_id isEqualToString:@""]||[_model_id isEqualToString:@""]) {
            
            [[ToolManager shareInstance] showInfoWithStatus:@"请选择品牌"];
            return ;
        }
        data.pinpaiTitle = _pinpaiLable.titleLabel.text;
        data.keyid = _keyID;
        data.series_id = _series_id;
        data.model_id= _model_id;
        data.color  =@"1";
        for (int i =0;i<_comboBoxColorArray.count; i++) {
            if ([weakself.comboBoxColorArray[i] isEqualToString:weakself.comboBoxColor.valueLabel.text]) {
                data.color = [NSString stringWithFormat:@"%i",i+1];
            }
            
        }
        data.cartime = [NSString stringWithFormat:@"%@-%@",[weakSelf.comboBoxYear.valueLabel.text componentsSeparatedByString:@"年"][0],[weakSelf.comboBoxMon.valueLabel.text componentsSeparatedByString:@"月"][0]];
        
        if ([_shangpaiAddressView.text
             isEqualToString:@""]) {
            [[ToolManager shareInstance] showInfoWithStatus:@"请输入上牌地"];
             return ;
        }
        data.carvenue = _shangpaiAddressView.text;
        
        if ([_runView.text
             isEqualToString:@""]) {
            [[ToolManager shareInstance] showInfoWithStatus:@"请输入行驶路程"];
             return ;
        }
        data.mileage = _runView.text;
        
        if ([_priceView.text
             isEqualToString:@""]) {
            [[ToolManager shareInstance] showInfoWithStatus:@"请输入价格"];
             return ;
        }
        data.price = _priceView.text;
        
        data.buyprice = _buyView.text;
        
        data.images = weakSelf.images;
        
        data.labels = [NSMutableArray new];
        
        if (_modal) {
            data.iscollect = _modal.datas.iscollect;
            data.isgetclue = _modal.datas.isgetclue;
            data.isreward = _modal.datas.isreward;
            data.iscross = _modal.datas.iscross;
            data.reward = _modal.datas.reward;
            data.amount = _modal.datas.amount;
        }
        else
        {
            data.iscollect = NO;
            data.isgetclue = YES;
        }
        data.isEdit = _isEdit;
        result.data = data;
        result.modal = weakSelf.modal;
        PushView(self, result);
    };
    
    [self.view addSubview:_mainScrollView];
    if (CGRectGetMaxX(_nextBtn.frame) + 10>frameHeight(_mainScrollView)) {
        _mainScrollView.contentSize = CGSizeMake(frameWidth(_mainScrollView), CGRectGetMaxX(_nextBtn.frame) + 10);
    }
}
#pragma mark - UITextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
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
                //                if (single == '0') {
                //
                //                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                //                    return NO;
                //                }
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
