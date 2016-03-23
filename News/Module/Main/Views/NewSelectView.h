//
//  NewSelectView.h
//  News
//
//  Created by longhongwei on 16/3/23.
//  Copyright © 2016年 longhongwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface NewSelectView : UIView

@property (nonatomic, weak) IBOutlet UIButton *newsBtn;

@property (nonatomic, weak) IBOutlet UIButton *followBtn;

@property (nonatomic, copy) void (^choiceCompletion)(LookType);

@end
