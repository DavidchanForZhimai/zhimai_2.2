//
//  NavRootViewController.m
//  Lebao
//
//  Created by David on 2016/11/11.
//  Copyright © 2016年 David. All rights reserved.
//

#import "NavRootViewController.h"
#import "BaseViewController.h"
@interface NavRootViewController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>
 @property(nonatomic,weak) BaseViewController* currentShowVC;
@end

@implementation NavRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.interactivePopGestureRecognizer.delegate =(id)self;
    // Do any additional setup after loading the view.
}
-(id)initWithRootViewController:(UIViewController *)rootViewController
{
    NavRootViewController* nvc = [super initWithRootViewController:rootViewController];
    self.interactivePopGestureRecognizer.delegate = self;
    nvc.delegate = self;
    return nvc;
}
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
}
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (navigationController.viewControllers.count == 1)
        self.currentShowVC = Nil;
    else
        self.currentShowVC = (BaseViewController *)viewController;
}
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        return (self.currentShowVC == self.topViewController); //the most important
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
