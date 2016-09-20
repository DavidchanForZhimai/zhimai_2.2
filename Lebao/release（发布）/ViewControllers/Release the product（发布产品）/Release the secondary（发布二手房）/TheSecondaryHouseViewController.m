//
//  TheSecondaryHouseViewController.m
//  Lebao
//
//  Created by David on 16/2/3.
//  Copyright © 2016年 David. All rights reserved.
//

#import "TheSecondaryHouseViewController.h"
#import "UpLoadImageManager.h"
#import "TheSecondHourseNextViewController.h"
#import "XLDataService.h"

#define ImageDefault @"ImageDefault"
#define ImageDiagram @"ImageDiagram"
#define ImageDiagramType @"ImageDiagramType"

#define Readdetail [NSString stringWithFormat:@"%@product/editestate",HttpURL]
@interface TheSecondaryHouseViewController ()
@property(nonatomic,strong)NSArray *comboBoxDatasource;
@property(nonatomic,strong)TheSecondaryHouseModal *modal;
@end


@implementation TheSecondaryHouseViewController
{

    BaseButton *_nextBtn;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navView];
    
    _images = [NSMutableArray new];
    _selectedArray = [NSMutableArray new];
    _comboBoxArray = [NSMutableArray new];
    _comboBoxDatasource = [[NSArray alloc] initWithObjects:@"客厅",@"主卧",@"厨房",@"阳台",@"洗手间",@"户型图",@"小区图",@"次卧",@"书房", @"餐厅", @"入户花园",nil];
    
    if (_isEdit) {
        [[ToolManager shareInstance] showWithStatus];
        NSMutableDictionary *parameter =[Parameter parameterWithSessicon];
        if (_acid) {
            [parameter setValue:_acid forKey:@"acid"];
        }
        if (_uid) {
            [parameter setValue:_uid forKey:@"uid"];
        }
        
        [XLDataService postWithUrl:Readdetail param:parameter modelClass:nil responseBlock:^(id dataObj, NSError *error) {
//            NSLog(@"Readdetail =%@ parameter=%@ dataObj =%@",Readdetail,parameter,dataObj);
            if (dataObj) {
                _modal = [TheSecondaryHouseModal mj_objectWithKeyValues:dataObj];
                _modal.datas.acid = _acid;
                if (_modal.rtcode ==1) {
                    
                    [[ToolManager shareInstance] dismiss];
                    for (TheSecondEstatepics *theSecondEstatepics in _modal.datas.estatepics) {
                     
                        if ([theSecondEstatepics.typekey intValue] - 1<_comboBoxDatasource.count) {
                     
                            [_images addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:theSecondEstatepics.imgurl,ImageDefault,theSecondEstatepics.abbre_imgurl,ImageDiagram, _comboBoxDatasource[[theSecondEstatepics.typekey intValue] - 1],ImageDiagramType, nil]];
                        }
                     
                    }

                    [self mainView];
                    
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
   
    
    _mainScrollView = allocAndInitWithFrame(UIScrollView, frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)));
    _mainScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_mainScrollView];
    
    UIView *view = allocAndInitWithFrame(UIView , frame(0, 10, APPWIDTH, 140));
    view.backgroundColor = WhiteColor;
    [_mainScrollView addSubview:view];
    
    __weak TheSecondaryHouseViewController *weakSelf =self;
    
    _nextBtn = [[BaseButton alloc]initWithFrame:frame(13*ScreenMultiple, 10 + CGRectGetMaxY(view.frame), APPWIDTH - 26*ScreenMultiple, 40) setTitle:@"下一步" titleSize:28*SpacedFonts  titleColor:WhiteColor textAlignment:NSTextAlignmentCenter  backgroundColor:AppMainColor inView:_mainScrollView];
    [_nextBtn
     setRoundWithfloat:4];
    _nextBtn.didClickBtnBlock =^
    {
        
        TheSecondHourseNextViewController *next = allocAndInit(TheSecondHourseNextViewController);
        next.images = [NSMutableArray new];
        for (NSDictionary *dic in weakSelf.images) {
            
            NSString *type;
            for (int i =0;i<weakSelf.comboBoxDatasource.count;i++) {
                NSString *ty = weakSelf.comboBoxDatasource[i];
                if ([ty isEqualToString:dic[ImageDiagramType]]) {
                    type = [NSString stringWithFormat:@"%i",i+1];
                }
            }
            NSArray *array = [NSArray arrayWithObjects:dic[ImageDefault],dic[ImageDiagram],type, nil];
            [next.images addObject:array];
        }
//        NSLog(@"next.images =%@",next.images);
        next.isEdit = weakSelf.isEdit;
        next.modal = weakSelf.modal;
        PushView(weakSelf, next);
        
    };
    [self reloadImagesView:weakSelf inView:view];
    if (CGRectGetMaxX(_nextBtn.frame) + 10>frameHeight(_mainScrollView)) {
        _mainScrollView.contentSize = CGSizeMake(frameWidth(_mainScrollView), CGRectGetMaxX(_nextBtn.frame) + 10);
    }
   
    
}
#pragma mark 二手房源
- (void)reloadImagesView:(TheSecondaryHouseViewController*)weakSelf inView:(UIView*)view
{
    for (UIView *subView in view.subviews) {
        
        [subView removeFromSuperview];
    }

    
    for (UIView *subView in _mainScrollView.subviews) {
        if ([subView isKindOfClass:[FSComboListView class]]) {
             [subView removeFromSuperview];
        }
    }
    
    
    float iconW = (APPWIDTH - 40)/3.0;
    for (int i=0;i<_images.count + 1; i++) {
        

        NSMutableDictionary *imageDic = [NSMutableDictionary new];;
        if (i<_images.count) {
            imageDic = _images[i];
        }
        
        _selectedBtn = [[BaseButton alloc]initWithFrame:frame(10 + i%3*(iconW+ 10), 15 + i/3*(iconW + 40), iconW, iconW) backgroundImage:nil iconImage:nil highlightImage:nil inView:view];
        
        _selectedBtn.didClickBtnBlock = ^
        {
            if (i<_images.count) {
                [[ToolManager shareInstance] showAlertViewTitle:@"确定删除？" contentText:nil showAlertViewBlcok:^{
                    [weakSelf.images removeObjectAtIndex:i];
                    [weakSelf reloadImagesView:weakSelf inView:view];
                } ];
            }
            else
            {
     
            [[ToolManager shareInstance] seleteImageFormSystem:weakSelf seleteImageFormSystemBlcok:^(UIImage *image) {
               
                [[UpLoadImageManager shareInstance] upLoadImageType:UploadImagesTypeProperty image:image  imageBlock:^(UpLoadImageModal * upLoadImageModal) {
                    
                        [imageDic setValue:upLoadImageModal.imgurl forKey:ImageDefault];
                        [imageDic setValue:upLoadImageModal.abbr_imgurl forKey:ImageDiagram];
                        [weakSelf.images addObject:imageDic];
                        [weakSelf reloadImagesView:weakSelf inView:view];
            
                    
                }];
                
            }];
            }
            
        };
        
      
        _comboBox = [[FSComboListView alloc] initWithValues:_comboBoxDatasource
                                                                           frame:frame(frameX(_selectedBtn) , CGRectGetMaxY(_selectedBtn.frame) + 13 , frameWidth(_selectedBtn), 25)];
        _comboBox.Combotype = comboListTypePicker;
        _comboBox.valueLabel.layer.borderColor = [UIColor clearColor].CGColor;
       
        if (i<_images.count) {
            [[ToolManager shareInstance] imageView:_selectedBtn setImageWithURL:imageDic[ImageDiagram]  placeholderType:PlaceholderTypeOther];
            
            if (!imageDic[ImageDiagramType]) {
                [imageDic setValue:[_comboBoxDatasource objectAtIndex:0] forKey:ImageDiagramType];
            }
            [ _comboBox.valueLabel setText:imageDic[ImageDiagramType]];
            _comboBox.changedBlock = ^(FSComboListView *comboListView,NSString * toValue)
            {
                if (imageDic) {
                  
                     [imageDic setValue:toValue forKey:ImageDiagramType];
                }
               
                [weakSelf.images replaceObjectAtIndex:i withObject:imageDic];
                
            };
            
            
        }
        else
        {
            [_selectedBtn setBackgroundImage:[UIImage imageNamed:@"addition"] forState:UIControlStateNormal];
            if (!imageDic[ImageDiagramType]) {
                [imageDic setValue:[_comboBoxDatasource objectAtIndex:0] forKey:ImageDiagramType];
            }
            [ _comboBox.valueLabel setText:imageDic[ImageDiagramType]];
            _comboBox.changedBlock = ^(FSComboListView *comboListView,NSString * toValue)
            {
//                 NSLog(@"comboboxClosed2=%@ imageDic2=%@",toValue,imageDic);

                [imageDic setValue:toValue forKey:ImageDiagramType];
                if (!imageDic[ImageDefault]||[imageDic[ImageDefault] isEqualToString:@""]) {
                    
                    [[ToolManager shareInstance] showInfoWithStatus:@"请选择相关图片"];
                    return ;
                }
                [weakSelf.images addObject:imageDic];
//                NSLog(@"comboboxClosed=%@",toValue);
            };

            
        }
        [_mainScrollView addSubview:_comboBox];
        
        [_comboBoxArray addObject:_comboBox];
        
        [_selectedArray addObject:_selectedBtn];
        
        view.frame = frame(0, 10, APPWIDTH, CGRectGetMaxY(_selectedBtn.frame) +40);
        _nextBtn.frame =frame(13*ScreenMultiple, 10 + CGRectGetMaxY(view.frame), APPWIDTH - 26*ScreenMultiple, 40);
        
        if (CGRectGetMaxX(_nextBtn.frame) + 10>frameHeight(_mainScrollView)) {
            _mainScrollView.contentSize = CGSizeMake(frameWidth(_mainScrollView), CGRectGetMaxX(_nextBtn.frame) + 10);
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



