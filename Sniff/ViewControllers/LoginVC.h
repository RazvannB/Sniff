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

@property (nonatomic, weak) IBOutlet UIImageView *logoImage;
@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UIButton *registerButton;
@property (nonatomic, weak) IBOutlet UIButton *loginFacebookButton;
@property (nonatomic, weak) IBOutlet UIButton *showEventsButton;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageTopConstraint;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *loginButtonWidthConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *registerButtonWidthConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *loginFacebookButtonWidthConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *loginFacebookButtonBottomConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *showEventsButtonWidthConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *showEventsButtonHeightConstraint;

@property (nonatomic) LoginType loginType;

- (instancetype)init;
- (instancetype)initWithTurningBack:(BOOL)event;

@end
