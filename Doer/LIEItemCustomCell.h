//
//  LIEItemCustomCell.h
//  Doer
//
//  Created by Liearth on 14-10-5.
//  Copyright (c) 2014年 Liearth. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ListModel;

@protocol LIEItemCustomCellDelegate <NSObject>

- (void)panLeftToDeleteCell:(UITableViewCell *)myCell;//向左滑动删除cell
- (void)panRightToCompleteCell:(UITableViewCell *)myCell;//向右滑动完成cell
- (void)panRightToShowList:(UITableViewCell *)myCell;//向右滑动返回List界面
- (void)tapTheCellToEdit:(UITableViewCell *)myCell;//点击编辑cell
- (void)canScrollTbaleView;
- (void)canNotScrollTableView;

@end


@interface LIEItemCustomCell : UITableViewCell<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *myContentView;
@property (strong, nonatomic) UILabel *myText;
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;
@property (strong, nonatomic) UIImageView *doneView;
@property (strong, nonatomic) UIImageView *clearView;
@property (strong, nonatomic) UIImageView *listView;

@property (nonatomic, strong)ListModel *listModel;

@property (nonatomic, weak) id <LIEItemCustomCellDelegate> delegate;

- (void)prepareForMoveSnapshot;
- (void)prepareForMove;

- (BOOL)color:(UIColor *)color1 isEqualToColor:(UIColor *)color2 withTolerance:(CGFloat)tolerance;
- (void)setCell;

- (void)setListModel:(ListModel *)listModel;//listModel的settet函数
- (void)checkStateOnModel:(ListModel *)model;//检查model的state


@end
