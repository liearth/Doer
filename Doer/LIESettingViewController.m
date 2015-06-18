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

@end

@implementation LIESettingViewController

@synthesize mySwitch;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    //self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(44, 0, 0, 0);
    self.tableView.separatorColor = [UIColor clearColor];
    [mySwitch addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    //NSLog(@"settingViewController will appear");
    mySwitch.on = [self readSwitchState];
}

#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}
 
 */
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *switchCell = [self.tableView dequeueReusableCellWithIdentifier:@"night"];
    UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    switchCell.textLabel.text = @"Night Mood";
            
    [switchCell.contentView addSubview:mySwitch];
            
    return switchCell;
}
 */

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
    
    //NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
   // NSString *fileName = [path stringByAppendingPathComponent:@"nightMood"];
    //[NSKeyedArchiver archiveRootObject:array toFile:fileName];
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
