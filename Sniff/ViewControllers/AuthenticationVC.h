//
//  AuthenticationVC.h
//  Sniff
//
//  Created by Razvan Balint on 14/11/15.
//  Copyright © 2015 Razvan Balint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

typedef enum {
    AuthenticationVCType_Login,
    AuthenticationVCType_Register,
    AuthenticationVCType_ForgotPassword,
    AuthenticationVCType_ResetPassword,
    AuthenticationVCType_Settings
} AuthenticationVCType;

@class AuthenticationVC;
@protocol AuthenticationVCDelegate <NSObject>

- (void)authenticationVC:(AuthenticationVC*)authVC authenticationButtonTouched:(id)sender user:(User*)user;
- (void)authenticationVC:(AuthenticationVC*)authVC forgotPasswordButtonTouched:(id)sender;
- (void)authenticationVC:(AuthenticationVC*)authVC backButtonTouched:(id)sender;

@end

@interface AuthenticationVC : UIViewController

@property (nonatomic, strong) id <AuthenticationVCDelegate> delegate;

@property (nonatomic) AuthenticationVCType authType;

@property (nonatomic, strong) User *user;

@property (nonatomic, weak) IBOutlet UITextField *firstName;
@property (nonatomic, weak) IBOutlet UITextField *lastName;
@property (nonatomic, weak) IBOutlet UITextField *email;
@property (nonatomic, weak) IBOutlet UITextField *password;
@property (nonatomic, weak) IBOutlet UITextField *confirmPassword;
@property (nonatomic, weak) IBOutlet UIButton *authButton;
@property (nonatomic, weak) IBOutlet UIButton *forgotButton;
@property (nonatomic, weak) IBOutlet UIButton *backButton;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *emailHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *emailWidthConstraint;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *firstNameHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *firstNameWidthConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *firstNameBottomConstraint;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lastNameHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lastNameWidthConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lastNameBottomConstraint;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *passwordWidthConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *passwordHeightConstraint;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *confirmPasswordWidthConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *confirmPasswordHeightConstraint;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *authHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *authWidthConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *authBottomConstraint;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lineHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lineWidthConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lineBottomConstraint;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *forgotHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *forgotWidthConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *forgotBottomConstraint;

- (void)setAuthType:(AuthenticationVCType)authType;

- (IBAction)authButtonTouched:(id)sender;
- (IBAction)forgotButtonTouched:(id)sender;
- (IBAction)backButtonTouched:(id)sender;

@end
