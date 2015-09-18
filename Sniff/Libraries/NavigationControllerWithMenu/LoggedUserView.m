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

    if ([AuthenticationController sharedInstance].loggedUser.id) {
        self.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:150.0f/255.0f blue:0.0f/255.0f alpha:1];
        self.messageLabel.text = @"Sunteti autentificat ca";
        [self.loggedUser setTitle:[AuthenticationController sharedInstance].loggedUser.first_name forState:UIControlStateNormal];
    } else {
        self.backgroundColor = [UIColor lightGrayColor];
        self.messageLabel.text = @"Nu sunteti autentificat";
        [self.loggedUser setTitle:@"Autentificare" forState:UIControlStateNormal];
        [self.loggedUser addTarget:self action:@selector(loginButtonPresed:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (IBAction)loginButtonPresed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginButtonPressedNotification" object:nil];
}

@end
