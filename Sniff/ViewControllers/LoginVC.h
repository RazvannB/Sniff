//
//  LoginVC.h
//  Sniff
//
//  Created by Razvan Balint on 21/07/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LoginType_Login,
    LoginType_Register
} LoginType;

@interface LoginVC : UIViewController

@property (nonatomic, weak) IBOutlet UITextField *first_name;
@property (nonatomic, weak) IBOutlet UITextField *last_name;
@property (nonatomic, weak) IBOutlet UITextField *email;
@property (nonatomic, weak) IBOutlet UITextField *password;
@property (nonatomic, weak) IBOutlet UITextField *confirmPassword;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UIButton *registerButton;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *firstNameHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *lastNameHeightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *passwordBottomConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageBottomLoginConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *passwordWidthConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *confirmPasswordWidthConstraint;

@property (nonatomic) LoginType loginType;

- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)registerButtonPressed:(id)sender;
- (instancetype)init;
- (instancetype)initWithTurningBack:(BOOL)event;

@end
