//
//  BaseViewController.m
//  News
//
//  Created by longhongwei on 16/3/28.
//  Copyright © 2016年 longhongwei. All rights reserved.
//

#import "BaseViewController.h"
#import "LwTransition.h"

@interface BaseViewController ()

@property (nonatomic, strong) LwTransition *animator;

@end

@implementation BaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}



- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    
    UIViewController *modalVC = viewControllerToPresent;

    modalVC.modalPresentationStyle = UIModalPresentationFullScreen;
    
    self.animator = [[LwTransition alloc] initWithModalViewController:modalVC];
    self.animator.dragable = YES;
    self.animator.bounces = NO;
    self.animator.behindViewAlpha = 0.5f;
    self.animator.behindViewScale = 0.9;
    self.animator.transitionDuration = 0.3f;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.animator setContentScrollView:[UIScrollView new]];
    });

    modalVC.transitioningDelegate = self.animator;

    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
 
}

@end
