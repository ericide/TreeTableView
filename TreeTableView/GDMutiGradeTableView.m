//
//  GDMutiGradeTableView.m
//  easyride_kuaiji
//
//  Created by gaodun on 15/12/29.
//  Copyright © 2015年 JET. All rights reserved.
//

#import "GDMutiGradeTableView.h"
@interface GDMutiGradeTableView()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableSet   *expandSet;

@end
@implementation GDMutiGradeTableView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup
{
    _tableView =[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.dataArray = [NSMutableArray new];
    self.expandSet = [NSMutableSet new];
    
    [self addSubview:self.tableView];
}
- (void)layoutSubviews
{
    self.tableView.frame = self.bounds;
}
#pragma mark --Public
- (void)registerNib:(nullable UINib *)nib forCellReuseIdentifier:(NSString *)identifier
{
    [self.tableView registerNib:nib forCellReuseIdentifier:identifier];
}
- (void)registerClass:(nullable Class)cellClass forCellReuseIdentifier:(NSString *)identifier
{
    [self.tableView registerClass:cellClass forCellReuseIdentifier:identifier];
}
- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    return [self.tableView dequeueReusableCellWithIdentifier:identifier];
}

- (void)reloadData
{
    [self.dataArray removeAllObjects];
    for (int i = 0; i < [self.dataSource tableView:self numberOfChildren:nil]; i++) {
        GDMutiGradeItem * currentItem = [self.dataSource tableView:self childForForObject:nil index:i];
        [self.dataArray addObject:currentItem];
        if ([self.expandSet containsObject:currentItem]){
            [self reloadDataWithObject:currentItem];
        }
    }
    NSLog(@"%@",self.dataArray);
    [self.tableView reloadData];
}
- (void)setItemsNeedToExpand:(NSArray *)items
{
    [self.expandSet addObjectsFromArray:items];
}
- (void)scrollToObject:(id)object animated:(BOOL)animated
{
    if (object == nil) {
        return;
    }
    NSInteger index = [self.dataArray indexOfObject:object];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:animated];
}
#pragma mark --Private
- (void)reloadDataWithObject:(id)object
{
    for (int i = 0; i < [self.dataSource tableView:self numberOfChildren:object]; i++) {
        GDMutiGradeItem * currentItem = [self.dataSource tableView:self childForForObject:object index:i];
        [self.dataArray addObject:currentItem];
        if ([self.expandSet containsObject:currentItem]){
            [self reloadDataWithObject:currentItem];
        }
    }
}
/**
 *  通过递归找到该级下所有的item的数量
 *
 *  @param object    当前对象
 *  @param container 收集对象的容器
 */
- (NSInteger)addChildrenObjectsWithObject:(id)object toContainer:(NSMutableArray *)container
{
    NSInteger numOfItems = 0;
    NSInteger count = [self.dataSource tableView:self numberOfChildren:object];
    for (int num = 0; num < count; num++ ) {
        id childObj = [self.dataSource tableView:self childForForObject:object index:num];
        if (container) {
            [container addObject:childObj];
        }
        if ([self.expandSet containsObject:childObj]){
           //[self.expandSet removeObject:object];//删除该项展开状态
            numOfItems += [self addChildrenObjectsWithObject:childObj toContainer:container];
        }
    }
    numOfItems += count;
    return numOfItems;
}
#pragma mark --Method

- (void)expandCellForObject:(id)obj AtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray * containter = [NSMutableArray new];
    NSMutableArray * tableViewIndexContainter = [NSMutableArray new];

    NSInteger count = [self addChildrenObjectsWithObject:obj toContainer:containter];
    
    for (NSInteger num = 0; num < count; num++) {
        [tableViewIndexContainter addObject:[NSIndexPath indexPathForRow:indexPath.row + 1 + num inSection:0]];
    }
    
    
    [self.tableView beginUpdates];
    [self.dataArray insertObjects:containter atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row + 1, count)]];
    [self.tableView insertRowsAtIndexPaths:tableViewIndexContainter withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}
- (void)pullbackCellForObject:(id)obj AtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray * tableViewIndexContainter = [NSMutableArray new];
    
    NSInteger count = [self addChildrenObjectsWithObject:obj toContainer:nil];
    for (NSInteger num = 0; num < count; num++) {
        [tableViewIndexContainter addObject:[NSIndexPath indexPathForRow:indexPath.row + 1 + num inSection:0]];
    }
    
    [self.tableView beginUpdates];
    [self.dataArray removeObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row + 1, count)]];
    [self.tableView deleteRowsAtIndexPaths:tableViewIndexContainter withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
}
#pragma mark --tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = self.dataArray[indexPath.row];
    if ([self.delegate tableView:self didSelectForObject:object]) {
        if ([self.expandSet containsObject:object]) {
            [self.expandSet removeObject:object];
            [self pullbackCellForObject:object AtIndexPath:indexPath];
        } else {
            [self.expandSet addObject:object];
            [self expandCellForObject:object AtIndexPath:indexPath];
        }
    };
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = self.dataArray[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(tableView:heightForRowForObject:)]) {
        return [self.delegate tableView:self heightForRowForObject:object];
    }
    return 44.0;
}
#pragma mark --tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GDMutiGradeViewPosition position = GDMutiPositonMiddle;
    if (indexPath.row == self.dataArray.count - 1) {
        position = GDMutiPositonEnd;
    }
    if (indexPath.row == 0) {
        position = GDMutiPositonHead;
    }

    
    id object = self.dataArray[indexPath.row];
    return [self.dataSource tableView:self cellForObject:object atPosition:position];
}

@end
@implementation GDMutiGradeItem

+ (instancetype)itemWithObject:(id)object identify:(NSString *)identify children:(NSArray *)array
{
    GDMutiGradeItem * item = [GDMutiGradeItem new];
    item.object = object;
    item.children = array;
    item.identify = identify;
    return item;
}

//- (NSString *)description
//{
//    return [NSString stringWithFormat:@"%@->%zd",self.object,self.children.count];
//}
@end

