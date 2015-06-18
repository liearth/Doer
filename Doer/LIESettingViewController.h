//
//  LIESettingViewController.h
//  Doer
//
//  Created by Liearth on 14/12/4.
//  Copyright (c) 2014年 Liearth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LIESettingViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

- (void)nightMood:(NSString *)string;

@property (retain, nonatomic) IBOutlet UISwitch *mySwitch;

@end
