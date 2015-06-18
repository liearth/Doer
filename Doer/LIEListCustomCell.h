//
//  LIEListCustomCell.h
//  Doer
//
//  Created by Liearth on 14-10-5.
//  Copyright (c) 2014年 Liearth. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ListModel;

@protocol LIEListCustomCellDelagae <NSObject>

- (void)panLeftToDeleteCell:(UITableViewCell *)myCell;//向左滑动删除cell
- (void)panRightToCompleteCell:(UITableViewCell *)myCell;//向右滑动完成cell
- (void)panRightToEditCell:(UITableViewCell *)myCell;//向右滑动编辑cell
- (void)canScrollTbaleView;
- (void)canNotScrollTableView;

@end


@interface LIEListCustomCell : UITableViewCell<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *myContentView;
@property (strong, nonatomic) UILabel *myText;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

@property (strong, nonatomic) UIImageView *doneView;
@property (strong, nonatomic) UIImageView *clearView;
@property (strong, nonatomic) UIImageView *editView;

@property (nonatomic, strong) ListModel *listModel;

@property (nonatomic, weak) id <LIEListCustomCellDelagae> delegate;

- (void)prepareForMoveSnapshot;
- (void)prepareForMove;

- (BOOL)color:(UIColor *)color1 isEqualToColor:(UIColor *)color2 withTolerance:(CGFloat)tolerance;
- (void)setListModel:(ListModel *)listModel;
- (void)checkStateOnModel:(ListModel *)model;//检查model的state

@end
