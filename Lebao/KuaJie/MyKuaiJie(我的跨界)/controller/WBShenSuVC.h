//
//  WBShenSuVC.h
//  KuaJie
//
//  Created by 严文斌 on 16/5/25.
//  Copyright © 2016年 严文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBShenSuVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *pyText;
@property (weak, nonatomic) IBOutlet UIButton *quedBtn;
- (IBAction)quedingAction:(id)sender;
@property (strong,nonatomic)NSString * xsID;
@end
