//
//  MeetPaydingVC.h
//  Lebao
//
//  Created by adnim on 16/9/12.
//  Copyright © 2016年 David. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SucceedBlock)(BOOL succeed);
@interface MeetPaydingVC : UIViewController
@property (nonatomic,copy)SucceedBlock succeedBlock;


@property (weak, nonatomic) IBOutlet UILabel *dingjinLab;//定金
@property (weak, nonatomic) IBOutlet UIImageView *zhimaiImg;//图片
@property (weak, nonatomic) IBOutlet UILabel *yueLab;//余额
@property (weak, nonatomic) IBOutlet UIImageView *wxImg;
@property (strong,nonatomic) NSString * jineStr;//金额
@property (weak, nonatomic) IBOutlet UIButton *zhifuBtn;//支付按钮
- (IBAction)zhifuAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *zhimaiV;
@property (weak, nonatomic) IBOutlet UIView *weixinV;
@property (assign,nonatomic)int zfymType;
@property (assign,nonatomic)int whatZfType;//什么页面的支付
@property (strong,nonatomic) NSData *audioData;
@property (nonatomic,strong)NSMutableDictionary *param;
@property (nonatomic,strong)NSString *tel;
@property (nonatomic,strong)NSString *realname;
@end
