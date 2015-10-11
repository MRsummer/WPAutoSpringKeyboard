//
//  WPAutoSpringTextViewController.m
//  wespy
//
//  Created by ZhuGuangwen on 15/10/10.
//  Copyright © 2015年 wepie. All rights reserved.
//

#import "WPAutoSpringTextViewController.h"
#import "UIResponder+FirstResponder.h"

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation WPAutoSpringTextViewController{
    BOOL keyboardIsShowing;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self enableEditTextScroll];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked)]];
}

- (void)viewClicked{
    if(keyboardIsShowing){
        id responder = [UIResponder currentFirstResponder];
        if([responder isKindOfClass:[UITextView class]] || [responder isKindOfClass:[UITextField class]]){
            UIView *view = responder;
            [view resignFirstResponder];
        }
    }
}

- (CGFloat)shouldScrollWithKeyboardHeight:(CGFloat)keyboardHeight{
    id responder = [UIResponder currentFirstResponder];
    if([responder isKindOfClass:[UITextView class]] || [responder isKindOfClass:[UITextField class]]){
        UIView *view = responder;
        CGFloat y = [responder convertPoint:CGPointZero toView:[UIApplication sharedApplication].keyWindow].y;
        CGFloat bottom = y + view.frame.size.height;
        NSLog(@"shouldScrollWithKeyboardHeight -->keyboradHeight %@, keyboradBottom %@, viewY %@, bottom %@", @(keyboardHeight), @(SCREEN_HEIGHT - keyboardHeight), @(y), @(bottom));
        if(bottom > SCREEN_HEIGHT - keyboardHeight){
            return bottom - (SCREEN_HEIGHT - keyboardHeight);
        }
    }
    return 0;
}

- (void)enableEditTextScroll{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wpKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wpKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wpKeyboardDidShow) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wpKeyboardDidHide) name:UIKeyboardDidHideNotification object:nil];
}

- (void)wpKeyboardDidShow{
    keyboardIsShowing = YES;
}

- (void)wpKeyboardDidHide{
    keyboardIsShowing = NO;
}

- (void)wpKeyboardWillHide:(NSNotification *)note {
    float duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    __weak WPAutoSpringTextViewController *weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        CGRect bounds = weakSelf.view.bounds;
        weakSelf.view.bounds = CGRectMake(0, 0, bounds.size.width, bounds.size.height);
    }];
}

- (void)wpKeyboardWillShow:(NSNotification *)note {
    float duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat keyboardHeight = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    CGFloat shouldScrollHeight = [self shouldScrollWithKeyboardHeight:keyboardHeight];
    if(shouldScrollHeight == 0){
        return;
    }
    __weak WPAutoSpringTextViewController *weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        CGRect bounds = weakSelf.view.bounds;
        weakSelf.view.bounds = CGRectMake(0, shouldScrollHeight + 10, bounds.size.width, bounds.size.height);
    }];
}

@end
