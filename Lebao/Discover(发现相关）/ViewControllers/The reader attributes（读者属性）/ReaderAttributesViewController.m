//
//  ReaderAttributesViewController.m
//  Lebao
//
//  Created by David on 16/5/25.
//  Copyright © 2016年 David. All rights reserved.
//

#import "ReaderAttributesViewController.h"
#import "ReaderMoreViewController.h"
#import "XLDataService.h"
#import "MCPieChartView.h"
#define MyconnectionURL [NSString stringWithFormat:@"%@statistics/myconnection",HttpURL]
@interface ReaderAttributesViewController ()<MCPieChartViewDelegate,MCPieChartViewDataSource>
@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong)ReaderAttributesModal *modal;
@property(nonatomic,strong)MCPieChartView *upChartView;
@property(nonatomic,strong)MCPieChartView *downChartView;
@property(nonatomic,strong)NSMutableArray *upChartArray;
@property(nonatomic,strong)NSMutableArray *downChartArray;
@property(nonatomic,assign)int all;
@property(nonatomic,strong)BaseButton *showMore;
@end
@implementation ReaderAttributesModal
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"city":@"ReaderAttributesData",
             };
}

@end
@implementation ReaderAttributesData


@end

@implementation ReaderAttributesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navView];
    [self mainView];
  
    
}
#pragma mark - Navi_View
- (void)navView
{
    
    [self navViewTitleAndBackBtn:@"读者属性"];
    
}
#pragma mark
#pragma mark - buttonAction -
- (void)buttonAction:(UIButton *)sender
{
    if (sender.tag ==NavViewButtonActionNavLeftBtnTag ) {
        PopView(self);
    }
    
}
- (void)mainView{
    _mainScrollView = allocAndInitWithFrame(UIScrollView, frame(0, StatusBarHeight + NavigationBarHeight, frameWidth(self.view), frameHeight(self.view) - StatusBarHeight - NavigationBarHeight));
    _mainScrollView.alwaysBounceVertical = YES;
    _mainScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_mainScrollView];
    
    UIView *firstSectionView = allocAndInitWithFrame(UIView, frame(0, 10, frameWidth(_mainScrollView), 210));
    firstSectionView.backgroundColor = WhiteColor;
    [_mainScrollView addSubview:firstSectionView];
    
    UILabel *allcover = [UILabel createLabelWithFrame:frame(10, 20, frameWidth(_mainScrollView)/2.0- 20, 28*SpacedFonts) text:@"总覆盖:" fontSize:28*SpacedFonts textColor:[UIColor colorWithRed:0.7216 green:0.7294 blue:0.7333 alpha:1.0] textAlignment:NSTextAlignmentLeft inView:firstSectionView];
    

    UILabel *looks = [UILabel createLabelWithFrame:frame(CGRectGetMaxX(allcover.frame) + 10, frameY(allcover), frameWidth(allcover), frameHeight(allcover)) text:@"他们看了:" fontSize:28*SpacedFonts textColor:[UIColor colorWithRed:0.7216 green:0.7294 blue:0.7333 alpha:1.0] textAlignment:NSTextAlignmentRight inView:firstSectionView];
    
    _upChartArray = [NSMutableArray new];
    
    _upChartView = [[MCPieChartView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(looks.frame) + 10, frameWidth(firstSectionView), frameHeight(firstSectionView) -(CGRectGetMaxY(looks.frame) + 20) )];
    _upChartView.dataSource = self;
    _upChartView.delegate = self;
    _upChartView.pieBackgroundColor = [UIColor colorWithRed:0.8431 green:0.851 blue:0.8549 alpha:1.0];
    _upChartView.ringWidth = 16;
    [firstSectionView addSubview:_upChartView];
    [_upChartView reloadDataWithAnimate:YES];
   
    UIView *nan = allocAndInitWithFrame(UIView, frame(frameWidth(firstSectionView) - 74, 140, 10, 10));
    [nan setRadius:2];
    nan.backgroundColor = [UIColor colorWithRed:0.2392 green:0.549 blue:1.0 alpha:1.0];
    [firstSectionView addSubview:nan];
    UILabel *nanLb =  [UILabel createLabelWithFrame:frame(CGRectGetMaxX(nan.frame) + 5, frameY(nan),100, 24*SpacedFonts) text:@"男" fontSize:24*SpacedFonts textColor:[UIColor colorWithRed:0.6078 green:0.6118 blue:0.6157 alpha:1.0] textAlignment:NSTextAlignmentLeft inView:firstSectionView];
    
    UIView *nv = allocAndInitWithFrame(UIView, frame(frameX(nan), CGRectGetMaxY(nan.frame) + 10, 10, 10));
    [nv setRadius:2];
    nv.backgroundColor = [UIColor colorWithRed:0.9765 green:0.4275 blue:0.1176 alpha:1.0];
    [firstSectionView addSubview:nv];
    UILabel *nvLb =  [UILabel createLabelWithFrame:frame(CGRectGetMaxX(nv.frame) + 5, frameY(nv), 100, 24*SpacedFonts) text:@"女" fontSize:24*SpacedFonts textColor:[UIColor colorWithRed:0.6078 green:0.6118 blue:0.6157 alpha:1.0] textAlignment:NSTextAlignmentLeft inView:firstSectionView];

    UIView *weizhi = allocAndInitWithFrame(UIView, frame(frameX(nv), CGRectGetMaxY(nv.frame) + 10, 10, 10));
    [weizhi setRadius:2];
    weizhi.backgroundColor = [UIColor colorWithRed:0.8431 green:0.851 blue:0.8549 alpha:1.0];
    [firstSectionView addSubview:weizhi];
   UILabel *weizhiLb=  [UILabel createLabelWithFrame:frame(CGRectGetMaxX(weizhi.frame) + 5, frameY(weizhi), 100, 24*SpacedFonts) text:@"未知" fontSize:24*SpacedFonts textColor:[UIColor colorWithRed:0.6078 green:0.6118 blue:0.6157 alpha:1.0] textAlignment:NSTextAlignmentLeft inView:firstSectionView];
    
    UIView *secondSectionView = allocAndInitWithFrame(UIView, frame(0, CGRectGetMaxY(firstSectionView.frame) + 10, frameWidth(_mainScrollView), 220));
    secondSectionView.backgroundColor = WhiteColor;
    [_mainScrollView addSubview:secondSectionView];
    
    _downChartArray = [NSMutableArray new];
    
    _downChartView = [[MCPieChartView alloc] initWithFrame:CGRectMake(0, 10, frameWidth(_upChartView), frameHeight(_upChartView))];
    _downChartView.dataSource = self;
    _downChartView.delegate = self;
    _downChartView.pieBackgroundColor = [UIColor colorWithRed:0.8431 green:0.851 blue:0.8549 alpha:1.0];
    _downChartView.ringWidth = 16;
    [secondSectionView addSubview:_downChartView];
    [_downChartView reloadDataWithAnimate:YES];
    

    _showMore = [[BaseButton alloc]initWithFrame:frame(0, frameHeight(secondSectionView) - 40, frameWidth(secondSectionView), 40) setTitle:@"查看更多>>" titleSize:28*SpacedFonts titleColor:AppMainColor textAlignment:NSTextAlignmentCenter backgroundColor:WhiteColor inView:secondSectionView];
        __weak typeof(self) weakSelf =self;
    _showMore.didClickBtnBlock = ^
    {
        if (weakSelf.modal.city.count==0) {
            [[ToolManager shareInstance] showInfoWithStatus:@"获取数据失败或没有相关数据"];
            return ;
        }
        ReaderMoreViewController *readerMoreVC = allocAndInit(ReaderMoreViewController);
        readerMoreVC.citys = weakSelf.modal.city;
        PushView(weakSelf, readerMoreVC);
        
    };
    
    
    
    [[ToolManager shareInstance] showWithStatus];
    NSMutableDictionary *parameter = [Parameter parameterWithSessicon];

    [XLDataService postWithUrl:MyconnectionURL param:parameter modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (dataObj) {
           
            _modal = [ReaderAttributesModal mj_objectWithKeyValues:dataObj];
            if (_modal.rtcode) {
                [[ToolManager shareInstance] dismiss];
                allcover.text = [NSString stringWithFormat:@"总覆盖:  %i人",_modal.all];
                NSMutableAttributedString *allcoverstr = [[NSMutableAttributedString alloc] initWithString:allcover.text];
                [allcoverstr addAttribute:NSForegroundColorAttributeName
                                    value:[UIColor colorWithRed:0.9765 green:0.3529 blue:0.0 alpha:1.0]
                                    range:[allcover.text rangeOfString:[NSString stringWithFormat:@"%i人",_modal.all]]];
                [allcoverstr addAttribute:NSFontAttributeName
                                    value:[UIFont systemFontOfSize:30*SpacedFonts]
                                    range:[allcover.text rangeOfString:[NSString stringWithFormat:@"%i人",_modal.all]]];
                allcover.attributedText = allcoverstr;
                
                looks.text = [NSString stringWithFormat:@"他们看了:  %i次",_modal.browse];
                
                NSMutableAttributedString *looksstr = [[NSMutableAttributedString alloc] initWithString:looks.text];
                [looksstr addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:30*SpacedFonts]
                                 range:[looks.text rangeOfString:[NSString stringWithFormat:@"%i次",_modal.browse]]];
                [looksstr addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor colorWithRed:0.9765 green:0.3529 blue:0.0 alpha:1.0]
                                 range:[looks.text rangeOfString:[NSString stringWithFormat:@"%i次",_modal.browse]]];
                looks.attributedText = looksstr;
                nanLb.text = [NSString stringWithFormat:@"男(%i)",_modal.man];
                nvLb.text = [NSString stringWithFormat:@"女(%i)",_modal.women];
                weizhiLb.text = [NSString stringWithFormat:@"未知(%i)",_modal.unknow];
                
                UIView *firstCity = allocAndInitWithFrame(UIView, frame(frameWidth(secondSectionView) - 74, 105, 10, 10));
                UIView *secondCity = allocAndInitWithFrame(UIView, frame(frameX(firstCity), CGRectGetMaxY(firstCity.frame) + 10, 10, 10));
                UIView *thirdCity = allocAndInitWithFrame(UIView, frame(frameX(secondCity), CGRectGetMaxY(secondCity.frame) + 10, 10, 10));
                
                [secondSectionView addSubview:firstCity];
                if (_modal.city.count>0) {
                    ReaderAttributesData *data =_modal.city[0];
                    [firstCity setRadius:2];
                    firstCity.backgroundColor = [UIColor colorWithRed:0.2392 green:0.549 blue:1.0 alpha:1.0];
                    UILabel *firstCityLb =  [UILabel createLabelWithFrame:frame(CGRectGetMaxX(firstCity.frame) + 5, frameY(firstCity),100, 24*SpacedFonts) text:@"" fontSize:24*SpacedFonts textColor:[UIColor colorWithRed:0.6078 green:0.6118 blue:0.6157 alpha:1.0] textAlignment:NSTextAlignmentLeft inView:secondSectionView];
                    
                    firstCityLb.text =[NSString stringWithFormat:@"%@(%i)",data.city,data.count];
                    _all+=data.count;
                    [_downChartArray addObject:@(data.count)];
                }
                if (_modal.city.count>1) {
                    ReaderAttributesData *data =_modal.city[1];
                    
                    [secondCity setRadius:2];
                    secondCity.backgroundColor = [UIColor colorWithRed:0.2118 green:0.9294 blue:0.6039 alpha:1.0];
                    [secondSectionView addSubview:secondCity];
                    
                    UILabel *secondCityLb =  [UILabel createLabelWithFrame:frame(CGRectGetMaxX(secondCity.frame) + 5, frameY(secondCity),100, 24*SpacedFonts) text:@"" fontSize:24*SpacedFonts textColor:[UIColor colorWithRed:0.6078 green:0.6118 blue:0.6157 alpha:1.0] textAlignment:NSTextAlignmentLeft inView:secondSectionView];

                    secondCityLb.text =[NSString stringWithFormat:@"%@(%i)",data.city,data.count];
                    _all+=data.count;
                    [_downChartArray addObject:@(data.count)];
                }
                if (_modal.city.count>2) {
                    ReaderAttributesData *data =_modal.city[2];
                    
                    [thirdCity setRadius:2];
                    thirdCity.backgroundColor = [UIColor colorWithRed:0.9843 green:0.7882 blue:0.2 alpha:1.0];
                    [secondSectionView addSubview:thirdCity];
                    
                    UILabel *thirdCityLb =  [UILabel createLabelWithFrame:frame(CGRectGetMaxX(thirdCity.frame) + 5, frameY(thirdCity),100, 24*SpacedFonts) text:@"" fontSize:24*SpacedFonts textColor:[UIColor colorWithRed:0.6078 green:0.6118 blue:0.6157 alpha:1.0] textAlignment:NSTextAlignmentLeft inView:secondSectionView];
                    thirdCityLb.text =[NSString stringWithFormat:@"%@(%i)",data.city,data.count];
                    _all+=data.count;
                    [_downChartArray addObject:@(data.count)];
                }
                if (_modal.city.count>3) {
                    ReaderAttributesData *data =_modal.city[3];
                    
                    UIView *fourCity = allocAndInitWithFrame(UIView, frame(frameX(thirdCity), CGRectGetMaxY(thirdCity.frame) + 10, 10, 10));
                    [fourCity setRadius:2];
                    fourCity.backgroundColor = [UIColor colorWithRed:0.8431 green:0.851 blue:0.8549 alpha:1.0];
                    [secondSectionView addSubview:fourCity];
                    
                    UILabel *fourCityLb =  [UILabel createLabelWithFrame:frame(CGRectGetMaxX(fourCity.frame) + 5, frameY(fourCity),100, 24*SpacedFonts) text:@"" fontSize:24*SpacedFonts textColor:[UIColor colorWithRed:0.6078 green:0.6118 blue:0.6157 alpha:1.0] textAlignment:NSTextAlignmentLeft inView:secondSectionView];
                    fourCityLb.text =[NSString stringWithFormat:@"%@(%i)",data.city,data.count];
                    _all+=data.count;
                    [_downChartArray addObject:@(data.count)];
                }
                  [_upChartArray addObject:@(_modal.man)];
                  [_upChartArray addObject:@(_modal.women)];
                  [_upChartArray addObject:@(_modal.unknow)];
                [_downChartView reloadDataWithAnimate:YES];
                [_upChartView reloadDataWithAnimate:YES];
                
               
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
   
    if (CGRectGetMaxY(secondSectionView.frame) + 10>frameHeight(_mainScrollView)) {
        _mainScrollView.contentSize = CGSizeMake(frameWidth(_mainScrollView), CGRectGetMaxY(secondSectionView.frame) + 10);
    }

}
- (NSInteger)numberOfPieInPieChartView:(MCPieChartView *)pieChartView {
    if (pieChartView ==_upChartView) {
        return _upChartArray.count;
    }
    return _downChartArray.count;
}

- (id)pieChartView:(MCPieChartView *)pieChartView valueOfPieAtIndex:(NSInteger)index {
    
    if (pieChartView ==_upChartView) {
        return _upChartArray[index];
    }
    return _downChartArray[index];
}

- (id)sumValueInPieChartView:(MCPieChartView *)pieChartView {
    
    if (pieChartView ==_upChartView) {
      
        return @(_modal.all);
    }
  
    return @(_all);
}

- (NSAttributedString *)ringTitleInPieChartView:(MCPieChartView *)pieChartView {
    
    NSString *all;
    NSString *name;
    if (pieChartView ==_upChartView) {
        
        all = [NSString stringWithFormat:@"%i",_modal.all];
        name = @"性别分布图";
    }
    else
    {
        all = [NSString stringWithFormat:@"%i",_all];
        name = @"城市分布";
    }
    NSString *text = [NSString stringWithFormat:@"%@人\n%@",all,name];
    
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.5804 green:0.5843 blue:0.5882 alpha:1.0] range:[text rangeOfString:name]];
    [str addAttribute:NSFontAttributeName value:Size(24) range:[text rangeOfString:name]];
    
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.2157 green:0.5333 blue:0.9882 alpha:1.0] range:[text rangeOfString:[NSString stringWithFormat:@"%@人",all]]];
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:40.0*SpacedFonts] range:[text rangeOfString:[NSString stringWithFormat:@"%@人",all]]];
    return str;
}

- (UIColor *)pieChartView:(MCPieChartView *)pieChartView colorOfPieAtIndex:(NSInteger)index {
    
    if (pieChartView ==_upChartView) {
        
        if (index == 0) {
            return [UIColor colorWithRed:0.2431 green:0.5451 blue:1.0 alpha:1.0];
        }
        else if (index == 1) {
            return [UIColor colorWithRed:0.9765 green:0.4275 blue:0.1176 alpha:1.0];
        }
        
        return [UIColor colorWithRed:0.8431 green:0.851 blue:0.8549 alpha:1.0];
    }
    
    else
    {
        if (index == 0) {
            return [UIColor colorWithRed:0.2431 green:0.5451 blue:1.0 alpha:1.0];
        }
        else if (index == 1) {
            return [UIColor colorWithRed:0.2039 green:0.9216 blue:0.6 alpha:1.0];
        }
        else if (index == 2) {
            return [UIColor colorWithRed:0.9843 green:0.7882 blue:0.2 alpha:1.0];
        }
        
        return [UIColor colorWithRed:0.8431 green:0.851 blue:0.8549 alpha:1.0];
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
