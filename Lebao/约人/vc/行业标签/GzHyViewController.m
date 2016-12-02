//
//  GzHyViewController.m
//  Lebao
//
//  Created by David on 16/9/12.
//  Copyright © 2016年 David. All rights reserved.
//

#import "GzHyViewController.h"
#import "AddIndustryViewController.h"
#import "XLDataService.h"
#import "NSString+Extend.h"
#define FocusIndustryURL [NSString stringWithFormat:@"%@user/focus-industry",HttpURL]
#define ViewStartX StatusBarHeight + NavigationBarHeight
@interface GzHyViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)id data;//数据
@property(nonatomic,strong)UITableView *gzhwTable;
@property(nonatomic,strong)NSMutableArray *gzhwDatas;
@property(nonatomic,strong)BaseButton* addHasLb;
@end

@implementation GzHyViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navViewTitleAndBackBtn:@"关注行业"];
    [self.view addSubview:self.addHasLb];
    [self.view addSubview:self.gzhwTable];
    [self netWork];

}

#pragma mark
#pragma mark netWork
- (void)netWork
{
    NSMutableDictionary *parame = [Parameter parameterWithSessicon];
    if (_gzhwDatas.count==0) {
         [[ToolManager shareInstance] showWithStatus];
    }
    [XLDataService postWithUrl:FocusIndustryURL param:parame modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (dataObj) {
            if ([dataObj[@"rtcode"] intValue] ==1) {
                [[ToolManager shareInstance] dismiss];
                [_gzhwDatas removeAllObjects];
                _addHasLb.hidden = NO;
                _data = dataObj;
                NSMutableArray * industrys = [NSMutableArray arrayWithArray:dataObj[@"industrys"]];
                NSLog(@"industrys =%@",dataObj[@"focus_industrys"]);
                NSArray *focus_industrys;
                if (dataObj[@"focus_industrys"]&&[dataObj[@"focus_industrys"] isKindOfClass:[NSString class]]&&![dataObj[@"focus_industrys"] isEqualToString:@""]) {
                    focus_industrys = [dataObj[@"focus_industrys"] componentsSeparatedByString:@"/"];
                }
               
                NSMutableDictionary *leibie = [NSMutableDictionary new];//行业类别
                for (NSString *leibieStr in focus_industrys) {
                    NSArray *jQleibie = [leibieStr componentsSeparatedByString:@"_"];//截取行业类别
                    if (jQleibie.count>1&&![jQleibie[0] isEqualToString:@""]) {
                        //判断是否存在同样的类别，否则就添加
                        
                        if (![leibie.allKeys containsObject:jQleibie[0]]) {
                            if ([Parameter zhuanghuanHangye:jQleibie[0] formdata:industrys].length>0) {
                                NSMutableDictionary *dic = [NSMutableDictionary new];
                                [dic setObject:[Parameter zhuanghuanHangye:jQleibie[0] formdata:industrys] forKey:@"title"];
                                NSMutableArray *content = [NSMutableArray new];
                                if (![content containsObject:[Parameter zhuanghuanHangye:leibieStr formdata:industrys]]) {
                                    [content addObject:[Parameter zhuanghuanHangye:leibieStr formdata:industrys]];
                                }
                                [dic setObject:content forKey:@"content"];
                                [leibie setObject:dic forKey:jQleibie[0]];
                            }
                            
                        }
                        else
                        {
                            NSMutableDictionary *dic =leibie[jQleibie[0]];
                            NSMutableArray *content = dic[@"content"];
                            if (![content containsObject:[Parameter zhuanghuanHangye:leibieStr formdata:industrys]]) {
                                [content addObject:[Parameter zhuanghuanHangye:leibieStr formdata:industrys]];
                            }
                            [dic setObject:content forKey:@"content"];
                            [leibie setObject:dic forKey:jQleibie[0]];
                        }
                    }
                
                }
                //根据行业类别添加行业
                [_gzhwDatas addObjectsFromArray:leibie.allValues];
                [_gzhwTable reloadData];
                
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

- (BaseButton *)addHasLb
{
    if (_addHasLb) {
        return _addHasLb;
    }
    _addHasLb = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 50 ,StatusBarHeight,50, NavigationBarHeight) setTitle:@"管理" titleSize:28*SpacedFonts titleColor:BlackTitleColor textAlignment:NSTextAlignmentRight backgroundColor:[UIColor clearColor] inView:nil];
    _addHasLb.shouldAnmial = NO;
    _addHasLb.hidden = YES;
    __weak typeof(self) weakSelf = self;
    _addHasLb.didClickBtnBlock = ^
    {
        
        AddIndustryViewController *addIndustryVC = allocAndInit(AddIndustryViewController);
        addIndustryVC.data = weakSelf.data;
        addIndustryVC.addTagsfinishBlock = ^(NSMutableArray *tags)
        {
            if (weakSelf.addTagsfinishBlock) {
                weakSelf.addTagsfinishBlock(tags);
            }
            [weakSelf netWork];
        };
        
        PushView(weakSelf, addIndustryVC);
    };
    return _addHasLb;
}
#pragma mark
#pragma mark UITableView

- (UITableView *)gzhwTable
{
    if (!_gzhwTable) {
        _gzhwTable = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)) style:UITableViewStyleGrouped];
        _gzhwTable.backgroundColor = [UIColor clearColor];
        _gzhwTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _gzhwTable.delegate = self;
        _gzhwTable.dataSource = self;
        [self.view addSubview:_gzhwTable];
    }
    return _gzhwTable;
}
- (NSMutableArray *)gzhwDatas
{
    if (!_gzhwDatas) {
        _gzhwDatas = [[NSMutableArray alloc]init];
        
    }
    return _gzhwDatas;
}
#pragma mark
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.gzhwDatas.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *content = _gzhwDatas[indexPath.row][@"content"];
    int hang = 0;
    if (content.count%4==0) {
        hang =(int)content.count/4;
    }
    else
    {
        hang =(int)content.count/4 + 1;
    }
    return 50 + 30*hang;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc]init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSString *str =@"关注行业说明\n1.首页“可添加人脉”和“动态”的数据与个人所关注的行业有关,关注的行业越多,其显示的数据越多\n2.用户没有关注任何行业时,“可添加人脉”和“动态”里默认显示全部的行业数据";
    
    return [str sizeWithFont:[UIFont systemFontOfSize:20] maxSize:CGSizeMake(APPHEIGHT - 40, 1000)].height + 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    NSString *str =@"关注行业说明\n1.首页“可添加人脉”和“动态”的数据与个人所关注的行业有关,关注的行业越多,其显示的数据越多\n2.用户没有关注任何行业时,“可添加人脉”和“动态”里默认显示全部的行业数据";
    UILabel *messageLab=[[UILabel alloc]initWithFrame:CGRectMake(20, 0 , APPWIDTH - 40, [str sizeWithFont:[UIFont systemFontOfSize:20] maxSize:CGSizeMake(APPHEIGHT - 40, 1000)].height)];
    messageLab.font=[UIFont systemFontOfSize:13];
    messageLab.textColor=LightBlackTitleColor;
    messageLab.text=str;
    messageLab.numberOfLines = 0;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:messageLab.text];
    [attributedString addAttribute:NSForegroundColorAttributeName value:BlackTitleColor range:[messageLab.text rangeOfString:@"关注行业说明"]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:[messageLab.text rangeOfString:messageLab.text]];
    messageLab.attributedText =attributedString;
    
    UIView *footer= [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPWIDTH, [str sizeWithFont:[UIFont systemFontOfSize:20] maxSize:CGSizeMake(APPHEIGHT - 40, 1000)].height + 10)];
    footer.backgroundColor = [UIColor clearColor];
    [footer addSubview:messageLab];
    return footer;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"GzHyCell";
    GzHyCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        
        cell =[[GzHyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSArray *contents = _gzhwDatas[indexPath.row][@"content"];
    int hang = 0;
    if (contents.count%4==0) {
        hang =(int)contents.count/4;
    }
    else
    {
        hang =(int)contents.count/4 + 1;
    }
    
    cell.content.tagsArray =contents;
    cell.content.frame = CGRectMake(10, 30, APPWIDTH - 20, hang*30);
    cell.view.frame =CGRectMake(0,CGRectGetMaxY(cell.content.frame) + 10,APPWIDTH,10);
    cell.title.frame = CGRectMake(20, 0, APPWIDTH, 30);
    cell.title.text = _gzhwDatas[indexPath.row][@"title"];
    return cell;
}

#pragma mark
#pragma mark buttons Aticon
- (void)buttonAction:(UIButton *)sender
{
   
    PopView(self);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

@implementation GzHyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = WhiteColor;
        _view = [[UIView alloc]initWithFrame:CGRectZero];
        _view.backgroundColor = AppViewBGColor;
        _content = allocAndInitWithFrame(DWTagsView, CGRectZero);
        _content.contentInsets = UIEdgeInsetsZero;
        _content.tagInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _content.mininumTagWidth = (APPWIDTH - 35)/4.0;
        _content.maximumTagWidth = (APPWIDTH - 35)/4.0;
        _content.tagHeight  = 25;
        _content.tagBackgroundColor = [UIColor whiteColor];
        _content.lineSpacing = 5;
        _content.interitemSpacing = 5;
        _content.tagFont = [UIFont systemFontOfSize:14];
        _content.tagTextColor = BlackTitleColor;
        _content.allowsSelection = NO;
        _title=[UILabel new];
        _title.font=[UIFont systemFontOfSize:15];
        _title.textColor=AppMainColor;
        _title.frame=CGRectZero;
        [self addSubview:_content];
        [self addSubview:_view];
        [self addSubview:_title];
    }
    
    return self;
}
@end
