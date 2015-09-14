//
//  FeedbackFooterView.m
//  Sniff
//
//  Created by Razvan Balint on 27/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "FeedbackFooterView.h"

@implementation FeedbackFooterView

- (instancetype)init {
    if (self = [super init]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"FeedbackFooterView" owner:self options:nil][0];
        self.commentView.layer.borderWidth = 1;
    }
    return self;
}

- (IBAction)feedbackButtonTouched:(id)sender {
    if ([self.delegate respondsToSelector:@selector(sendFeedbackWithRating:Comment:)]) {
        [self.delegate sendFeedbackWithRating:self.userVote Comment:self.commentView.text];
    }
}

#pragma mark - CustomRatingSliderDelegate

- (void)rateValueChangedForSlider:(CustomRatingSlider *)slider {
    self.userVote = slider.value;
}

@end
