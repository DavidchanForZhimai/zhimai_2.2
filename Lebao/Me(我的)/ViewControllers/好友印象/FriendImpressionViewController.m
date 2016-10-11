//
//  FriendImpressionViewController.m
//  Lebao
//
//  Created by David on 16/9/19.
//  Copyright © 2016年 David. All rights reserved.
//

#import "FriendImpressionViewController.h"
#import "XLDataService.h"
#import "BaseModal.h"
#import "DWTagsView.h"
#import "NSString+Extend.h"
#import "InvateFriendCommentViewController.h"//邀请好友评价
#define TagHeight 22
#define MininumTagWidth (APPWIDTH - 120)/5.0
#define MaxinumTagWidth (APPWIDTH - 20)
#define UserFriendImpression [NSString stringWithFormat:@"%@user/friend-impression",HttpURL]

@interface FriendImpressionData : NSObject
@property(nonatomic,copy)NSString *createtime;
@property(nonatomic,copy)NSString *headimgurl;
@property(nonatomic,copy)NSString *nickname;
@property(nonatomic,copy)NSString *openid;
@property(nonatomic,copy)NSString *relation_label;
@property(nonatomic,copy)NSMutableArray *labels;
@end
@implementation FriendImpressionData


@end

@interface FriendImpressionModel : BaseModal
@property(nonatomic,copy)NSMutableArray *labels;
@end

@implementation FriendImpressionModel

+ (NSDictionary *)objectClassInArray{
    return @{@"datas" : [FriendImpressionData class]};
}
@end

@interface  FriendImpressionCell: UITableViewCell
- (void)setData:(FriendImpressionData *)data;
@end

@implementation FriendImpressionCell

{
    DWTagsView *impressionTagsView;
    UIView *view;
    UIImageView *userICon;
    UILabel *userName;
    UILabel *time;
    
    UIImageView *weixinIcon;
    UILabel *from;
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        impressionTagsView = allocAndInitWithFrame(DWTagsView, CGRectMake(20, 60, APPWIDTH - 40, 22));
        impressionTagsView.contentInsets = UIEdgeInsetsZero;
        impressionTagsView.tagInsets = UIEdgeInsetsMake(5, 15, 5, 15);
        impressionTagsView.tagcornerRadius = 2;
        impressionTagsView.mininumTagWidth =MininumTagWidth;
        impressionTagsView.maximumTagWidth = MaxinumTagWidth;
        impressionTagsView.tagHeight  = TagHeight;
        impressionTagsView.tagBackgroundColor = AppMainColor;
        impressionTagsView.lineSpacing = 10;
        impressionTagsView.interitemSpacing = 20;
        impressionTagsView.tagFont = [UIFont systemFontOfSize:14];
        impressionTagsView.tagTextColor = WhiteColor;
        impressionTagsView.tagSelectedBackgroundColor = impressionTagsView.tagBackgroundColor;
        impressionTagsView.tagSelectedTextColor = impressionTagsView.tagTextColor;
        impressionTagsView.tag = 8888;
        [self addSubview:impressionTagsView];
        
        userICon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 40, 40)];
        [userICon setRound];
        [self addSubview:userICon];
        
        userName = [UILabel createLabelWithFrame:CGRectMake(CGRectGetMaxX(userICon.frame) + 10, 10, APPWIDTH, 14) text:@"" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:self];
        
        time = [UILabel createLabelWithFrame:CGRectMake(0, 10, APPWIDTH - 10, 12) text:@"" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentRight inView:self];
        
        weixinIcon = [[UIImageView alloc]initWithFrame:CGRectMake(userName.x, userName.y + userName.height + 5, 16, 16)];
        weixinIcon.image = [UIImage imageNamed:@"icon_me_weixin"];
        [weixinIcon setRound];
        [self addSubview:weixinIcon];
        
        from = [UILabel createLabelWithFrame:CGRectMake(weixinIcon.x + weixinIcon.width + 5, weixinIcon.y + 2, APPWIDTH - 10, 12) text:@"来自微信" fontSize:24*SpacedFonts textColor:LightBlackTitleColor textAlignment:NSTextAlignmentLeft inView:self];
        
        view = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(impressionTagsView.frame) + 10, APPWIDTH,10 )];
        
        view.backgroundColor = AppViewBGColor;
        [self addSubview:view];
    }
    return self;
}
- (void)setData:(FriendImpressionData *)data;
{
    
    [[ToolManager shareInstance] imageView:userICon setImageWithURL:data.headimgurl placeholderType:PlaceholderTypeUserHead];
    NSString *relation_label;
    if (data.relation_label&&![data.relation_label isEqualToString:@""]) {
        relation_label =[NSString stringWithFormat:@"(%@)",data.relation_label];
       
    }
    else
    {
       relation_label =@"";
    }
     userName.text = [NSString stringWithFormat:@"%@ %@",data.nickname,relation_label];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:userName.text];
    
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:24*SpacedFonts] range:[userName.text rangeOfString:relation_label]];
     [str addAttribute:NSForegroundColorAttributeName value:LightBlackTitleColor range:[userName.text rangeOfString:relation_label]];
    userName.attributedText = str;
    
    time.text = [data.createtime updateTime];
    
    if (data.openid&&data.openid.length>0) {
        
        weixinIcon.hidden = NO;
        from.hidden = NO;
        
    }
    else
    {
        weixinIcon.hidden = YES;
        from.hidden = YES;
    }
    
    NSMutableArray *tags = [NSMutableArray new];
    for (NSDictionary *tag in data.labels) {
        [tags addObject:tag[@"label"]];
    }
    impressionTagsView.tagsArray = tags;
    impressionTagsView.frame = CGRectMake(20, 60, APPWIDTH - 40, [impressionTagsView.collectionView.collectionViewLayout collectionViewContentSize].height);

    view.frame = CGRectMake(0, CGRectGetMaxY(impressionTagsView.frame) + 10, APPWIDTH,10 );
}
@end

@interface FriendImpressionViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *impressionView;
@property(nonatomic,copy)NSMutableArray *impressions;
@property(nonatomic,strong)BaseButton *evaluation;
@property(nonatomic,strong)DWTagsView *impressionTagsView;//求cell高用的
@property(nonatomic,copy)NSMutableArray *impressionTags;
@property(assign)int page;;
@end

@implementation FriendImpressionViewController
{
    FriendImpressionModel *model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navViewTitleAndBackBtn:@"好友印象"];
    [self.view addSubview:self.evaluation];
    [self.view addSubview:self.impressionView];
    _page = 1;
    
    [self netWorkIsRefresh:NO isLoadMoreData:NO shouldClearData:NO];
}
#pragma mark
#pragma mark - getter
-(UITableView *)impressionView
{
    if (_impressionView) {
        return _impressionView;
    }
    _impressionView = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)) style:UITableViewStyleGrouped];
    _impressionView.backgroundColor = [UIColor clearColor];
    _impressionView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _impressionView.delegate = self;
    _impressionView.dataSource = self;
    __weak typeof(self) weakSelf = self;
    [[ToolManager shareInstance] scrollView:_impressionView headerWithRefreshingBlock:^{
        weakSelf.page =1;
        [weakSelf netWorkIsRefresh:YES isLoadMoreData:NO shouldClearData:YES];
    }];
    [[ToolManager shareInstance] scrollView:_impressionView footerWithRefreshingBlock:^{
        weakSelf.page = weakSelf.page+1;
        [weakSelf netWorkIsRefresh:NO isLoadMoreData:YES shouldClearData:NO];
    }];
    return _impressionView;
    
}
-(NSMutableArray *)impressions
{
    
    if (_impressions) {
        return _impressions;
    }
    _impressions = [NSMutableArray new];
    return _impressions;
}
- (DWTagsView *)impressionTagsView
{
    if (_impressionTagsView) {
        return _impressionTagsView;
    }
    _impressionTagsView = allocAndInitWithFrame(DWTagsView, CGRectMake(20, 0, APPWIDTH - 40, 2*(TagHeight+10)));
    _impressionTagsView.contentInsets = UIEdgeInsetsZero;
    _impressionTagsView.tagInsets = UIEdgeInsetsMake(5, 15, 5, 15);
    _impressionTagsView.tagcornerRadius = 2;
    _impressionTagsView.mininumTagWidth =MininumTagWidth;
    _impressionTagsView.maximumTagWidth = MaxinumTagWidth;
    _impressionTagsView.tagHeight  = TagHeight;
    
    _impressionTagsView.tagBackgroundColor = AppMainColor;
    _impressionTagsView.lineSpacing = 10;
    _impressionTagsView.interitemSpacing = 20;
    _impressionTagsView.tagFont = [UIFont systemFontOfSize:14];
    _impressionTagsView.tagTextColor = WhiteColor;
    _impressionTagsView.tagSelectedBackgroundColor = _impressionTagsView.tagBackgroundColor;
    _impressionTagsView.tagSelectedTextColor = _impressionTagsView.tagTextColor;

    return _impressionTagsView;

}
-(NSMutableArray *)impressionTags
{
    if (_impressionTags) {
        return _impressionTags;
    }
    _impressionTags = [NSMutableArray new];
    return _impressionTags;
}
#pragma mark
#pragma mark -UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return [NSString stringWithFormat:@"%i好友给我打了印象标签",model.count];
    }
    else
    {
      return @"最新印象";
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        return 1;
    }
    else
    {
        return _impressions.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        
        self.impressionTagsView.tagsArray = self.impressionTags;
        return [_impressionTagsView.collectionView.collectionViewLayout collectionViewContentSize].height + 40;
    }
    else
    {
        FriendImpressionData *data = self.impressions[indexPath.row];
        NSMutableArray *tags = [NSMutableArray new];
        for (NSDictionary *tag in data.labels) {
            [tags addObject:tag[@"label"]];
        }
        self.impressionTagsView.tagsArray = tags;
        
        return [self.impressionTagsView.collectionView.collectionViewLayout collectionViewContentSize].height + 80;
        
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
       
        static NSString *cellID = @"UITableViewCellIndexPathSection0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.backgroundColor = WhiteColor;
            cell.selectionStyle = 0;
            DWTagsView *impressionTagsView = allocAndInitWithFrame(DWTagsView, CGRectMake(20, 20, APPWIDTH - 40, cell.height- 40));
            impressionTagsView.contentInsets = UIEdgeInsetsZero;
            impressionTagsView.tagInsets = UIEdgeInsetsMake(5, 15, 5, 15);
            impressionTagsView.tagcornerRadius = 2;
            impressionTagsView.mininumTagWidth =MininumTagWidth;
            impressionTagsView.maximumTagWidth = MaxinumTagWidth;
            impressionTagsView.tagHeight  = TagHeight;
            impressionTagsView.tagBackgroundColor = AppMainColor;
            impressionTagsView.lineSpacing = 10;
            impressionTagsView.interitemSpacing = 20;
            impressionTagsView.tagFont = [UIFont systemFontOfSize:14];
            impressionTagsView.tagTextColor = WhiteColor;
            impressionTagsView.tagSelectedBackgroundColor = impressionTagsView.tagBackgroundColor;
            impressionTagsView.tagSelectedTextColor = impressionTagsView.tagTextColor;
            impressionTagsView.tag = 888;
            [cell addSubview:impressionTagsView];
            
            
        }
        
        DWTagsView *impressionTagsView = [cell viewWithTag:888];
        impressionTagsView.tagsArray = self.impressionTags;
        impressionTagsView.frame = CGRectMake(20, 20, APPWIDTH - 40, [impressionTagsView.collectionView.collectionViewLayout collectionViewContentSize].height);
        return cell;
    }
    else
    {
        static NSString *cellID = @"FriendImpressionCell";
        FriendImpressionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[FriendImpressionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.backgroundColor = WhiteColor;
            cell.selectionStyle = 0;

            
        }
        
        FriendImpressionData *data = self.impressions[indexPath.row];
        [cell setData:data];
        return cell;
 
    }
    
}
#pragma mark 网络请求
-(void)netWorkIsRefresh:(BOOL )isRefresh isLoadMoreData:(BOOL)isLoadMoreData shouldClearData:(BOOL)isShouldClearData
{
    NSMutableDictionary *param=[Parameter parameterWithSessicon];
    [param setObject:@(_page) forKey:@"page"];
    if (_impressions.count==0) {
        [[ToolManager shareInstance] showWithStatus];
    }
    
    [XLDataService putWithUrl:UserFriendImpression param:param modelClass:nil responseBlock:^(id dataObj, NSError *error) {
//        NSLog(@" param =%@   dataObj =%@",param,dataObj);
        if (isRefresh) {
            
            [[ToolManager shareInstance] endHeaderWithRefreshing:_impressionView];
        }
        if (isLoadMoreData) {
            [[ToolManager shareInstance] endFooterWithRefreshing:_impressionView];
        }
        
        if (dataObj) {
            
            model = [FriendImpressionModel mj_objectWithKeyValues:dataObj];
            
            self.page =model.page;
            if (model.rtcode==1) {
                [[ToolManager shareInstance] dismiss];
                
                if (isShouldClearData) {
                    [self.impressions removeAllObjects];
                }
                
                for (FriendImpressionData *data in model.datas) {
                    [self.impressions addObject:data];
                }
                self.impressionTags = model.labels;
                
                if (_impressions.count>=model.count) {
                    
                    [[ToolManager shareInstance] noMoreDataStatus:_impressionView];
                }
                else
                {
                    [[ToolManager shareInstance] moreDataStatus:_impressionView];
                }

                
                [_impressionView reloadData];
                
            }
            else
            {
                [[ToolManager shareInstance] showAlertMessage:model.rtmsg];
            }
            
        }
        else
        {
            [[ToolManager shareInstance] showInfoWithStatus];
        }
        
    }];
}

#pragma mark getter
- (BaseButton *)evaluation
{
    if (_evaluation) {
        return _evaluation;
    }
    _evaluation = [[BaseButton alloc]initWithFrame:frame(APPWIDTH - 50 ,StatusBarHeight,50, NavigationBarHeight) setTitle:@"求评价" titleSize:28*SpacedFonts titleColor:BlackTitleColor textAlignment:NSTextAlignmentRight backgroundColor:[UIColor clearColor] inView:nil];
    _evaluation.shouldAnmial = NO;
    __weak typeof(self) weakSelf = self;
    _evaluation.didClickBtnBlock = ^
    {
        PushView(weakSelf, allocAndInit(InvateFriendCommentViewController));
    };
    return _evaluation;
}
#pragma mark button aticons
- (void)buttonAction:(UIButton *)sender
{
    PopView(self);
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
