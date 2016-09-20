//
//  DiscoverTabViewController.h
//  Lebao
//
//  Created by David on 15/12/7.
//  Copyright © 2015年 David. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger,IndustryTag) {
    
    IndustryTagInsurance,
    IndustryTagFinance,
    IndustryTagProperty,
    IndustryTagOther
    
};
@interface DiscoverTabViewController : BaseViewController
@property (nonatomic,assign)IndustryTag selected;
@end
