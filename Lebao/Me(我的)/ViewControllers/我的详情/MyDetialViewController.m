//
//  MyDetialViewController.m
//  Lebao
//
//  Created by David on 16/9/14.
//  Copyright © 2016年 David. All rights reserved.
//

#import "MyDetialViewController.h"
#import "DWTagsView.h"
#import "LWLayout.h"
#import "LWTextParser.h"
#import "Gallop.h"
#import "Parameter.h"
#import "BasicInformationViewController.h"
#import "OtherDynamicdViewController.h"
#define TagHeight 22
#define MininumTagWidth (APPWIDTH - 120)/5.0
#define MaxinumTagWidth (APPWIDTH - 20)

@interface HeaderModel : NSObject
@property(nonatomic,strong)NSString *authen;
@property(nonatomic,strong)NSString *imgurl;
@property(nonatomic,strong)NSString *industry;
@property(nonatomic,strong)NSString *realname;
@property(nonatomic,strong)NSString *workyears;
@property(nonatomic,strong)NSString *userid;
@property(nonatomic,strong)NSString *company;
@end
@implementation HeaderModel

@end

@interface HeaderViewLayout : LWLayout
@property(nonatomic,assign)float height;
- (HeaderViewLayout *)initCellLayoutWithModel:(HeaderModel *)model;
@end


@implementation HeaderViewLayout

- (HeaderViewLayout *)initCellLayoutWithModel:(HeaderModel *)model;
{
    self = [super init];
    if (self) {
        //用户头像
        LWImageStorage *_avatarStorage = [[LWImageStorage alloc]initWithIdentifier:@"avatar"];
        _avatarStorage.frame = CGRectMake((APPWIDTH - 44)/2.0, 13, 44, 44);
        model.imgurl = [[ToolManager shareInstance] urlAppend:model.imgurl];
        //        NSLog(@"model.imgurl  =%@",model.imgurl );
        _avatarStorage.contents = model.imgurl;
        _avatarStorage.placeholder = [UIImage imageNamed:@"defaulthead"];
        if ([model.imgurl isEqualToString:ImageURLS]) {
            
            _avatarStorage.contents = [UIImage imageNamed:@"defaulthead"];
            
        }
        _avatarStorage.cornerRadius = _avatarStorage.width/2.0;
        //用户名
        //名字模型 nameTextStorage
        LWTextStorage* nameTextStorage = [[LWTextStorage alloc] init];
        nameTextStorage.text = model.realname;
        nameTextStorage.font = Size(28.0);
        nameTextStorage.textColor = BlackTitleColor;
        nameTextStorage.frame = CGRectMake(0, _avatarStorage.bottom + 8, SCREEN_WIDTH , CGFLOAT_MAX);
        nameTextStorage.textAlignment = NSTextAlignmentCenter;
         //行业
        LWTextStorage* industryTextStorage = [[LWTextStorage alloc] init];
        if (model.company&&model.company.length>0) {
            industryTextStorage.text =[NSString stringWithFormat:@"%@\n",model.company];
        }
        if (model.industry&&model.industry.length>0) {
            industryTextStorage.text =[NSString stringWithFormat:@"%@%@  ",industryTextStorage.text,[Parameter industryForChinese:model.industry]];
        }
        if (model.workyears&&model.workyears.length>0) {
            industryTextStorage.text=[NSString stringWithFormat:@"%@从业%@年\n",industryTextStorage.text,model.workyears];
        }
        industryTextStorage.text =[NSString stringWithFormat:@"%@ [iconprofilerenzhen] [iconprofilevip] ",industryTextStorage.text];
        
        industryTextStorage.textColor = [UIColor colorWithRed:0.549 green:0.5569 blue:0.5608 alpha:1.0];
        industryTextStorage.font = Size(24.0);
        industryTextStorage.frame = CGRectMake(nameTextStorage.left, nameTextStorage.bottom + 8, nameTextStorage.width, CGFLOAT_MAX);
        
//        NSString *range = @"";
//        if (model.industry&&model.industry.length>0) {
//            range =[Parameter industryForChinese:model.industry];
//        }
//        if (model.workyears&&model.workyears.length>0) {
//            range=[NSString stringWithFormat:@"%@从业%@年\n",range,model.workyears];
//        }
//        
//        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:industryTextStorage.text];
//        
//        [str addAttribute:NSFontAttributeName value:Size(20.0) range:[industryTextStorage.text rangeOfString:range]];
//        industryTextStorage.attributedText = str;
        industryTextStorage.textAlignment = NSTextAlignmentCenter;
        
        
        [LWTextParser parseEmojiWithTextStorage:industryTextStorage];
        
        [self addStorage:_avatarStorage];
        [self addStorage:nameTextStorage];
        [self addStorage:industryTextStorage];
         self.height  = [self suggestHeightWithBottomMargin:50.0];
    }
    return self;
}
@end

@interface MyDetialViewController ()<UITableViewDelegate,UITableViewDataSource,DWTagsViewDelegate>

@property(nonatomic,strong)UITableView *myDetailTV;
@property(nonatomic,strong)LWAsyncDisplayView *userView;
@property(nonatomic,strong)HeaderViewLayout *headerViewLayout;
@property(nonatomic,strong)BaseButton *edit;
@property(nonatomic,strong)UIView *viewHeader;
@property(nonatomic,strong)UIView *viewFooter;

@property(nonatomic,strong)DWTagsView *productTagsView;//产品标签
@property(nonatomic,strong)DWTagsView *resourseTagsView;//资源标签
@property(nonatomic,copy)NSMutableArray *productsTags;//产品标签array
@property(nonatomic,copy)NSMutableArray *resourseaTags;//资源标签array
@property(nonatomic,strong)DWTagsView *personsTagsView;//个人标签
@property(nonatomic,copy)NSMutableArray *personsTags;//个人标签array
@property(nonatomic,strong)UILabel *productTagsLb;//产品标签
@property(nonatomic,strong)UILabel *resourseTagsLb;//资源标签
@property(nonatomic,strong)UILabel *personsTagsLb;//个人标签
@property(nonatomic,strong)UIView *line1;//间隔
@end

@implementation MyDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     [self navViewTitleAndBackBtn:@"我的详情"];
    [self.view addSubview:self.edit];
    [self.view addSubview:self.myDetailTV];
    
    HeaderModel *headerModel = [[HeaderModel alloc]init];
    headerModel.imgurl = @"";
    headerModel.realname = @"陈大伟";
    headerModel.industry = @"car";
    headerModel.workyears = @"18";
    headerModel.company = @"厦门知脉科技有限公司";
    self.headerViewLayout = [[HeaderViewLayout alloc]initCellLayoutWithModel:headerModel];

    _myDetailTV.tableHeaderView = self.viewHeader;
    _myDetailTV.tableFooterView = self.viewFooter;
}

#pragma mark
#pragma mark UiTableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc]init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
     return [[UIView alloc]init];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *cellID = @"myDatial";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
        [UILabel createLabelWithFrame:frame(20, 0, 100, 40) text:@"我的动态" fontSize:14 textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:cell];
        
        [UILabel createLabelWithFrame:frame(APPWIDTH - 100, 0, 70, 40) text:@"10" fontSize:12 textColor:LightBlackTitleColor textAlignment:NSTextAlignmentRight inView:cell];
        
       cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OtherDynamicdViewController *otherDynamicdVC =[[OtherDynamicdViewController alloc]init];
    otherDynamicdVC.dynamicdName = @"我的动态";
    otherDynamicdVC.dynamicdID   = _userID;
    [self.navigationController pushViewController:otherDynamicdVC animated:YES];
}

#pragma mark getter
- (BaseButton *)edit
{
    if (_edit) {
        return _edit;
    }
    _edit = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 50 ,StatusBarHeight,50, NavigationBarHeight) setTitle:@"编辑" titleSize:28*SpacedFonts titleColor:BlackTitleColor textAlignment:NSTextAlignmentRight backgroundColor:[UIColor clearColor] inView:nil];
    _edit.shouldAnmial = NO;
    __weak typeof(self) weakSelf = self;
    _edit.didClickBtnBlock = ^
    {
        BasicInformationViewController *basicInfoVc = [[BasicInformationViewController alloc]init];
        [weakSelf.navigationController pushViewController:basicInfoVc animated:YES];
    };
    return _edit;
}

- (UITableView *)myDetailTV
{
    if (_myDetailTV) {
        return _myDetailTV;
    }
    _myDetailTV = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)) style:UITableViewStyleGrouped];
    _myDetailTV.delegate = self;
    _myDetailTV.dataSource = self;
    _myDetailTV.separatorColor = [UIColor clearColor];
    
    return _myDetailTV;
    
}
- (UIView *)viewHeader
{
    if (_viewHeader) {
        return _viewHeader;
    }
    _viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPWIDTH, self.headerViewLayout.height)];
    _viewHeader.backgroundColor = WhiteColor;
    [_viewHeader addSubview:self.userView];

    //人脉
    BaseButton *renmai = [self addViewWithFrame:frame(0, self.userView.y + self.userView.height + 10, APPWIDTH/3, 40) andTitle:@"人脉" rangeText:@"10" andView:_viewHeader];
    renmai.didClickBtnBlock = ^
    {
        NSLog(@"人脉");
        
    };
    //约见成功
    BaseButton *yuejian = [self addViewWithFrame:frame(CGRectGetMaxX(renmai.frame),renmai.y,renmai.width, renmai.height) andTitle:@"约见成功" rangeText:@"18" andView:_viewHeader];
    yuejian.didClickBtnBlock = ^
    {
        NSLog(@"约见成功");
        
    };
    
    //想约
    BaseButton *xiangyue = [self addViewWithFrame:frame(CGRectGetMaxX(yuejian.frame),yuejian.y,yuejian.width, yuejian.height) andTitle:@"想约" rangeText:@"18" andView:_viewHeader];
    xiangyue.didClickBtnBlock = ^
    {
        NSLog(@"想约");
        
    };
    
    [self addLine:frame(0, self.userView.y + self.userView.height + 10, APPWIDTH, 0.5) andView:_viewHeader];
    
    [self addLine:frame(APPWIDTH/3.0 - 0.5, self.userView.height + self.userView.y + 15, 0.5, 30) andView:_viewHeader];
    
    [self addLine:frame(2*APPWIDTH/3.0 - 0.5, self.userView.height + self.userView.y + 15, 0.5, 30) andView:_viewHeader];
    
    return _viewHeader;
}

- (LWAsyncDisplayView *)userView
{
    if (_userView) {
        return  _userView;
    }
    
    _userView = [[LWAsyncDisplayView alloc]initWithFrame:frame(0, 0, APPWIDTH, self.headerViewLayout.height - 50)];
//    _userView.delegate = self;
    return _userView;
    
}
- (void)setHeaderViewLayout:(HeaderViewLayout *)headerViewLayout
{
    if (_headerViewLayout == headerViewLayout) {
        return;
    }
     _headerViewLayout = headerViewLayout;
    self.userView.layout = headerViewLayout;
   
}

#pragma mark
#pragma mark getter tagsView

- (UIView *)viewFooter
{
    if (_viewFooter) {
        return _viewFooter;
    }
    
    _viewFooter = [[UIView alloc]initWithFrame:CGRectZero];
    _viewFooter.backgroundColor = WhiteColor;

    //产品标签
    [self.viewFooter addSubview:self.productTagsLb];
    
    [self.viewFooter addSubview:self.productTagsView];
    
    // 资源特点
    [self.viewFooter addSubview:self.resourseTagsLb];;
    [self.viewFooter addSubview:self.resourseTagsView];
    
    // 个人特点
    [self.viewFooter addSubview:self.line1];
    
    [self.viewFooter addSubview:self.personsTagsLb];
    [self.viewFooter addSubview:self.personsTagsView];
    //设置位置
    [self tagsViewReSetFrame];
    return _viewFooter;
}
- (UILabel *)productTagsLb
{
    if (_productTagsLb) {
        return  _productTagsLb;
    }
    _productTagsLb =[UILabel createLabelWithFrame:CGRectMake(20, 10, APPWIDTH - 40, 35) text:@"产品标签" fontSize:14 textColor:AppMainColor textAlignment:NSTextAlignmentLeft inView:nil];
    
    return  _productTagsLb;
    
}
- (DWTagsView *)productTagsView
{
    if (_productTagsView) {
        return _productTagsView;
    }
    _productTagsView = allocAndInitWithFrame(DWTagsView, CGRectZero);
    _productTagsView.contentInsets = UIEdgeInsetsZero;
    _productTagsView.tagInsets = UIEdgeInsetsMake(5, 15, 5, 15);
    _productTagsView.tagcornerRadius = 2;
    _productTagsView.mininumTagWidth = MininumTagWidth;
    _productTagsView.maximumTagWidth = MaxinumTagWidth;
    _productTagsView.tagHeight  = TagHeight;
    _productTagsView.tag = 88;
    _productTagsView.tagBackgroundColor = AppMainColor;
    _productTagsView.lineSpacing = 10;
    _productTagsView.interitemSpacing = 20;
    _productTagsView.tagFont = [UIFont systemFontOfSize:14];
    _productTagsView.tagTextColor = WhiteColor;
    _productTagsView.tagSelectedBackgroundColor = _productTagsView.tagBackgroundColor;
    _productTagsView.tagSelectedTextColor = _productTagsView.tagTextColor;
    
    _productTagsView.delegate = self;
    _productTagsView.tagsArray = self.productsTags;
    
    return _productTagsView;
    
}
- (UILabel *)resourseTagsLb
{
    if (_resourseTagsLb) {
        return  _resourseTagsLb;
    }
    _resourseTagsLb =[UILabel createLabelWithFrame:CGRectZero text:@"资源特点" fontSize:14 textColor:[UIColor colorWithRed:0.9843 green:0.5137 blue:0.3412 alpha:1.0] textAlignment:NSTextAlignmentLeft inView:nil];
    
    return  _resourseTagsLb;
    
}

- (DWTagsView *)resourseTagsView
{
    if (_resourseTagsView) {
        return _resourseTagsView;
    }
    _resourseTagsView = allocAndInitWithFrame(DWTagsView, CGRectZero);
    _resourseTagsView.contentInsets = UIEdgeInsetsZero;
    _resourseTagsView.tagInsets = UIEdgeInsetsMake(5, 15, 5, 15);
    _resourseTagsView.tagcornerRadius = 2;
    _resourseTagsView.tag = 888;
    _resourseTagsView.mininumTagWidth = MininumTagWidth;
    _resourseTagsView.maximumTagWidth = MaxinumTagWidth;
    _resourseTagsView.tagHeight  = TagHeight;
    
    _resourseTagsView.tagBackgroundColor = [UIColor colorWithRed:0.9843 green:0.451 blue:0.2549 alpha:1.0];
    _resourseTagsView.lineSpacing = 10;
    _resourseTagsView.interitemSpacing = 20;
    _resourseTagsView.tagFont = [UIFont systemFontOfSize:14];
    _resourseTagsView.tagTextColor = WhiteColor;
    _resourseTagsView.tagSelectedBackgroundColor = _resourseTagsView.tagBackgroundColor;
    _resourseTagsView.tagSelectedTextColor = _resourseTagsView.tagTextColor;
    
    _resourseTagsView.delegate = self;
    _resourseTagsView.tagsArray = self.resourseaTags;
    
    return _resourseTagsView;
    
}
- (UIView *)line1
{
    if (_line1) {
        return _line1;
    }
    _line1 = [[UIView alloc]initWithFrame:CGRectZero];
    _line1.backgroundColor = self.view.backgroundColor;
    return _line1;
}
- (UILabel *)personsTagsLb
{
    if (_personsTagsLb) {
        return  _personsTagsLb;
    }
    _personsTagsLb =[UILabel createLabelWithFrame:CGRectZero text:@"人脉标签" fontSize:14 textColor:AppMainColor textAlignment:NSTextAlignmentLeft inView:nil];
    
    return  _personsTagsLb;
    
}

- (DWTagsView *)personsTagsView
{
    if (_personsTagsView) {
        return _personsTagsView;
    }
    _personsTagsView = allocAndInitWithFrame(DWTagsView, CGRectZero);
    _personsTagsView.contentInsets = UIEdgeInsetsZero;
    _personsTagsView.tagInsets = UIEdgeInsetsMake(5, 15, 5, 15);
    _personsTagsView.tagcornerRadius = 2;
    _personsTagsView.tag = 8888;
    _personsTagsView.mininumTagWidth =MininumTagWidth;
    _personsTagsView.maximumTagWidth = MaxinumTagWidth;
    _personsTagsView.tagHeight  = TagHeight;
    
    _personsTagsView.tagBackgroundColor = AppMainColor;
    _personsTagsView.lineSpacing = 10;
    _personsTagsView.interitemSpacing = 20;
    _personsTagsView.tagFont = [UIFont systemFontOfSize:14];
    _personsTagsView.tagTextColor = WhiteColor;
    _personsTagsView.tagSelectedBackgroundColor = _personsTagsView.tagBackgroundColor;
    _personsTagsView.tagSelectedTextColor = _personsTagsView.tagTextColor;
    
    _personsTagsView.delegate = self;
    _personsTagsView.tagsArray = self.personsTags;
    
    return _personsTagsView;
    
}
- (NSMutableArray *)productsTags
{
    if (_productsTags) {
        return _productsTags;
    }
    _productsTags = [[NSMutableArray alloc]initWithObjects:@"商务1",@"开发",@"产品",@"经理",@"老板",@"业务", nil];
    return _productsTags;
}
- (NSMutableArray *)resourseaTags
{
    if (_resourseaTags) {
        return _resourseaTags;
    }
    _resourseaTags = [[NSMutableArray alloc]initWithObjects:@"商务2",@"开发",@"产品",@"经理",@"老板",@"业务", nil];
    return _resourseaTags;
}
- (NSMutableArray *)personsTags
{
    if (_personsTags) {
        return _personsTags;
    }
    _personsTags = [[NSMutableArray alloc]initWithObjects:@"商务3",@"开发",@"产品",@"经理",@"老板",@"业务", nil];
    return _personsTags;
}
#pragma mark
#pragma mark resetFrame
- (void)tagsViewReSetFrame
{
    
    _productTagsView.frame = CGRectMake(20, 45, APPWIDTH - 40, 2*(TagHeight+10));
    _resourseTagsLb.frame = CGRectMake(20, CGRectGetMaxY(_productTagsView.frame), APPWIDTH, 35);
    _resourseTagsView.frame = CGRectMake(20, CGRectGetMaxY(_resourseTagsLb.frame), APPWIDTH - 40,2*(TagHeight+10));
    _line1.frame = CGRectMake(0, CGRectGetMaxY(_resourseTagsView.frame), APPWIDTH, 10);
    _personsTagsLb.frame = CGRectMake(20, CGRectGetMaxY(_line1.frame), APPWIDTH, 35);
    _personsTagsView.frame =CGRectMake(20, CGRectGetMaxY(_personsTagsLb.frame), APPWIDTH - 40, 2*(TagHeight+10));
    _viewFooter.frame = frame(0, 0, APPWIDTH, CGRectGetMaxY(_personsTagsView.frame) + 10);
    
    
}

#pragma mark button aticons
- (void)buttonAction:(UIButton *)sender
{
    PopView(self);
}


#pragma mark
#pragma mark 私有方法
//线条
- (void)addLine:(CGRect)frame andView:(UIView *)view
{
    UILabel *line = allocAndInitWithFrame(UILabel , frame);
    line.backgroundColor = LineBg;
    [view addSubview:line];
}
//人脉 约见成功 想约
- (BaseButton *)addViewWithFrame:(CGRect)frame andTitle:(NSString *)text rangeText:(NSString *)rangeText andView:(UIView *)view{
    NSString *str = @"";
    
    BaseButton *btn = [[BaseButton alloc]initWithFrame:frame setTitle:[NSString stringWithFormat:@"%@\n%@",rangeText?rangeText:str,text] titleSize:22*SpacedFonts titleColor:BlackTitleColor textAlignment:NSTextAlignmentCenter backgroundColor:WhiteColor inView:view];
    btn.titleLabel.numberOfLines = 0;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:btn.titleLabel.text];
    [attributedString addAttribute:NSFontAttributeName value:Size(28) range:[btn.titleLabel.text rangeOfString:rangeText?rangeText:str]];
    
    btn.titleLabel.attributedText =attributedString;
    
    return btn;
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
