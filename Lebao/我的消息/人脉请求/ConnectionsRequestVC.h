//
//  ConnectionsRequestVC.h
//  Lebao
//
//  Created by adnim on 16/9/20.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ConnectionsRequestBlcok)();
@interface ConnectionsRequestVC : BaseViewController
@property(nonatomic,copy)ConnectionsRequestBlcok succeedBlock;
@end
