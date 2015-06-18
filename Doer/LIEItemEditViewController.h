//
//  LIEItemEditViewController.h
//  Doer
//
//  Created by Liearth on 14/11/28.
//  Copyright (c) 2014年 Liearth. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LIEItemEditViewController : UIViewController

@property (nonatomic, strong) UITextField *myTextField;
@property (nonatomic, strong) UIView *myView;
@property (nonatomic, strong) UIVisualEffectView *myVisualEffectView;

@property (nonatomic, assign) int showOption;
@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) UITapGestureRecognizer *backgroundTap;

- (void)removeItemEditViewInOption:(int)removeOption;

@end
