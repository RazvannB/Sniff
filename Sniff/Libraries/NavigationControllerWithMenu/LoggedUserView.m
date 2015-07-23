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
        [self addSubview:[[NSBundle mainBundle] loadNibNamed:@"LoggedUserView" owner:self options:nil][0]];
        self.frame = frame;
        
        if ([AuthenticationController sharedInstance].loggedUser) {
            self.backgroundColor = [UIColor colorWithRed:3/255.0f green:154/255.0f blue:255/255.0f alpha:1];
            self.messageLabel.text = @"Sunteti inregistrat ca";
            [self.loggedUser setTitle:[AuthenticationController sharedInstance].loggedUser.username forState:UIControlStateNormal];
        } else {
            self.backgroundColor = [UIColor lightGrayColor];
            self.messageLabel.text = @"Nu sunteti inregistrat";
            [self.loggedUser setTitle:@"Inregistrati-va" forState:UIControlStateNormal];
        }
    }
    return self;
}

@end
