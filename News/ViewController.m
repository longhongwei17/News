//
//  ViewController.m
//  News
//
//  Created by longhongwei on 16/3/23.
//  Copyright © 2016年 longhongwei. All rights reserved.
//

#import "ViewController.h"
#import "NewSelectView.h"
#import "NavBarView.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *newsContainerView;
@property (weak, nonatomic) IBOutlet UIView *followContainerView;
@property (weak, nonatomic) IBOutlet NewSelectView *selectView;
@property (weak, nonatomic) IBOutlet NavBarView *navView;
@property (nonatomic) LookType curType;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)initUI
{
    self.curType = LookType_News;
    
    [self configureSelectView];
}

- (void)configureSelectView
{
    __weak typeof(self) weakSelf = self;
    [self.selectView setChoiceCompletion:^(LookType type) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.curType = type;
    }];
}

#pragma mark - setter

- (void)setCurType:(LookType)curType
{
    _curType = curType;
    
    self.newsContainerView.hidden = _curType==LookType_Follow;
    self.followContainerView.hidden = _curType==LookType_News;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
