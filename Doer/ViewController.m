//
//  ViewController.m
//  Doer
//
//  Created by Liearth on 14/12/8.
//  Copyright (c) 2014年 Liearth. All rights reserved.
//

#import "ViewController.h"
#import "LIEItemViewController.h"
#import "LIEListCustomCell.h"
#import "LIESettingViewController.h"
#import "LIEColor.h"
#import "ListModel.h"
#import "LIEListTableView.h"

#define openState @"open"
#define doneState @"done"
#define listKey @"list"
#define stateKey @"state"

@interface ViewController () <LIEListCustomCellDelagae>

@end

@implementation ViewController

@synthesize listArray = _listArray;
@synthesize list = _list;
@synthesize presentIndexPath = _presentIndexPath;
@synthesize originalString;
@synthesize originalState = _originalState;
@synthesize arrowView = _arrowView;
@synthesize addView = _addView;
@synthesize listEditViewController = _listEditViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _list = [[NSMutableArray alloc] init];
    _list = [self creatAndReadListFile];
    
    _listArray = [[NSMutableArray alloc] init];
    _listArray = [self readListAtLastIndexPath];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settingBar"] style:UIBarButtonItemStyleDone target:self action:@selector(showSettingBar)];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addBar"] style:UIBarButtonItemStyleDone target:self action:@selector(addList)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewList:) name:@"ADDLIST" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editList:) name:@"EDITLIST" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadList:) name:@"reloadList" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{    self.tableView.backgroundColor = [LIEColor ListViewBackgroundColor];
    [self.tableView setSeparatorColor:[UIColor clearColor]];//分割线的颜色
    [self.tableView reloadData];
    
    self.navigationController.navigationBar.barTintColor = [LIEColor navigationBarColor];
    NSLog(@"viewController will appear");
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listArray count];
}

- (UITableViewCell *)tableView:(LIEListTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *theTableIdentifier = @"listCell";
    LIEListCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:theTableIdentifier];
    cell.delegate = self;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([tableView indexPathIsMovingIndexPath:indexPath]) {
        [cell prepareForMove];
    }
    else
    {
        if (tableView.movingIndexPath != nil) {
            indexPath = [tableView adaptedIndexPathForRowAtIndexPath:indexPath];
        }
        cell.listModel = [[self readModelAtLastIndexPath] objectAtIndex:indexPath.row];
    }
//    
//    NSUInteger row = [indexPath row];
//    cell.listModel = [[self readModelAtLastIndexPath] objectAtIndex:row];
    
    return cell;
}

- (BOOL)moveTableView:(LIEListTableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)moveTableView:(LIEListTableView *)tableView moveRowFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSInteger openCount = [self getOpenStateCount];
    
    if (toIndexPath.row < openCount) {
        [self changeListState:openState atIndexPath:fromIndexPath];
        [[_listArray objectAtIndex:fromIndexPath.row] setObject:openState forKey:stateKey];
        
        id openArrayObject = [_listArray objectAtIndex:fromIndexPath.row];
        [_listArray removeObjectAtIndex:fromIndexPath.row];
        [_listArray insertObject:openArrayObject atIndex:toIndexPath.row];
        
        id openObject = [_list objectAtIndex:fromIndexPath.row];
        [_list removeObjectAtIndex:fromIndexPath.row];
        [_list insertObject:openObject atIndex:toIndexPath.row];
    }
    else
    {
        [self changeListState:doneState atIndexPath:fromIndexPath];
        [[_listArray objectAtIndex:fromIndexPath.row] setObject:doneState forKey:stateKey];
        
        id doneArrayObject = [_listArray objectAtIndex:fromIndexPath.row];
        [_listArray removeObjectAtIndex:fromIndexPath.row];
        [_listArray insertObject:doneArrayObject atIndex:toIndexPath.row];
        
        id doneObject = [_list objectAtIndex:fromIndexPath.row];
        [_list removeObjectAtIndex:fromIndexPath.row];
        [_list insertObject:doneObject atIndex:toIndexPath.row];
    }
    [_list replaceObjectAtIndex:_list.count - 1 withObject:_listArray];
    
    [self writeToPlistFile];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height)];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];//获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard
    
    //LIEItemViewController *itemViewController = [[LIEItemViewController alloc] init];
    LIEItemViewController *itemViewController = [storyBoard instantiateViewControllerWithIdentifier:@"LIEItemViewController"];//由storyboard根据itemViewController的storyBoardID来获取我们要切换的视图
    itemViewController.listIndexPath = indexPath;
    
    [self.navigationController pushViewController:itemViewController animated:YES];
}

- (void)panLeftToDeleteCell:(UITableViewCell *)myCell//向左滑动删除cell，注册函数
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:myCell];
    
    [_listArray removeObjectAtIndex:indexPath.row];
    [_list removeObjectAtIndex:indexPath.row];
    
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self writeToPlistFile];
}

- (void)panRightToCompleteCell:(UITableViewCell *)myCell//向右滑动完成cell，注册函数
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:myCell];//当前cell的indexPath
    
    NSUInteger openCount = [self getOpenStateCount];
    
    if ([[[_listArray objectAtIndex:indexPath.row] valueForKey:stateKey] isEqualToString:openState]) {
        
        NSIndexPath *afterLastOpenIndexPath = [NSIndexPath indexPathForRow:openCount - 1 inSection:0];
        
        [_list exchangeObjectAtIndex:indexPath.row withObjectAtIndex:afterLastOpenIndexPath.row];
        [_listArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:afterLastOpenIndexPath.row];
        
        [self changeListState:doneState atIndexPath:afterLastOpenIndexPath];
        
        [self.tableView moveRowAtIndexPath:indexPath toIndexPath:afterLastOpenIndexPath];
    }
    else
    {
        NSIndexPath *openIndexPath = [NSIndexPath indexPathForRow:openCount inSection:0];
        
        [_list exchangeObjectAtIndex:indexPath.row withObjectAtIndex:openIndexPath.row];
        [_listArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:openIndexPath.row];
        
        [self changeListState:openState atIndexPath:openIndexPath];
        
        [self.tableView moveRowAtIndexPath:indexPath toIndexPath:openIndexPath];
    }
    
    [self writeToPlistFile];
}

- (void)panRightToEditCell:(UITableViewCell *)myCell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:myCell];
    
    _presentIndexPath = indexPath;
    originalString = [[_listArray objectAtIndex:indexPath.row] valueForKey:listKey];
    _originalState = [[_listArray objectAtIndex:indexPath.row] valueForKey:stateKey];
    
    [self showListEditViewInOption:0 withText:originalString];
    
    [_listArray removeObjectAtIndex:indexPath.row];
    
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self writeToPlistFile];
}

- (void)canScrollTbaleView
{
    self.tableView.scrollEnabled = YES;
}

- (void)canNotScrollTableView
{
    self.tableView.scrollEnabled = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //NSLog(@"the view will begin dragging");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CANNOTPANLISTCELL" object:self userInfo:nil];
    
    _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"theArrow"]];
    _arrowView.center = CGPointMake(scrollView.center.x, -22);
    [scrollView addSubview:_arrowView];
    
    _addView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add"]];
    _addView.center = CGPointMake(scrollView.center.x, -22);
    _addView.alpha = 0.0;
    [scrollView addSubview:_addView];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yFloat = scrollView.contentOffset.y;
    if (yFloat < -120) {
        //[_arrowView removeFromSuperview];
        //[scrollView addSubview:_addView];
        _addView.alpha = 1.0;
        _arrowView.alpha = 0.0;
    }
    if (yFloat > -120) {
        //[scrollView addSubview:_arrowView];
        _addView.alpha = 0.0;
        _arrowView.alpha = 1.0;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CANPANLISTCELL" object:self userInfo:nil];
    
    [_addView removeFromSuperview];
    [_arrowView removeFromSuperview];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y < -120) {
        [self showListEditViewInOption:1 withText:nil];
    }
}

- (void)showSettingBar
{
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];//获取storyboard: 通过bundle根据storyboard的名字来获取我们的storyboard
    LIESettingViewController *settingViewController = [storyBoard instantiateViewControllerWithIdentifier:@"LIESettingViewController"];
    [self.navigationController pushViewController:settingViewController animated:YES];
}

- (void)addList
{
    [self showListEditViewInOption:1 withText:nil];
}

- (void)addNewList:(NSNotification *)notification
{
    NSDictionary *nameDictionary = [notification userInfo];
    NSString *newText = [nameDictionary objectForKey:@"LISTNAME"];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    if ([self isEmptyOrEqualToOtherList:newText] == YES) {
        //NSLog(@"The new text is empty or equal to other string");
    }
    else
    {
        [_listArray insertObject:[self setDictWithValue:newText state:openState] atIndex:0];
        [_list insertObject:array atIndex:0];
        [_list replaceObjectAtIndex:_list.count - 1 withObject:_listArray];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [self writeToPlistFile];
    }
}

- (void)editList:(NSNotification *)notification
{
    NSDictionary *nameDictionary = [notification userInfo];
    NSString *editText = [nameDictionary objectForKey:@"LISTNAME"];
    
    [_listArray insertObject:[self setDictWithValue:editText state:_originalState] atIndex:_presentIndexPath.row];

    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:_presentIndexPath] withRowAnimation:UITableViewRowAnimationRight];
    
    [self writeToPlistFile];
}

- (void)showListEditViewInOption:(int)showOption withText:(NSString *)text
{
    _listEditViewController = [[LIEListEditViewController alloc] init];
    
    _listEditViewController.showOption = showOption;
    _listEditViewController.text = text;
    
    [self.navigationController.view addSubview:_listEditViewController.view];
    
}

- (BOOL)isEmptyOrEqualToOtherList:(NSString *)text
{
    NSString *emptyString = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    int same = 0;
    for (int i = 0; i < _listArray.count; i++) {
        if ([text isEqualToString:[[_listArray objectAtIndex:i] valueForKey:listKey]]) {
            same++;
        }
    }
    
    if (same > 0 || emptyString.length == 0) {
        //NSLog(@"The text is empty or equal to other string");
        return YES;
    }
    else
    {
        return NO;
    }
}

- (NSMutableArray *)creatAndReadListFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [path objectAtIndex:0];
    //NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *plistSuffix = @".plist";
    NSString *plistPath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",@"MyList",plistSuffix]];
    
    if (![fileManager fileExistsAtPath:plistPath]) {
        [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
        
        NSString *listPath = [[NSBundle mainBundle] pathForResource:@"List" ofType:@"plist"];
        NSMutableArray *theArray = [[NSMutableArray alloc] initWithContentsOfFile:listPath];
        [theArray writeToFile:plistPath atomically:YES];
        
        return theArray;
    }
    else
    {
        NSLog(@"The file is exist");
        NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
        
        return array;
    }
}

- (void)changeListState:(NSString *)state atIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *itemArray = [[NSMutableArray alloc] init];
    itemArray = [_list objectAtIndex:indexPath.row];
    for (int i = 0; i < itemArray.count; i++) {
        [[itemArray objectAtIndex:i] setObject:state forKey:stateKey];
    }
    
    [[_listArray objectAtIndex:indexPath.row] setObject:state forKey:stateKey];
    [_list replaceObjectAtIndex:indexPath.row withObject:itemArray];
    [_list replaceObjectAtIndex:_list.count - 1 withObject:_listArray];
    
    [self writeToPlistFile];
}


- (NSUInteger)getOpenStateCount
{
    NSUInteger theOPENCount = 0;
    for (int i = 0; i < _listArray.count; i++) {
        if ([[[_listArray objectAtIndex:i] valueForKey:stateKey] isEqual: openState]) {
            theOPENCount ++;
        }
    }
    
    return theOPENCount;
}

- (NSMutableDictionary *)setDictWithValue:(NSString *)value state:(NSString *)state
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:value forKey:@"list"];
    [dict setObject:state forKey:@"state"];
    
    return dict;
}

- (void)reloadList:(NSNotification *)notification
{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *plistSuffix = @".plist";
    NSString *plistPath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",@"MyList",plistSuffix]];
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:plistPath];
    
    _list = array;
}

- (void)writeToPlistFile
{
//    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *filePath = [path objectAtIndex:0];
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *plistSuffix = @".plist";
    NSString *plistPath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",@"MyList",plistSuffix]];
    
    BOOL success = [_list writeToFile:plistPath atomically:YES];
    
    if (success) {
        NSLog(@"success");
    }
    else
    {
        NSLog(@"faile");
    }
}

- (NSMutableArray *)readListAtLastIndexPath
{
    return [_list objectAtIndex:_list.count - 1];
}

- (NSMutableArray *)readModelAtLastIndexPath
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (NSMutableDictionary *dict in _listArray)
    {
        [array addObject:[ListModel listWithDict:dict]];
    }
    
    return array;
}


@end
