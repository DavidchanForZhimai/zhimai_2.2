//
//  PublishDynamicVC.h
//  Lebao
//
//  Created by adnim on 16/8/1.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseButton.h"
typedef void (^FaBuSucceedBlock) (void);
@interface PublishDynamicVC : UIViewController
@property (strong,nonatomic)UIScrollView *svMain;           //背景滚动式图
@property (strong,nonatomic)UIView *viewBg;                 //上面的文本背景
@property (strong,nonatomic)UIView *viewlin;                 //上面的线
@property (strong,nonatomic)UITextView *tfView;             //文本输入
@property (strong,nonatomic)NSMutableArray *phonelist;      //图片数组
@property (strong,nonatomic)UIButton *btnAddPhone;          //添加照片
@property (strong,nonatomic)FaBuSucceedBlock faBuSucceedBlock;//发布成功
@property (strong,nonatomic)BaseButton *hotTopicBtn;            //话题按钮
@end
