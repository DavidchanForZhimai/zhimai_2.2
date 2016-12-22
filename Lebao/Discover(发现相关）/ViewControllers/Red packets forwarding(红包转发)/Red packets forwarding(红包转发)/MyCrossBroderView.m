//
//  MyCrossBroderView.m
//  Lebao
//
//  Created by David on 16/4/6.
//  Copyright © 2016年 David. All rights reserved.
//

#import "MyCrossBroderView.h"
#define cellH 130.0
#import "XLDataService.h"
#import "ToolManager.h"
#import "NSString+Extend.h"

//我的URL ：appinterface/personal
#define PersonalURL [NSString stringWithFormat:@"%@release/myreward",HttpURL]
@implementation MyCrossBroderView

- (instancetype)initWithFrame:(CGRect)frame  selectedIndex:(int)selectedIndex moneyBlock:(MoneyBlock)moneyBlock didCellBlock:(DidCellBlock)didCellBlock communityBlock:(CommunityBlock)communityBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        
       
        _selectedIndex = selectedIndex;
        _moneyBlock = moneyBlock;
        _didCellBlock = didCellBlock;
        _communityBlock = communityBlock;
         releasePage = rewardPage = 1;
        
        _myCrossBroderArray = allocAndInit(NSMutableArray);
        
        
        
        UITableView *crossBroderView = [[UITableView alloc]initWithFrame:frame(0, 0, frame.size.width, frame.size.height) style:UITableViewStyleGrouped];
        crossBroderView.separatorStyle = UITableViewCellSeparatorStyleNone;
        crossBroderView.dataSource = self;
        crossBroderView.delegate = self;
         crossBroderView.backgroundColor = [UIColor clearColor];
        [self addSubview:crossBroderView];
        
        _crossBroderView = [[UITableView alloc]initWithFrame:frame(0, 0, frame.size.width, frame.size.height) style:UITableViewStyleGrouped];
        _crossBroderView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _crossBroderView.dataSource = self;
        _crossBroderView.delegate = self;
        _crossBroderView.backgroundColor = [UIColor clearColor];
        [self addSubview:_crossBroderView];
        
        __weak MyCrossBroderView *weakSelf =self;
       
        [[ToolManager  shareInstance] scrollView:_crossBroderView headerWithRefreshingBlock:^{
            if (_selectedIndex ==1) {
                releasePage = 1;
            }
            else
            {
                rewardPage = 1;
            }
            
            [weakSelf netWorkisRefresh:YES isLoadMore:NO ShouldClearData:YES];
        }];
        [[ToolManager  shareInstance] scrollView:_crossBroderView footerWithRefreshingBlock:^{
           
            if (_selectedIndex ==1) {
                releasePage = releasepNowPage+  1;
            }
            else
            {
                rewardPage =rewardNowPage + 1;
            }
            [weakSelf netWorkisRefresh:NO isLoadMore:YES ShouldClearData:NO];
        }];
        
        [self netWorkisRefresh:NO isLoadMore:NO ShouldClearData:YES];
    }
    
    return self;
}

- (void)netWorkisRefresh:(BOOL)isRefresh isLoadMore:(BOOL)isLoadMore ShouldClearData:(BOOL)shouldClearData
{
    if (_myCrossBroderArray.count ==0) {
        [[ToolManager shareInstance] showWithStatus];
    }

    NSMutableDictionary *parameter= [Parameter parameterWithSessicon];
    [parameter setObject:@(releasePage) forKey:@"releasepage"];
     [parameter setObject:@(rewardPage) forKey:@"rewardpage"];
    [XLDataService postWithUrl:PersonalURL param:parameter modelClass:nil responseBlock:^(id dataObj, NSError *error) {
      
        if (dataObj) {
        
            if (isRefresh) {
               
                [[ToolManager shareInstance] endHeaderWithRefreshing:_crossBroderView];
                
            }
           
            if (isLoadMore) {
                [[ToolManager shareInstance] endFooterWithRefreshing:_crossBroderView];
            }
            MyCrossBroderModal *modal = [MyCrossBroderModal mj_objectWithKeyValues:dataObj];
            
            if (modal.rtcode ==1) {
                [[ToolManager shareInstance] dismiss];
                if (shouldClearData) {
                    
                    [_myCrossBroderArray removeAllObjects];
                    
                }
                
                rewardNowPage =(int) modal.reward_page;
                releasepNowPage = (int)modal.release_page;
                
                if (_moneyBlock) {
                 
                    _moneyBlock(modal.rewardreleasesum,modal.rewardforwardsum);
                }
                if (_selectedIndex ==1) {
                    
                    if (releasepNowPage ==1) {
                        
                        [[ToolManager shareInstance] moreDataStatus:_crossBroderView];
                    }
                    if (releasepNowPage == modal.release_allpage) {
                        [[ToolManager shareInstance] noMoreDataStatus:_crossBroderView];
                    }
                    
                    for (MyCrossBroderRelease *myCrossBroderRelease in  modal.myCrossBroderRelease) {
                        myCrossBroderRelease.isOpen = NO;
                        [_myCrossBroderArray addObject:myCrossBroderRelease];
                    }
                }
                else
                {
                    if (rewardNowPage ==1) {
                       
                        
                        [[ToolManager shareInstance] moreDataStatus:_crossBroderView];
                    }
                    if (rewardNowPage == modal.reward_allpage) {
                        [[ToolManager shareInstance] noMoreDataStatus:_crossBroderView];
                    }

                    for (MyCrossBroderRewardforwards *myCrossBroderRewardforwards in  modal.rewardforwards) {
                        
                        [_myCrossBroderArray addObject:myCrossBroderRewardforwards];
                    }
 
                }
                [_crossBroderView reloadData];
                
                
            }
            else
            {
                [[ToolManager shareInstance] showInfoWithStatus:modal.rtmsg];
            }
        }
        else
        {
            [[ToolManager shareInstance] showInfoWithStatus];
        }
       
    }];
    
    
    
}
- (void)isShowEmptyStatus:(BOOL)isShowEmptyStatus
{
    
    UILabel *v =[UILabel createLabelWithFrame:frame(0, StatusBarHeight + NavigationBarHeight, APPWIDTH, 50) text:@"没有相关数据" fontSize:28*SpacedFonts textColor: AppMainColor textAlignment:NSTextAlignmentCenter inView:self];
    
    v.hidden = !isShowEmptyStatus;
    
    
    
}
#pragma mark - UITableViewDelegate and UITableDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return _myCrossBroderArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellH;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view  = [[UIView alloc]init];
    if (_selectedIndex ==1) {
        MyCrossBroderRelease *myCrossBroderRelease = _myCrossBroderArray[section];
        if (myCrossBroderRelease.isOpen) {
            
            if (myCrossBroderRelease.rewardforwardinfo.count>0) {
                view.frame = CGRectMake(0, 0, APPWIDTH, 30*(myCrossBroderRelease.rewardforwardinfo.count + 1) + 4);
                
                UIView *cellView = [[UIView alloc]initWithFrame:CGRectMake(view.x, 4, APPWIDTH, view.height - 4)];
                cellView.backgroundColor = WhiteColor;
                [view addSubview:cellView];
                float cellW = APPWIDTH/4.0;
                for (int i = 0; i<myCrossBroderRelease.rewardforwardinfo.count + 1; i++) {
                    
                    
                    UIView *cell = [[UIView alloc]initWithFrame:CGRectMake(0, i*30, APPWIDTH, 30)];
                    UILabel *name =[UILabel createLabelWithFrame:CGRectMake(0, 0, cellW, cell.height) text:@"姓名" fontSize:12 textColor:BlackTitleColor textAlignment:NSTextAlignmentCenter inView:cell];
                    UILabel *gerenYX =[UILabel createLabelWithFrame:CGRectMake(cellW, 0, cellW, cell.height) text:@"个人影响" fontSize:12 textColor:BlackTitleColor textAlignment:NSTextAlignmentCenter inView:cell];
                    UILabel *zongYX =[UILabel createLabelWithFrame:CGRectMake(2*cellW, 0, cellW, cell.height) text:@"总影响" fontSize:12 textColor:BlackTitleColor textAlignment:NSTextAlignmentCenter inView:cell];
                    UILabel *zhanbi =[UILabel createLabelWithFrame:CGRectMake(3*cellW, 0, cellW, cell.height) text:@"占比(%)" fontSize:12 textColor:BlackTitleColor textAlignment:NSTextAlignmentCenter inView:cell];
                    if (i>0) {
                        Rewardforwardinfo *info =  myCrossBroderRelease.rewardforwardinfo[i-1];
                        name.text =info.realname;
                        name.textColor = hexColor(838383);
                        name.font = [UIFont systemFontOfSize:14.0];
                        
                        gerenYX.text =[NSString stringWithFormat:@"%@",info.readcount];
                        gerenYX.textColor = hexColor(838383);
                        gerenYX.font = [UIFont systemFontOfSize:14.0];
                        
                        zongYX.text =[NSString stringWithFormat:@"%ld",myCrossBroderRelease.rewardreadsum];
                        zongYX.textColor = hexColor(838383);
                        zongYX.font = [UIFont systemFontOfSize:14.0];
                        zhanbi.text =[NSString stringWithFormat:@"%@",info.ratio];
                        zhanbi.textColor = hexColor(838383);
                        zhanbi.font = [UIFont systemFontOfSize:14.0];
                        
                    }
                    
                    
                    [cellView addSubview:cell];
                }
                
                
            }
            
        }
        
    }
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return allocAndInit(UIView);
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (_selectedIndex ==1) {
        MyCrossBroderRelease *myCrossBroderRelease = _myCrossBroderArray[section];
        if (myCrossBroderRelease.isOpen) {

            if (myCrossBroderRelease.rewardforwardinfo.count>0) {
                 return 30*(myCrossBroderRelease.rewardforwardinfo.count + 1) + 4;
            }
           
        }
        
    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (_selectedIndex ==1) {
        static NSString *cellID = @"MyCrossBroderCell1";
        MyCrossBroderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[MyCrossBroderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellHeights:cellH cellWidths:frameWidth(_crossBroderView)];
        }
        
        MyCrossBroderRelease *modal = _myCrossBroderArray[indexPath.section];
            [cell setRelease:modal communityBlock:^(MyCrossBroderRewardforwards *myCrossBroderRewardforwards, MyCrossBroderRelease *myCrossBroderRelease) {
                modal.isOpen = !modal.isOpen;
                [tableView reloadData];
            }];
            return cell;

    }
    else
    {
        static NSString *cellID = @"MyCrossBroderCell0";
        MyCrossBroderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[MyCrossBroderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID cellHeight:cellH cellWidth:frameWidth(_crossBroderView)];
        }
        
        
        MyCrossBroderRewardforwards *modal = _myCrossBroderArray[indexPath.section];
            [cell setRewardforwards:modal communityBlock:^(MyCrossBroderRewardforwards *myCrossBroderRewardforwards,MyCrossBroderRelease *relese) {
                if (_communityBlock) {
                    _communityBlock(myCrossBroderRewardforwards,nil);
                }
            }];
      
        return cell;

    }

    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_didCellBlock) {
        
        if (_selectedIndex ==0) {
            MyCrossBroderRewardforwards *modal = _myCrossBroderArray[indexPath.section];
          
            _didCellBlock(nil,modal,(MyCrossBroderCell *)[tableView cellForRowAtIndexPath:indexPath]);
        }
        else
        {
            MyCrossBroderRelease *modal = _myCrossBroderArray[indexPath.section];
         
            _didCellBlock(modal,nil,(MyCrossBroderCell *)[tableView cellForRowAtIndexPath:indexPath]);
        }
        
    }
}

@end


@implementation MyCrossBroderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeight:(float)cellheight cellWidth:(float)cellWidth
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor =[UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *cell = allocAndInitWithFrame(UIView, frame(0, 10, cellWidth, cellheight - 10));
        cell.backgroundColor = WhiteColor;
        
        _cellIcon = allocAndInitWithFrame(UIImageView, frame(10, 10, 78, 57));
        [cell addSubview:_cellIcon];
     
        
        _celltitle = [DWLable createLabelWithFrame:frame(CGRectGetMaxX(_cellIcon.frame) + 10, frameY(_cellIcon),frameWidth(cell) - CGRectGetMaxX(_cellIcon.frame) - 20, 35) text:@"" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:cell];
        _celltitle.numberOfLines = 0;
        _celltitle.verticalAlignment = VerticalAlignmentTop;
        
        UIImage *image =[UIImage imageNamed:@"exhibition_redPaper"];

        _redPaper = [[BaseButton alloc]initWithFrame:frame(cellWidth - 100, CGRectGetMaxY(_celltitle.frame) + 10, 100, image.size.height)  setTitle:@"¥20" titleSize:14 titleColor:[UIColor redColor] backgroundImage:nil iconImage:image highlightImage:nil setTitleOrgin:CGPointMake(0,5) setImageOrgin:CGPointMake(0,0)  inView:cell];
        _redPaper.shouldAnmial = NO;
        _redPaper.clipsToBounds = YES;
    
        UIView *cellline = [[UIView alloc]initWithFrame:frame(0, frameHeight(cell) - 40.5, frameWidth(cell), 0.5)];
        cellline.backgroundColor = AppViewBGColor;
        [cell addSubview:cellline];
        
        UIImage *imagetime =[UIImage imageNamed:@"exhibition_createtime"];

        _time = [[BaseButton alloc]initWithFrame:frame(_celltitle.x, _redPaper.y,frameWidth(cell)/4.0, _redPaper.height)  setTitle:@"" titleSize:12 titleColor:hexColor(c9c9c9) backgroundImage:nil iconImage:imagetime highlightImage:nil setTitleOrgin:CGPointMake(0,5*ScreenMultiple) setImageOrgin:CGPointMake(0,0)  inView:cell];
        _time.shouldAnmial = NO;
        
        
        float iconW = frameWidth(cell)/3.0;
        UIImage *imageEyes =[UIImage imageNamed:@"me_mycross_icon_eyes"];
      

        _eyes = [[BaseButton alloc]initWithFrame:frame(0, frameHeight(cell) - 40,iconW, 40)  setTitle:@"0" titleSize:14 titleColor:hexColor(838383) backgroundImage:nil iconImage:imageEyes highlightImage:nil setTitleOrgin:CGPointMake((40 - imageEyes.size.height)/2.0,5) setImageOrgin:CGPointMake((40 - imageEyes.size.height)/2.0,0)  inView:cell];
        _eyes.titleLabel.textAlignment = NSTextAlignmentCenter;
        _eyes.shouldAnmial = NO;
        
        UIImage *imagemoney =[UIImage imageNamed:@"me_mycross_icon_hasreward"];
      
        _money = [[BaseButton alloc]initWithFrame:frame(iconW, _eyes.y,_eyes.width, _eyes.height)  setTitle:@"0" titleSize:14 titleColor:hexColor(838383) backgroundImage:nil iconImage:imagemoney highlightImage:nil setTitleOrgin:CGPointMake((40 - imageEyes.size.height)/2.0,5) setImageOrgin:CGPointMake((40 - imageEyes.size.height)/2.0,0)  inView:cell];
        _money.shouldAnmial = NO;

        
        
        UIImage *imagepercent =[UIImage imageNamed:@"me_mycross_icon_percent"];
       
        
        _percent = [[BaseButton alloc]initWithFrame:frame(2*iconW, _eyes.y,_eyes.width, _eyes.height)  setTitle:@"0" titleSize:14 titleColor:hexColor(838383) backgroundImage:nil iconImage:imagepercent highlightImage:nil setTitleOrgin:CGPointMake((40 - imageEyes.size.height)/2.0,5) setImageOrgin:CGPointMake((40 - imageEyes.size.height)/2.0,0)  inView:cell];
        _percent.shouldAnmial = NO;
        
        
         UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(iconW, _eyes.y + 3, 0.5, _eyes.height - 6)];
        line1.backgroundColor = AppViewBGColor;
        [cell addSubview:line1];
        
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(2*iconW, _eyes.y + 3, 0.5, _eyes.height - 6)];
        line2.backgroundColor = AppViewBGColor;
        [cell addSubview:line2];
        
        [self addSubview:cell];
        
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeights:(float)cellheight cellWidths:(float)cellWidth
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor =[UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *cell = allocAndInitWithFrame(UIView, frame(0, 10, cellWidth, cellheight - 10));
        cell.backgroundColor = WhiteColor;
        
        _cellIcon = allocAndInitWithFrame(UIImageView, frame(10, 10, 60, 60));

        [cell addSubview:_cellIcon];
        
        _celltitle = [DWLable createLabelWithFrame:frame(CGRectGetMaxX(_cellIcon.frame) + 10, frameY(_cellIcon),frameWidth(cell) - CGRectGetMaxX(_cellIcon.frame) - 20, 35) text:@"" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:cell];
        _celltitle.numberOfLines = 0;
        _celltitle.verticalAlignment = VerticalAlignmentTop;
        
        UIImage *image =[UIImage imageNamed:@"exhibition_redPaper"];
        
        _redPaper = [[BaseButton alloc]initWithFrame:frame(cellWidth - 100, CGRectGetMaxY(_celltitle.frame) + 10, 100, image.size.height)  setTitle:@"¥20" titleSize:14 titleColor:[UIColor redColor] backgroundImage:nil iconImage:image highlightImage:nil setTitleOrgin:CGPointMake(0,5) setImageOrgin:CGPointMake(0,0)  inView:cell];
        _redPaper.shouldAnmial = NO;
        _redPaper.clipsToBounds = YES;
        
        
        
        UIView *cellline = [[UIView alloc]initWithFrame:frame(0, frameHeight(cell) - 40.5, frameWidth(cell), 0.5)];
        cellline.backgroundColor = AppViewBGColor;
        [cell addSubview:cellline];
        
        
        UIImage *imagetime =[UIImage imageNamed:@"exhibition_createtime"];
        
        _time = [[BaseButton alloc]initWithFrame:frame(_celltitle.x, _redPaper.y,frameWidth(cell)/4.0, _redPaper.height)  setTitle:@"" titleSize:12 titleColor:hexColor(c9c9c9) backgroundImage:nil iconImage:imagetime highlightImage:nil setTitleOrgin:CGPointMake(0,5*ScreenMultiple) setImageOrgin:CGPointMake(0,0)  inView:cell];
        _time.shouldAnmial = NO;
        float iconW = frameWidth(cell)/2.0;
        
        
        UIImage *imageShare =[UIImage imageNamed:@"exhibition_clueNum"];
        
        _share = [[BaseButton alloc]initWithFrame:frame(0, frameHeight(cell) - 40,iconW, 40)  setTitle:@"0" titleSize:14 titleColor:hexColor(838383) backgroundImage:nil iconImage:imageShare highlightImage:nil setTitleOrgin:CGPointMake((40 - imageShare.size.height)/2.0,5) setImageOrgin:CGPointMake((40 - imageShare.size.height)/2.0,0)  inView:cell];
        _share.shouldAnmial = NO;
        
        
        UIImage *imageEyes =[UIImage imageNamed:@"me_mycross_icon_eyes"];
        
        
        _eyes = [[BaseButton alloc]initWithFrame:frame(iconW,_share.y,_share.width, _share.height)  setTitle:@"0" titleSize:14 titleColor:hexColor(838383) backgroundImage:nil iconImage:imageEyes highlightImage:nil setTitleOrgin:CGPointMake((40 - imageEyes.size.height)/2.0,5) setImageOrgin:CGPointMake((40 - imageEyes.size.height)/2.0,0)  inView:cell];
        _eyes.titleLabel.textAlignment = NSTextAlignmentCenter;
        _eyes.shouldAnmial = NO;
        
        

        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(iconW - 0.5, _eyes.y + 3, 0.5, _eyes.height - 6)];
        line2.backgroundColor = AppViewBGColor;
        [cell addSubview:line2];
        
        [self addSubview:cell];
        
    }
    
    return self;
}
- (void)setRewardforwards:(MyCrossBroderRewardforwards *)modal communityBlock:(CommunityBlock)communityBlock
{
    [[ToolManager shareInstance] imageView:_cellIcon setImageWithURL:modal.imgurl placeholderType:PlaceholderTypeImageProcessing];
    _celltitle.text = modal.title;
    
    NSString *_timeStr;
    if ([[[NSString stringWithFormat:@"%i",(int)modal.createtime] countdownFormTimeInterval] intValue] ==-1) {
        _timeStr = @"已结束";
        [_time setTitle:_timeStr forState:UIControlStateNormal];
        [_time setImage:nil forState:UIControlStateNormal];
        [_time textCenter];
    }
    else
    {
        _timeStr =[[NSString stringWithFormat:@"%i",(int)modal.createtime] countdownFormTimeInterval];
        [_time setTitle:_timeStr forState:UIControlStateNormal];
        [_time setImage:[UIImage imageNamed:@"exhibition_createtime"] forState:UIControlStateNormal];
//         [_time textAndImageCenter];
        
    }
    
    [_redPaper setTitle:[NSString stringWithFormat:@"%@",modal.reward_article] forState:UIControlStateNormal];

    [_communicationsBtn setTitle:[NSString stringWithFormat:@"(%@)",modal.comsum] forState:UIControlStateNormal];
    _communicationsBtn.didClickBtnBlock = ^
    {
        communityBlock(modal,nil);
    };
    [_eyes setTitle:[NSString stringWithFormat:@"%i",(int)modal.readcount] forState:UIControlStateNormal];
    [_eyes textAndImageCenter];
    [_percent setTitle:[NSString stringWithFormat:@"%i",(int)modal.ratio] forState:UIControlStateNormal];
    [_percent textAndImageCenter];
    [_money setTitle:[NSString stringWithFormat:@"%.2f",modal.reward] forState:UIControlStateNormal];
     [_money textAndImageCenter];
    
}
- (void)setRelease:(MyCrossBroderRelease *)modal communityBlock:(CommunityBlock)communityBlock
{
    [[ToolManager shareInstance] imageView:_cellIcon setImageWithURL:modal.imgurl placeholderType:PlaceholderTypeImageProcessing];
    _celltitle.text = modal.title;
    
    NSString *_timeStr;
    if ([[[NSString stringWithFormat:@"%i",(int)modal.createtime] countdownFormTimeInterval] intValue] ==-1) {
        _timeStr = @"已结束";
        [_time setTitle:_timeStr forState:UIControlStateNormal];
        [_time setImage:nil forState:UIControlStateNormal];
        [_time textCenter];
    }
    else
    {
        _timeStr =[[NSString stringWithFormat:@"%i",(int)modal.createtime] countdownFormTimeInterval];
        [_time setTitle:_timeStr forState:UIControlStateNormal];
        [_time setImage:[UIImage imageNamed:@"exhibition_createtime"] forState:UIControlStateNormal];
//        [_time textAndImageCenter];
        
    }
    
    [_redPaper setTitle:[NSString stringWithFormat:@"%@",modal.reward_article] forState:UIControlStateNormal];
    
    
    [_communicationsBtn setTitle:[NSString stringWithFormat:@"(%@)",modal.comsum] forState:UIControlStateNormal];
    

    [_eyes setTitle:[NSString stringWithFormat:@"%i",(int)modal.rewardreadsum] forState:UIControlStateNormal];
    [_eyes textAndImageCenter];
    [_share setTitle:[NSString stringWithFormat:@"%ld",modal.rewardforwardcount] forState:UIControlStateNormal];
    _share.didClickBtnBlock = ^
    {
        communityBlock(nil,modal);
    };
    if (!modal.isOpen) {
        [_share setImage:[UIImage imageNamed:@"exhibition_clueNum"] forState:UIControlStateNormal];
        [_share setBackgroundColor:WhiteColor];
    }
    else
    {
        [_share setImage:[UIImage imageNamed:@"exhibition_clueNum_selected"] forState:UIControlStateNormal];
        [_share setBackgroundColor:AppViewBGColor];
    }
    [_share textAndImageCenter];
}
@end


@implementation MyCrossBroderModal


+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"myCrossBroderRelease" : @"release",
             };
}

+ (NSDictionary *)mj_objectClassInArray
{
    
    
    return @{
             @"myCrossBroderRelease":@"MyCrossBroderRelease",
             @"rewardforwards":@"MyCrossBroderRewardforwards",
             };

}

@end

@implementation Rewardforwardinfo


@end
@implementation MyCrossBroderRelease
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}

+ (NSDictionary *)mj_objectClassInArray
{
    
    return @{
             @"rewardforwardinfo":@"Rewardforwardinfo",
             };
    
}

@end


@implementation MyCrossBroderRewardforwards

@end




