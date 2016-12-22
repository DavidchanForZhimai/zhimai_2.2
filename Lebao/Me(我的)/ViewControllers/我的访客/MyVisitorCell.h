//
//  MyVisitorCell.h
//  Lebao
//
//  Created by adnim on 2016/12/19.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYText.h>
#import "MeetingModel.h"
@interface MyVisitorCell : UITableViewCell

@property (nonatomic,strong)YYLabel *nameLab;
@property (nonatomic,strong)UIImageView *headImgV;
@property (nonatomic,strong)YYLabel *positionAndYearsLab;
@property (nonatomic,strong)YYLabel *companyLab;
@property (nonatomic,strong)YYLabel *timeLab;
@property (nonatomic,strong)UIImageView *renzhImg;
@property (nonatomic,strong)UIImageView *vipImg;

-(void)configCellWithModel:(MeetingModel *)model;
@end
