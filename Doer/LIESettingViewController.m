//
//  LIESettingViewController.m
//  Doer
//
//  Created by Liearth on 14/12/4.
//  Copyright (c) 2014年 Liearth. All rights reserved.
//

#import "LIESettingViewController.h"
#import "LIEColor.h"

@interface LIESettingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation LIESettingViewController

@synthesize mySwitch;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.separatorColor = [UIColor clearColor];
    [mySwitch addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventValueChanged];
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    self.versionLabel.text = [NSString stringWithFormat:@"%@ %@", infoDict[@"CFBundleName"], infoDict[@"CFBundleShortVersionString"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    mySwitch.on = [self readSwitchState];
}

- (void)changeColor:(UISwitch *)theSwitch
{
    if (mySwitch.on) {
        [self nightMood:@"YES"];
    }
    else
    {
        [self nightMood:@"NO"];
    }
    self.navigationController.navigationBar.barTintColor = [LIEColor navigationBarColor];
    [self saveSwitchState:mySwitch.on];
}

- (void)nightMood:(NSString *)string
{
    NSString *nightColor = string;
    NSArray *array = [NSArray arrayWithObjects:nightColor, nil];
    
    NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
    [saveDefaults setObject:array forKey:@"nightMood"];
}

- (void)saveSwitchState:(BOOL)onOff
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    [preferences setBool:onOff forKey:@"switchOnOff"];
    [preferences synchronize];
}

- (BOOL)readSwitchState
{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    return [preferences boolForKey:@"switchOnOff"];
}

@end
