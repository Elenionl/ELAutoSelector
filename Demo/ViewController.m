//
//  ViewController.m
//  ELAutoSelectorHelper
//
//  Created by Elenion on 2017/11/22.
//  Copyright © 2017年 elenion. All rights reserved.
//

#import "ViewController.h"
#import "ELAutoSelectorHelper.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self checkButtonResponse];
    [self checkNotificationResponse];
    [self checkBlocksRecycle];
    [self checkRecognizerResponse];
}

- (void)checkButtonResponse {
    UIButton *buttonOne = [UIButton new];
    [buttonOne addTarget:ELTarget action:ELAction(^(id  _Nonnull _self, id  _Nonnull sender) {
        NSLog(@"Button One Tapped");
    }, self) forControlEvents:UIControlEventTouchUpInside];
    buttonOne.backgroundColor = [UIColor blueColor];
    [buttonOne setTitle:@"Button One" forState:UIControlStateNormal];
    [self.view addSubview:buttonOne];
    buttonOne.frame = CGRectMake(50, 50, 150, 50);;
    UIButton *buttonTwo = [UIButton new];
    UIButton *unstableDependency = [UIButton new];
    [buttonTwo addTarget:ELTarget action:ELAction(^(id  _Nonnull _self, id  _Nonnull sender) {
        NSLog(@"Button Two Tapped");
    }, unstableDependency) forControlEvents:UIControlEventTouchUpInside];
    buttonTwo.backgroundColor = [UIColor blueColor];
    [buttonTwo setTitle:@"Button Two" forState:UIControlStateNormal];
    [self.view addSubview:buttonTwo];
    buttonTwo.frame = CGRectMake(50, 120, 150, 50);
}

- (void)checkBlocksRecycle {
    // Check If Block Is Recycled
    UIButton *button = [UIButton new];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"Recycled" attributes:nil];
    __weak typeof(string) stringWeak = string;
    [button addTarget:ELTarget action:ELAction(^(id  _Nonnull _self, id  _Nonnull sender) {
        NSLog(@"This block will be recycled %@", stringWeak);
    }, string) forControlEvents:UIControlEventTouchUpInside];
}

- (void)checkNotificationResponse {
    // Check As Notification Target
    UITextField *textField = [UITextField new];
    [textField addTarget:ELTarget action:ELAction(^(id  _Nonnull _self, id  _Nonnull sender) {
        NSLog(@"Text changed by target action");
    }, textField) forControlEvents:UIControlEventEditingChanged];
    textField.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:textField];
    textField.frame = CGRectMake(50, 250, 200, 50);
    [[NSNotificationCenter defaultCenter] addObserver:ELTarget selector:ELAction(^(id  _Nonnull _self, id  _Nonnull sender) {
        NSLog(@"Text changed by Notification");
    }, nil) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)checkRecognizerResponse {
    UIGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] init];
    [recognizer addTarget:ELTarget action:ELAction(^(id  _Nonnull _self, id  _Nonnull sender) {
        NSLog(@"UIGestureRecognizer Invoked");
    }, recognizer)];
    [self.view addGestureRecognizer:recognizer];
}

@end
