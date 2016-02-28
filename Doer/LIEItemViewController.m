//
//  LIEItemViewController.m
//  Doer
//
//  Created by Liearth on 14-10-5.
//  Copyright (c) 2014年 Liearth. All rights reserved.
//

#import "LIEItemViewController.h"
#import "LIEItemCustomCell.h"
#import "LIEItemEditViewController.h"
#import "LIEColor.h"
#import "ListModel.h"
#import "LIEItemTableView.h"

#define openState @"open"
#define doneState @"done"
#define stateKey @"state"
#define itemKey @"item"

@interface LIEItemViewController () <LIEItemCustomCellDelegate>

@end

static UIImageView *arrowView;
static UIImageView *addView;

@implementation LIEItemViewController


@synthesize itemArray = _itemArray;
@synthesize originalString;
@synthesize presentIndexPath = _presentIndexPath;
@synthesize listIndexPath = _listIndexPath;
@synthesize itemEditViewController = _itemEditViewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _itemArray = [[NSMutableArray alloc] init];
    _itemArray = [self readItemAtIndex:_listIndexPath];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sideBar"] style:UIBarButtonItemStyleDone target:self action:@selector(showSideBar)];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addBar"] style:UIBarButtonItemStyleDone target:self action:@selector(addItem)];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    self.tableView.backgroundColor = [LIEColor ItemViewBackgroundColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addNewItem:) name:@"ADDITEM" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editItem:) name:@"EDITITEM" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView setSeparatorColor:[UIColor clearColor]];//分割线的颜色
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [_itemArray count];
}

- (UITableViewCell *)tableView:(LIEItemTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"itemCell";
    LIEItemCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.delegate = self;
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([tableView indexPathIsMovingIndexPath:indexPath]) {
        [cell prepareForMove];
    }
    else
    {
        if (tableView.movingIndexPath != nil) {
            indexPath = [tableView adaptedIndexPathForRowAtIndexPath:indexPath];
        }
        cell.listModel = [[self readModelAtIndex] objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (BOOL)moveTableView:(LIEItemTableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)moveTableView:(LIEItemTableView *)tableView moveRowFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSInteger openCount = [self getOpenStateCount];
//    
//    [_itemArray exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    NSLog(@"fromeIndexPath is %@",[_itemArray objectAtIndex:fromIndexPath.row]);
    
    if (toIndexPath.row >= openCount) {
        [[_itemArray objectAtIndex:fromIndexPath.row] setObject:doneState forKey:stateKey];
        
        id doneObject = [_itemArray objectAtIndex:fromIndexPath.row];
        
        [_itemArray removeObjectAtIndex:fromIndexPath.row];
        [_itemArray insertObject:doneObject atIndex:toIndexPath.row];
    }
    else
    {
        [[_itemArray objectAtIndex:fromIndexPath.row] setObject:openState forKey:stateKey];
        
        id openObject = [_itemArray objectAtIndex:fromIndexPath.row];
        
        [_itemArray removeObjectAtIndex:fromIndexPath.row];
        [_itemArray insertObject:openObject atIndex:toIndexPath.row];
    }
    NSLog(@"toIndexPath is %ld",(long)toIndexPath.row);
    
    [self writeToFile];
}

//The delegate method
- (void)panLeftToDeleteCell:(UITableViewCell *)myCell//向左滑动删除cell，注册函数
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:myCell];
    
    [_itemArray removeObjectAtIndex:indexPath.row];
    
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self writeToFile];
}

- (void)panRightToCompleteCell:(UITableViewCell *)myCell//向右滑动完成cell，注册函数
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:myCell];//当前cell的indexPath
    
    NSInteger openCount = [self getOpenStateCount];
    
    if (indexPath.row < openCount) {
        
        [[_itemArray objectAtIndex:indexPath.row] setObject:doneState forKey:stateKey];
        id doneObject = [_itemArray objectAtIndex:indexPath.row];
        
        NSIndexPath *afterLastOpenIndexPath = [NSIndexPath indexPathForRow:openCount - 1 inSection:0];
        
        [_itemArray removeObjectAtIndex:indexPath.row];
        [_itemArray insertObject:doneObject atIndex:afterLastOpenIndexPath.row];
        
        [self.tableView moveRowAtIndexPath:indexPath toIndexPath:afterLastOpenIndexPath];
    }
    else
    {
        [[_itemArray objectAtIndex:indexPath.row] setObject:openState forKey:stateKey];
        id openObject = [_itemArray objectAtIndex:indexPath.row];
        
        NSIndexPath *lastOpenIndexPath = [NSIndexPath indexPathForRow:openCount inSection:0];
        
        [_itemArray removeObjectAtIndex:indexPath.row];
        [_itemArray insertObject:openObject atIndex:lastOpenIndexPath.row];
        [self.tableView moveRowAtIndexPath:indexPath toIndexPath:lastOpenIndexPath];
    }
    
    [self writeToFile];
}

- (void)panRightToShowList:(UITableViewCell *)myCell//向右滑动返回List界面
{
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self showSideBar];
}

- (void)tapTheCellToEdit:(UITableViewCell *)myCell//点击编辑cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:myCell];//当前cell的indexPath
    _presentIndexPath = indexPath;
    originalString = [[_itemArray objectAtIndex:indexPath.row] valueForKey:itemKey];
    
    [self showItemEditViewInOption:0 withText:[[_itemArray objectAtIndex:indexPath.row] valueForKey:itemKey]];
    
    [_itemArray removeObjectAtIndex:indexPath.row];
    
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self writeToFile];
    
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CANNOTPANITEMCELL" object:self userInfo:nil];
    
    arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"theArrow"]];
    arrowView.center = CGPointMake(scrollView.center.x, -22);
    [scrollView addSubview:arrowView];
    
    addView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add"]];
    addView.center = CGPointMake(scrollView.center.x, -22);
    addView.alpha = 0.0;
    [scrollView addSubview:addView];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{    CGFloat yFloat = scrollView.contentOffset.y;
    
    if (yFloat < -120) {
        addView.alpha = 1.0;
        arrowView.alpha = 0.0;
    }
    if (yFloat > -120) {
        addView.alpha = 0.0;
        arrowView.alpha = 1.0;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CANPANITEMCELL" object:self userInfo:nil];
    
    [addView removeFromSuperview];
    [arrowView removeFromSuperview];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y < -120) {
        
        [self showItemEditViewInOption:1 withText:nil];
    }
}

- (void)showSideBar
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadList" object:self userInfo:nil];
}

- (void)addItem
{
    [self showItemEditViewInOption:1 withText:nil];
}

- (void)showItemEditViewInOption:(int)showOption withText:(NSString *)text
{
    _itemEditViewController = [[LIEItemEditViewController alloc] init];
    
    _itemEditViewController.showOption = showOption;
    _itemEditViewController.text = text;
    
    [self.navigationController.view addSubview:_itemEditViewController.view];

}

- (void)addNewItem:(NSNotification *)notification
{
    NSDictionary *nameDictionary = [notification userInfo];
    NSString *newText = [nameDictionary objectForKey:@"ITEMNAME"];
    NSString *emptyString = [newText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (_itemArray.count == 0) {
        if (emptyString.length == 0) {
        }
        else
        {
            [_itemArray addObject:[self setDictWithValue:newText state:openState]];
            //[_itemArray insertObject:[self setDictWithValue:newText state:openState] atIndex:0];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
            [self writeToFile];
        }
    }
    else
    {
        if (emptyString.length == 0) {
        }
        else
        {
            [_itemArray insertObject:[self setDictWithValue:newText state:openState] atIndex:0];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
            [self writeToFile];
        }
    }
}

- (void)editItem:(NSNotification *)notification
{
    NSDictionary *nameDictionary = [notification userInfo];
    NSString *editText = [nameDictionary objectForKey:@"ITEMNAME"];
    NSString *emptyString = [editText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSUInteger theOPENCount = [self getOpenStateCount];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:theOPENCount inSection:0];
    
    if (_presentIndexPath.row < theOPENCount) {
        if (emptyString.length == 0) {
            [_itemArray insertObject:[self setDictWithValue:originalString state:openState] atIndex:_presentIndexPath.row];
        }
        else
        {
            [_itemArray insertObject:[self setDictWithValue:editText state:openState] atIndex:_presentIndexPath.row];
        }
        
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:_presentIndexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
    else
    {
        if (emptyString.length == 0) {
            [_itemArray insertObject:[self setDictWithValue:originalString state:openState] atIndex:indexPath.row];
        }
        else
        {
            [_itemArray insertObject:[self setDictWithValue:editText state:openState] atIndex:indexPath.row];
        }
        
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
    
    [self writeToFile];
    
}

- (NSUInteger)getOpenStateCount
{
    NSUInteger theOPENCount = 0;
    
    for (int i = 0; i <_itemArray.count; i++) {
        if ([[[_itemArray objectAtIndex:i] valueForKey:@"state"]  isEqual: openState]) {
            theOPENCount ++;
        }
    }
    
    return theOPENCount;
}

- (void)writeToFile
{
//    NSString *listPath = [[NSBundle mainBundle] pathForResource:@"List" ofType:@"plist"];
//    NSMutableArray *listArray = [[NSMutableArray alloc] initWithContentsOfFile:listPath];
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [path objectAtIndex:0];
    //NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *plistSuffix = @".plist";
    NSString *plistPath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",@"MyList",plistSuffix]];
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    [array removeObjectAtIndex:_listIndexPath.row];
    [array insertObject:_itemArray atIndex:_listIndexPath.row];
    //[array replaceObjectAtIndex:_listIndexPath.row withObject:_itemArray];
    
    BOOL success = [array writeToFile:plistPath atomically:YES];
    if (success) {
        NSLog(@"Item write to file success");
    }
    else
    {
        NSLog(@"Item write to file fail");
    }
}

- (NSMutableArray *)readModelAtIndex
{
    NSMutableArray *itemModelArray = [[NSMutableArray alloc] init];
    
    for (NSMutableDictionary *dict in _itemArray)
    {
        [itemModelArray addObject:[ListModel listWithDict:dict]];
    }
    
    return itemModelArray;
}

- (NSMutableArray *)readItemAtIndex:(NSIndexPath *)indexPath
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [path objectAtIndex:0];
    //NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *plistSuffix = @".plist";
    NSString *plistPath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",@"MyList",plistSuffix]];
    
    NSMutableArray *listArray = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    NSMutableArray *array = nil;
    array = [listArray objectAtIndex:indexPath.row];
    
    return array;
}

- (NSMutableDictionary *)setDictWithValue:(NSString *)value state:(NSString *)state
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:value forKey:@"item"];
    [dict setObject:state forKey:@"state"];
    
    return dict;
}

@end
