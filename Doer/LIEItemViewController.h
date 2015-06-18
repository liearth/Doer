//
//  LIEItemViewController.h
//  Doer
//
//  Created by Liearth on 14-10-5.
//  Copyright (c) 2014年 Liearth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LIEItemEditViewController.h"
#import "LIEItemTableView.h"


@interface LIEItemViewController : UITableViewController<UIGestureRecognizerDelegate, LIEItemTableViewDelegate, LIEItemTableViewDataSource>

@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) NSIndexPath *presentIndexPath;//相对于Item中的当前indexPath
@property (nonatomic, strong) NSIndexPath *listIndexPath;//相对于List中的indexPath
@property (nonatomic, strong) NSString *originalString;

//@property (nonatomic, strong) static UIImageView *arrowView;
//@property (nonatomic, strong) static UIImageView *addView;

@property (nonatomic, strong) LIEItemEditViewController *itemEditViewController;

- (void)showItemEditViewInOption:(int)showOption withText:(NSString *)text;
- (void)writeToFile;//写入文件
- (NSMutableArray *)readModelAtIndex;//从plist中读取数据模型
- (NSMutableArray *)readItemAtIndex:(NSIndexPath *)indexPath;//从List中读取Items
- (NSMutableDictionary *)setDictWithValue:(NSString *)value state:(NSString *)state;//设置字典

@end
