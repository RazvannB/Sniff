//
//  LoggedUserView.m
//  Sniff
//
//  Created by Razvan Balint on 21/07/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "LoggedUserView.h"
#import "AuthenticationController.h"

@implementation LoggedUserView

- (id)initWithFrame:(CGRect)frame {
    if  (self = [super initWithFrame:frame]) {
        self.frame = frame;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    if ([AuthenticationController sharedInstance].loggedUser) {
        self.backgroundColor = [UIColor colorWithRed:3/255.0f green:154/255.0f blue:255/255.0f alpha:1];
        self.messageLabel.text = @"You are logged in as";
        [self.loggedUser setTitle:[AuthenticationController sharedInstance].loggedUser.first_name forState:UIControlStateNormal];
    } else {
        self.backgroundColor = [UIColor lightGrayColor];
        self.messageLabel.text = @"You are not logged in";
        [self.loggedUser setTitle:@"Log in" forState:UIControlStateNormal];
        [self.loggedUser addTarget:self action:@selector(loginButtonPresed:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (IBAction)loginButtonPresed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginButtonPressedNotification" object:nil];
}

@end
