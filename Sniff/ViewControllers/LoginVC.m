//
//  LoginVC.m
//  Sniff
//
//  Created by Razvan Balint on 21/07/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "LoginVC.h"
#import "User.h"
#import "ServerRequest.h"
#import "AuthenticationController.h"
#import "MBProgressHUD.h"
#import "HomepageVC.h"

@interface LoginVC () <UITextFieldDelegate>

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.loginType = LoginType_Login;
    [self.loginButton setTitle:@"Submit" forState:UIControlStateNormal];
    self.firstNameHeightConstraint.constant = 0;
    self.lastNameHeightConstraint.constant = 0;
    [self.view layoutIfNeeded];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDismiss:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(id)sender {
    switch (self.loginType) {
        case LoginType_Login: {
            User *user = [[User alloc] init];
            user.email = self.email.text;
            user.password = self.password.text;
            
            MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            progressHud.labelText = @"Logging in...";
            
            [[AuthenticationController sharedInstance] loginUser:user
                                                  withCompletion:^(BOOL success, NSString *message, AuthenticationController *completion) {
                                                      if (success) {
                                                          [progressHud hide:YES];
                                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"UserSuccessfullyLoggedInNotification" object:nil];
                                                      } else {
                                                          [progressHud hide:YES];
                                                      }
                                                  }];
            break;

        }
            
        case LoginType_Register: {
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.firstNameHeightConstraint.constant = 0;
                                 self.lastNameHeightConstraint.constant = 0;
                                 [self.view layoutIfNeeded];
                             }];
            self.loginType = LoginType_Login;
            [self.registerButton setTitle:@"Register" forState:UIControlStateNormal];
            [self.loginButton setTitle:@"Submit" forState:UIControlStateNormal];
            break;
        }
            
        default:
            break;
    }
}

- (IBAction)registerButtonPressed:(id)sender {
    switch (self.loginType) {
        case LoginType_Login: {
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.firstNameHeightConstraint.constant = 30;
                                 self.lastNameHeightConstraint.constant = 30;
                                 [self.view layoutIfNeeded];
                             }];
            self.loginType = LoginType_Register;
            [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
            [self.registerButton setTitle:@"Submit" forState:UIControlStateNormal];
            break;
        }
            
        case LoginType_Register: {
            User *user = [[User alloc] init];
            user.first_name = self.first_name.text;
            user.last_name = self.last_name.text;
            user.email = self.email.text;
            user.password = self.password.text;
            
            MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            progressHud.labelText = @"Register...";
            
            [[AuthenticationController sharedInstance] registerUser:user
                                                     withCompletion:^(BOOL success, NSString *message, AuthenticationController *completion) {
                                                         if (success) {
                                                             [progressHud hide:YES];
                                                             [[NSNotificationCenter defaultCenter] postNotificationName:@"UserSuccessfullyLoggedInNotification" object:nil];
                                                         } else {
                                                             [progressHud hide:YES];
                                                         }
                                                     }];
            break;
        }
            
        default:
            break;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField; {
    [textField becomeFirstResponder];
}

- (void)keyboardAppear:(NSNotification*)notification {
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    [UIView animateWithDuration:0
                     animations:^{
                         self.passwordBottomConstraint.constant = 8 + keyboardFrameBeginRect.size.height - 76;
                         [self.view layoutIfNeeded];
                     }];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(tapToDismissKeyboard)]];
}

- (void)keyboardDismiss:(NSNotification*)notification {
    [UIView animateWithDuration:0
                     animations:^{
                         self.passwordBottomConstraint.constant = 8;
                         [self.view layoutIfNeeded];
                     }];
}

- (void)tapToDismissKeyboard {
    [self.view endEditing:YES];
}

@end
