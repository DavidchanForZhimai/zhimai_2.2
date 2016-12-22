//
//  RecommendView.h
//  Lebao
//
//  Created by adnim on 2016/12/19.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYText.h>
#import "MeetingModel.h"
@protocol RecommendViewDelegate <NSObject>

-(void)didSelectRecommendViewWithModel:(MeetingData *)data;

@end

@interface RecommendView : UIView

@property(nonatomic,strong)UIImageView *headView;
@property(nonatomic,strong)YYLabel *nameLab;
@property(nonatomic,strong)YYLabel *positionLab;
@property(nonatomic,strong)MeetingData *data;
@property(nonatomic,weak)id<RecommendViewDelegate> delegate;
-(void)configWithData:(MeetingData *)data;
@end
