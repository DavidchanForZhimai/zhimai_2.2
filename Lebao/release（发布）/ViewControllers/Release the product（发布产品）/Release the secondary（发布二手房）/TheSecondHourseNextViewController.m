//
//  TheSecondHourseNextViewController.m
//  Lebao
//
//  Created by David on 16/4/11.
//  Copyright © 2016年 David. All rights reserved.
//

#import "TheSecondHourseNextViewController.h"
#import "ReleaseTheSecondHourseViewController.h"//发布二手房源
#import "FSComboListView.h"
@interface TheSecondHourseNextViewController ()
{
    FSComboListView *_comboBox;
}
@end

@implementation TheSecondHourseNextViewController
{
    UITextField *_titleTextField;
    
    UITextField *_allPriceLeftTextField;
    UITextField *_allPriceRightTextField;
    
    UITextField *_hourseTypeShiTextField;
    UITextField *_hourseTypeTingTextField;
    UITextField *_hourseTypeWeiTextField;
    UITextField *_hourseTypeChuTextField;
    
     BaseButton *_locationlow;
     BaseButton *_locationcenter;
     BaseButton *_locationhight;
    
    UITextField *_locationCengTextField;
    NSString *chuanxiang;

    NSMutableArray *_items;
    NSString *location;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navView];
    [self mainView];
    
    
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
    _selecteds  =[NSMutableArray arrayWithObjects:@"0",@"0",@"0", nil];
    location = @"1";
    _items = [NSMutableArray new];
    
    _mainScrollView = allocAndInitWithFrame(UIScrollView, frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)));
    _mainScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_mainScrollView];
    
    UIView *_releaseViewBg = allocAndInitWithFrame(UIView, frame(10 , 10, frameWidth(_mainScrollView) - 50, 42));
    _releaseViewBg.backgroundColor =[UIColor whiteColor];
    [_releaseViewBg setBorder:LineBg width:0.5];
    [_releaseViewBg setRadius:5.0];
    [_mainScrollView addSubview:_releaseViewBg];
    //带型号
    [UILabel createLabelWithFrame:frame(CGRectGetMaxX(_releaseViewBg.frame) + 10, frameY(_releaseViewBg), 20, frameHeight(_releaseViewBg)) text:@"*" fontSize:28*SpacedFonts textColor:[UIColor redColor] textAlignment:NSTextAlignmentCenter inView:_mainScrollView];
    
    _titleTextField = allocAndInitWithFrame(UITextField, frame(10 , 0, frameWidth(_releaseViewBg)-20, frameHeight(_releaseViewBg)));
    _titleTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入小区名" attributes:@{NSForegroundColorAttributeName:LightBlackTitleColor }];
    [_releaseViewBg addSubview:_titleTextField];
    _titleTextField.textColor = BlackTitleColor;
    _titleTextField.font = Size(24);
    _titleTextField.clearButtonMode =UITextFieldViewModeWhileEditing;
    if (_modal.datas.estatename) {
        _titleTextField.text =_modal.datas.estatename;
    }
    
    UIView *view = allocAndInitWithFrame(UIView , frame(0, 63, APPWIDTH, 255));
    view.backgroundColor = WhiteColor;
    [_mainScrollView addSubview:view];
    
    //总价
    [UILabel createLabelWithFrame:frame(10, 0, 2*24*SpacedFonts, 35) text:@"总价" fontSize:24*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:view];
    
    float allpriceX = 10;
    float allpriceY = 35;
    float allpriceW = (APPWIDTH - 40)/2.0;
    float allpriceH = 32;
   _allPriceLeftTextField = [self createframe:frame(allpriceX, allpriceY, allpriceW, allpriceH) title:@"万元*" inView:view text:_modal.datas.total];
    
    _allPriceRightTextField = [self createframe:frame(2*allpriceX + allpriceW,allpriceY,allpriceW, allpriceH) title:@"万/平" inView:view text:_modal.datas.acreage];
    if (_modal.datas.estatename) {
        _allPriceRightTextField.text =_modal.datas.acreage;
    }
   [UILabel CreateLineFrame:frame(10, 83, APPWIDTH - 20, 0.5) inView:view];
    
    //户型

    [UILabel createLabelWithFrame:frame(10,83, 2*24*SpacedFonts, 35) text:@"户型" fontSize:24*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:view];
    
    float typeX = 10;
    float typeY = 83 + 35;
    float typeW =(APPWIDTH - 20*4)/4.0;
    float typeH = 32;
    
    _hourseTypeShiTextField = [self createframe:frame(typeX, typeY, typeW, typeH) title:@"室" inView:view text:_modal.datas.room];
    
    _hourseTypeTingTextField = [self createframe:frame(2*typeX + typeW, typeY, typeW, typeH) title:@"厅" inView:view text:_modal.datas.hall];
    
    _hourseTypeWeiTextField = [self createframe:frame(3*typeX + 2*typeW, typeY, typeW, typeH) title:@"卫" inView:view text:_modal.datas.toilet];
    _hourseTypeChuTextField = [self createframe:frame(4*typeX + 3*typeW, typeY, typeW +20, typeH) title:@"平*" inView:view text:[NSString stringWithFormat:@"%i",(int)_modal.datas.square]];
    [UILabel CreateLineFrame:frame(10, 169, APPWIDTH - 20, 0.5) inView:view];
    __weak TheSecondHourseNextViewController *weakSelf =self;
    //楼层位置
    //开关选择
    NSArray *array = @[@"低",@"中",@"高"];
   
    //    NSMutableArray *instanceArray =
    location = @"0";
    if (_modal.datas.floorgrade) {
//        NSLog(@"_modal.datas.floorgrade =%i",(int)_modal.datas.floorgrade);
        location =[NSString stringWithFormat:@"%i",(int)_modal.datas.floorgrade];
    }
    float cellW = (APPWIDTH/2.0)/3.0;
    for (int i =0; i<array.count; i++) {
        NSString *name  = array[i];
        UIImage *imageicon = [UIImage imageNamed:@"xuanzheweixuanzhong"];
        UIImage *imageH =[UIImage imageNamed:@"xuanzhexuanzhong"] ;
        if (i==[location integerValue] -1) {
            imageicon =[UIImage imageNamed:@"xuanzhexuanzhong"];
            imageH = [UIImage imageNamed:@"xuanzheweixuanzhong"];
        }
        else
        {
        imageicon = [UIImage imageNamed:@"xuanzheweixuanzhong"];
        imageH =[UIImage imageNamed:@"xuanzhexuanzhong"] ;
        }
        BaseButton * _item = [[BaseButton alloc]initWithFrame:frame(i%4*cellW + 10, i/4*typeH + 169 + 35, cellW, typeH) setTitle:name titleSize:24*SpacedFonts titleColor:BlackTitleColor backgroundImage:nil iconImage:imageicon highlightImage:imageH setTitleOrgin:CGPointMake((typeH -imageicon.size.height)/2.0 , (cellW - 48*SpacedFonts)/2.0 - imageicon.size.width + 5) setImageOrgin:CGPointMake((typeH -imageicon.size.height)/2.0 , (cellW - 48*SpacedFonts)/2.0 - imageicon.size.width) inView:view];
        _item.shouldAnmial = NO;
        
        _item.didClickBtnBlock=^
        {
            
            
            if ([weakSelf.selecteds[i] isEqualToString:@"0"]) {
            
                for (int j = 0; j<weakSelf.selecteds.count; j++) {
                    BaseButton *btnj = _items[j];
                    if (j ==i) {
                        [btnj setImage:[UIImage imageNamed:@"xuanzhexuanzhong"] forState:UIControlStateNormal];
                        [btnj setImage:[UIImage imageNamed:@"xuanzheweixuanzhong"] forState:UIControlStateHighlighted];
                        [weakSelf.selecteds replaceObjectAtIndex:i withObject:@"1"];
                        location = [NSString stringWithFormat:@"%i",i+1];
                        
                    }
                    else
                    {
                    [btnj setImage:[UIImage imageNamed:@"xuanzheweixuanzhong"] forState:UIControlStateNormal];
                    [btnj setImage:[UIImage imageNamed:@"xuanzhexuanzhong"] forState:UIControlStateHighlighted];
                    [weakSelf.selecteds replaceObjectAtIndex:j withObject:@"0"];
                    }
                    
                }
                
            }
            
            
        };
        [_items addObject:_item];
        
    }

    
    
    [UILabel createLabelWithFrame:frame(10, 169 , 4*24*SpacedFonts, 35) text:@"楼层位置" fontSize:24*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:view];
    typeY = 169 + 35;
    _locationCengTextField = [self createframe:frame(3*typeX + 2*typeW   +10 , typeY, typeW, typeH) title:@"层" inView:view text:_modal.datas.floor];
    
    NSArray *comboBoxDatasource = [[NSArray alloc] initWithObjects:@"正东",@"正西",@"正南",@"正北",@"东南方",@"西南方",@"东北方",@"西北方",nil];
    
    _comboBox = [[FSComboListView alloc] initWithValues:comboBoxDatasource
                                                  frame:frame(4*typeX + 3*typeW +5 ,frameY(view)+ typeY , 70, 25)];
    _comboBox.Combotype = comboListTypeTable;
    _comboBox.backgroundColor = [UIColor clearColor];
    [_comboBox.valueLabel setText:[comboBoxDatasource objectAtIndex:0]];
    chuanxiang= [comboBoxDatasource objectAtIndex:0];
    if (_modal.datas.face) {
        [_comboBox.valueLabel setText:_modal.datas.face];
        chuanxiang= _modal.datas.face;
    }
    _comboBox.changedBlock = ^(FSComboListView *comboListView,NSString * toValue)
    {
//         NSLog(@"comboboxClosed=%@",toValue);
       chuanxiang = toValue;
    };


    [UILabel createLabelWithFrame:frame(CGRectGetMaxX(_comboBox.frame), _comboBox.frame.origin.y, 2*24*SpacedFonts, 25) text:@"朝向" fontSize:24*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:_mainScrollView];
   
    BaseButton *_nextBtn = [[BaseButton alloc]initWithFrame:frame(13*ScreenMultiple, 20 + CGRectGetMaxY(view.frame), APPWIDTH - 26*ScreenMultiple, 40) setTitle:@"下一步" titleSize:28*SpacedFonts  titleColor:WhiteColor textAlignment:NSTextAlignmentCenter  backgroundColor:AppMainColor inView:_mainScrollView];
    [_nextBtn
     setRoundWithfloat:4];
    _nextBtn.didClickBtnBlock =^
    {
        
        if (_titleTextField.text.length<1||_hourseTypeChuTextField.text.length<1||_allPriceLeftTextField.text.length<1) {
            [[ToolManager shareInstance] showInfoWithStatus:@"请完善信息（带星号必填）"];
            return ;
            
        }
        if (_hourseTypeShiTextField.text.length>2||_hourseTypeWeiTextField.text.length>2||_hourseTypeTingTextField.text.length>2) {
            [[ToolManager shareInstance] showInfoWithStatus:@"室卫厅不能超过两个字符"];
            return ;
        }
    
        ReleaseTheSecondHourseViewController *secondhourse = allocAndInit(ReleaseTheSecondHourseViewController);
        ReleaseTheSecond *data = allocAndInit(ReleaseTheSecond);
        data.images = weakSelf.images;
        data.estatename = _titleTextField.text;
        data.total = _allPriceLeftTextField.text;
        data.acreage = _allPriceRightTextField.text;
        data.room = _hourseTypeShiTextField.text;
        data.hall = _hourseTypeTingTextField.text;
        data.toilet = _hourseTypeWeiTextField.text;
        data.square = _hourseTypeChuTextField.text;
        data.floorgrade = location;
        data.square = _hourseTypeChuTextField.text;
        data.face =chuanxiang;
        data.floor =_locationCengTextField.text;
        data.labels = [NSMutableArray new];
        data.isEdit = weakSelf.isEdit;
        secondhourse.modal = _modal;
        if (_modal) {
            data.iscollect = _modal.datas.iscollect;
            data.isgetclue = _modal.datas.isgetclue;
            data.isreward = _modal.datas.isreward;
            data.iscross = _modal.datas.iscross;
            data.reward = _modal.datas.reward;
            data.amount = _modal.datas.amount;
        }
        
        secondhourse.data = data;
        
        PushView(weakSelf, secondhourse);
        
    };
    [_mainScrollView addSubview:_comboBox];
    if (CGRectGetMaxY(_nextBtn.frame) + 10>frameHeight(_mainScrollView)) {
        _mainScrollView.contentSize = CGSizeMake(frameWidth(_mainScrollView), CGRectGetMaxY(_nextBtn.frame) + 10);
    }
}
-(UITextField *)createframe:(CGRect)frame title:(NSString *)title inView:(UIView *)view text:(NSString *)text
{
    UIView *texfFiledView = allocAndInitWithFrame(UIView, frame(frame.origin.x, frame.origin.y, frame.size.width - 10 - 24*SpacedFonts*title.length, frame.size.height));
    texfFiledView.backgroundColor =[UIColor whiteColor];
    [texfFiledView setBorder:LineBg width:0.5];
    [view addSubview:texfFiledView];
    
    UITextField *textField = allocAndInitWithFrame(UITextField, frame(5 , 0, frameWidth(texfFiledView)-10, frameHeight(texfFiledView)));
    [texfFiledView addSubview:textField];
    if (text) {
        textField.text = text;
    }

    textField.textColor = BlackTitleColor;
    textField.font = Size(24);
    textField.keyboardType = UIKeyboardTypeNumberPad;
    
    [UILabel createLabelWithFrame:frame(CGRectGetMaxX(texfFiledView.frame)  +10, frame.origin.y, title.length*24*SpacedFonts, frame.size.height) text:title fontSize:24*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:view];
    
    return textField;
    
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
