//
//  EvaluateCell.h
//  Lebao
//
//  Created by adnim on 16/10/26.
//  Copyright © 2016年 David. All rights reserved.
//

#import "TableViewCell.h"
#import "EvaluateLayout.h"
@protocol EvaluateTableViewDelegate <NSObject>
//点击头像
- (void)tableViewCellDidSeleteHeadImg:(LWImageStorage *)imageStoragen layout:(EvaluateLayout*)layout;
@end
@interface EvaluateCell : UITableViewCell
@property(nonatomic,strong)EvaluateLayout *evaluateLayout;
@property (nonatomic,strong)CALayer* lineV;
@property (nonatomic,strong)CALayer* cellline;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,weak)id <EvaluateTableViewDelegate > delegat;
@end
