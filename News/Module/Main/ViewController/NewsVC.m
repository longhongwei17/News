//
//  NewsVC.m
//  News
//
//  Created by longhongwei on 16/3/23.
//  Copyright © 2016年 longhongwei. All rights reserved.
//

#import "NewsVC.h"
#import "NewsDetailViewController.h"

@interface NewsVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataList;

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

static NSString * const cellIdentifier = @"cellIdentifier";

@implementation NewsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
}


- (void)initUI
{
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
}

#pragma mark - getters

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
        for (NSInteger index = 0; index < 5; index ++) {
            [_dataList addObject:[NSString stringWithFormat:@"new s %@",@(index)]];
        }
    }
    return _dataList;
}

#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NewsDetailViewController *newDetailVC = [[NewsDetailViewController alloc] initWithNibName:NSStringFromClass([NewsDetailViewController class]) bundle:nil];
    
    [self.parentViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:newDetailVC] animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
