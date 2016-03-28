//
//  LwDetectScrollViewEndGestureRecognizer.m
//  News
//
//  Created by longhongwei on 16/3/28.
//  Copyright © 2016年 longhongwei. All rights reserved.
//

#import "LwDetectScrollViewEndGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface LwDetectScrollViewEndGestureRecognizer ()
@property (nonatomic, strong) NSNumber *isFail;
@end

@implementation LwDetectScrollViewEndGestureRecognizer

- (void)reset
{
    [super reset];
    self.isFail = nil;
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    if (!self.scrollView) {
        return;
    }
    
    if (self.state == UIGestureRecognizerStateFailed) return;
    CGPoint velocity = [self velocityInView:self.view];
    CGPoint nowPoint = [touches.anyObject locationInView:self.view];
    CGPoint prevPoint = [touches.anyObject previousLocationInView:self.view];
    
    if (self.isFail) {
        if (self.isFail.boolValue) {
            self.state = UIGestureRecognizerStateFailed;
        }
        return;
    }
    
    CGFloat topVerticalOffset = -self.scrollView.contentInset.top;
    
    if ((fabs(velocity.x) < fabs(velocity.y)) && (nowPoint.y > prevPoint.y) && (self.scrollView.contentOffset.y <= topVerticalOffset)) {
        self.isFail = @NO;
    } else if (self.scrollView.contentOffset.y >= topVerticalOffset) {
        self.state = UIGestureRecognizerStateFailed;
        self.isFail = @YES;
    } else {
        self.isFail = @NO;
    }
}

@end
