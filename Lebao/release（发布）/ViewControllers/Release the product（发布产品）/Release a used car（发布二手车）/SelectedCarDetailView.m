//
//  SelectedCarDetailViewController.m
//  Lebao
//
//  Created by David on 16/4/14.
//  Copyright © 2016年 David. All rights reserved.
//

#import "SelectedCarDetailView.h"
#import "SelectedCarResultView.h"
#import "XLDataService.h"
#define GetcarinfoUrl  [NSString stringWithFormat:@"%@common/getcarinfo",HttpURL]
@interface SelectedCarDetailView ()

@end

@implementation SelectedCarDetailView


- (instancetype)initWithFrame:(CGRect)frame seriesID:(NSString *)seriesID
{
    self = [super initWithFrame:frame];
    if (self) {
        [self navViewTitleAndBackBtn:_title];
        self.backgroundColor = AppViewBGColor;
        _selectedArray = [NSMutableArray new];
        _selectedTable = [[UITableView alloc]initWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH - 40, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)) style:UITableViewStylePlain];
        _selectedTable.delegate = self;
        _selectedTable.dataSource =self;
        _selectedTable.backgroundColor =[UIColor clearColor];
        
        [self addSubview:_selectedTable];
        
         [[ToolManager shareInstance] showWithStatus];
        NSMutableDictionary *parameter= [Parameter parameterWithSessicon];
        [parameter setValue:seriesID forKey:@"keyid"];
        [XLDataService postWithUrl:GetcarinfoUrl param:parameter modelClass:nil responseBlock:^(id dataObj, NSError *error) {
//            NSLog(@"%@",dataObj);
            if (dataObj) {
                if ([dataObj[@"rtcode"] integerValue]==1) {
                    [[ToolManager shareInstance] dismiss];
                    
                    for (NSDictionary *dic in dataObj[@"datas"]) {
                 
                        [_selectedArray addObject:dic];
                        
                        
                    }
                    [_selectedTable reloadData];
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
    return self;
}
- (void)addSelectedView{
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _selectedArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView
  titleForHeaderInSection:(NSInteger)section {
    
   
    return self.title;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return allocAndInit(UIView);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"SelectedCarDetailView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = _selectedArray[indexPath.row][@"series_name"];
    cell.textLabel.textColor = BlackTitleColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
    SelectedCarResultView *carDetail = allocAndInitWithFrame(SelectedCarResultView, frame(APPWIDTH -40, 0, APPWIDTH - 40, APPHEIGHT ) seriesID:_selectedArray[indexPath.row][@"series_id"]);
    carDetail.title = _selectedArray[indexPath.row][@"series_name"];
    carDetail.resultBlock = ^(NSString *str,NSString *model_id)
    {
        if (_resultBlock) {
            _resultBlock([NSString stringWithFormat:@"%@ %@",_selectedArray[indexPath.row][@"series_name"],str],_selectedArray[indexPath.row][@"series_id"],model_id);
        }
    };
    
    [self addSubview:carDetail];
    [UIView animateWithDuration:0.5 animations:^{
        carDetail.frame =frame(0, 0, APPWIDTH - 40, APPHEIGHT );
    }];

 
}

- (void)navViewTitleAndBackBtn:(NSString *)title
{
    UIImage *navBarLeftImg = [UIImage imageNamed:@"icon_back"];
    UIButton *navBarLeftBtn = [UIButton createButtonWithfFrame:frame(0 ,StatusBarHeight, navBarLeftImg.size.width +20*ScreenMultiple, NavigationBarHeight) title:nil backgroundImage:nil iconImage:navBarLeftImg highlightImage:nil tag:NavViewButtonActionNavLeftBtnTag ];
    [navBarLeftBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self navViewTitle:title leftBtn:navBarLeftBtn ];
}
- (void)navViewTitle:(NSString *)title leftBtn:(UIButton *)navLeftBtn
{
    UIView *_navigationBarView = [[UIView alloc]initWithFrame:frame(0, 0, APPWIDTH, StatusBarHeight + NavigationBarHeight)];
    _navigationBarView.backgroundColor = WhiteColor;
    [self addSubview:_navigationBarView];
    
    [UILabel createLabelWithFrame:frame(50, StatusBarHeight, APPWIDTH - 100, NavigationBarHeight) text:title fontSize:34*SpacedFonts textColor:WhiteColor textAlignment:NSTextAlignmentCenter inView:_navigationBarView];
    
    [_navigationBarView addSubview:navLeftBtn];
    
    
    
    
}

#pragma mark
-(void)buttonAction:(UIButton *)sender
{
    if (sender.tag ==NavViewButtonActionNavLeftBtnTag) {
        
        [UIView animateWithDuration:0.5 animations:^{
            self.frame =frame(APPWIDTH, 0, APPWIDTH - 40, APPHEIGHT );
            [self removeFromSuperview];
        }];
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
