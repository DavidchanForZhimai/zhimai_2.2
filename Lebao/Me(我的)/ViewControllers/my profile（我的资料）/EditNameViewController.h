//
//  EditNameViewController.h
//  Lebao
//
//  Created by David on 16/1/28.
//  Copyright © 2016年 David. All rights reserved.
//

#import "BaseViewController.h"
typedef enum {
   EditNamePageTag,
   EditPhoneNumPageTag,
   EditIntroducePageTag,
   EditCompanyTag,
   EditWorkYearsPageTag,
   EditeTag
}EditPageTag;
typedef void (^EditBlock)(NSString *text);
@interface EditNameViewController : BaseViewController
@property(nonatomic,assign)EditPageTag editPageTag;
@property(nonatomic,copy)EditBlock editBlock;
@property(nonatomic,strong)NSString *textView;
@end
