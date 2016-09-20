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
                
                
                if (_myCrossBroderArray.count==0) {
                    [self isShowEmptyStatus:YES];
                }
                else
                {
                    [self isShowEmptyStatus:NO];
                    
                }
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
    return _myCrossBroderArray.count;
}

 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellH;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return allocAndInit(UIView);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return allocAndInit(UIView);
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
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
        
    
        MyCrossBroderRelease *modal = _myCrossBroderArray[indexPath.row];
            [cell setRelease:modal communityBlock:^(MyCrossBroderRewardforwards *myCrossBroderRewardforwards, MyCrossBroderRelease *myCrossBroderRelease) {
                if (_communityBlock) {
                    _communityBlock(nil,myCrossBroderRelease);
                }
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
        
        
        MyCrossBroderRewardforwards *modal = _myCrossBroderArray[indexPath.row];
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
            MyCrossBroderRewardforwards *modal = _myCrossBroderArray[indexPath.row];
          
            _didCellBlock(nil,modal,(MyCrossBroderCell *)[tableView cellForRowAtIndexPath:indexPath]);
        }
        else
        {
            MyCrossBroderRelease *modal = _myCrossBroderArray[indexPath.row];
         
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
        UIView *cell = allocAndInitWithFrame(UIView, frame(7, 10, cellWidth - 14, cellheight - 10));
        cell.backgroundColor = WhiteColor;
//        [cell setRadius:8.0];
        
        _cellIcon = allocAndInitWithFrame(UIImageView, frame(10, 10, 60, 60));
        [cell addSubview:_cellIcon];
        [_cellIcon setRadius:5];
        
        _celltitle = [DWLable createLabelWithFrame:frame(CGRectGetMaxX(_cellIcon.frame) + 10, frameY(_cellIcon),frameWidth(cell) - CGRectGetMaxX(_cellIcon.frame) - 20, 35) text:@"" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:cell];
        _celltitle.numberOfLines = 0;
        _celltitle.verticalAlignment = VerticalAlignmentTop;
        
        UIImage *image =[UIImage imageNamed:@"exhibition_redPaper"];
        CGSize sizebrowse = [_celltitle sizeWithContent:@"¥2015" font:[UIFont systemFontOfSize:22*SpacedFonts]];
        
        _redPaper = [[BaseButton alloc]initWithFrame:frame(frameX(_celltitle), CGRectGetMaxY(_celltitle.frame) + 10, image.size.width + 5 + sizebrowse.width, image.size.height)  setTitle:@"¥20" titleSize:22*SpacedFonts titleColor:[UIColor redColor] backgroundImage:nil iconImage:image highlightImage:nil setTitleOrgin:CGPointMake(1,5) setImageOrgin:CGPointMake(0,0)  inView:cell];
        _redPaper.shouldAnmial = NO;

        
        UIImage *_communicationImgs =[UIImage imageNamed:@"across_home_communication"];
        CGSize size  =[[NSString stringWithFormat:@"(1234)"] sizeWithFont:Size(20) maxSize:CGSizeMake(0, _communicationImgs.size.height)];
        
        _communicationsBtn = [[BaseButton alloc]initWithFrame:frame(cellWidth - 25- size.width - _communicationImgs.size.width, frameY(_redPaper), 15 +size.width + _communicationImgs.size.width , _communicationImgs.size.height) setTitle:@"(20)" titleSize:20*SpacedFonts titleColor:LightBlackTitleColor backgroundImage:nil iconImage:_communicationImgs highlightImage:nil setTitleOrgin:CGPointMake(0, 17) setImageOrgin:CGPointMake(0, 10 ) inView:cell ];
        _communicationsBtn.exclusiveTouch = YES;

        
        [UILabel CreateLineFrame:frame(0, frameHeight(cell) - 40, frameWidth(cell), 0.5) inView:cell];
        
        
        UIImage *imagetime =[UIImage imageNamed:@"exhibition_createtime"];
        UILabel *time =allocAndInit(UILabel);
        CGSize sizeTime = [time sizeWithContent:@" 22:00 " font:[UIFont systemFontOfSize:22*SpacedFonts]];
        
        _time = [[BaseButton alloc]initWithFrame:frame(0, frameHeight(cell) - 40,frameWidth(cell)/4.0, 40)  setTitle:@"" titleSize:22*SpacedFonts titleColor:LightBlackTitleColor backgroundImage:nil iconImage:imagetime highlightImage:nil setTitleOrgin:CGPointMake(imagetime.size.height,5 - image.size.width) setImageOrgin:CGPointMake(0,(sizeTime.width - imagetime.size.width)/2.0)  inView:cell];
        _time.shouldAnmial = NO;
        
        
        UIImage *imageEyes =[UIImage imageNamed:@"me_mycross_icon_eyes"];
        CGSize sizeEyes = [_celltitle sizeWithContent:@"0" font:[UIFont systemFontOfSize:22*SpacedFonts]];
        
        _eyes = [[BaseButton alloc]initWithFrame:frame(frameWidth(cell)/4.0, frameHeight(cell) - 40,frameWidth(cell)/4.0, 40)  setTitle:@"0" titleSize:22*SpacedFonts titleColor:LightBlackTitleColor backgroundImage:nil iconImage:imageEyes highlightImage:nil setTitleOrgin:CGPointMake(10 + imageEyes.size.height,(frameWidth(cell)/4.0 - sizeEyes.width)/2.0 - imageEyes.size.width) setImageOrgin:CGPointMake(10,(frameWidth(cell)/4.0 - sizeEyes.width)/2.0)  inView:cell];
        _eyes.titleLabel.textAlignment = NSTextAlignmentCenter;
        _eyes.shouldAnmial = NO;
        
        
        UIImage *imagepercent =[UIImage imageNamed:@"me_mycross_icon_percent"];
        CGSize sizepercent = [_celltitle sizeWithContent:@"0" font:[UIFont systemFontOfSize:22*SpacedFonts]];
        
        _percent = [[BaseButton alloc]initWithFrame:frame(2*frameWidth(cell)/4.0, frameHeight(cell) - 40,frameWidth(cell)/4.0, 40)  setTitle:@"0" titleSize:22*SpacedFonts titleColor:LightBlackTitleColor backgroundImage:nil iconImage:imagepercent highlightImage:nil setTitleOrgin:CGPointMake(10 + imagepercent.size.height,(frameWidth(cell)/4.0 - sizepercent.width)/2.0 - imagepercent.size.width) setImageOrgin:CGPointMake(10,(frameWidth(cell)/4.0 - sizepercent.width)/2.0)  inView:cell];
        _percent.shouldAnmial = NO;
        
        UIImage *imagemoney =[UIImage imageNamed:@"me_mycross_icon_hasreward_momey"];
        CGSize sizemoney = [_celltitle sizeWithContent:@"0" font:[UIFont systemFontOfSize:22*SpacedFonts]];
        
        _money = [[BaseButton alloc]initWithFrame:frame(3*frameWidth(cell)/4.0, frameHeight(cell) - 40,frameWidth(cell)/4.0, 40)  setTitle:@"0" titleSize:22*SpacedFonts titleColor:LightBlackTitleColor backgroundImage:nil iconImage:imagemoney highlightImage:nil setTitleOrgin:CGPointMake(10 + imagemoney.size.height,(frameWidth(cell)/4.0 - sizemoney.width)/2.0 - imagemoney.size.width) setImageOrgin:CGPointMake(10,(frameWidth(cell)/4.0 - sizemoney.width)/2.0)  inView:cell];
        _money.shouldAnmial = NO;
        
        [self addSubview:cell];
        
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellHeights:(float)cellheight cellWidths:(float)cellWidth
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor =[UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *cell = allocAndInitWithFrame(UIView, frame(7, 10, cellWidth - 14, cellheight - 10));
        cell.backgroundColor = WhiteColor;
//        [cell setRadius:8.0];
        
        _cellIcon = allocAndInitWithFrame(UIImageView, frame(10, 10, 60, 60));
        [_cellIcon setRadius:5];
        [cell addSubview:_cellIcon];
        
        _celltitle = [DWLable createLabelWithFrame:frame(CGRectGetMaxX(_cellIcon.frame) + 10, frameY(_cellIcon),frameWidth(cell) - CGRectGetMaxX(_cellIcon.frame) - 20, 35) text:@"" fontSize:28*SpacedFonts textColor:BlackTitleColor textAlignment:NSTextAlignmentLeft inView:cell];
        _celltitle.numberOfLines = 0;
        _celltitle.verticalAlignment = VerticalAlignmentTop;
        
        UIImage *image =[UIImage imageNamed:@"exhibition_redPaper"];
        CGSize sizebrowse = [_celltitle sizeWithContent:@"¥2015" font:[UIFont systemFontOfSize:22*SpacedFonts]];
        
        _redPaper = [[BaseButton alloc]initWithFrame:frame(frameX(_celltitle), CGRectGetMaxY(_celltitle.frame) + 10, image.size.width + 5 + sizebrowse.width, image.size.height)  setTitle:@"¥20" titleSize:22*SpacedFonts titleColor:[UIColor redColor] backgroundImage:nil iconImage:image highlightImage:nil setTitleOrgin:CGPointMake(1,5) setImageOrgin:CGPointMake(0,0)  inView:cell];
        _redPaper.shouldAnmial = NO;
        
        
        UIImage *_communicationImgs =[UIImage imageNamed:@"across_home_communication"];
        CGSize size  =[[NSString stringWithFormat:@"(1234)"] sizeWithFont:Size(20) maxSize:CGSizeMake(0, _communicationImgs.size.height)];
        
        _communicationsBtn = [[BaseButton alloc]initWithFrame:frame(cellWidth - 25- size.width - _communicationImgs.size.width, frameY(_redPaper), 15 +size.width + _communicationImgs.size.width , _communicationImgs.size.height) setTitle:@"(20)" titleSize:20*SpacedFonts titleColor:LightBlackTitleColor backgroundImage:nil iconImage:_communicationImgs highlightImage:nil setTitleOrgin:CGPointMake(0, 17) setImageOrgin:CGPointMake(0, 10 ) inView:cell ];
        _communicationsBtn.exclusiveTouch = YES;
        
        
        [UILabel CreateLineFrame:frame(0, frameHeight(cell) - 40, frameWidth(cell), 0.5) inView:cell];
        
        
        UIImage *imagetime =[UIImage imageNamed:@"exhibition_createtime"];
//        UILabel *time =allocAndInit(UILabel);
        
        _time = [[BaseButton alloc]initWithFrame:frame(0, frameHeight(cell) - 40,frameWidth(cell)/3.0, 40)  setTitle:@"" titleSize:22*SpacedFonts titleColor:LightBlackTitleColor backgroundImage:nil iconImage:imagetime highlightImage:nil setTitleOrgin:CGPointMake(0,5) setImageOrgin:CGPointMake(0,0)  inView:cell];
        _time.shouldAnmial = NO;
        
        UIImage *imagepercent =[UIImage imageNamed:@"exhibition_clueNum"];
        CGSize sizepercent = [_celltitle sizeWithContent:@"0" font:[UIFont systemFontOfSize:22*SpacedFonts]];
        
        _share = [[BaseButton alloc]initWithFrame:frame(frameWidth(cell)/3.0, frameHeight(cell) - 40,frameWidth(cell)/3.0, 40)  setTitle:@"0" titleSize:22*SpacedFonts titleColor:LightBlackTitleColor backgroundImage:nil iconImage:imagepercent highlightImage:nil setTitleOrgin:CGPointMake(10 + imagepercent.size.height,(frameWidth(cell)/3.0 - sizepercent.width)/2.0 - imagepercent.size.width) setImageOrgin:CGPointMake(10,(frameWidth(cell)/3.0 - sizepercent.width)/2.0)  inView:cell];
        _share.shouldAnmial = NO;
        
    
        UIImage *imageEyes =[UIImage imageNamed:@"me_mycross_icon_eyes"];
        CGSize sizeEyes = [_celltitle sizeWithContent:@"0" font:[UIFont systemFontOfSize:22*SpacedFonts]];
        
        _eyes = [[BaseButton alloc]initWithFrame:frame(2*frameWidth(cell)/3.0, frameHeight(cell) - 40,frameWidth(cell)/3.0, 40)  setTitle:@"0" titleSize:22*SpacedFonts titleColor:LightBlackTitleColor backgroundImage:nil iconImage:imageEyes highlightImage:nil setTitleOrgin:CGPointMake(10 + imageEyes.size.height,(frameWidth(cell)/3.0 - sizeEyes.width)/2.0 - imageEyes.size.width) setImageOrgin:CGPointMake(10,(frameWidth(cell)/3.0 - sizeEyes.width)/2.0)  inView:cell];
        _eyes.shouldAnmial = NO;
        
        
        
        
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
         [_time textAndImageCenter];
        
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
        [_time textAndImageCenter];
        
    }
    
    [_redPaper setTitle:[NSString stringWithFormat:@"%@",modal.reward_article] forState:UIControlStateNormal];
    
    
    [_communicationsBtn setTitle:[NSString stringWithFormat:@"(%@)",modal.comsum] forState:UIControlStateNormal];
    _communicationsBtn.didClickBtnBlock = ^
    {
        communityBlock(nil,modal);
    };
//    [_communicationsBtn setTitle:[NSString stringWithFormat:@"(%@)",modal.comsum] forState:UIControlStateNormal];
    [_eyes setTitle:[NSString stringWithFormat:@"%i",(int)modal.rewardreadsum] forState:UIControlStateNormal];
    [_eyes textAndImageCenter];
    [_share setTitle:[NSString stringWithFormat:@"%.2f",(float)modal.rewardforwardcount] forState:UIControlStateNormal];
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
@implementation MyCrossBroderRelease
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}

@end


@implementation MyCrossBroderRewardforwards

@end




