//
//  LIEListEditViewController.h
//  Doer
//
//  Created by Liearth on 14/12/3.
//  Copyright (c) 2014年 Liearth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LIEListEditViewController : UIViewController

@property (nonatomic, strong) UITextField *myTextField;
@property (nonatomic, strong) UIView *myView;
@property (nonatomic, strong) UIVisualEffectView *myVisualEffectView;

@property (nonatomic, assign) int showOption;
@property (nonatomic, strong) NSString *text;

@property (nonatomic, strong) UITapGestureRecognizer *backgroundTap;

- (void)removeListEditViewInOption:(int)removeOption;

@end
