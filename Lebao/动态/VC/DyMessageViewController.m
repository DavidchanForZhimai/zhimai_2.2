//
//  DyMessageViewController.m
//  Lebao
//
//  Created by David on 2016/11/14.
//  Copyright © 2016年 David. All rights reserved.
//

#import "DyMessageViewController.h"
#import "XLDataService.h"
#import "NSString+Extend.h"
#import "DynamicDetailsViewController.h"
#define DynamicMessageURL [NSString stringWithFormat:@"%@dynamic/message",HttpURL]


@implementation DyMessageModel
+ (NSDictionary *)objectClassInArray{
    return @{@"datas" : [DyMessageData class]};
}
@end

@implementation DyMessageData
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{ @"ID" : @"id"
              };
}
@end

@implementation DyMessageLayout


@end
@implementation DyMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellHeight cellWidth:(float)cellWidth
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _userIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 40, 40)];
        [_userIcon setRound];
        [self addSubview:_userIcon];
        
        _userLabel = [UILabel createLabelWithFrame:CGRectMake(CGRectGetMaxX(_userIcon.frame) + 5, 5, APPWIDTH/2.0, 20) text:@"" fontSize:14 textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:self];
        
        UIImage *imageLike =[UIImage imageNamed:@"dongtai_dianzan_pressed"];
        _userLike = [[UIImageView alloc]initWithFrame:CGRectMake(_userLabel.x, _userLabel.height + _userLabel.y + 5, imageLike.size.width, imageLike.size.height)];
        _userLike.image = imageLike;
        _userLike.hidden = YES;
        [self addSubview:_userLike];
        
        _userContent = [UILabel createLabelWithFrame:CGRectMake(_userLike.x, _userLabel.height + _userLabel.y, APPWIDTH - (_userLike.x + 70), 30) text:@"" fontSize:11 textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:self];
        _userContent.numberOfLines = 0;
        _userContent.hidden = YES;
        
        _userTime = [UILabel createLabelWithFrame:CGRectMake(_userLike.x, cellHeight - 25, APPWIDTH - (_userLike.x + 70), 20) text:@"" fontSize:11 textColor:hexColor(bcbcbc) textAlignment:NSTextAlignmentLeft inView:self];
        
        
        
         float imageW = cellHeight - 2*_userIcon.y;
        _userImage = [[UIImageView alloc]initWithFrame:CGRectMake(APPWIDTH - (_userIcon.y + imageW), _userIcon.y, imageW, imageW) ];
        _userImage.hidden = YES;
        [self addSubview:_userImage];
        
        _userTitleView = [[UIView alloc]initWithFrame:_userImage.frame];
        _userTitleView.backgroundColor = hexColor(eeeeee);
        _userTitleView.hidden = YES;
        [self addSubview:_userTitleView];
        _userTitle = [DWLable createLabelWithFrame:CGRectMake(5, 5, _userTitleView.width - 10, _userTitleView.height - 10) text:@"" fontSize:11 textColor:hexColor(bcbcbc) textAlignment:NSTextAlignmentLeft inView:_userTitleView];
        _userTitle.numberOfLines = 0;

        [UILabel CreateLineFrame:CGRectMake(0, cellHeight -0.5, APPWIDTH, 0.5) inView:self];
        
        
    }
    return self;
}
- (void)setModel:(DyMessageData *)data
{
    [[ToolManager shareInstance] imageView:_userIcon setImageWithURL:data.imgurl placeholderType:0];
    _userLabel.text = data.realname;
    
    if ([data.type isEqualToString:@"like"]) {
        
        _userLike.hidden = NO;
        _userContent.hidden = YES;
    }
    else
    {
        _userLike.hidden = YES;
        _userContent.hidden = NO;
        _userContent.text = data.content;
        
    }
    if (data.title_img.length>0) {
        
        _userTitleView.hidden = YES;
        _userImage.hidden = NO;
        [[ToolManager shareInstance] imageView:_userImage setImageWithURL:data.title_img placeholderType:PlaceholderTypeOther];
        
    }
    else
    {
        _userTitleView.hidden = NO;
        _userImage.hidden = YES;
        _userTitle.text = data.title;
    }
    
    _userTime.text = [data.createtime updateTime];
    
    
}
@end

@interface DyMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,assign)int page;
@property(nonatomic,strong)UITableView *dyMessageView;
@property(nonatomic,strong)NSMutableArray *dyMessageArray;
@end


@implementation DyMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navViewTitleAndBackBtn:@"动态消息"];
    _page = 1;
    [self netWorkIsRefresh:NO andShouldLoadMore:NO andShouldClearData:NO];
    [self.view addSubview:self.dyMessageView];
    
}
#pragma mark
#pragma mark - UI getter
- (NSMutableArray *)dyMessageArray
{
    if (!_dyMessageArray) {
        
        _dyMessageArray = [[NSMutableArray  alloc]init];
    }
    
    return _dyMessageArray;
}
- (UITableView *)dyMessageView
{
    if (!_dyMessageView) {
        
        _dyMessageView = [[UITableView  alloc]initWithFrame:CGRectMake(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, APPHEIGHT - (StatusBarHeight + NavigationBarHeight)) style:UITableViewStyleGrouped];
        _dyMessageView.delegate = self;
        _dyMessageView.dataSource = self;
        _dyMessageView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _dyMessageView.backgroundColor = [UIColor clearColor];
        __weak typeof(self) weakSelf = self;
        [[ToolManager shareInstance] scrollView:_dyMessageView headerWithRefreshingBlock:^{
            
            weakSelf.page=1;
            [weakSelf netWorkIsRefresh:YES andShouldLoadMore:NO andShouldClearData:YES];
            
        }];
        [[ToolManager shareInstance] scrollView:_dyMessageView footerWithRefreshingBlock:^{
           weakSelf.page +=1;
            [weakSelf netWorkIsRefresh:NO andShouldLoadMore:YES andShouldClearData:NO];
        }];
    }

    return _dyMessageView;
}
#pragma mark netWork
- (void)netWorkIsRefresh:(BOOL)isRefresh andShouldLoadMore:(BOOL)isLoadMore andShouldClearData:(BOOL)shouldClearData
{
    NSMutableDictionary *parame = [Parameter parameterWithSessicon];
    if (_dyMessageArray.count==0) {
        [[ToolManager shareInstance] showWithStatus];
    }
    [XLDataService postWithUrl:DynamicMessageURL param:parame modelClass:nil responseBlock:^(id dataObj, NSError *error) {
        if (isRefresh) {
            [[ToolManager shareInstance] endHeaderWithRefreshing:_dyMessageView];
            
        }
        if (isLoadMore) {
            [[ToolManager shareInstance]endFooterWithRefreshing:_dyMessageView];
        }
    
        if (dataObj) {
          
            DyMessageModel *model = [DyMessageModel mj_objectWithKeyValues:dataObj];
            if (model.rtcode==1) {
                [[ToolManager shareInstance] dismiss];
                if (_page==1) {
                    [[ToolManager shareInstance] moreDataStatus:_dyMessageView];
                }
                if (_page==model.allpage) {
                    [[ToolManager shareInstance] noMoreDataStatus:_dyMessageView];
                }
               
                if (shouldClearData) {
                    [_dyMessageArray removeAllObjects];
                }
                
                [_dyMessageArray addObjectsFromArray:model.datas];
                
                
            }
            else
            {
                [[ToolManager shareInstance] showInfoWithStatus:model.rtmsg];
            }
            
            [_dyMessageView reloadData];
            
            
        }
        else
        {
            
            [[ToolManager shareInstance] showInfoWithStatus];
            
        }
        
        
    }];
    
}
#pragma mark
#pragma mark -UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc]init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc]init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.dyMessageArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"DyMessageCell";
    DyMessageCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[DyMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellHeight:80 cellWidth:APPWIDTH];
    }
    [cell setModel:_dyMessageArray[indexPath.row]];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
     DyMessageData *data =  _dyMessageArray[indexPath.row];
     DynamicDetailsViewController *detail = [[DynamicDetailsViewController alloc]init];
     detail.dynamicdID = data.dynamicid;
     PushView(self, detail);
}
#pragma mark
#pragma mark back 
- (void)buttonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
