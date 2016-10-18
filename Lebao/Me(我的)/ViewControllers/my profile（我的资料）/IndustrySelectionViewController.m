//
//  IndustrySelectionViewController.m
//  Lebao
//
//  Created by David on 16/10/8.
//  Copyright © 2016年 David. All rights reserved.
//

#import "IndustrySelectionViewController.h"
#import "XLDataService.h"


#define SaveIndustryURL [NSString stringWithFormat:@"%@user/save-industry",HttpURL]

@interface IndustrySelectionViewController()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableV1;
    UITableView *tableV2;
    NSMutableArray *industry_label;
    NSMutableArray *industrySon_label;
    NSMutableArray *industry;
    NSDictionary  *saveIndustry_label;
 
}
@end

@implementation IndustrySelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navViewTitleAndBackBtn:@"选择行业"];
    BaseButton *finish = [[BaseButton alloc]initWithFrame:CGRectMake(APPWIDTH - 50, StatusBarHeight, 50, NavigationBarHeight - 1) setTitle:@"完成" titleSize:28*SpacedFonts titleColor:BlackTitleColor textAlignment:NSTextAlignmentCenter backgroundColor:WhiteColor inView:self.view];
    __weak typeof(self) weakSelf = self;
    finish.didClickBtnBlock = ^
    {
        if (saveIndustry_label&&![saveIndustry_label[@"full_number"] isEqualToString:@""]) {
            if (weakSelf.editBlock) {
                
               [weakSelf netWork];
                
            }
        }
        else
        {
            [[ToolManager shareInstance] showAlertMessage:@"请选择行业！"];
        }
        
        
    };
    [self creatTableView];
    
   
    
    tableV2.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    industry_label = [NSMutableArray new];
    industry = [NSMutableArray new];
    industrySon_label = [NSMutableArray new];
    saveIndustry_label = [NSDictionary new];
    if (_dataObj) {
        [self setdata:_dataObj];
    }
}
- (void)setdata:(id)dataObj
{
 
    NSArray *industryDic= dataObj[@"industry_label"];
    for (id value in industryDic) {
        if ([value isKindOfClass:[NSDictionary class]]) {
            
            [industry_label addObject:value];
            
        }
    }
    [tableV1 reloadData];
    [tableV2 reloadData];
    if (industry_label.count>0) {
        //选中tableV1的第一行
        [self tableView:tableV1 didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [tableV1 selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
 
}
#pragma mark
#pragma mark netWork
- (void)netWork
{
    NSMutableDictionary *parame = [Parameter parameterWithSessicon];
  
    [parame setValue:saveIndustry_label[@"code"] forKey:@"industry"];
    [[ToolManager shareInstance] showWithStatus:@"保存行业..."];
   
    [XLDataService postWithUrl:SaveIndustryURL param:parame modelClass:nil responseBlock:^(id dataObj, NSError *error) {

        if (dataObj) {
            if ([dataObj[@"rtcode"] intValue] ==1) {
                [[ToolManager shareInstance] dismiss];
       
                self.editBlock(saveIndustry_label[@"name"]);
                PopView(self);
                
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
-(void)creatTableView{
    
    tableV1 = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + NavigationBarHeight, APPWIDTH/2-40, APPHEIGHT-StatusBarHeight - NavigationBarHeight) style:UITableViewStyleGrouped];
    tableV1.delegate = self;
    tableV1.dataSource = self;
    [self.view addSubview:tableV1];
    
    
    tableV2 = [[UITableView alloc]initWithFrame:CGRectMake(tableV1.width, tableV1.y , APPWIDTH - tableV1.width, tableV1.height) style:UITableViewStyleGrouped];
    tableV2.delegate = self;
    tableV2.dataSource = self;
    [self.view addSubview:tableV2];
    
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc]init];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == tableV1) {
      
       return industry_label.count;
        
    }else{
        return industrySon_label.count;
    }
    
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //表1
    if (tableView == tableV1) {
        
        static NSString *cellId = @"identify";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.backgroundColor = AppViewBGColor;
        NSDictionary *dic = industry_label[indexPath.row];
        cell.textLabel.text = dic[@"name"];
        return cell;
    }
    
    //表2
    static NSString *cellId2 = @"cell";
    UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellId2];
    
    if (!cell2) {
        
        cell2 = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId2];
    }
    cell2.selectionStyle = UITableViewCellSelectionStyleBlue;
    NSDictionary *dic = industrySon_label[indexPath.row];
    cell2.textLabel.text = dic[@"name"];
    return cell2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(tableView == tableV1){
        [industrySon_label removeAllObjects];
        saveIndustry_label  = nil;
        NSArray *array = industry_label[indexPath.row][@"son"];
        for (id value in array) {
            if ([value isKindOfClass:[NSDictionary class]]) {
                [industrySon_label addObject:value];
            }
        }
    
        [tableV2 reloadData];
    }
    else
    {
        saveIndustry_label = industrySon_label[indexPath.row];
    }
}


#pragma mark
#pragma mark - buttonAction
- (void)buttonAction:(UIButton *)sender
{
    PopView(self);
}

@end
