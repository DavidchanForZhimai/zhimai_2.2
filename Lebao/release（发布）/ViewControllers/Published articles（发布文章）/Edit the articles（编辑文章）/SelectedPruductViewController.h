//
//  SelectedPruductViewController.h
//  Lebao
//
//  Created by David on 16/6/23.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^SelectedPruductSureBlock) (NSDictionary *dic);

@interface SelectedPruductViewController : BaseViewController
@property(nonatomic,strong)NSArray *selectedPruductArray;
@property(nonatomic,copy)SelectedPruductSureBlock selectedPruductSureBlock;
@end

@interface SelectedPruductCell : UITableViewCell
@property(nonatomic,strong)UIImageView *cellImage;
@property(nonatomic,strong)UILabel *cellTitle;
@end