//
//  LwDetectScrollViewEndGestureRecognizer.h
//  News
//
//  Created by longhongwei on 16/3/28.
//  Copyright © 2016年 longhongwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LwDetectScrollViewEndGestureRecognizer : UIPanGestureRecognizer

@property (nonatomic, weak) UIScrollView *scrollView;

@end
