//
//  LwTransition.m
//  News
//
//  Created by longhongwei on 16/3/23.
//  Copyright © 2016年 longhongwei. All rights reserved.
//

#import "LwTransition.h"

@interface LwTransition ()

@property (nonatomic, weak) UIViewController *modalVC;

@property (nonatomic, strong) LwDetectScrollViewEndGestureRecognizer *gesture;

@property (nonatomic, strong) id<UIViewControllerContextTransitioning> trainsiontContext;

@property (nonatomic) CGFloat panLocationStart;

@property (nonatomic) BOOL isDismiss;

@property (nonatomic) BOOL isInteractive;

@property (nonatomic) CATransform3D tmpTransform;

@end


@implementation LwTransition

- (instancetype)initWithModalViewController:(UIViewController *)modalViewController
{
    self = [super init];
    
    if (self) {
        
        self.modalVC = modalViewController;
        self.dragable = NO;
        self.bounces = YES;
        self.behindViewAlpha = 0.9f;
        self.behindViewScale = 1.0f;
        self.transitionDuration = 0.8f;
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    
}


#pragma mark - setter

- (void)setDragable:(BOOL)dragable
{
    _dragable = dragable;
    if (_dragable) {
        [self removeGestureRecognizerFromModalVC];
        self.gesture = [[LwDetectScrollViewEndGestureRecognizer alloc] initWithTarget:self action:@selector(handPan:)];
        self.gesture.delegate = self;
        [self.modalVC.view addGestureRecognizer:self.gesture];
    }else{
        [self removeGestureRecognizerFromModalVC];
    }
}

- (void)setContentScrollView:(UIScrollView *)scrollView
{
    if (!self.dragable) {
        self.dragable = YES;
    }
    self.gesture.scrollView = scrollView;
}



- (void)removeGestureRecognizerFromModalVC
{
    if (self.gesture && [self.modalVC.view.gestureRecognizers containsObject:self.gesture]) {
        [self.modalVC.view removeGestureRecognizer:self.gesture];
        self.gesture = nil;
    }
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return self.transitionDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.isInteractive) {
        return;
    }
    // Grab the from and to view controllers from the context
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    
    if (!self.isDismiss) {
        
        CGRect startRect;
        
        [containerView addSubview:toVc.view];
        
        toVc.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        
        startRect = CGRectMake(CGRectGetWidth(containerView.frame),
                               0,
                               CGRectGetWidth(containerView.bounds),
                               CGRectGetHeight(containerView.bounds));
        
        
        CGPoint transformedPoint = CGPointApplyAffineTransform(startRect.origin, toVc.view.transform);
        toVc.view.frame = CGRectMake(transformedPoint.x, transformedPoint.y, startRect.size.width, startRect.size.height);
        
        if (toVc.modalPresentationStyle == UIModalPresentationCustom) {
            [fromVC beginAppearanceTransition:NO animated:YES];
        }
        
        [UIView animateWithDuration:self.transitionDuration delay:0.F options:UIViewAnimationOptionCurveEaseInOut animations:^{
            fromVC.view.transform = CGAffineTransformScale(fromVC.view.transform, self.behindViewScale, self.behindViewScale);
            fromVC.view.alpha = self.behindViewAlpha;
            
            toVc.view.frame = CGRectMake(0,0,CGRectGetWidth(toVc.view.frame),CGRectGetHeight(toVc.view.frame));
        } completion:^(BOOL finished) {
            if (toVc.modalPresentationStyle == UIModalPresentationCustom) {
                [fromVC endAppearanceTransition];
            }
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
        
    } else {
        
        if (fromVC.modalPresentationStyle == UIModalPresentationFullScreen) {
            [containerView addSubview:toVc.view];
        }
        
        [containerView bringSubviewToFront:fromVC.view];
        
        if (![self isPriorToIOS8]) {
            toVc.view.layer.transform = CATransform3DScale(toVc.view.layer.transform, self.behindViewScale, self.behindViewScale, 1);
        }
        
        toVc.view.alpha = self.behindViewAlpha;
        
        CGRect endRect;
        
        endRect = CGRectMake(CGRectGetWidth(fromVC.view.bounds),0,CGRectGetWidth(fromVC.view.frame),CGRectGetHeight(fromVC.view.frame));
        
        CGPoint transformedPoint = CGPointApplyAffineTransform(endRect.origin, fromVC.view.transform);
        endRect = CGRectMake(transformedPoint.x, transformedPoint.y, endRect.size.width, endRect.size.height);
        
        if (fromVC.modalPresentationStyle == UIModalPresentationCustom) {
            [toVc beginAppearanceTransition:YES animated:YES];
        }
        
        [UIView animateWithDuration:self.transitionDuration delay:0.F options:UIViewAnimationOptionCurveEaseInOut animations:^{
            CGFloat scaleBack = (1 / self.behindViewScale);
            toVc.view.layer.transform = CATransform3DScale(toVc.view.layer.transform, scaleBack, scaleBack, 1);
            toVc.view.alpha = 1.0f;
            fromVC.view.frame = endRect;
        } completion:^(BOOL finished) {
            toVc.view.layer.transform = CATransform3DIdentity;
            if (fromVC.modalPresentationStyle == UIModalPresentationCustom) {
                [toVc endAppearanceTransition];
            }
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

- (void)animationEnded:(BOOL)transitionCompleted
{
    self.isInteractive = NO;
    self.trainsiontContext = nil;
}


#pragma mark - UIViewControllerContextTransitioning


-(void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.trainsiontContext = transitionContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (![self isPriorToIOS8]) {
        toViewController.view.layer.transform = CATransform3DScale(toViewController.view.layer.transform, self.behindViewScale, self.behindViewScale, 1);
    }
    
    self.tmpTransform = toViewController.view.layer.transform;
    
    toViewController.view.alpha = self.behindViewAlpha;
    
    if (fromViewController.modalPresentationStyle == UIModalPresentationFullScreen) {
        [[transitionContext containerView] addSubview:toViewController.view];
    }
    [[transitionContext containerView] bringSubviewToFront:fromViewController.view];
}

- (void)updateInteractiveTransition:(CGFloat)percentComplete
{
    if (!self.bounces && percentComplete < 0) {
        percentComplete = 0;
    }
    
    id<UIViewControllerContextTransitioning> transitionContext = self.trainsiontContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CATransform3D transform = CATransform3DMakeScale(
                                                     1 + (((1 / self.behindViewScale) - 1) * percentComplete),
                                                     1 + (((1 / self.behindViewScale) - 1) * percentComplete), 1);
    toViewController.view.layer.transform = CATransform3DConcat(self.tmpTransform, transform);
    
    toViewController.view.alpha = self.behindViewAlpha + ((1 - self.behindViewAlpha) * percentComplete);
    
    CGRect updateRect;
   
        updateRect = CGRectMake(CGRectGetWidth(fromViewController.view.bounds) * percentComplete,
                                0,
                                CGRectGetWidth(fromViewController.view.frame),
                                CGRectGetHeight(fromViewController.view.frame));
    
    
    // reset to zero if x and y has unexpected value to prevent crash
    if (isnan(updateRect.origin.x) || isinf(updateRect.origin.x)) {
        updateRect.origin.x = 0;
    }
    if (isnan(updateRect.origin.y) || isinf(updateRect.origin.y)) {
        updateRect.origin.y = 0;
    }
    
    CGPoint transformedPoint = CGPointApplyAffineTransform(updateRect.origin, fromViewController.view.transform);
    updateRect = CGRectMake(transformedPoint.x, transformedPoint.y, updateRect.size.width, updateRect.size.height);
    
    fromViewController.view.frame = updateRect;
}

- (void)finishInteractiveTransition
{
    id<UIViewControllerContextTransitioning> transitionContext = self.trainsiontContext;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect endRect;

    endRect = CGRectMake(CGRectGetWidth(fromViewController.view.bounds),
                             0,
                             CGRectGetWidth(fromViewController.view.frame),
                             CGRectGetHeight(fromViewController.view.frame));
    
    
    CGPoint transformedPoint = CGPointApplyAffineTransform(endRect.origin, fromViewController.view.transform);
    endRect = CGRectMake(transformedPoint.x, transformedPoint.y, endRect.size.width, endRect.size.height);
    
    if (fromViewController.modalPresentationStyle == UIModalPresentationCustom) {
        [toViewController beginAppearanceTransition:YES animated:YES];
    }
    
    [UIView animateWithDuration:0.25 delay:.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGFloat scaleBack = (1 / self.behindViewScale);
        toViewController.view.layer.transform = CATransform3DScale(self.tmpTransform, scaleBack, scaleBack, 1);
        toViewController.view.alpha = 1.0f;
        fromViewController.view.frame = endRect;
    } completion:^(BOOL finished) {
        if (fromViewController.modalPresentationStyle == UIModalPresentationCustom) {
            [toViewController endAppearanceTransition];
        }
        [transitionContext completeTransition:YES];
    }];
}

- (void)cancelInteractiveTransition
{
    id<UIViewControllerContextTransitioning> transitionContext = self.trainsiontContext;
    [transitionContext cancelInteractiveTransition];
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    [UIView animateWithDuration:0.25 delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        toViewController.view.layer.transform = self.tmpTransform;
        toViewController.view.alpha = self.behindViewAlpha;
        
        fromViewController.view.frame = CGRectMake(0,0,
                                                   CGRectGetWidth(fromViewController.view.frame),
                                                   CGRectGetHeight(fromViewController.view.frame));
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:NO];
        if (fromViewController.modalPresentationStyle == UIModalPresentationFullScreen) {
            [toViewController.view removeFromSuperview];
        }
    }];
}
 
 


#pragma mark - UIViewControllerTransitioningDelegate Methods

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.isDismiss = NO;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.isDismiss = YES;
    return self;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator
{
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator
{
    // Return nil if we are not interactive
    if (self.isInteractive && self.dragable) {
        self.isDismiss = YES;
        return self;
    }
    
    return nil;
}

# pragma mark - Gesture

- (void)handPan:(UIPanGestureRecognizer *)recognizer
{
    // Location reference
    CGPoint location = [recognizer locationInView:self.modalVC.view.window];
    location = CGPointApplyAffineTransform(location, CGAffineTransformInvert(recognizer.view.transform));
    // Velocity reference
    CGPoint velocity = [recognizer velocityInView:[self.modalVC.view window]];
    velocity = CGPointApplyAffineTransform(velocity, CGAffineTransformInvert(recognizer.view.transform));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.isInteractive = YES;
        
        self.panLocationStart = location.x;
        
        [self.modalVC dismissViewControllerAnimated:YES completion:nil];
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat animationRatio = 0;
        
        
        animationRatio = (location.x - self.panLocationStart) / (CGRectGetWidth([self.modalVC view].bounds));
        
        
        [self updateInteractiveTransition:animationRatio];
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGFloat velocityForSelectedDirection;
        velocityForSelectedDirection = velocity.x;
        if (velocityForSelectedDirection > 100) {
            [self finishInteractiveTransition];
            
            
        }else{
            [self cancelInteractiveTransition];
        }
        self.isInteractive = NO;
    }
}


#pragma mark - Gesture Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.gestureRecognizerToFailPan && otherGestureRecognizer && self.gestureRecognizerToFailPan == otherGestureRecognizer) {
        return YES;
    }
    return NO;
}

#pragma mark - Orientation

- (void)orientationChanged:(NSNotification *)notification
{
    UIViewController *backViewController = self.modalVC;
    backViewController.view.transform = CGAffineTransformIdentity;
    backViewController.view.frame = self.modalVC.view.frame;
    
    backViewController.view.transform = CGAffineTransformScale(backViewController.view.transform, self.behindViewScale, self.behindViewScale);
}

#pragma mark - others
- (BOOL)isPriorToIOS8
{
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare: @"8.0" options: NSNumericSearch];
    if (order == NSOrderedSame || order == NSOrderedDescending) {
        return YES;
    }
    return NO;
}

@end
