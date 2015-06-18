//
//  LIEListEditViewController.m
//  Doer
//
//  Created by Liearth on 14/12/3.
//  Copyright (c) 2014年 Liearth. All rights reserved.
//

#import "LIEListEditViewController.h"
#import "LIEColor.h"

@interface LIEListEditViewController ()

@end

@implementation LIEListEditViewController

@synthesize myTextField = _myTextField;
@synthesize myView = _myView;
@synthesize myVisualEffectView = _myVisualEffectView;
@synthesize showOption = _showOption;
@synthesize text = _text;
@synthesize backgroundTap = _backgroundTap;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _myTextField = [[UITextField alloc] init];
    _myTextField.returnKeyType = UIReturnKeyDone;
    
    _myView = [[UIView alloc] init];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    _myVisualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    _myVisualEffectView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _myVisualEffectView.alpha = 0.0;
    
    
    switch (_showOption) {
        case 0:
        {
            //toLeft
            
            _myTextField.frame = CGRectMake(2 * self.view.frame.size.width + 15, 0, self.view.frame.size.width - 30, 44);
            _myTextField.text = _text;
            _myTextField.textColor = [LIEColor editOrAddTextColor];
            [self.myTextField addTarget:self action:@selector(keyEditedAndRemoveController) forControlEvents:UIControlEventEditingDidEndOnExit];
            
            _myView.frame = CGRectMake(2 * self.view.frame.size.width, 20, self.view.frame.size.width, 44);
            _myView.backgroundColor = [LIEColor ListEditTextColor];
            
            [self.view addSubview:_myVisualEffectView];
            [_myVisualEffectView.contentView addSubview:_myView];
            [_myView addSubview:_myTextField];
            
            _backgroundTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editedAndRemoveController:)];
            _backgroundTap.numberOfTapsRequired = 1;
            [self.view addGestureRecognizer:_backgroundTap];
            
            [UIView animateWithDuration:0.5 animations:^{
                _myTextField.frame = CGRectMake(15, 0, self.view.frame.size.width - 30, 44);
                _myView.frame = CGRectMake(0, 20, self.view.frame.size.width, 44);
                _myVisualEffectView.alpha = 1.0;
            } completion:^(BOOL finished) {
                [_myTextField becomeFirstResponder];
            }];
        }
            break;
        case 1:
        {
            //toRight
            
            _myTextField.frame = CGRectMake(2 * self.view.frame.size.width + 15, 0, self.view.frame.size.width - 30, 44);
            _myTextField.textColor = [LIEColor editOrAddTextColor];
            [self.myTextField addTarget:self action:@selector(keyAddedAndRemoveController) forControlEvents:UIControlEventEditingDidEndOnExit];
            
            _myView.frame = CGRectMake(-self.view.frame.size.width, 20, self.view.frame.size.width, 44);
            _myView.backgroundColor = [LIEColor ListAddTextColor];
            
            [self.view addSubview:_myVisualEffectView];
            [_myVisualEffectView.contentView addSubview:_myView];
            [_myView addSubview:_myTextField];
            
            _backgroundTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addedAndRemoveController:)];
            _backgroundTap.numberOfTapsRequired = 1;
            [self.view addGestureRecognizer:_backgroundTap];
            
            [UIView animateWithDuration:0.5 animations:^{
                _myVisualEffectView.alpha = 1.0;
                _myTextField.frame = CGRectMake(15, 0, self.view.frame.size.width - 30, 44);
                _myView.frame = CGRectMake(0, 20, self.view.frame.size.width, 44);
            } completion:^(BOOL finished) {
                [_myTextField becomeFirstResponder];
            }];
        }
            break;
            
        default:
            break;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)removeListEditViewInOption:(int)removeOption
{
    [self.myTextField resignFirstResponder];
    switch (removeOption) {
        case 0:
        {
            [UIView animateWithDuration:0.5 animations:^{
                self.myView.center = CGPointMake(-2 * self.myView.center.x, self.myView.center.y);
                self.myTextField.center = CGPointMake(-2 * self.myTextField.center.x, self.myTextField.center.y);
                self.myVisualEffectView.alpha = 0.1;
            } completion:^(BOOL finished) {
                
                [self.myTextField removeFromSuperview];
                [self.myView removeFromSuperview];
                [self.myVisualEffectView removeFromSuperview];
                [self.view removeFromSuperview];
                
                [self.view removeGestureRecognizer:_backgroundTap];
                [self removeFromParentViewController];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ADDLIST" object:self userInfo:@{@"LISTNAME":self.myTextField.text}];
            }];
        }
            break;
        case 1:
        {
            [UIView animateWithDuration:0.5 animations:^{
                self.myView.center = CGPointMake(3 * self.myView.center.x, self.myView.center.y);
                self.myTextField.center = CGPointMake(3 * self.myTextField.center.x, self.myTextField.center.y);
                self.myVisualEffectView.alpha = 0.1;
            } completion:^(BOOL finished) {
                
                [self.myTextField removeFromSuperview];
                [self.myView removeFromSuperview];
                [self.myVisualEffectView removeFromSuperview];
                [self.view removeFromSuperview];
                
                [self.view removeGestureRecognizer:_backgroundTap];
                [self removeFromParentViewController];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"EDITLIST" object:self userInfo:@{@"LISTNAME":self.myTextField.text}];
            }];
        }
            break;
        default:
            break;
    }
}

- (void)editedAndRemoveController:(UIGestureRecognizer *)recognizer
{
    if (recognizer.numberOfTouches == 1) {
        //NSLog(@"editedAndRemove");
        [self removeListEditViewInOption:1];
    }
}

- (void)addedAndRemoveController:(UIGestureRecognizer *)recognizer
{
    if (recognizer.numberOfTouches == 1) {
        //NSLog(@"addedAndRemove");
        [self removeListEditViewInOption:0];
    }
}

- (void)keyEditedAndRemoveController
{
    [self removeListEditViewInOption:1];
}

- (void)keyAddedAndRemoveController
{
    [self removeListEditViewInOption:0];
}


@end
