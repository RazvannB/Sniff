//
//  ButtonsTVC.m
//  Sniff
//
//  Created by Razvan Balint on 17/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "ButtonsTVC.h"

@implementation ButtonsTVC

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)schedulePressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(scheduleButtonPressed)]) {
        [self.delegate scheduleButtonPressed];
    }
}

- (void)feedbackPressed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(feedbackButtonPressed)]) {
        [self.delegate feedbackButtonPressed];
    }
}

@end
