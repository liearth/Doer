//
//  LIEColor.m
//  Doer
//
//  Created by Liearth on 14/12/10.
//  Copyright (c) 2014年 Liearth. All rights reserved.
//

#import "LIEColor.h"

@implementation LIEColor


+ (UIColor *)ListViewBackgroundColor
{
    if ([self isNightMood]) {
        return [UIColor colorWithRed:40.0 / 255.0f green:40.0 / 255.0f blue:40.0 / 255.0f alpha:1.0];
    }
    else
        return [UIColor colorWithRed:61.0 / 255.0f green:75.0 / 255.0f blue:90.0 / 255.0f alpha:1.0];
}

+ (UIColor *)ListCellOpenColor
{
    if ([self isNightMood]) {
        return [UIColor colorWithRed:36.0 / 255.0f green:36.0 / 255.0f blue:36.0 / 255.0f alpha:1.0];
    }
    return [UIColor colorWithRed:91.0 / 255.0f green:114.0 / 255.0f blue:133.0 / 255.0f alpha:1.0];
}

+ (UIColor *)ListCellDoneColor
{
    if ([self isNightMood]) {
        return [UIColor colorWithRed:40.0 / 255.0f green:40.0 / 255.0f blue:40.0 / 255.0f alpha:1.0];
    }
    else
        return [UIColor colorWithRed:61.0 / 255.0f green:75.0 / 255.0f blue:90.0 / 255.0f alpha:1.0];
    //return [UIColor colorWithRed:235 / 255.0f green:236 / 255.0f blue:238 / 255.0f alpha:1.0];
}

+ (UIColor *)ListCellWillDoneColor
{
    return [UIColor colorWithRed:47.0 / 255.0f green:163.0 / 255.0f blue:95.0 / 255.0f alpha:1.0];
}

+ (UIColor *)ListCellWillClearColor
{
    return [UIColor colorWithRed:216.0 / 255.0f green:38 / 255.0f blue:36 / 255.0f alpha:1.0];
}

+ (UIColor *)ListTextOpenColor
{
    if ([self isNightMood]) {
        return [UIColor colorWithRed:128.0 / 255.0f green:128.0 / 255.0f blue:128.0 / 255.0f alpha:1.0];
    }
    return [UIColor colorWithRed:240.0 / 255.0f green:240.0 / 255.0f blue:240.0 / 255.0f alpha:1.0];
}

+ (UIColor *)ListTextDoneColor
{
    if ([self isNightMood]) {
        return [UIColor colorWithRed:60.0 / 255.0f green:60.0 / 255.0f blue:60.0 / 255.0f alpha:1.0];
    }
    return [UIColor colorWithRed:126.0 / 255.0f green:139.0 / 255.0f blue:158.0 / 255.0f alpha:1.0];
}

+ (UIColor *)ListAddTextColor
{
    return [UIColor colorWithRed:61.0 / 255.0f green:75.0 / 255.0f blue:90.0 / 255.0f alpha:1.0];
}

+ (UIColor *)ListEditTextColor
{
    return [UIColor colorWithRed:91.0 / 255.0f green:114.0 / 255.0f blue:133.0 / 255.0f alpha:1.0];
}







+ (UIColor *)ItemViewBackgroundColor
{
    if ([self isNightMood]) {
        return [UIColor colorWithRed:43.0 / 255.0f green:43.0 / 255.0f blue:43.0 / 255.0f alpha:1.0];
    }
    return [UIColor colorWithRed:10.0 / 255.0f green:56.0 / 255.0f blue:112.0 / 255.0f alpha:1.0];
}

+ (UIColor *)ItemCellOpenColor
{
    if ([self isNightMood]) {
        return [UIColor colorWithRed:38.0 / 255.0f green:38.0 / 255.0f blue:38.0 / 255.0f alpha:1.0];
    }
    return [UIColor colorWithRed:24.0 / 255.0f green:133.0 / 255.0f blue:188.0 / 255.0f alpha:1.0];
}

+ (UIColor *)ItemCellDoneColor
{
    if ([self isNightMood]) {
        return [UIColor colorWithRed:43.0 / 255.0f green:43.0 / 255.0f blue:43.0 / 255.0f alpha:1.0];
    }
    return [UIColor colorWithRed:10.0 / 255.0f green:56.0 / 255.0f blue:112.0 / 255.0f alpha:1.0];
    //return [UIColor colorWithRed:5 / 255.0f green:15 / 255.0f blue:49 / 255.0f alpha:1.0];
}

+ (UIColor *)ItemCellWillDoneColor
{
    return [UIColor colorWithRed:47.0 / 255.0f green:163.0 / 255.0f blue:95.0 / 255.0f alpha:1.0];
}

+ (UIColor *)ItemCellWillClearColor
{
    return [UIColor colorWithRed:216.0 / 255.0f green:38 / 255.0f blue:36 / 255.0f alpha:1.0];
}

+ (UIColor *)ItemTextOpenColor
{
    if ([self isNightMood]) {
        return [UIColor colorWithRed:128.0 / 255.0f green:128.0 / 255.0f blue:128.0 / 255.0f alpha:1.0];
    }
    return [UIColor colorWithRed:240.0 / 255.0f green:240.0 / 255.0f blue:240.0 / 255.0f alpha:1.0];
}

+ (UIColor *)ItemTextDoneColor
{
    if ([self isNightMood]) {
        return [UIColor colorWithRed:60.0 / 255.0f green:60.0 / 255.0f blue:60.0 / 255.0f alpha:1.0];
    }
    return [UIColor colorWithRed:15.0 / 255.0f green:72.0 / 240.0f blue:121.0 / 255.0f alpha:1.0];
}

+ (UIColor *)ItemAddTextColor
{
    return [UIColor colorWithRed:10.0 / 255.0f green:56.0 / 255.0f blue:112.0 / 255.0f alpha:1.0];
}

+ (UIColor *)ItemEditTextColor
{
    return [UIColor colorWithRed:24.0 / 255.0f green:133.0 / 255.0f blue:188.0 / 255.0f alpha:1.0];
}

+ (UIColor *)navigationBarColor
{
    if ([self isNightMood]) {
        return [UIColor colorWithRed:31.0 / 255.0f green:31.0 / 255.0f blue:31.0 / 255.0f alpha:1.0];
    }
    else
        return [UIColor colorWithRed:200.0 / 255.0f green:200.0 / 255.0f blue:200.0 / 255.0f alpha:1.0];
}

+ (UIColor *)editOrAddTextColor
{
    return [UIColor colorWithRed:240.0 / 255.0f green:240.0 / 255.0f blue:240.0 / 255.0f alpha:1.0];
}


+ (BOOL)isNightMood
{
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = [saveDefaults objectForKey:@"nightMood"];
    NSString *string = [array objectAtIndex:0];
    
    if ([string isEqualToString:@"YES"]) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        return YES;
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        return NO;
    }
}

@end