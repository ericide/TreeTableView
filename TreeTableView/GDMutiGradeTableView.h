//
//  GDMutiGradeTableView.h
//  easyride_kuaiji
//
//  Created by gaodun on 15/12/29.
//  Copyright © 2015年 JET. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GDMutiGradeTableViewDataSource;
@protocol GDMutiGradeTableViewDelegate;

typedef NS_ENUM(NSInteger,GDMutiGradeViewPosition) {
    GDMutiPositonHead,
    GDMutiPositonMiddle,
    GDMutiPositonEnd
};


/**
 *  GDmutiGradeTableView 树形TableView
 */
@interface GDMutiGradeTableView : UIView

@property (nonatomic,weak) id<GDMutiGradeTableViewDelegate  > delegate;
@property (nonatomic,weak) id<GDMutiGradeTableViewDataSource> dataSource;
@property (nonatomic,strong,readonly) UITableView *tableView;

- (void)setItemsNeedToExpand:(NSArray *)items;
- (void)scrollToObject:(id)object animated:(BOOL)animated;
- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier;
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;
- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (UITableViewCell *)dequeueReusableCellAtIndexPathWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
- (void)reloadData;
@end
/**
 *  GDMutiGradeTableViewDataSource
 */
@protocol GDMutiGradeTableViewDataSource <NSObject>
- (NSInteger)tableView:(GDMutiGradeTableView *)tableView numberOfChildren:(id)object;
- (id)tableView:(GDMutiGradeTableView *)tableView childForForObject:(id)object index:(NSInteger)index;
- (UITableViewCell *)tableView:(GDMutiGradeTableView *)tableView cellForObject:(id)object atPosition:(GDMutiGradeViewPosition)positon;
@end
/**
 *  GDMutiGradeTableViewDelegate
 */
@protocol GDMutiGradeTableViewDelegate <NSObject>
- (CGFloat)tableView:(GDMutiGradeTableView *)tableView heightForRowForObject:(id)object;
- (BOOL)tableView:(GDMutiGradeTableView *)tableView didSelectForObject:(id)object;
@end

@interface GDMutiGradeItem : NSObject
@property (nonatomic,copy) NSArray * children;
@property (nonatomic,strong) id object;
@property (nonatomic,copy) NSString * identify;

+ (instancetype)itemWithObject:(id)object identify:(NSString *)identify children:(NSArray *)array;
@end