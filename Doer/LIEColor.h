//
//  LIEColor.h
//  Doer
//
//  Created by Liearth on 14/12/10.
//  Copyright (c) 2014年 Liearth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LIEColor : NSObject


+ (UIColor *)ListViewBackgroundColor;
+ (UIColor *)ListCellOpenColor;
+ (UIColor *)ListCellDoneColor;
+ (UIColor *)ListCellWillDoneColor;
+ (UIColor *)ListCellWillClearColor;
+ (UIColor *)ListTextOpenColor;
+ (UIColor *)ListTextDoneColor;
+ (UIColor *)ListAddTextColor;
+ (UIColor *)ListEditTextColor;

+ (UIColor *)ItemViewBackgroundColor;
+ (UIColor *)ItemCellOpenColor;
+ (UIColor *)ItemCellDoneColor;
+ (UIColor *)ItemCellWillDoneColor;
+ (UIColor *)ItemCellWillClearColor;
+ (UIColor *)ItemTextOpenColor;
+ (UIColor *)ItemTextDoneColor;
+ (UIColor *)ItemAddTextColor;
+ (UIColor *)ItemEditTextColor;

+ (UIColor *)navigationBarColor;
+ (UIColor *)editOrAddTextColor;

+ (BOOL)isNightMood;

@end


