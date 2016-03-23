//
//  NewSelectView.m
//  News
//
//  Created by longhongwei on 16/3/23.
//  Copyright © 2016年 longhongwei. All rights reserved.
//

#import "NewSelectView.h"

@interface NewSelectView ()

@property (nonatomic) LookType type;

@end

@implementation NewSelectView


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self initialize];
}

- (void)initialize
{
    self.userInteractionEnabled = YES;
    
    _type = LookType_News;
    
    SEL sector = @selector(cmdChoice:);
    
    [self.followBtn addTarget:self action:sector forControlEvents:UIControlEventTouchUpInside];
    
    [self.newsBtn addTarget:self action:sector forControlEvents:UIControlEventTouchUpInside];
}

- (void)cmdChoice:(UIButton *)btn
{
    if (self.newsBtn == btn && _type != LookType_News) {
        _type = LookType_News;
    }else if (self.followBtn == btn && _type != LookType_Follow ){
         _type = LookType_Follow;
    }else{
        return;
    }
    
    self.choiceCompletion?self.choiceCompletion(_type):0;
}

@end
