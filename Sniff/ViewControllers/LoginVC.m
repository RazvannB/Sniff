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
#import "EventsController.h"
#import "MBProgressHUD.h"
#import "EventsTableVC.h"
#import "AuthenticationVC.h"
#import "Macros.h"
#import "NavigationControllerWithMenu.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface LoginVC () <AuthenticationVCDelegate> {
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
    
    [EventsController makeNavigationBarTranslucent:self.navigationController.navigationBar];
    
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.loginButton.layer.cornerRadius = 7.5;
    self.registerButton.layer.cornerRadius = 7.5;
    self.loginFacebookButton.layer.cornerRadius = 7.5;
    
    if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5) {
        self.loginButtonWidthConstraint.constant = fieldWidthSmallScreen;
        self.registerButtonWidthConstraint.constant = fieldWidthSmallScreen;
        self.loginFacebookButtonWidthConstraint.constant = fieldWidthSmallScreen;
        self.showEventsButtonWidthConstraint.constant = fieldWidthSmallScreen;
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(animateLogoImage)];
    self.logoImage.userInteractionEnabled = YES;
    [self.logoImage addGestureRecognizer:tap];
    
    if (shouldReturnToEvent) {
        self.showEventsButtonHeightConstraint.constant = 0;
        self.loginFacebookButtonBottomConstraint.constant = 0;
        self.showEventsButton.hidden = YES;
    }
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

- (void)registerUser:(User *)user {
    AuthenticationVC *auth = [[AuthenticationVC alloc] init];
    [auth setAuthType:AuthenticationVCType_Register];
    [auth setDelegate:self];
    auth.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.navigationController presentViewController:auth animated:YES completion:nil];
}

- (IBAction)loginViaFacebookButtonTouched:(id)sender {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    [login
     logInWithReadPermissions: @[@"public_profile", @"email"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             
             if ([FBSDKAccessToken currentAccessToken]) {
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"email,first_name,last_name"}]
                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                      if (!error) {
                          NSLog(@"Fetched user:%@", result);
                          User *user = [User initWithDictionary:@{@"first_name": result[@"first_name"],
                                                                  @"last_name": result[@"last_name"],
                                                                  @"email": result[@"email"]}];
                          user.password = [AuthenticationController hashString:result[@"id"] withKey:@"SniffEventsForiOS"];;
                          
                          MBProgressHUD *progressHud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                          progressHud.labelText = @"Autentificare...";
                          
                          [[AuthenticationController sharedInstance]
                           loginUser:user
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
                                       [[NSNotificationCenter defaultCenter] postNotificationName:@"UserSuccessfullyLoggedInNotification"
                                                                                           object:nil];
                                   }
                               } else {
                                   [[AuthenticationController sharedInstance]
                                    registerUser:user
                                    withCompletion:^(BOOL success, NSString *message, AuthenticationController *completion) {
                                        if (success) {
                                            
                                            [[AuthenticationController sharedInstance]
                                             loginUser:user
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
                                        } else {
                                            [progressHud hide:YES];
                                        }
                                    }];
                               }
                           }];
                      }
                  }];
             }
         }
     }];
}

- (IBAction)showEventsButtonPressed:(id)sender {
    
    EventsTableVC *events = [[EventsTableVC alloc] initWithType:EventsTableVCType_Default];
    events.navigationItem.leftBarButtonItem = [(NavigationControllerWithMenu *)self.navigationController menuButton];
    [self.navigationController setViewControllers:@[events] animated:YES];
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
                     [authVC resignFirstResponder];
                     [authVC dismissViewController];
                     
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
                     
                     [[AuthenticationController sharedInstance]
                      loginUser:user
                      withCompletion:^(BOOL success, NSString *message, AuthenticationController *completion) {
                          if (success) {
                              if (authVC) {
                                  [authVC resignFirstResponder];
                                  [authVC dismissViewController];
                              }
                              
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
            
        default:
            break;
    }
}

- (void)authenticationVC:(AuthenticationVC *)authVC forgotPasswordButtonTouched:(id)sender {
    [[[UIAlertView alloc] initWithTitle:nil
                                message:@"A aparut o eroare. Incercati mai tarziu"
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles: nil] show];
}

@end
