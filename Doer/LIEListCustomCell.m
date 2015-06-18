//
//  LIEListCustomCell.m
//  Doer
//
//  Created by Liearth on 14-10-5.
//  Copyright (c) 2014年 Liearth. All rights reserved.
//

#import "LIEListCustomCell.h"
#import "LIEColor.h"
#import "ListModel.h"

#define openState @"open"

@implementation LIEListCustomCell

@synthesize myContentView = _myContentView;
@synthesize myText = _myText;
@synthesize panGesture = _panGesture;
@synthesize delegate;
@synthesize doneView = _doneView;
@synthesize clearView = _clearView;
@synthesize editView = _editView;


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat width = screenBounds.size.width;
    CGFloat cellHeight = 44;
    
    self.backgroundColor = [LIEColor ListViewBackgroundColor];
    
    _myContentView = [[UIView alloc] init];
    _myContentView.frame = CGRectMake(0, 0, width, cellHeight);
    //_myContentView.backgroundColor = [LIEColor ListCellOpenColor];
    [self.contentView addSubview:_myContentView];
    
    _myText = [[UILabel alloc] init];
    _myText.frame = CGRectMake(15, self.contentView.center.y, width - 30, cellHeight);
    [self.myContentView addSubview:_myText];
    _myText.textColor = [LIEColor ListTextOpenColor];
    
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panCell:)];
    _panGesture.delegate = self;
    [self.myContentView addGestureRecognizer:_panGesture];
    self.panGesture.minimumNumberOfTouches = 1;
    self.panGesture.maximumNumberOfTouches = 1;
    
    
    _doneView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"done"]];
    _clearView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clear"]];
    _editView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"edit"]];
    
    _doneView.center = CGPointMake(self.myContentView.frame.origin.x - 22, self.myContentView.center.y);
    _clearView.center = CGPointMake(self.myContentView.frame.origin.x + self.myContentView.frame.size.width + 22, self.myContentView.center.y);
    _editView.center = CGPointMake(self.myContentView.frame.origin.x - 22, self.myContentView.center.y);
    
    _doneView.alpha = 0.0;
    _clearView.alpha = 0.0;
    _editView.alpha = 0.0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canNotPan:) name:@"CANNOTPANLISTCELL" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canPan:) name:@"CANPANLISTCELL" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setListModel:(ListModel *)listModel
{
    _listModel = listModel;
    
    _myText.text = listModel.list;
    
    [self checkStateOnModel:listModel];
}

- (void)checkStateOnModel:(ListModel *)model
{
    if ([model.state isEqualToString:openState]) {
        self.myContentView.backgroundColor = [LIEColor ListCellOpenColor];
        self.myText.textColor = [LIEColor ListTextOpenColor];
    }
    else
    {
        self.myContentView.backgroundColor = [LIEColor ListCellDoneColor];
        self.myText.textColor = [LIEColor ListTextDoneColor];
    }
    self.myContentView.frame = CGRectMake(0, 0, self.myContentView.frame.size.width, self.myContentView.frame.size.height);
}

- (void)panCell:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.myContentView];
    
    //recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y);//左右拖动
    
    float x = recognizer.view.center.x - self.contentView.center.x;//移动的距离
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            
            [self.myContentView addSubview:_doneView];
            [self.myContentView addSubview:_clearView];
            [self.myContentView addSubview:_editView];
            [self.delegate canNotScrollTableView];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (x <  -60) {
                self.contentView.backgroundColor = [LIEColor ListCellWillClearColor];
                _clearView.alpha = 1.0;
            }
            else if (x > 60 && x <= 120)
            {
                self.contentView.backgroundColor = [LIEColor ListCellWillDoneColor];
                _doneView.alpha = 1.0;
                _editView.alpha = 0.0;
            }
            else if (x > 120)
            {
                self.contentView.backgroundColor = [UIColor orangeColor];
                _editView.alpha = 1.0;
                _doneView.alpha = 0.0;
            }
            else
            {
                self.contentView.backgroundColor = [LIEColor ListViewBackgroundColor];
                _doneView.alpha = 0.0;
                _clearView.alpha = 0.0;
                _editView.alpha = 0.0;
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (x <  -60) {
                self.contentView.backgroundColor = [LIEColor ListCellWillClearColor];
                //[self.delegate panLeftToDeleteCell:self];//注册函数，向左滑动删除cell
                [UIView animateWithDuration:0.2 animations:^{
                    self.myContentView.backgroundColor = [UIColor redColor];
                    self.myContentView.center = CGPointMake(-2 * self.contentView.center.x, self.contentView.center.y);
                } completion:^(BOOL finished) {
                    [self.delegate panLeftToDeleteCell:self];
                }];
            }
            else if (x > 60 && x <= 120)
            {
                self.contentView.backgroundColor = [LIEColor ListViewBackgroundColor];
                
                //[self.delegate panRightToCompleteCell:self];//注册函数，向右滑动完成cell
                
                if ([self color:self.myContentView.backgroundColor isEqualToColor:[LIEColor ListCellOpenColor] withTolerance:0.0]) {
                    [UIView animateWithDuration:0.2 animations:^{
                        self.myContentView.backgroundColor = [LIEColor ListCellDoneColor];
                        self.myText.textColor = [LIEColor ListTextDoneColor];
                        self.myContentView.center = self.contentView.center;
                    } completion:^(BOOL finished) {
                        [self.delegate panRightToCompleteCell:self];
                    }];
                }
                else
                {
                    [UIView animateWithDuration:0.2 animations:^{
                        self.myContentView.backgroundColor = [LIEColor ListCellOpenColor];
                        self.myText.textColor = [LIEColor ListTextOpenColor];
                        self.myContentView.center = self.contentView.center;
                    } completion:^(BOOL finished) {
                        [self.delegate panRightToCompleteCell:self];
                    }];
                }
            }
            else if (x > 120)
            {
                [UIView animateWithDuration:0.2 animations:^{
                    self.myContentView.backgroundColor = [LIEColor ListCellOpenColor];
                    self.myContentView.center = CGPointMake(3 * self.contentView.center.x, self.contentView.center.y);
                } completion:^(BOOL finished) {
                    [self.delegate panRightToEditCell:self];//向右滑动编辑cell
                }];
            }
            else
            {
                self.contentView.backgroundColor = [LIEColor ListViewBackgroundColor];
                
                [UIView animateWithDuration:0.2 animations:^{
                    self.myContentView.center = self.contentView.center;
                }];
            }
            
            [_doneView removeFromSuperview];
            [_clearView removeFromSuperview];
            [_editView removeFromSuperview];
        }
            
        default:
            break;
    }
    
    [self.delegate canScrollTbaleView];
    
    [recognizer setTranslation:CGPointZero inView:self.myContentView];
    
}

- (void)canNotPan:(NSNotification *)notification
{
    self.panGesture.enabled = NO;
}

- (void)canPan:(NSNotification *)notification
{
    self.panGesture.enabled = YES;
}

- (BOOL)color:(UIColor *)color1 isEqualToColor:(UIColor *)color2 withTolerance:(CGFloat)tolerance
{
    CGFloat r1, g1, b1, a1, r2, g2, b2, a2;
    [color1 getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [color2 getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    return

    fabs(r1 - r2) <= tolerance &&
    fabs(g1 - g2) <= tolerance &&
    fabs(b1 - b2) <= tolerance &&
    fabs(a1 - a2) <= tolerance;

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    //NSLog(@"the Gesture is %@;the other Gesture is %@",cellPanGestureRecognizer, otherGestureRecognizer);
    return YES;
}

- (void)prepareForMoveSnapshot
{
    // Should be implemented by subclasses if needed
}

- (void)prepareForMove
{
    //    self.textLabel.text = @"";
    //    self.detailTextLabel.text = @"";
    //    self.imageView.image = nil;
    self.hidden = YES;
}

@end
