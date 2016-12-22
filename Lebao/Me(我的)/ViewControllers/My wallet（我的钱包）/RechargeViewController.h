//
//  RechargeViewController.h
//  Lebao
//
//  Created by David on 2016/12/22.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"
typedef void (^MoneyPayCallBack)(float money);
@interface RechargeViewController : BaseViewController
@property(nonatomic,copy)MoneyPayCallBack moneyPayCallBack;
@end
