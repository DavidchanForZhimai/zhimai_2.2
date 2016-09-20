//
//  WantMeetTabCell.h
//  Lebao
//
//  Created by adnim on 16/9/12.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WantMeetLayout.h"
@protocol MeettingTableViewDelegate <NSObject>

//约见按钮
- (void)tableViewCellDidSeleteMeetingBtn:(UIButton *)btn andIndexPath:(NSIndexPath *)indexPath;
//语音按钮
- (void)tableViewCellDidSeleteAudioBtn:(UIButton *)btn andIndexPath:(NSIndexPath *)indexPath;
//电话按钮
- (void)tableViewCellDidSeleteTelBtn:(UIButton *)btn andIndexPath:(NSIndexPath *)indexPath;
//对话按钮
- (void)tableViewCellDidSeleteMessageBtn:(UIButton *)btn andIndexPath:(NSIndexPath *)indexPath;
@end

@interface WantMeetTabCell : UITableViewCell
@property(nonatomic,strong)WantMeetLayout *cellLayout;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,strong)UIButton *meetingBtn;//约见
@property (nonatomic,strong)UIButton *audioBtn;
@property (nonatomic,strong)UIButton *telBtn;//电话
@property (nonatomic,strong)UIButton *messageBtn;//短信
@property(nonatomic,weak)id <MeettingTableViewDelegate > delegate;

@end
