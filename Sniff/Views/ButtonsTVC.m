//
//  ButtonsTVC.m
//  Sniff
//
//  Created by Razvan Balint on 17/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "ButtonsTVC.h"

@implementation ButtonsTVC

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scheduleButtonLeadingConstraint.constant = (CGRectGetWidth(self.frame)/2 - 8 - CGRectGetWidth(self.scheduleButton.frame))/2;
    self.feedbackButtonTrailingConstrant.constant = (CGRectGetWidth(self.frame)/2 - 8 - CGRectGetWidth(self.feedbackButton.frame))/2;
}

- (IBAction)schedulePressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(scheduleButtonPressed)]) {
        [self.delegate scheduleButtonPressed];
    }
}

- (IBAction)feedbackPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(feedbackButtonPressed)]) {
        [self.delegate feedbackButtonPressed];
    }
}

@end
