//
//  SelectedPruductViewController.m
//  Lebao
//
//  Created by David on 16/6/23.
//  Copyright © 2016年 David. All rights reserved.
//

#import "SelectedPruductViewController.h"
#import "ToolManager.h"
@interface SelectedPruductViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *selectedPruductView;
@property(nonatomic,strong)NSIndexPath *lastPath;
@end

@implementation SelectedPruductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   [self navViewTitleAndBackBtn:@"选择附带产品"];
   
    BaseButton *sure = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 50, StatusBarHeight, 50, NavigationBarHeight - 1) setTitle:@"确定" titleSize:28*SpacedFonts titleColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft backgroundColor:WhiteColor inView:self.view];
    sure.didClickBtnBlock = ^{
        if (_selectedPruductSureBlock) {
            _selectedPruductSureBlock(_selectedPruductArray[_lastPath.row]);
            PopView(self);
        }
        
        
    };

    _selectedPruductView = [[UITableView alloc]initWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)) style:UITableViewStylePlain];
    _selectedPruductView.delegate = self;
    _selectedPruductView.dataSource =self;
    [self.view addSubview:_selectedPruductView];
    
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return  _selectedPruductArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"SelectedPruductCell";
    SelectedPruductCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[SelectedPruductCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//        cell.selectionStyle =
    }
    NSDictionary *dic =_selectedPruductArray[indexPath.row];
   
    [[ToolManager shareInstance] imageView:cell.cellImage setImageWithURL:dic[@"imgurl"] placeholderType:PlaceholderTypeImageUnProcessing];
    cell.cellTitle.text=dic[@"title"];
    
    NSInteger row = [indexPath row];
    
    NSInteger oldRow = [_lastPath row];
    
    if (row == oldRow && _lastPath!=nil) {
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
    }else{
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }

    return cell;

}

//第二步：在didSelectRowAtIndexPath:中实现如下代码

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    int newRow = (int)[indexPath row];
    
    int oldRow = (_lastPath !=nil)?(int)[_lastPath row]:-1;
    
    if (newRow != oldRow) {
        
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:_lastPath];
        
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        
        _lastPath = indexPath;
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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

@implementation SelectedPruductCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self==[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _cellImage = allocAndInitWithFrame(UIImageView, frame(10, 5, 80, 50));
        [self addSubview:_cellImage];
        
        _cellTitle = allocAndInitWithFrame(UILabel, frame(CGRectGetMaxX(_cellImage.frame) + 5, frameY(_cellImage), APPWIDTH -(CGRectGetMaxX(_cellImage.frame) + 30) , 50));
        _cellTitle.numberOfLines = 0;
        _cellTitle.font = Size(28);
        _cellTitle.textColor = BlackTitleColor;
        [self addSubview:_cellTitle];
    }
    
    return self;
    
}

@end
