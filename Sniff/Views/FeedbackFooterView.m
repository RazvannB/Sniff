//
//  FeedbackFooterView.m
//  Sniff
//
//  Created by Razvan Balint on 27/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "FeedbackFooterView.h"
#import "EventsController.h"

@implementation FeedbackFooterView

- (instancetype)init {
    if (self = [super init]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"FeedbackFooterView" owner:self options:nil][0];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self.layer addSublayer:[EventsController drawMaskForSendFeedbackView:self]];
    
    [self bringSubviewToFront:self.sendFeedbackButton];
}

- (IBAction)feedbackButtonTouched:(id)sender {
    if ([self.delegate respondsToSelector:@selector(feedbackFooterOpenSendPage)]) {
        [self.delegate feedbackFooterOpenSendPage];
    }
}

+ (CGFloat)height {
    return 56;
}

@end
