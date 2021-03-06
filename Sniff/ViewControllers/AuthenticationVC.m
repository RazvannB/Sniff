//
//  AuthenticationVC.m
//  Sniff
//
//  Created by Razvan Balint on 14/11/15.
//  Copyright © 2015 Razvan Balint. All rights reserved.
//

#define buttonHeightBigDevice 40
#define buttonHeightSmallDevice 30
#define spaceHeight 8
#define lineHeight 1
#define buttonWidthBigDevice 300
#define buttonWidthSmallDevice 256

#import "AuthenticationVC.h"
#import "AuthenticationController.h"
#import "EventsController.h"
#import "Macros.h"
#import "Colors.h"

@interface AuthenticationVC () <UITextFieldDelegate> {
    BOOL validationPassed;
    BOOL shouldRaiseFields;
}

@end

@implementation AuthenticationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    shouldRaiseFields = YES;
    
    [self setAuthType:self.authType];
    [self setDeviceDimensions];
    [self setButtonsLayout];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardAppear:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
}

- (void)setAuthType:(AuthenticationVCType)authType {
    _authType = authType;
    
    switch (authType) {
        case AuthenticationVCType_Login:
            [AuthenticationController addBlackTransluscentEffectOnView:self.view];
            
            [self.authButton setTitle:@"Autentifica-te" forState:UIControlStateNormal];
            
            self.firstNameHeightConstraint.constant = 0;
            self.firstNameBottomConstraint.constant = 0;
            self.firstName.alpha = 0;
            
            self.lastNameHeightConstraint.constant = 0;
            self.lastNameBottomConstraint.constant = 0;
            self.lastName.alpha = 0;
            
            self.confirmPasswordWidthConstraint.constant = 0;
            self.confirmPassword.alpha = 0;
            
            self.lineHeightConstraint.constant = lineHeight;
            self.lineBottomConstraint.constant = spaceHeight;
            
            self.confirmPassword.tag = -1;
            self.password.returnKeyType = UIReturnKeyGo;
            
            [self.email becomeFirstResponder];
            break;
            
        case AuthenticationVCType_Register:
            [AuthenticationController addBlackTransluscentEffectOnView:self.view];
            
            [self.authButton setTitle:@"Creeaza cont" forState:UIControlStateNormal];
            
            self.firstNameBottomConstraint.constant = spaceHeight;
            self.lastNameBottomConstraint.constant = spaceHeight;
            
            self.lineHeightConstraint.constant = 0;
            self.lineBottomConstraint.constant = 0;
            
            self.forgotHeightConstraint.constant = 0;
            self.forgotBottomConstraint.constant = 0;
            self.forgotButton.alpha = 0;
            
            self.confirmPassword.tag = 4;
            self.password.returnKeyType = UIReturnKeyNext;
            
            [self.firstName becomeFirstResponder];
            
            break;
            
        case AuthenticationVCType_Settings:
            [EventsController makeNavigationBarBackToDefault:self.navigationController.navigationBar];
            
            self.extendedLayoutIncludesOpaqueBars = YES;
            self.automaticallyAdjustsScrollViewInsets = YES;
            
            self.firstNameBottomConstraint.constant = spaceHeight;
            self.lastNameBottomConstraint.constant = spaceHeight;
            
            self.lineHeightConstraint.constant = 0;
            self.lineBottomConstraint.constant = 0;
            
            self.forgotHeightConstraint.constant = 0;
            self.forgotBottomConstraint.constant = 0;
            self.forgotButton.alpha = 0;
            
            self.confirmPassword.tag = 4;
            self.password.returnKeyType = UIReturnKeyNext;
            
            [self.firstName becomeFirstResponder];
            
            self.backButton.hidden = YES;
            self.view.backgroundColor = [Colors customGrayColor];
            
            self.title = @"Setari";
            [self.authButton setTitle:@"Salveaza modificarile" forState:UIControlStateNormal];
            self.firstName.text = [AuthenticationController sharedInstance].loggedUser.first_name;
            self.lastName.text = [AuthenticationController sharedInstance].loggedUser.last_name;
            self.email.text = [AuthenticationController sharedInstance].loggedUser.email;
            self.password.text = @"Sample Pass";
            self.confirmPassword.text = @"Sample Pass";
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

- (void)setDeviceDimensions {
    if (IS_IPHONE_4_OR_LESS) {
        self.firstNameHeightConstraint.constant = buttonHeightSmallDevice;
        self.lastNameHeightConstraint.constant = buttonHeightSmallDevice;
        self.emailHeightConstraint.constant = buttonHeightSmallDevice;
        self.passwordHeightConstraint.constant = buttonHeightSmallDevice;
        self.confirmPasswordHeightConstraint.constant = buttonHeightSmallDevice;
        self.authHeightConstraint.constant = buttonHeightSmallDevice;
        self.forgotHeightConstraint.constant = buttonHeightSmallDevice;
        
        self.firstNameWidthConstraint.constant = buttonWidthSmallDevice;
        self.lastNameWidthConstraint.constant = buttonWidthSmallDevice;
        self.emailWidthConstraint.constant = buttonWidthSmallDevice;
        
        self.authWidthConstraint.constant = buttonWidthSmallDevice;
        self.forgotWidthConstraint.constant = buttonWidthSmallDevice;
        self.lineWidthConstraint.constant = buttonWidthSmallDevice - 32;
        
        if (self.authType == AuthenticationVCType_Login) {
            self.passwordWidthConstraint.constant = buttonWidthSmallDevice;
            
        } else {
            self.passwordWidthConstraint.constant = buttonWidthSmallDevice/2 - 4;
            self.confirmPasswordWidthConstraint.constant = buttonWidthSmallDevice/2 - 4;
        }
        
    } else if (IS_IPHONE_5) {
        self.firstNameWidthConstraint.constant = buttonWidthSmallDevice;
        self.lastNameWidthConstraint.constant = buttonWidthSmallDevice;
        self.emailWidthConstraint.constant = buttonWidthSmallDevice;
        self.passwordWidthConstraint.constant = buttonWidthSmallDevice;
        self.confirmPasswordWidthConstraint.constant = buttonWidthSmallDevice;
        self.authWidthConstraint.constant = buttonWidthSmallDevice;
        self.forgotWidthConstraint.constant = buttonWidthSmallDevice;
        self.lineWidthConstraint.constant = buttonWidthSmallDevice - 32;
        
        if (self.authType == AuthenticationVCType_Login) {
            self.passwordWidthConstraint.constant = buttonWidthSmallDevice;
            
        } else {
            self.passwordWidthConstraint.constant = buttonWidthSmallDevice/2 - 4;
            self.confirmPasswordWidthConstraint.constant = buttonWidthSmallDevice/2 - 4;
        }
    } else {
    
        if (self.authType == AuthenticationVCType_Login) {
            self.passwordWidthConstraint.constant = buttonWidthBigDevice;
            
        } else {
            self.passwordWidthConstraint.constant = buttonWidthBigDevice/2 - 4;
            self.confirmPasswordWidthConstraint.constant = buttonWidthBigDevice/2 - 4;
        }
        
    }
    
    [self.view layoutIfNeeded];
}

- (void)setButtonsLayout {
    self.authButton.layer.cornerRadius = 7.5;
    self.authButton.layer.borderWidth = 1.5;
    self.authButton.layer.borderColor = [[Colors customGreenColor] CGColor];
    
    self.forgotButton.layer.cornerRadius = 7.5;
    self.forgotButton.layer.borderWidth = 1.5;
    self.forgotButton.layer.borderColor = [[Colors customGreenColor] CGColor];
}

- (void)keyboardAppear:(NSNotification*)notification {
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    CGFloat newHeight = 0;
    if (IS_IPHONE_4_OR_LESS) {
        newHeight = 0;
    } else if (IS_IPHONE_5) {
        newHeight = spaceHeight*3;
    } else {
        newHeight = spaceHeight*7;
    }
    
    if (self.authType == AuthenticationVCType_Login) {
        newHeight += spaceHeight*3;
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

- (void)showAlertViewWithMessage:(NSString*)message {
    [[[UIAlertView alloc] initWithTitle:nil
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    validationPassed = FALSE;
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
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
                [self showAlertViewWithMessage:@"Informatii insuficiente. Va rugam sa completati toate campurile!"];
            } else if (![self.user.password isEqualToString:self.confirmPassword.text]) {
                [self showAlertViewWithMessage:@"Cele doua parole nu corespund!"];
                self.confirmPassword.text = @"";
            } else if (![AuthenticationController verifyEmail:self.user.email]) {
                [self showAlertViewWithMessage:@"Adresa de email este invalida!"];
            } else if ([self.user.password length] < 8) {
                [self showAlertViewWithMessage:@"Parola trebuie sa contina minim 8 caractere!"];
                self.password.text = @"";
                self.confirmPassword.text = @"";
            }
            break;
            
        case AuthenticationVCType_Settings:
            [[[UIAlertView alloc] initWithTitle:nil
                                        message:@"A aparut o eroare. Incercati mai tarziu"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil] show];
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
    [self dismissViewController];
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
