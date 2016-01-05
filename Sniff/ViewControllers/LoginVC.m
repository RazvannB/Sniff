//
//  LoginVC.m
//  Sniff
//
//  Created by Razvan Balint on 21/07/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

//  STOP

#define fieldHeight 40
#define fieldWidthBigScreen 300
#define fieldWidthSmallScreen 256

#import "LoginVC.h"
#import "User.h"
#import "ServerRequest.h"
#import "AuthenticationController.h"
#import "MBProgressHUD.h"
#import "EventsTableVC.h"
#import "AuthenticationVC.h"
#import "Macros.h"

@interface LoginVC () <UITextFieldDelegate, AuthenticationVCDelegate> {
    BOOL shouldReturnToEvent;
    BOOL keyboardOnScreen;
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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.loginButton.layer.cornerRadius = 7.5;
    self.registerButton.layer.cornerRadius = 7.5;
    self.loginFacebookButton.layer.cornerRadius = 7.5;
    
    if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5) {
        self.loginButtonWidthConstraint.constant = fieldWidthSmallScreen;
        self.registerButtonWidthConstraint.constant = fieldWidthSmallScreen;
        self.loginFacebookButtonWidthConstraint.constant = fieldWidthSmallScreen;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(animateLogoImage)];
    self.logoImage.userInteractionEnabled = YES;
    [self.logoImage addGestureRecognizer:tap];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.imageTopConstraint.constant = (self.loginButton.frame.origin.y - self.logoImage.frame.size.height -
                                        self.navigationController.navigationBar.frame.size.height -
                                        [UIApplication sharedApplication].statusBarFrame.size.height)/2;
}

- (void)animateLogoImage {
    
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut animations:^{
                            
                            self.logoImage.transform = CGAffineTransformMakeScale(1.75, 1.75);
                            
                        } completion:^(BOOL finished){
                            
                            [UIView animateWithDuration:0.5
                                                  delay:0
                                                options:UIViewAnimationOptionCurveEaseOut animations:^{
                                                    
                                                    self.logoImage.transform = CGAffineTransformIdentity;
                                                    
                                                } completion:^(BOOL finished){
                                                    
                                                }];

                        }];
}

- (IBAction)loginButtonPressed:(id)sender {
    AuthenticationVC *auth = [[AuthenticationVC alloc] init];
    [auth setAuthType:AuthenticationVCType_Login];
    [auth setDelegate:self];
    auth.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.navigationController presentViewController:auth animated:YES completion:nil];
}

- (IBAction)registerButtonPressed:(id)sender {
    AuthenticationVC *auth = [[AuthenticationVC alloc] init];
    [auth setAuthType:AuthenticationVCType_Register];
    [auth setDelegate:self];
    auth.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.navigationController presentViewController:auth animated:YES completion:nil];
}

#pragma mark - AuthenticationVCDelegate

- (void)authenticationVC:(AuthenticationVC *)authVC authenticationButtonTouched:(id)sender user:(User*)user {
    
    switch (authVC.authType) {
        case AuthenticationVCType_Login: {
            MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            progressHud.labelText = @"Autentificare...";
            
            [[AuthenticationController sharedInstance]
             loginUser:user
             withCompletion:^(BOOL success, NSString *message, AuthenticationController *completion) {
                 if (success) {
                     [self.navigationController dismissViewControllerAnimated:authVC completion:nil];
                     
                     [progressHud hide:YES];
                     if (shouldReturnToEvent) {
                         [self.navigationController popViewControllerAnimated:YES];
                         [[[UIAlertView alloc] initWithTitle:nil
                                                     message:message
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles: nil] show];
                     } else {
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"UserSuccessfullyLoggedInNotification"
                                                                              object:nil];
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
            
        case AuthenticationVCType_Register: {
            MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            progressHud.labelText = @"Creare cont...";
            
            [[AuthenticationController sharedInstance]
             registerUser:user
             withCompletion:^(BOOL success, NSString *message, AuthenticationController *completion) {
                 if (success) {
                     [self.navigationController dismissViewControllerAnimated:authVC completion:nil];
                     
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

- (void)authenticationVC:(AuthenticationVC *)authVC forgotPasswordButtonTouched:(id)sender {
    
}

- (void)authenticationVC:(AuthenticationVC *)authVC backButtonTouched:(id)sender {
    [self.navigationController dismissViewControllerAnimated:authVC completion:nil];
}

#pragma mark - UITextFieldDelegate

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
