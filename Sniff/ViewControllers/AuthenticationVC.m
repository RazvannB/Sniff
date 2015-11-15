//
//  AuthenticationVC.m
//  Sniff
//
//  Created by Razvan Balint on 14/11/15.
//  Copyright © 2015 Razvan Balint. All rights reserved.
//

#define buttonHeight 40
#define spaceHeight 8
#define lineHeight 1
#define buttonWidthBigDevice 300
#define buttonWidthSmallDevice 256

#import "AuthenticationVC.h"

@interface AuthenticationVC () <UITextFieldDelegate> {
    BOOL validationPassed;
    BOOL shouldRaiseFields;
}

@end

@implementation AuthenticationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    shouldRaiseFields = YES;
    
    [self addBlackTransluscentEffectOnView:self.view];
    [self setDeviceDimenssions];
    [self setButtonsLayout];
    
    self.navigationController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAppear:) name:UIKeyboardWillShowNotification object:nil];
    
    [self setAuthType:self.authType];
}

- (void)addBlackTransluscentEffectOnView:(UIView*)view {
    UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *beView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    beView.frame = view.bounds;
    
    view.frame = view.bounds;
    view.backgroundColor = [UIColor clearColor];
    [view insertSubview:beView atIndex:0];
}

- (void)setDeviceDimenssions {
    
}

- (void)setButtonsLayout {
    self.authButton.layer.cornerRadius = 7.5;
    self.authButton.layer.borderWidth = 1.5;
    self.authButton.layer.borderColor = [[UIColor colorWithRed:0.0f green:150.0f/255.0f blue:0.0f alpha:1] CGColor];
    
    self.forgotButton.layer.cornerRadius = 7.5;
    self.forgotButton.layer.borderWidth = 1.5;
    self.forgotButton.layer.borderColor = [[UIColor colorWithRed:0.0f green:150.0f/255.0f blue:0.0f alpha:1] CGColor];
}

- (void)keyboardAppear:(NSNotification*)notification {
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    CGFloat newHeight = 56;
    if (self.authType == AuthenticationVCType_Login) {
        newHeight += spaceHeight;
    }
    
    if (shouldRaiseFields) {
        [UIView animateWithDuration:0.5 animations:^{
            self.forgotBottomConstraint.constant = keyboardFrameBeginRect.size.height + newHeight;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                self.forgotBottomConstraint.constant = keyboardFrameBeginRect.size.height + newHeight - 16;
                [self.view layoutIfNeeded];
            }];
        }];
        shouldRaiseFields = NO;
    }
}

- (void)setAuthType:(AuthenticationVCType)authType {
    _authType = authType;
    
    switch (authType) {
        case AuthenticationVCType_Login:
            [self.authButton setTitle:@"Autentifica-te" forState:UIControlStateNormal];
            
            self.firstNameHeightConstraint.constant = 0;
            self.firstNameBottomConstraint.constant = 0;
            self.firstName.alpha = 0;
            
            self.lastNameHeightConstraint.constant = 0;
            self.lastNameBottomConstraint.constant = 0;
            self.lastName.alpha = 0;

            self.passwordWidthConstraint.constant = buttonWidthBigDevice;
            self.confirmPasswordWidthConstraint.constant = 0;
            self.confirmPassword.alpha = 0;
            
            self.lineHeightConstraint.constant = lineHeight;
            self.lineBottomConstraint.constant = spaceHeight;
            
            self.forgotHeightConstraint.constant = buttonHeight;
            self.forgotBottomConstraint.constant = spaceHeight;
            
            self.confirmPassword.tag = -1;
            self.password.returnKeyType = UIReturnKeyGo;
            
            [self.email becomeFirstResponder];
            break;
            
        case AuthenticationVCType_Register:
            [self.authButton setTitle:@"Creeaza cont" forState:UIControlStateNormal];
            
            self.firstNameHeightConstraint.constant = buttonHeight;
            self.firstNameBottomConstraint.constant = spaceHeight;
            
            self.lastNameHeightConstraint.constant = buttonHeight;
            self.lastNameBottomConstraint.constant = spaceHeight;
            
            self.passwordWidthConstraint.constant = buttonWidthBigDevice/2 - 4;
            self.confirmPasswordWidthConstraint.constant = buttonWidthBigDevice/2 - 4;
            
            self.lineHeightConstraint.constant = 0;
            self.lineBottomConstraint.constant = 0;
            
            self.forgotHeightConstraint.constant = 0;
            self.forgotBottomConstraint.constant = 0;
            self.forgotButton.alpha = 0;
            
            self.confirmPassword.tag = 4;
            self.password.returnKeyType = UIReturnKeyNext;
            
            [self.firstName becomeFirstResponder];
            break;
            
        case AuthenticationVCType_ForgotPassword:
            break;
            
        case AuthenticationVCType_ResetPassword:
            break;
            
        default:
            break;
    }
    
    [self.view layoutIfNeeded];
}

- (void)showAlertViewWithMessage:(NSString*)message {
    [[[UIAlertView alloc] initWithTitle:nil
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    validationPassed = FALSE;
}

#pragma mark - Delegate Methods

- (void)authButtonTouched:(id)sender {
    self.user = [[User alloc] init];
    self.user.email = self.email.text;
    self.user.first_name = self.firstName.text;
    self.user.last_name = self.lastName.text;
    self.user.password = self.password.text;
    
    //  Validation
    
    validationPassed = TRUE;
    switch (self.authType) {
        case AuthenticationVCType_Login:
            if (![self.user.email length] || ![self.user.password length]) {
                [self showAlertViewWithMessage:@"Informatii insuficiente. Va rugam sa completati toate campurile"];
            }
            break;
            
        case AuthenticationVCType_Register:
            if (![self.user.email length] || ![self.user.first_name length] || ![self.user.last_name length] || ![self.user.password length]) {
                [self showAlertViewWithMessage:@"Informatii insuficiente. Va rugam sa completati toate campurile"];
            } else if (![self.user.password isEqualToString:self.confirmPassword.text]) {
                [self showAlertViewWithMessage:@"Cele doua parole nu corespund"];
            }
            break;
            
        case AuthenticationVCType_ForgotPassword:
            break;
            
        case AuthenticationVCType_ResetPassword:
            break;
            
        default:
            break;
    }
    
    if (validationPassed) {
        if ([self.delegate respondsToSelector:@selector(authenticationVC:authenticationButtonTouched:user:)]) {
            [self.delegate authenticationVC:self authenticationButtonTouched:sender user:self.user];
        }
    }
}

- (void)forgotButtonTouched:(id)sender {
    if ([self.delegate respondsToSelector:@selector(authenticationVC:forgotPasswordButtonTouched:)]) {
        [self.delegate authenticationVC:self forgotPasswordButtonTouched:sender];
    }
}

- (void)backButtonTouched:(id)sender {
    [self.view endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(authenticationVC:backButtonTouched:)]) {
        [self.delegate authenticationVC:self backButtonTouched:sender];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        NSInteger nextTag = textField.tag + 1;
        
        UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
        if (nextResponder) {
            [nextResponder becomeFirstResponder];
        } else {
            [self authButtonTouched:nil];
        }
    }
    
    return YES;
}

@end
