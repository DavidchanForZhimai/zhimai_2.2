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
#import "AddConnectionView.h"
#import "MeetPaydingVC.h"
#import "XLDataService.h"
#import "MeetingModel.h"
#import "GJGCChatFriendViewController.h"
#import "LWImageBrowser.h"
#import "EvaluateVC.h"
#import "VIPPrivilegeVC.h"
#import "AuthenticationHomeViewController.h"
#import "NSString+Extend.h"
#import "RecommendView.h"//推荐人脉
#import "MyConnectionsVC.h"
#import "MeetSucceedVC.h"
#import "MyVisitorVC.h"
#define TagHeight 22
#define MininumTagWidth (APPWIDTH - 120)/5.0
#define MaxinumTagWidth (APPWIDTH - 20)

@interface HeaderModel : NSObject
@property(nonatomic,assign)int sex;
@property(nonatomic,strong)NSString *authen;
@property(nonatomic,strong)NSString *connection_count;
@property(nonatomic,strong)NSString *dynamic_count;
@property(nonatomic,strong)NSString *near_count;
@property(nonatomic,strong)NSString *visitorscount;
@property(nonatomic,strong)NSString *realname;
@property(nonatomic,strong)NSString *Id;
@property(nonatomic,strong)NSString *imgurl;
@property(nonatomic,strong)NSMutableArray *impression;


@property(nonatomic,strong)NSString *labels;
@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSString *position;
@property(nonatomic,strong)NSString *resource;
@property(nonatomic,strong)NSString *service;
@property(nonatomic,strong)NSString *success_count;
@property(nonatomic,strong)NSString *synopsis;
@property(nonatomic,strong)NSString *vip;
@property(nonatomic,strong)NSString *want_count;
@property(nonatomic,assign)int  workyears;
@property(nonatomic,copy) NSString  *area;
@property(assign)BOOL isme;
@end
@implementation HeaderModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id" : @"id",
             };
}
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
//        LWImageStorage *_avatarStorage = [[LWImageStorage alloc]initWithIdentifier:@"avatar"];
//        _avatarStorage.frame = CGRectMake((APPWIDTH - 44)/2.0, 13, 44, 44);
//        model.imgurl = [[ToolManager shareInstance] urlAppend:model.imgurl];
//        //        NSLog(@"model.imgurl  =%@",model.imgurl );
//        _avatarStorage.contents = model.imgurl;
//        _avatarStorage.placeholder = [UIImage imageNamed:@"defaulthead"];
//        if ([model.imgurl isEqualToString:ImageURLS]) {
//            
//            _avatarStorage.contents = [UIImage imageNamed:@"defaulthead"];
//            
//        }
//        _avatarStorage.cornerRadius = _avatarStorage.width/2.0;
        //用户名
        //名字模型 nameTextStorage
        LWTextStorage* nameTextStorage = [[LWTextStorage alloc] init];
        nameTextStorage.text = model.realname;
        nameTextStorage.font = Size(28.0);
        nameTextStorage.textColor = BlackTitleColor;
        nameTextStorage.frame = CGRectMake(0, 65, SCREEN_WIDTH , CGFLOAT_MAX);
        nameTextStorage.textAlignment = NSTextAlignmentCenter;
        //城市
        LWTextStorage* city = [[LWTextStorage alloc] init];
        NSArray *array = [model.area componentsSeparatedByString:@"-"];
        NSString *area = model.area;
        if (array.count>1) {
            area =array[1];
            
        }
        if (area.length>6) {
            area = [area substringWithRange:NSMakeRange(0, 6)];
        }
        city.text = [NSString stringWithFormat:@"[icondinwei]  %@",area];
        city.font = Size(24.0);

        city.textColor = LightBlackTitleColor;
        city.frame = CGRectMake( APPWIDTH - ([area sizeWithFont: city.font maxSize:CGSizeMake(100, CGFLOAT_MAX)].width + 30),15,[city.text sizeWithFont: city.font maxSize:CGSizeMake(100, CGFLOAT_MAX)].width + 20, CGFLOAT_MAX);
        [LWTextParser parseEmojiWithTextStorage:city];
        
        //行业
        LWTextStorage* industryTextStorage = [[LWTextStorage alloc] init];
        if (model.address.length>0) {
            industryTextStorage.text =[NSString stringWithFormat:@"%@\n",model.address];
        }else
        {
            industryTextStorage.text=@"";
        }
        if (model.position.length>0) {
            industryTextStorage.text =[NSString stringWithFormat:@"%@%@  ",industryTextStorage.text,model.position];
        }
        NSString *years =@"";
        if (model.workyears>0) {
            years =[NSString stringWithFormat:@"从业%i年",model.workyears];
        }
        if (model.workyears>0) {
            industryTextStorage.text=[NSString stringWithFormat:@"%@%@\n",industryTextStorage.text,years];
        }
        NSString *authen=@"";
        if ([model.authen isEqualToString:@"3"]) {
            authen = @"[iconprofilerenzhen]";
        }
        
        NSString *vip=@"";
        if ([model.vip isEqualToString:@"1"]) {
            vip = @"[iconprofilevip]";
        }
        
        industryTextStorage.text =[NSString stringWithFormat:@"%@ %@ %@ ",industryTextStorage.text,authen,vip];
        
        industryTextStorage.textColor = [UIColor colorWithRed:0.549 green:0.5569 blue:0.5608 alpha:1.0];
        industryTextStorage.font = Size(24.0);
        industryTextStorage.frame = CGRectMake(nameTextStorage.left, nameTextStorage.bottom + 8, nameTextStorage.width, CGFLOAT_MAX);
        
        industryTextStorage.textAlignment = NSTextAlignmentCenter;
        [LWTextParser parseEmojiWithTextStorage:industryTextStorage];
        
//        [self addStorage:_avatarStorage];
        [self addStorage:nameTextStorage];
        [self addStorage:industryTextStorage];
        [self addStorage:city];
        self.height  = [self suggestHeightWithBottomMargin:60.0];
    }
    return self;
}
@end

@interface MyDetialViewController ()<UITableViewDelegate,UITableViewDataSource,DWTagsViewDelegate,AddConnectionViewDelegate,UIAlertViewDelegate,RecommendViewDelegate>

@property(nonatomic,strong)UITableView *myDetailTV;
@property(nonatomic,strong)LWAsyncDisplayView *userView;
@property(nonatomic,strong)UIImageView *userIcon;
@property(nonatomic,strong)HeaderViewLayout *headerViewLayout;
@property(nonatomic,strong)BaseButton *edit;
@property(nonatomic,strong)UIView *viewHeader;
@property(nonatomic,strong)UIView *viewFooter;

@property(nonatomic,strong)UIScrollView *recommendScrV;//推荐访客
@property(nonatomic,strong)DWTagsView *productTagsView;//产品标签
@property(nonatomic,strong)DWTagsView *resourseTagsView;//资源标签
@property(nonatomic,copy)NSMutableArray *productsTags;//产品标签array
@property(nonatomic,copy)NSMutableArray *resourseaTags;//资源标签array
@property(nonatomic,strong)DWTagsView *personsTagsView;//个人标签
@property(nonatomic,copy)NSMutableArray *personsTags;//个人标签array
@property(nonatomic,strong)UILabel *recommendLb;//推荐访客
@property(nonatomic,strong)UILabel *productTagsLb;//产品标签
@property(nonatomic,strong)UILabel *resourseTagsLb;//资源标签
@property(nonatomic,strong)UILabel *personsTagsLb;//个人标签
@property(nonatomic,strong)UIView *line1;//间隔
@property(nonatomic,strong)UIView *line2;//间隔
@property(nonatomic,strong)DWTagsView *impressionTagsView;//好友印象
@property(nonatomic,strong)UILabel *impressionTagsLb;//个人标签
@property(nonatomic,copy)NSMutableArray *impressionTags;

@property(nonatomic,strong)BaseButton *lookMore;
@property(nonatomic,assign)BOOL islookMore;

@property(nonatomic,strong)HeaderModel *model;
@property(nonatomic,strong)NSMutableArray *visitorsArr;


@end

@implementation MyDetialViewController
{
    HeaderModel *headerModel;
    UIButton *addConnectionsBtn;
    AddConnectionView *connectionView;
    UITapGestureRecognizer *recognizerTap;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reflashBtn:) name:@"KReflashCanMeet"  object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navViewTitleAndBackBtn:@"个人详情"];
    [self.view addSubview:self.myDetailTV];
    [self netWork];
    
   
}

-(void)reflashBtn:(NSNotification *)notification
{
    if ([notification.object[@"relation"]isEqualToString:@"1"]) {
        [self addBottomViewWithBtnStr:1 andReward:[notification.object[@"reward"] floatValue]];
    }
}
#pragma mark
#pragma mark UiTableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
        
        UILabel *dt =  [UILabel createLabelWithFrame:frame(20, 0, 100, 40) text:@"他的动态" fontSize:14 textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:cell];
        dt.tag = 88;
        UILabel *label =  [UILabel createLabelWithFrame:frame(APPWIDTH - 100, 0, 70, 40) text:headerModel.dynamic_count fontSize:12 textColor:LightBlackTitleColor textAlignment:NSTextAlignmentRight inView:cell];
        label.tag =888;
        

        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    }
    NSString *title;
    UILabel *dt = [cell viewWithTag:88];
    UILabel *label = [cell viewWithTag:888];
    if (indexPath.row==0) {
        if (headerModel.isme) {
            title = @"我的动态";
            _recommendLb.text=@"看了我的人还看了";
        }
        else
        {
            title = @"他的动态";
            _recommendLb.text=@"看了他的人还看了";
        }
        
        dt.text = title;
        label.text = headerModel.dynamic_count;
    }
    else
    {
        dt.text = @"约见评价";
        label.text = headerModel.near_count;
    }
   

    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        OtherDynamicdViewController *otherDynamicdVC =[[OtherDynamicdViewController alloc]init];
        
        otherDynamicdVC.dynamicdName = headerModel.realname;
        otherDynamicdVC.dynamicdID   = _userID;
        [self.navigationController pushViewController:otherDynamicdVC animated:YES];
    }
    else if (indexPath.row==1)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        EvaluateVC *evaluateVC =[[EvaluateVC alloc]init];
        
        evaluateVC.name = headerModel.realname;
        evaluateVC.userid   = _userID;
        [self.navigationController pushViewController:evaluateVC animated:YES];
        
    }
   
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
    _model = headerModel;
    _edit.didClickBtnBlock = ^
    {
        if (weakSelf.model&&weakSelf.model.authen.length>0) {
            BasicInformationViewController *basicInfoVc = [[BasicInformationViewController alloc]init];
            [weakSelf.navigationController pushViewController:basicInfoVc animated:YES];
        }
        else
        {
             [[ToolManager shareInstance ]showAlertMessage:@"认证信息不全"];
        }
        
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
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, APPWIDTH, 10)];
    view.backgroundColor = self.view.backgroundColor;
    [_viewHeader addSubview:view];
    //人脉
    
    BaseButton *renmai = [self addViewWithFrame:frame(0, self.userView.y + self.userView.height + 10, APPWIDTH/3, 40) andTitle:@"人脉" rangeText:headerModel.connection_count andView:_viewHeader];
    __weak typeof (self)weakSelf = self;
    renmai.didClickBtnBlock = ^
    {
        //        NSLog(@"人脉");
        if (headerModel.isme) {
            [weakSelf.navigationController pushViewController:allocAndInit(MyConnectionsVC) animated:YES];
        }
        
    };
    //访客
    BaseButton *fangke = [self addViewWithFrame:frame(CGRectGetMaxX(renmai.frame),renmai.y,renmai.width, renmai.height) andTitle:@"访客" rangeText:headerModel.visitorscount andView:_viewHeader];
    fangke.didClickBtnBlock = ^
    {
        //        NSLog(@"访客");

        if (headerModel.isme) {
        MyVisitorVC *myVisitorVC = allocAndInit(MyVisitorVC);
        [weakSelf.navigationController pushViewController:myVisitorVC animated:YES];
        }
    };

    //约见成功
    BaseButton *yuejian = [self addViewWithFrame:frame(CGRectGetMaxX(fangke.frame),fangke.y,fangke.width, fangke.height) andTitle:@"约见成功" rangeText:headerModel.success_count andView:_viewHeader];
    yuejian.didClickBtnBlock = ^
    {
        //        NSLog(@"约见成功");
        if (headerModel.isme) {
        MeetSucceedVC *otherDynamicdVC = allocAndInit(MeetSucceedVC);
        [weakSelf.navigationController pushViewController:otherDynamicdVC animated:YES];
        }
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
    
    _userView = [[LWAsyncDisplayView alloc]initWithFrame:frame(0, 10, APPWIDTH, self.headerViewLayout.height - 60)];
    _userView.userInteractionEnabled = YES;
    [_userView addSubview:self.userIcon];
    
    return _userView;
    
}
- (UIImageView *)userIcon
{
    if (!_userIcon) {
        _userIcon = [[UIImageView alloc]initWithFrame:CGRectMake((APPWIDTH - 44)/2.0, 13, 44, 44)];
        _userIcon.layer.masksToBounds = YES;
        _userIcon.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTap:)];
        tap.numberOfTapsRequired = 1;
        [_userIcon addGestureRecognizer:tap];
        
    }
    return _userIcon;
}
-(void)imageViewTap:(UITapGestureRecognizer *)sender
{
    
   
    LWImageBrowserModel* imageModel  = [[LWImageBrowserModel alloc]initWithplaceholder:nil thumbnailURL:[NSURL URLWithString:[[ToolManager shareInstance] urlAppend:headerModel.imgurl]] HDURL:[self bigImageUrl:headerModel.imgurl]imageViewSuperView:_userView positionAtSuperView:_userIcon.frame index:0];
    
    LWImageBrowser* imageBrowser = [[LWImageBrowser alloc] initWithParentViewController:self
                                                                            imageModels:@[imageModel]
                                                                           currentIndex:0];
    imageBrowser.view.backgroundColor = [UIColor blackColor];
    [imageBrowser show];
    
}
#pragma mark
#pragma mark 图片url处理
- (NSURL *)bigImageUrl:(NSString *)str
{
    NSURL *url;
    
    NSArray *strs = [str componentsSeparatedByString:@"/"];
    NSMutableArray *urls= [NSMutableArray arrayWithArray:strs];
    NSMutableString *replaceStr =[NSMutableString stringWithString:strs[strs.count - 1]] ;
    if ([replaceStr hasPrefix:@"s"]) {
        ;
        [replaceStr deleteCharactersInRange:NSMakeRange(0, 1)];
        [urls replaceObjectAtIndex:strs.count - 1 withObject:replaceStr];
    }
    
    url = [NSURL URLWithString:[[ToolManager shareInstance] urlAppend:[urls componentsJoinedByString:@"/"]] ];

    return url;
}

- (void)setHeaderViewLayout:(HeaderViewLayout *)headerViewLayout
{
    if (_headerViewLayout == headerViewLayout) {
        return;
    }
    _headerViewLayout = headerViewLayout;
    self.userView.layout = headerViewLayout;
    
    //判断男女
    PlaceholderType placeholder = PlaceholderTypeUserHead;
    if (headerModel.sex==2) {
        placeholder = PlaceholderTypeUserHeadNv;
    }
    [[ToolManager shareInstance] imageView:self.userIcon setImageWithURL:headerModel.imgurl placeholderType:placeholder];
    
}

#pragma mark - 推荐访客
-(NSMutableArray *)visitorsArr{
    if (!_visitorsArr) {
        _visitorsArr=[NSMutableArray new];
    }
    return _visitorsArr;
}

-(UILabel *)recommendLb
{
    if (!_recommendLb) {
        _recommendLb=[[UILabel alloc]init];
        _recommendLb.backgroundColor=[UIColor whiteColor];
        _recommendLb.font=[UIFont systemFontOfSize:14];
    }
    return _recommendLb;
}
-(UIScrollView *)recommendScrV
{
    if (!_recommendScrV) {
    _recommendScrV=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 35,APPWIDTH, APPWIDTH/2.0-30)];
        if (APPWIDTH<375) {
            _recommendScrV.frame=CGRectMake(0, 35,APPWIDTH, APPWIDTH/2.0-20);
        }
    float scrWidth=0;
    for (int i=0; i<self.visitorsArr.count; i++) {
        RecommendView *reView=[[RecommendView alloc]initWithFrame:CGRectMake(15+i*(APPWIDTH -60)/3.0+15*i, 10, (APPWIDTH-60)/3.0, _recommendScrV.height-20)];
        MeetingData *visitorsModel=[MeetingData mj_objectWithKeyValues:self.visitorsArr[i]];
        [reView configWithData:visitorsModel];
        reView.delegate=self;
        scrWidth = CGRectGetMaxX(reView.frame)+10;
        [_recommendScrV addSubview:reView];
    }
    _recommendScrV.showsVerticalScrollIndicator = FALSE;
    _recommendScrV.showsHorizontalScrollIndicator = FALSE;
    _recommendScrV.contentSize=CGSizeMake(scrWidth, 0);
        
    }
    return _recommendScrV;
}
#pragma mark - 推荐人脉点击
-(void)didSelectRecommendViewWithModel:(MeetingData *)data
{
    MyDetialViewController *myDetialViewCT=[MyDetialViewController new];
    myDetialViewCT.userID=data.userid;
    [self.navigationController pushViewController:myDetialViewCT animated:YES];
}

#pragma mark getter tagsView

- (UIView *)viewFooter
{
    if (_viewFooter) {
        return _viewFooter;
    }
    
    _viewFooter = [[UIView alloc]initWithFrame:CGRectZero];
    _viewFooter.backgroundColor = WhiteColor;
    
    //推荐访客
    [self.viewFooter addSubview:self.recommendLb];
    [self.viewFooter addSubview:self.recommendScrV];

    //产品标签
    [self.viewFooter addSubview:self.line2];
    
    [self.viewFooter addSubview:self.productTagsLb];
    
    [self.viewFooter addSubview:self.productTagsView];
    
    // 资源特点
    [self.viewFooter addSubview:self.resourseTagsLb];;
    [self.viewFooter addSubview:self.resourseTagsView];
    
    // 个人特点
    [self.viewFooter addSubview:self.line1];
    
    [self.viewFooter addSubview:self.personsTagsLb];
    [self.viewFooter addSubview:self.personsTagsView];
    
    //好友印象
    [self.viewFooter addSubview:self.impressionTagsLb];
    [self.viewFooter addSubview:self.impressionTagsView];
    
     [self.viewFooter addSubview:self.lookMore];
    
     _viewFooter.userInteractionEnabled = YES;
    //设置位置
    [self tagsViewReSetFrame];
    return _viewFooter;
}
- (UILabel *)productTagsLb
{
    if (_productTagsLb) {
        return  _productTagsLb;
    }
    _productTagsLb =[UILabel createLabelWithFrame:CGRectMake(20, 15, APPWIDTH - 40, 35) text:@"产品服务" fontSize:14 textColor:AppMainColor textAlignment:NSTextAlignmentLeft inView:nil];
    
    return  _productTagsLb;
    
}
- (DWTagsView *)productTagsView
{
    if (_productTagsView) {
        return _productTagsView;
    }
    _productTagsView = allocAndInitWithFrame(DWTagsView, CGRectMake(20, CGRectGetMaxY(_productTagsLb.frame)+10, APPWIDTH - 40, 2*(TagHeight+10)));
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
    _resourseTagsLb =[UILabel createLabelWithFrame:CGRectZero text:@"人脉资源" fontSize:14 textColor:[UIColor colorWithRed:0.9843 green:0.5137 blue:0.3412 alpha:1.0] textAlignment:NSTextAlignmentLeft inView:nil];
    
    return  _resourseTagsLb;
    
}

- (DWTagsView *)resourseTagsView
{
    if (_resourseTagsView) {
        return _resourseTagsView;
    }
    _resourseTagsView = allocAndInitWithFrame(DWTagsView, CGRectMake(20, CGRectGetMaxY(_resourseTagsLb.frame), APPWIDTH - 40,2*(TagHeight+10)));
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
- (UIView *)line2
{
    if (_line2) {
        return _line2;
    }
    _line2 = [[UIView alloc]initWithFrame:CGRectZero];
    _line2.backgroundColor = self.view.backgroundColor;
    return _line2;
}
- (UILabel *)personsTagsLb
{
    if (_personsTagsLb) {
        return  _personsTagsLb;
    }
    _personsTagsLb =[UILabel createLabelWithFrame:CGRectZero text:@"自我评价" fontSize:14 textColor:AppMainColor textAlignment:NSTextAlignmentLeft inView:nil];
    
    return  _personsTagsLb;
    
}

- (DWTagsView *)personsTagsView
{
    if (_personsTagsView) {
        return _personsTagsView;
    }
    _personsTagsView = allocAndInitWithFrame(DWTagsView, CGRectMake(20, CGRectGetMaxY(_personsTagsLb.frame), APPWIDTH - 40, 2*(TagHeight+10)));
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

- (UILabel *)impressionTagsLb
{
    if (_impressionTagsLb) {
        return  _impressionTagsLb;
    }
    _impressionTagsLb =[UILabel createLabelWithFrame:CGRectZero text:@"好友印象" fontSize:14 textColor:[UIColor colorWithRed:0.9843 green:0.451 blue:0.2549 alpha:1.0] textAlignment:NSTextAlignmentLeft inView:nil];
    
    return  _impressionTagsLb;
    
}
-(DWTagsView *)impressionTagsView
{
    if (_impressionTagsView) {
        return _impressionTagsView;
    }
    _impressionTagsView = allocAndInitWithFrame(DWTagsView, CGRectMake(20, CGRectGetMaxY(_impressionTagsLb.frame), APPWIDTH - 40, 2*(TagHeight+10)));
    _impressionTagsView.contentInsets = UIEdgeInsetsZero;
    _impressionTagsView.tagInsets = UIEdgeInsetsMake(5, 15, 5, 15);
    _impressionTagsView.tagcornerRadius = 2;
    _impressionTagsView.tag = 8888;
    _impressionTagsView.mininumTagWidth =MininumTagWidth;
    _impressionTagsView.maximumTagWidth = MaxinumTagWidth;
    _impressionTagsView.tagHeight  = TagHeight;
    
    _impressionTagsView.tagBackgroundColor = [UIColor colorWithRed:0.9843 green:0.451 blue:0.2549 alpha:1.0];
    _impressionTagsView.lineSpacing = 10;
    _impressionTagsView.interitemSpacing = 20;
    _impressionTagsView.tagFont = [UIFont systemFontOfSize:14];
    _impressionTagsView.tagTextColor = WhiteColor;
    _impressionTagsView.tagSelectedBackgroundColor = _impressionTagsView.tagBackgroundColor;
    _impressionTagsView.tagSelectedTextColor = _impressionTagsView.tagTextColor;
    
    _impressionTagsView.delegate = self;
    _impressionTagsView.tagsArray = self.impressionTags;
    
    return _impressionTagsView;
}
- (NSMutableArray *)productsTags
{
    if (_productsTags) {
        return _productsTags;
    }
    _productsTags = [[NSMutableArray alloc]init];
    return _productsTags;
}
- (NSMutableArray *)resourseaTags
{
    if (_resourseaTags) {
        return _resourseaTags;
    }
    _resourseaTags = [[NSMutableArray alloc]init];
    return _resourseaTags;
}
- (NSMutableArray *)personsTags
{
    if (_personsTags) {
        return _personsTags;
    }
    _personsTags = [[NSMutableArray alloc]init];
    return _personsTags;
}
- (NSMutableArray *)impressionTags
{
    if (_impressionTags) {
        return _impressionTags;
    }
    
    _impressionTags = [[NSMutableArray alloc]init];
    return _impressionTags;
}
- (BaseButton *)lookMore
{
    if (_lookMore) {
        return _lookMore;
    }
    _lookMore = [[BaseButton alloc]initWithFrame:CGRectZero setTitle:@"查看更多" titleSize:13 titleColor:LightBlackTitleColor textAlignment:NSTextAlignmentCenter backgroundColor:WhiteColor inView:nil];
    _lookMore.userInteractionEnabled = YES;
    if (self.impressionTags.count>10) {
        
        self.lookMore.hidden = NO;
        
    }
    else
    {
        self.lookMore.hidden = YES;
    }

    __weak typeof(self) weakSelf = self;
    _lookMore.didClickBtnBlock = ^
    {
        weakSelf.islookMore = !weakSelf.islookMore;
        [weakSelf tagsViewReSetFrame];
    };
    
    return _lookMore;
}
#pragma mark
#pragma mark resetFrame
- (void)tagsViewReSetFrame
{
    if (self.visitorsArr.count>=3) {
        self.recommendLb.frame=CGRectMake(20, 10, APPWIDTH-40, 15);
        self.recommendScrV.frame=CGRectMake(0, 35,APPWIDTH, APPWIDTH/2.0-30);
        self.line2.frame = CGRectMake(0, APPWIDTH/2.0+15, APPWIDTH, 10);
    }else{
        [self.recommendLb removeFromSuperview];
        [self.recommendScrV removeFromSuperview];
        self.line2.frame =CGRectMake(0, 0, 0, 0);
    }
    _productTagsLb.frame =CGRectMake(20, CGRectGetMaxY(_line2.frame), APPWIDTH - 40, 35);
    _productTagsView.frame = CGRectMake(20,CGRectGetMaxY(_productTagsLb.frame), APPWIDTH - 40, [_productTagsView.collectionView.collectionViewLayout collectionViewContentSize].height);
    _resourseTagsLb.frame = CGRectMake(20, CGRectGetMaxY(_productTagsView.frame), APPWIDTH, 35);
    _resourseTagsView.frame = CGRectMake(20, CGRectGetMaxY(_resourseTagsLb.frame), APPWIDTH - 40,[_resourseTagsView.collectionView.collectionViewLayout collectionViewContentSize].height);
    _line1.frame = CGRectMake(0, CGRectGetMaxY(_resourseTagsView.frame) + 10, APPWIDTH, 10);
    _personsTagsLb.frame = CGRectMake(20, CGRectGetMaxY(_line1.frame), APPWIDTH, 35);
    _personsTagsView.frame =CGRectMake(20, CGRectGetMaxY(_personsTagsLb.frame), APPWIDTH - 40, [_personsTagsView.collectionView.collectionViewLayout collectionViewContentSize].height);
    
    _impressionTagsLb.frame = CGRectMake(20, CGRectGetMaxY(_personsTagsView.frame), APPWIDTH, 35);
    
    if (self.impressionTags.count<=10) {
        
        _impressionTagsView.tagsArray = self.impressionTags;
        _impressionTagsView.frame =CGRectMake(20, CGRectGetMaxY(_impressionTagsLb.frame), APPWIDTH - 40, [_impressionTagsView.collectionView.collectionViewLayout collectionViewContentSize].height);
        _lookMore.frame = CGRectMake(0, CGRectGetMaxY(_impressionTagsView.frame), APPWIDTH, 0);
       _viewFooter.frame = frame(0, 0, APPWIDTH, CGRectGetMaxY(_impressionTagsView.frame) + 10);
        
    }
    else
    {
        NSMutableArray *array;
        if (self.islookMore) {
            [_lookMore setTitle:@"点击收回" forState:UIControlStateNormal];
            array = self.impressionTags;
        }
        else
        {
            [_lookMore setTitle:@"查看更多" forState:UIControlStateNormal];
            array = (NSMutableArray *)[self.impressionTags subarrayWithRange:NSMakeRange(0, 10)];
        }
        _impressionTagsView.tagsArray = array;
        _impressionTagsView.frame =CGRectMake(20, CGRectGetMaxY(_impressionTagsLb.frame), APPWIDTH - 40, [_impressionTagsView.collectionView.collectionViewLayout collectionViewContentSize].height);
        
        _lookMore.frame = CGRectMake(0, CGRectGetMaxY(_impressionTagsView.frame) + 10, APPWIDTH, 30);
        _viewFooter.frame = frame(0, 0, APPWIDTH, CGRectGetMaxY(_lookMore.frame) + 10);
        
    }
    
    [self.myDetailTV beginUpdates];
    _myDetailTV.tableFooterView = self.viewFooter;
     [self.myDetailTV endUpdates];
    
}
#pragma mark --bottomView底部view
-(void)addBottomViewWithBtnStr:(int)btnStr andReward:(float )reward
{

    NSString *titleStr;
    if (btnStr==0) {
        titleStr=@"添加人脉";
        addConnectionsBtn.tag=2222;
        addConnectionsBtn.userInteractionEnabled=YES;
        [addConnectionsBtn setTitleColor:AppMainColor forState:UIControlStateNormal];
        
    }else if (btnStr==1) {
        if (reward>0) {
            titleStr=[NSString stringWithFormat:@"等待对方通过(已打赏%0.2f元)",reward];
        }else{
        titleStr=@"等待对方通过";
        }
        addConnectionsBtn.tag=2223;
        addConnectionsBtn.userInteractionEnabled=NO;
        [addConnectionsBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }else if (btnStr==2) {
        if (reward>0) {
            titleStr=[NSString stringWithFormat:@"等待您的通过(已打赏%0.2f元)",reward];
        }else{
        titleStr=@"等待您的通过";
        }
        addConnectionsBtn.tag=2224;
        addConnectionsBtn.userInteractionEnabled=NO;
        [addConnectionsBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }else if (btnStr==3) {
        titleStr=@"对话";
        addConnectionsBtn.tag=2225;
        addConnectionsBtn.userInteractionEnabled=YES;
        [addConnectionsBtn setTitleColor:AppMainColor forState:UIControlStateNormal];
        
    }
    addConnectionsBtn.backgroundColor=[UIColor colorWithWhite:0.902 alpha:1.000];
    [addConnectionsBtn setTitle:titleStr forState:UIControlStateNormal];
    [addConnectionsBtn addTarget:self action:@selector(addConnectionsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
   
    
}
#pragma mark button aticons
- (void)buttonAction:(UIButton *)sender
{
    PopView(self);
}
-(void)addConnectionsBtnClick:(UIButton *)sender
{
    if (sender.tag==2222) {
        [[ToolManager shareInstance] showWithStatus];
        NSMutableDictionary *param=[Parameter parameterWithSessicon];
        [param setObject:@"connection_add" forKey:@"type"];
        [XLDataService putWithUrl:connetionCheckedURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
            if(dataObj){
//                NSLog(@"dataobj===%@",dataObj);
                
                if ([dataObj[@"rtcode"] intValue]==1) {
                    [[ToolManager shareInstance] dismiss];
                    CGFloat dilX = 25;
                    CGFloat dilH = 250;
                    connectionView = [[AddConnectionView alloc] initAlertViewWithFrame:CGRectMake(dilX, 0, 250, dilH) andSuperView:self.view];
                    connectionView.center = CGPointMake(APPWIDTH/2, APPHEIGHT/2-30);
                    connectionView.delegate = self;
                    connectionView.titleStr = @"提示";
                    connectionView.title2Str=@"打赏让加人脉更顺畅!";
                }
                else if ([dataObj[@"rtcode"] intValue]==4001){
                    [[ToolManager shareInstance]dismiss];
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"去身份认证吗?" message:dataObj[@"rtmsg"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"不去",@"走起", nil];
                    alertView.tag=333;
                    alertView.delegate=self;
                    [alertView show];
                    
                }else if ([dataObj[@"rtcode"] intValue] ==4005){
                    [[ToolManager shareInstance]dismiss];
                    
                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"知脉君温馨提示" message:[NSString stringWithFormat:@"%@",dataObj[@"rtmsg"]] delegate:self cancelButtonTitle:nil otherButtonTitles:@"再看看",@"马上开通", nil];
                    alertView.tag=22223;
                    alertView.delegate=self;
                    [alertView show];
                }
                else
                {
                    [[ToolManager shareInstance] showAlertMessage:dataObj[@"rtmsg"]];
                }
            }
            else
            {
                [[ToolManager shareInstance] showInfoWithStatus];
                
            }
        }];


    }else if (sender.tag==2223) {
    }else if (sender.tag==2224) {
    }else if (sender.tag==2225) {
        GJGCChatFriendTalkModel *talk = [[GJGCChatFriendTalkModel alloc]init];
        talk.talkType = GJGCChatFriendTalkTypePrivate;
        talk.toId =headerModel.Id;
        talk.toUserName =headerModel.realname;
        GJGCChatFriendViewController *privateChat = [[GJGCChatFriendViewController alloc]initWithTalkInfo:talk ];
        privateChat.type = MessageTypeNormlPage;
        [self.navigationController pushViewController:privateChat animated:YES];
        
    }
}

#pragma mark - AddConnectionViewDelegate
- (void) customAlertView:(AddConnectionView *) customAlertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==0) {
//        NSMutableDictionary *param=[Parameter parameterWithSessicon];
//        [param setObject:_userID forKey:@"beinvited"];
//        [[ToolManager shareInstance] showWithStatus];
//        [XLDataService putWithUrl:addConnectionsURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
//            if(dataObj){
////                NSLog(@"dataobj===%@",dataObj);
//                
//                MeetingModel *model=[MeetingModel mj_objectWithKeyValues:dataObj];
//                if (model.rtcode==1) {
//                    [[ToolManager shareInstance] dismiss];
//                    UIAlertView *successAlertV=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"添加人脉请求已发出,请耐心等待" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                     [[NSNotificationCenter defaultCenter]postNotificationName:@"KReflashCanMeet" object:@{@"userid":headerModel.Id,@"relation":@"1",@"reward":@"0"}];
//                    [successAlertV show];
//                    [connectionView.window removeGestureRecognizer:recognizerTap];
//                }else if (model.rtcode ==4005){
//                    [[ToolManager shareInstance]dismiss];
//                    
//                    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"知脉君温馨提示" message:[NSString stringWithFormat:@"%@",model.rtmsg] delegate:self cancelButtonTitle:nil otherButtonTitles:@"再看看",@"马上开通", nil];
//                    alertView.tag=22223;
//                    alertView.delegate=self;
//                    [alertView show];
//                }
//                else
//                {
//                    [[ToolManager shareInstance] showAlertMessage:model.rtmsg];
//                }
//            }else
//            {
//                [[ToolManager shareInstance] showInfoWithStatus];
//            }
//            
//        }];
        [customAlertView dissMiss];

    }else
    {
        if ([customAlertView.money floatValue]>=1) {
        MeetPaydingVC * payVC = [[MeetPaydingVC alloc]init];
        NSMutableDictionary *param=[Parameter parameterWithSessicon];
        [param setObject:_userID forKey:@"beinvited"];
        [param setObject:[NSString stringWithFormat:@"%.2f",[customAlertView.money floatValue]] forKey:@"reward"];
        payVC.param=param;
        payVC.jineStr =[NSString stringWithFormat:@"%.2f",[customAlertView.money floatValue]];
        payVC.whatZfType=1;
        [self.navigationController pushViewController:payVC animated:YES];
        [customAlertView dissMiss];
        [connectionView.window removeGestureRecognizer:recognizerTap];
        }else{
            [[ToolManager shareInstance] showAlertMessage:@"金额格式不正确,最低1元"];
        }
    }
}
#pragma mark 网络请求
-(void)netWork
{
    NSMutableDictionary *param=[Parameter parameterWithSessicon];
    [param setObject:_userID forKey:@"id"];
//    NSLog(@"id =%@",_userID);
   
    [[ToolManager shareInstance] showWithStatus];
    [XLDataService putWithUrl:detailManURL param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        NSLog(@"detailManURLdataObj =%@",dataObj);
        if (dataObj) {
            headerModel = [HeaderModel mj_objectWithKeyValues:dataObj[@"data"]];
            if ([dataObj[@"rtcode"] integerValue]==1) {
                [[ToolManager shareInstance] dismiss];
                self.visitorsArr=dataObj[@"visitors"];
                self.headerViewLayout = [[HeaderViewLayout alloc]initCellLayoutWithModel:headerModel];
                if (![headerModel.labels isEqualToString:@""]) {
                    [self.personsTags addObjectsFromArray:[headerModel.labels componentsSeparatedByString:@","]];
                    
                }
                
                
                if (![headerModel.service
                      isEqualToString:@""]) {
                    [self.productsTags addObjectsFromArray:[headerModel.service componentsSeparatedByString:@","]];
                    
                }
                
                if (![headerModel.resource
                      isEqualToString:@""]) {
                    [self.resourseaTags addObjectsFromArray:[headerModel.resource componentsSeparatedByString:@","]];
                    
                }
                [self.impressionTags addObjectsFromArray:headerModel.impression];
                
                [self navViewTitleAndBackBtn:headerModel.realname];
                
                
                _myDetailTV.tableHeaderView = self.viewHeader;
                _myDetailTV.tableFooterView = self.viewFooter;
                
                [_myDetailTV reloadData];
                
                if (!headerModel.isme) {
                    
                    addConnectionsBtn=[UIButton buttonWithType:UIButtonTypeCustom];
                    addConnectionsBtn.frame=CGRectMake(0,APPHEIGHT-TabBarHeight,APPWIDTH, TabBarHeight);
                    addConnectionsBtn.tag=2222;
                    [self.view addSubview:addConnectionsBtn];
                    
                    [self addBottomViewWithBtnStr:[dataObj[@"relation"] intValue] andReward:[dataObj[@"reward"] floatValue]];
                    _myDetailTV.frame = CGRectMake(0, _myDetailTV.y,_myDetailTV.width, APPHEIGHT - (_myDetailTV.y) -TabBarHeight);
                }else{
                    
                    [self.view addSubview:self.edit];
                    _myDetailTV.frame = CGRectMake(0, _myDetailTV.y,_myDetailTV.width, APPHEIGHT - (_myDetailTV.y));
                    
                }
                
            }
            else
            {
                [[ToolManager shareInstance] showAlertMessage:dataObj[@"rtmsg"]];
            }
            
        }
        else
        {
            [[ToolManager shareInstance] showInfoWithStatus];
        }
        
    }];
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
    [btn setAttributedTitle:attributedString forState:UIControlStateNormal];
    
    
    return btn;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==333) {
        if (buttonIndex==0) {
            
        }else if(buttonIndex==1){
            if (headerModel.authen&&headerModel.authen.length>0) {
                AuthenticationHomeViewController *authen =  allocAndInit(AuthenticationHomeViewController);
                PushView(self, authen);
            }
            else
            {
                [[ToolManager shareInstance ]showAlertMessage:@"认证信息不全"];
            }
            
        }
    }else if (alertView.tag==22223) {
        if (buttonIndex==0) {
            
        }else if(buttonIndex==1){
            PushView(self, allocAndInit(VIPPrivilegeVC));
        }
    }
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
