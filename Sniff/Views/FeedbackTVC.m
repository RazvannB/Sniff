//
//  FeedbackTVC.m
//  Sniff
//
//  Created by Razvan Balint on 27/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "FeedbackTVC.h"
#import "AuthenticationController.h"
#import "EventsController.h"

@implementation FeedbackTVC

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self.containerView.layer addSublayer:[EventsController drawMaskForFeedbackView:self.containerView]];
}

- (void)setFeedback:(Feedback *)feedback {
    _feedback = feedback;
    
    self.nameLabel.text = feedback.name;
    self.dateLabel.text = [EventsController changeTextCellDateFormatFrom:feedback.date];
    
    [self setMessage:feedback.message];
}

- (void)setMessage:(NSString *)message {
    
    self.commentHeightConstraint.constant = [EventsController getTextCellHeightWithText:message];
    self.commentView.text = message;
    [self layoutIfNeeded];
}

+ (CGFloat)getCellHeightWithText:(NSString*)text {
    
    if ([text class] != [NSNull class] && [text length]) {
        return [EventsController getTextCellHeightWithText:text] +
        16 + 21 + 3 + 15 + 8 + 17;
    } else {
        return 101;
    }
}

@end
