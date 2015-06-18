//
//  ViewController.h
//  Doer
//
//  Created by Liearth on 14/12/8.
//  Copyright (c) 2014年 Liearth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LIEListEditViewController.h"
#import "LIEListTableView.h"

@interface ViewController : UITableViewController <LIEListViewDelegate, LIEListViewDataSource>

@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) NSMutableArray *list;

@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UIImageView *addView;

@property (nonatomic, strong) NSIndexPath *presentIndexPath;
@property (nonatomic, strong) NSString *originalString;
@property (nonatomic, strong) NSString *originalState;

@property (nonatomic, strong) LIEListEditViewController *listEditViewController;

- (NSMutableArray *)creatAndReadListFile;//创建plist文件

- (void)writeToPlistFile;//写入plist文件

- (BOOL)isEmptyOrEqualToOtherList:(NSString *)text;
- (NSUInteger)getOpenStateCount;

- (void)changeListState:(NSString *)state atIndexPath:(NSIndexPath *)indexPath;
- (void)showListEditViewInOption:(int)showOption withText:(NSString *)text;

- (NSMutableDictionary *)setDictWithValue:(NSString *)value state:(NSString *)state;//设置Dict
- (NSMutableArray *)readModelAtLastIndexPath;//在list最后一行读取模型
- (NSMutableArray *)readListAtLastIndexPath;//在list最后一行读取数据

@end

