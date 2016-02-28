//
//  LIEItemCustomCell.m
//  Doer
//
//  Created by Liearth on 14-10-5.
//  Copyright (c) 2014年 Liearth. All rights reserved.
//

#import "LIEItemCustomCell.h"
#import "LIEItemViewController.h"
#import "LIEColor.h"
#import "ListModel.h"

#define openState @"open"

@interface LIEItemCustomCell ()

@end

@implementation LIEItemCustomCell


@synthesize myContentView = _myContentView;
@synthesize myText = _myText;
@synthesize panGesture = _panGesture;
@synthesize tapGesture = _tapGesture;
@synthesize delegate;
@synthesize doneView = _doneView;
@synthesize clearView = _clearView;
@synthesize listView = _listView;

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setCell];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canNotPan:) name:@"CANNOTPANITEMCELL" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canPan:) name:@"CANPANITEMCELL" object:nil];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCell
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat cellWidth = screenBounds.size.width;
    CGFloat cellHeight = 44;
    
    _myContentView = [[UIView alloc] init];
    _myContentView.frame = CGRectMake(0, 0, cellWidth, cellHeight);
    //_myContentView.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:_myContentView];
    
    self.backgroundColor = [LIEColor ItemViewBackgroundColor];
    //_myContentView.layer.cornerRadius = 5.0;
    //_myContentView.layer.borderWidth = 0.5;
    //_myContentView.layer.borderColor = [UIColor orangeColor].CGColor;
    
    _myText = [[UILabel alloc] init];
    _myText.frame = CGRectMake(15, 0, cellWidth - 30, cellHeight);
    _myText.textColor = [LIEColor ItemTextOpenColor];
    [self.myContentView addSubview:_myText];
    
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panCell:)];
    _panGesture.delegate = self;
    [self.myContentView addGestureRecognizer:_panGesture];
    self.panGesture.minimumNumberOfTouches = 1;
    self.panGesture.maximumNumberOfTouches = 1;
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCell:)];
    _tapGesture.numberOfTapsRequired = 1;
    _tapGesture.delegate = self;
    [self.myContentView addGestureRecognizer:_tapGesture];
    
    
    
    _doneView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"done"]];
    _clearView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"clear"]];
    _listView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list"]];
    
    _doneView.center = CGPointMake(self.myContentView.frame.origin.x - 22, self.myContentView.center.y);
    _clearView.center = CGPointMake(self.myContentView.frame.origin.x + self.myContentView.frame.size.width + 22, self.myContentView.center.y);
    _listView.center = CGPointMake(self.myContentView.frame.origin.x - 22, self.myContentView.center.y);
    
    _doneView.alpha = 0.0;
    _clearView.alpha = 0.0;
    _listView.alpha = 0.0;
}

- (void)setListModel:(ListModel *)listModel
{
    _listModel = listModel;
    _myText.text = listModel.item;//设置item
    
    [self checkStateOnModel:listModel];
}

- (void)checkStateOnModel:(ListModel *)model
{
    if ([model.state isEqualToString:openState]) {
        self.myContentView.backgroundColor = [LIEColor ItemCellOpenColor];
        self.myText.textColor = [LIEColor ItemTextOpenColor];
    }
    else
    {
        self.myContentView.backgroundColor = [LIEColor ItemCellDoneColor];
        self.myText.textColor = [LIEColor ItemTextDoneColor];
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
            //NSLog(@"UIGestureRecognizerStateBegan");
            
            /*
            CGPoint velocity = [recognizer velocityInView:self.myContentView];
            NSLog(@"velocity is %f",velocity.y);
            if (velocity.y > 10) {
                recognizer.enabled = NO;
                self.myContentView.center = self.contentView.center;
            }
             */
            
            [self.myContentView addSubview:_doneView];
            [self.myContentView addSubview:_clearView];
            [self.myContentView addSubview:_listView];
            
            [self.delegate canNotScrollTableView];
            
            
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (x <  -60) {
                self.contentView.backgroundColor = [LIEColor ItemCellWillClearColor];
                _clearView.alpha = 1.0;
            }
            else if (x > 60 && x <= 120)
            {
                self.contentView.backgroundColor = [LIEColor ItemCellWillDoneColor];
                _doneView.alpha = 1.0;
                _listView.alpha = 0.0;
            }
            else if (x > 120)
            {
                self.contentView.backgroundColor = [LIEColor ListCellOpenColor];
                _listView.alpha = 1.0;
                _doneView.alpha = 0.0;
            }
            else
            {
                self.contentView.backgroundColor = [LIEColor ItemViewBackgroundColor];
                _doneView.alpha = 0.0;
                _clearView.alpha = 0.0;
                _listView.alpha = 0.0;
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (x <  -60) {
                //[self.delegate panLeftToDeleteCell:self];//注册函数，向左滑动删除cell
                [UIView animateWithDuration:0.2 animations:^{
                    //self.myContentView.backgroundColor = [UIColor clearColor];
                    self.myContentView.center = CGPointMake(-2 * self.contentView.center.x, self.contentView.center.y);
                } completion:^(BOOL finished) {
                    [self.delegate panLeftToDeleteCell:self];
                }];
            }
            else if (x > 60 && x <= 120)
            {
                self.contentView.backgroundColor = [LIEColor ItemViewBackgroundColor];
                
                //[self.delegate panRightToCompleteCell:self];//注册函数，向右滑动完成cell
                if ([self color:self.myContentView.backgroundColor isEqualToColor:[LIEColor ItemCellOpenColor] withTolerance:0.0]) {
                    [UIView animateWithDuration:0.2 animations:^{
                        self.myContentView.center = self.contentView.center;
                        self.myContentView.backgroundColor = [LIEColor ItemCellDoneColor];
                        self.myText.textColor = [LIEColor ItemTextDoneColor];
                    } completion:^(BOOL finished) {
                        [self.delegate panRightToCompleteCell:self];
                    }];
                }
                else
                {
                    [UIView animateWithDuration:0.2 animations:^{
                        self.myContentView.center = self.contentView.center;
                        self.myContentView.backgroundColor = [LIEColor ItemCellOpenColor];
                        self.myText.textColor = [LIEColor ItemTextOpenColor];
                    } completion:^(BOOL finished) {
                        [self.delegate panRightToCompleteCell:self];
                    }];
                }
            }
            else if (x > 120)
            {
                if ([self color:self.myContentView.backgroundColor isEqualToColor:[LIEColor ItemCellOpenColor] withTolerance:0.0]) {
                    [UIView animateWithDuration:0.2 animations:^{
                        //self.myContentView.backgroundColor = [LIEColor ItemCellOpenColor];
                        self.myContentView.center = self.contentView.center;
                    } completion:^(BOOL finished) {
                        [self.delegate panRightToShowList:self];
                    }];
                }
                else
                {
                    [UIView animateWithDuration:0.2 animations:^{
                        self.myContentView.backgroundColor = [LIEColor ItemCellDoneColor];
                        self.myContentView.center = self.contentView.center;
                    } completion:^(BOOL finished) {
                        [self.delegate panRightToShowList:self];
                    }];
                }

            }
            else
            {
                self.contentView.backgroundColor = [LIEColor ItemViewBackgroundColor];
                
                [UIView animateWithDuration:0.2 animations:^{
                    self.myContentView.center = self.contentView.center;
                }];
            }
            [_doneView removeFromSuperview];
            [_clearView removeFromSuperview];
            [_listView removeFromSuperview];
        }
            
        default:
            break;
    }
    
    [self.delegate canScrollTbaleView];
    //self.panGesture.enabled = NO;
    
    [recognizer setTranslation:CGPointZero inView:self.myContentView];

}

- (void)tapCell:(UIGestureRecognizer *)recognizer
{
    if (recognizer.numberOfTouches == 1) {
        [UIView animateWithDuration:0.3 animations:^{
            self.myContentView.center = CGPointMake(3 * self.contentView.center.x, self.contentView.center.y);
        } completion:^(BOOL finished) {
            [self.delegate tapTheCellToEdit:self];
        }];
    }
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

/*
- (void)backToOriginalPosition:(NSNotification *)notification
{
    NSString *originalString = self.myText.text;
    
    NSDictionary *nameDictionary = [notification userInfo];
    self.myText.text = [nameDictionary objectForKey:@"TEXT"];
    
    NSString *emptyString = [self.myText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([emptyString length] == 0) {
        self.myText.text = originalString;
    }
    
    [UIView animateWithDuration:0.5 delay:0.5 options:(UIViewAnimationOptionShowHideTransitionViews) animations:^{
        self.myContentView.center = CGPointMake(self.contentView.center.x, self.contentView.center.y);
    } completion:^(BOOL finished) {
        nil;
    }];
}
 */

@end
