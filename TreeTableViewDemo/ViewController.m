//
//  ViewController.m
//  TreeTableViewDemo
//
//  Created by gaodun on 16/2/2.
//  Copyright © 2016年 idea. All rights reserved.
//


#import "ViewController.h"
#import "GDMutiGradeTableView.h"
#import "FirstTableViewCell.h"
#import "SecondTableViewCell.h"

@interface ViewController ()<GDMutiGradeTableViewDataSource,GDMutiGradeTableViewDelegate>

@property (nonatomic , strong) GDMutiGradeTableView * tableView;
@property (nonatomic , strong) NSArray *dataArray; //任务列表

@end

@implementation ViewController
- (void)loadView
{
    [super loadView];
    [self.view addSubview:self.tableView];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = [UIColor grayColor];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"TreeView DEMO";
    
    [self loadData];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- setter & getter
- (GDMutiGradeTableView *)tableView
{
    if (!_tableView ) {
        _tableView  = [[GDMutiGradeTableView  alloc]init];
        _tableView.frame = [UIScreen mainScreen].bounds;
        _tableView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.97 alpha:1.0];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView ;
}


- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray  = [[NSArray  alloc]init];
    }
    return _dataArray ;
}
#pragma mark - GDMutiGradeTableView Delegate
- (CGFloat)tableView:(GDMutiGradeTableView *)tableView heightForRowForObject:(GDMutiGradeItem*)dateItem
{
    
    if ([dateItem.identify isEqualToString:@"grade1"]) {
        return 44;
    }else if ([dateItem.identify isEqualToString:@"grade2"]) {
        return 44;
    }
    return 0;
}
- (BOOL)tableView:(GDMutiGradeTableView *)tableView didSelectForObject:(GDMutiGradeItem *)currentItem
{
    return YES;
}
#pragma mark - GDMutiGradeTableView Datasource
- (NSInteger)tableView:(GDMutiGradeTableView *)tableView numberOfChildren:(GDMutiGradeItem *)item
{
    if (item == nil) {
        return self.dataArray.count;
    } else {
        return item.children.count;
    }
}
- (id)tableView:(GDMutiGradeTableView *)tableView childForForObject:(GDMutiGradeItem *)item index:(NSInteger)index
{
    if (item == nil) {
        return self.dataArray[index];
    } else {
        return item.children[index];
    }
}
- (UITableViewCell *)tableView:(GDMutiGradeTableView *)gradeTableView cellForObject:(GDMutiGradeItem *)dateItem atPosition:(GDMutiGradeViewPosition)positon
{
    UITableViewCell * cell = nil;
    if ([dateItem.identify isEqualToString:@"grade1"]) {
        cell = [gradeTableView.tableView dequeueReusableCellWithIdentifier:@"grade1"];
        if (!cell) {
            cell = [[FirstTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"grade1"];
            cell.textLabel.text = @"Grade1";
            cell.backgroundColor = [UIColor colorWithRed:0.99 green:0.90 blue:0.90 alpha:1.0];
        }
    }else if ([dateItem.identify isEqualToString:@"grade2"]) {
        cell = [gradeTableView.tableView dequeueReusableCellWithIdentifier:@"grade2"];
        if (!cell) {
            cell = [[FirstTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"grade2"];
            cell.textLabel.text = @"    Grade2";
            cell.backgroundColor = [UIColor colorWithRed:0.90 green:0.99 blue:0.90 alpha:1.0];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark -- Method


#pragma mark -- 数据加载
-(void)loadData
{
    GDMutiGradeItem * item1 = [GDMutiGradeItem itemWithObject:nil identify:@"grade2" children:nil];
    GDMutiGradeItem * item2 = [GDMutiGradeItem itemWithObject:nil identify:@"grade2" children:nil];
    GDMutiGradeItem * item3 = [GDMutiGradeItem itemWithObject:nil identify:@"grade2" children:nil];
    GDMutiGradeItem * item4 = [GDMutiGradeItem itemWithObject:nil identify:@"grade2" children:nil];
    
    GDMutiGradeItem * item5 = [GDMutiGradeItem itemWithObject:nil identify:@"grade2" children:nil];
    GDMutiGradeItem * item6 = [GDMutiGradeItem itemWithObject:nil identify:@"grade2" children:nil];
    GDMutiGradeItem * item7 = [GDMutiGradeItem itemWithObject:nil identify:@"grade2" children:nil];
    
    GDMutiGradeItem * itemG1 = [GDMutiGradeItem itemWithObject:nil identify:@"grade1" children:@[item1,item2,item3,item4]];
    GDMutiGradeItem * itemG2 = [GDMutiGradeItem itemWithObject:nil identify:@"grade1" children:@[item5,item6,item7]];
    
    self.dataArray = @[itemG1,itemG2];
    
    [self.tableView reloadData];

}


@end
