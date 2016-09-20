//
//  ReaderMoreViewController.m
//  Lebao
//
//  Created by David on 16/5/26.
//  Copyright © 2016年 David. All rights reserved.
//

#import "ReaderMoreViewController.h"

@interface ReaderMoreViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *readerMoreView;
@end

@implementation ReaderMoreData


@end
@implementation ReaderMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navViewTitleAndBackBtn:@"城市分布"];
    [self addTableView];
    
}
- (void)addTableView
{

    _readerMoreView = [[UITableView alloc]initWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, frameWidth(self.view), APPHEIGHT -(StatusBarHeight + NavigationBarHeight) ) style:UITableViewStyleGrouped];
    _readerMoreView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _readerMoreView.backgroundColor = [UIColor clearColor];
    _readerMoreView.delegate = self;
    _readerMoreView.dataSource = self;
    [self.view addSubview:_readerMoreView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return _citys.count;
    
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 52;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = allocAndInitWithFrame(UIView, frame(0, 0, frameWidth(_readerMoreView), 52));
    headerView.backgroundColor = WhiteColor;
 
    UIView *header = allocAndInitWithFrame(UIView, frame(0, 0, frameWidth(_readerMoreView), 10));
    header.backgroundColor = AppViewBGColor;
    [headerView addSubview:header];

    [UILabel createLabelWithFrame:frame(10, 10, frameWidth(headerView), 42) text:@"城市分布" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:headerView];
    return headerView;
    
}
- (CGFloat) tableView:(UITableView *)tableView  heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 42;
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID =@"ReaderMoreCell";
    ReaderMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ReaderMoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellHeight:42 cellWidth:frameWidth(_readerMoreView)];
                
            }
    
    BOOL isClear;
    if (indexPath.row%2==0) {
        isClear = YES;
    }
    else
    {
         isClear = NO;
    }
    [cell setData:_citys[indexPath.row] isClear:isClear];
    
    return cell;
    
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

@implementation ReaderMoreCell
{
    
    UILabel *city;
    UILabel *count;
    UIView *cell;
    
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        cell= allocAndInitWithFrame(UIView, frame(0, 0, cellWidth , cellHeight));
        cell.backgroundColor = AppViewBGColor;
        [self addSubview:cell];
        city = [UILabel createLabelWithFrame:frame(20, 0, cellWidth/2.0, cellHeight) text:@"" fontSize:28*SpacedFonts textColor:[UIColor colorWithRed:0.3922 green:0.4 blue:0.4039 alpha:1.0] textAlignment:NSTextAlignmentLeft inView:cell];
        
        count = [UILabel createLabelWithFrame:frame(cellWidth/2.0 + 40 , 0, cellWidth/2.0 - 60, cellHeight) text:@"0人" fontSize:28*SpacedFonts textColor:[UIColor colorWithRed:0.3765 green:0.3765 blue:0.3804 alpha:1.0] textAlignment:NSTextAlignmentRight inView:cell];
        
       
        
    }
    return self;
    
}
- (void)setData:(ReaderMoreData *)modal isClear:(BOOL)isClear
{
    if (isClear) {
         cell.backgroundColor = AppViewBGColor;
    }
    else
    {
       cell.backgroundColor = WhiteColor;
    }
    city.text =modal.city;
    count.text = [NSString stringWithFormat:@"%i人",modal.count];
}
@end
