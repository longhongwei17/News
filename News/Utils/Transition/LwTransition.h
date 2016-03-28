//
//  LwTransition.h
//  News
//
//  Created by longhongwei on 16/3/23.
//  Copyright © 2016年 longhongwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LwDetectScrollViewEndGestureRecognizer.h"

@interface LwTransition :UIPercentDrivenInteractiveTransition <UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning,UIGestureRecognizerDelegate>

@property (nonatomic, getter=isDragable) BOOL dragable;

@property (nonatomic, readonly)LwDetectScrollViewEndGestureRecognizer *gesture;

@property (nonatomic, assign) UIGestureRecognizer *gestureRecognizerToFailPan;

@property (nonatomic) BOOL bounces;

@property (nonatomic) CGFloat behindViewScale;

@property (nonatomic) CGFloat behindViewAlpha;

@property (nonatomic) CGFloat transitionDuration;


- (instancetype)initWithModalViewController:(UIViewController *)modalViewController;

- (void)setContentScrollView:(UIScrollView *)scrollView;

@end
