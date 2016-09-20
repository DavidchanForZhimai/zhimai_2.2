//
//  SelecteCarTypeViewController.m
//  Lebao
//
//  Created by David on 16/4/14.
//  Copyright © 2016年 David. All rights reserved.
//

#import "SelecteCarTypeViewController.h"
#import "SelectedCarDetailView.h"
#import "XLDataService.h"
#import "CoreArchive.h"
//发布二手房源的接口
#define CarbrandUrl  [NSString stringWithFormat:@"%@common/carbrand",HttpURL]
@interface SelecteCarTypeViewController ()

@end

@implementation SelecteCarTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navViewTitleAndBackBtn:@""];
    [self addSelectedView];

}
- (void)addSelectedView{

    _selectedKeyArray = allocAndInit(NSMutableArray);
    _selectedArray = allocAndInit(NSMutableArray);
    _selectedTable = [[UITableView alloc]initWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH - 40, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)) style:UITableViewStylePlain];
    _selectedTable.delegate = self;
    _selectedTable.dataSource =self;
    _selectedTable.backgroundColor =[UIColor clearColor];
    
    [self.view addSubview:_selectedTable];


    NSMutableArray *defaultArrayValue = [NSMutableArray arrayWithObjects:@"大众",@"丰田",@"本田",@"现代",@"别克",@"奥迪",@"福特",@"日产",@"哈弗",@"起亚", nil];
    NSMutableArray *defaultArraykey = [NSMutableArray arrayWithObjects:@"25",@"36",@"5",@"125",@"6",@"1",@"35",@"108",@"50",@"104", nil];
    NSMutableArray *defaultArray = allocAndInit(NSMutableArray);
    for (int i =0;i<defaultArrayValue.count;i++) {
        [defaultArray addObject: [NSDictionary dictionaryWithObjectsAndKeys:defaultArrayValue[i],@"brand",defaultArraykey[i],@"keyid",nil]];
    }
   
        [_selectedArray addObject:defaultArray];
 
        [_selectedKeyArray addObject:@"#"];
    if (![CoreArchive strForKey:KCarOldVersion]||![[CoreArchive strForKey:KCarOldVersion] isEqualToString:[CoreArchive strForKey:KCarNewVersion ]]) {
        [[ToolManager shareInstance] showWithStatus];
        [XLDataService postWithUrl:CarbrandUrl param:[Parameter parameterWithSessicon] modelClass:nil responseBlock:^(id dataObj, NSError *error) {
//            NSLog(@"%@",dataObj);
            if (dataObj) {
                if ([dataObj[@"rtcode"] integerValue]==1) {
                    [[ToolManager shareInstance] dismiss];
                    
                   [CoreArchive setobject:dataObj[@"datas"] key:[CoreArchive strForKey:KCarNewVersion ]];
                    [CoreArchive setStr:[CoreArchive strForKey:KCarNewVersion ] key:KCarOldVersion ];
                    for (NSDictionary *dic in dataObj[@"datas"]) {
                        [_selectedKeyArray addObject:dic[@"key"]];
                        [_selectedArray addObject:dic[@"datas"]];
                        
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
    else
    {
       
        NSMutableArray *array=(NSMutableArray *)[CoreArchive objectForKey:[CoreArchive strForKey:KCarNewVersion ]];
        for (NSDictionary *dic in array) {
            [_selectedKeyArray addObject:dic[@"key"]];
            [_selectedArray addObject:dic[@"datas"]];
        }
         [_selectedTable reloadData];
    }

    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *array =_selectedArray[section];
    return array.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _selectedArray.count;
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
    static NSString *cellID = @"SelecteCarTypeView";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = _selectedArray[indexPath.section][indexPath.row][@"brand"];
    cell.textLabel.textColor = BlackTitleColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SelectedCarDetailView *carDetail = allocAndInitWithFrame(SelectedCarDetailView, frame(APPWIDTH -40, 0, APPWIDTH - 40, APPHEIGHT ) seriesID:_selectedArray[indexPath.section][indexPath.row][@"keyid"]);
    
    carDetail.title = _selectedArray[indexPath.section][indexPath.row][@"brand"];
    carDetail.resultBlock = ^(NSString *str,NSString *seriesid,NSString *model_id)
    {
        if (_resultBlock) {
            _resultBlock([NSString stringWithFormat:@"%@ %@",_selectedArray[indexPath.section][indexPath.row][@"brand"],str],_selectedArray[indexPath.section][indexPath.row][@"keyid"],seriesid,model_id);
        }
    };

    [self.view addSubview:carDetail];
    [UIView animateWithDuration:0.5 animations:^{
        carDetail.frame =frame(0, 0, APPWIDTH - 40, APPHEIGHT);
    }];
//    PushView(self, carDetail);
}


- (NSString *)tableView:(UITableView *)tableView
    titleForHeaderInSection:(NSInteger)section {
    
    NSString *key = [_selectedKeyArray objectAtIndex:section];
    if (section ==0) {
        
      key =@"热门品牌";
    }
    return key;
}

//索引分区只是要添加这一个代理方法即可实现
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _selectedKeyArray;
}
#pragma mark
-(void)buttonAction:(UIButton *)sender
{
    if (sender.tag ==NavViewButtonActionNavLeftBtnTag) {
        
        if (_dimissBlock) {
            _dimissBlock();
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
