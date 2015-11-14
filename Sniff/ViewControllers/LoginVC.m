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
#import "EventsTableVC.h"

@interface LoginVC () <UITextFieldDelegate> {
    BOOL shouldReturnToEvent;
}

@end

@implementation LoginVC

- (instancetype)init {
    if (self = [super init]) {
        shouldReturnToEvent = NO;
    }
    return self;
}

- (instancetype)initWithTurningBack:(BOOL)event {
    if (self = [super init]) {
        if (event) {
            shouldReturnToEvent = YES;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.loginType = LoginType_Login;
    [self.loginButton setTitle:@"Trimite" forState:UIControlStateNormal];
    self.firstNameHeightConstraint.constant = 0;
    self.lastNameHeightConstraint.constant = 0;
    self.imageBottomLoginConstraint.priority = 999;
    [self.view layoutIfNeeded];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDismiss:) name:UIKeyboardWillHideNotification object:nil];
    
    self.loginButton.layer.cornerRadius = 7.5;
    self.registerButton.layer.cornerRadius = 7.5;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    switch (self.loginType) {
        case LoginType_Login:
            self.passwordWidthConstraint.constant = self.view.frame.size.width - 16;
            self.confirmPasswordWidthConstraint.constant = 0;
            self.password.returnKeyType = UIReturnKeyDone;
            self.confirmPassword.tag = -1;  //  Eliminate it from the text fields evidence
            break;
            
        case LoginType_Register:
            self.passwordWidthConstraint.constant = self.view.frame.size.width/2 - 12;
            self.confirmPasswordWidthConstraint.constant = self.view.frame.size.width/2 - 12;
            self.password.returnKeyType = UIReturnKeyNext;
            self.confirmPassword.tag = 4;
            break;
            
        default:
            break;
    }

    [self.view layoutIfNeeded];
}

- (IBAction)loginButtonPressed:(id)sender {
    switch (self.loginType) {
        case LoginType_Login: {
            User *user = [[User alloc] init];
            user.email = self.email.text;
            user.password = self.password.text;
            
            MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            progressHud.labelText = @"Autentificare...";
            
            [[AuthenticationController sharedInstance] loginUser:user
                                                  withCompletion:^(BOOL success, NSString *message, AuthenticationController *completion) {
                                                      if (success) {
                                                          [progressHud hide:YES];
                                                          if (shouldReturnToEvent) {
                                                              [self.navigationController popViewControllerAnimated:YES];
                                                              [[[UIAlertView alloc] initWithTitle:nil
                                                                                          message:message
                                                                                         delegate:nil
                                                                                cancelButtonTitle:@"OK"
                                                                                otherButtonTitles: nil] show];
                                                          } else {
                                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"UserSuccessfullyLoggedInNotification" object:nil];
                                                          }
                                                      } else {
                                                          [[[UIAlertView alloc] initWithTitle:nil
                                                                                      message:message
                                                                                     delegate:nil
                                                                            cancelButtonTitle:@"OK"
                                                                            otherButtonTitles: nil] show];
                                                          [progressHud hide:YES];
                                                      }
                                                  }];
            break;

        }
            
        case LoginType_Register: {
            self.firstNameHeightConstraint.constant = 0;
            self.lastNameHeightConstraint.constant = 0;
            self.loginType = LoginType_Login;
            [self.registerButton setTitle:@"Inregistrare" forState:UIControlStateNormal];
            [self.loginButton setTitle:@"Trimite" forState:UIControlStateNormal];
            self.imageBottomLoginConstraint.priority = 999;
            [self.view layoutIfNeeded];
            break;
        }
            
        default:
            break;
    }
}

- (IBAction)registerButtonPressed:(id)sender {
    switch (self.loginType) {
        case LoginType_Login: {
            self.firstNameHeightConstraint.constant = 30;
            self.lastNameHeightConstraint.constant = 30;
            self.loginType = LoginType_Register;
            [self.loginButton setTitle:@"Autentificare" forState:UIControlStateNormal];
            [self.registerButton setTitle:@"Trimite" forState:UIControlStateNormal];
            self.imageBottomLoginConstraint.priority = 997;
            [self.view layoutIfNeeded];
            break;
        }
            
        case LoginType_Register: {
            User *user = [[User alloc] init];
            user.first_name = self.first_name.text;
            user.last_name = self.last_name.text;
            user.email = self.email.text;
            user.password = self.password.text;
            
            if (![user.password length] || ![self.confirmPassword.text length] || ![user.first_name length] || ![user.last_name length] || ![user.email length]) {
                [[[UIAlertView alloc] initWithTitle:nil
                                            message:@"Te rog sa completezi toate campurile"
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles: nil] show];
                return;
            } else if (![user.password isEqualToString:self.confirmPassword.text]) {
                [[[UIAlertView alloc] initWithTitle:nil
                                            message:@"Cele doua parole nu se potrivesc"
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles: nil] show];
                return;
            }
            
            MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            progressHud.labelText = @"Inregistrare...";
            
            [[AuthenticationController sharedInstance] registerUser:user
                                                     withCompletion:^(BOOL success, NSString *message, AuthenticationController *completion) {
                                                         if (success) {
                                                             [progressHud hide:YES];
                                                             if (shouldReturnToEvent) {
                                                                 [self.navigationController popViewControllerAnimated:YES];
                                                                 [[[UIAlertView alloc] initWithTitle:nil
                                                                                             message:@"Autentificare cu succes"
                                                                                            delegate:nil
                                                                                   cancelButtonTitle:@"OK"
                                                                                   otherButtonTitles: nil] show];
                                                             } else {
                                                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"UserSuccessfullyLoggedInNotification" object:nil];
                                                             }
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

- (void)keyboardAppear:(NSNotification*)notification {
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    [UIView animateWithDuration:0
                     animations:^{
                         self.passwordBottomConstraint.constant = keyboardFrameBeginRect.size.height - 68;
                         self.confirmPasswordBottomConstraint.constant = keyboardFrameBeginRect.size.height - 68;
                         [self.view layoutIfNeeded];
                     }];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(tapToDismissKeyboard)]];
}

- (void)keyboardDismiss:(NSNotification*)notification {
    [UIView animateWithDuration:0
                     animations:^{
                         self.passwordBottomConstraint.constant = 8;
                         self.confirmPasswordBottomConstraint.constant = 8;
                         [self.view layoutIfNeeded];
                     }];
}

- (void)tapToDismissKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        NSInteger nextTag = textField.tag + 1;
        
        UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
        if (nextResponder) {
            [nextResponder becomeFirstResponder];
        } else {
            [textField resignFirstResponder];
        }
    }
    
    return YES;
}

@end
