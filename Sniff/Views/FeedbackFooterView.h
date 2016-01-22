//
//  FeedbackFooterView.h
//  Sniff
//
//  Created by Razvan Balint on 27/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomRatingSlider.h"

@protocol FeedbackFooterViewDelegate <NSObject>

- (void)feedbackFooterOpenSendPage;

@end

@interface FeedbackFooterView : UIView

@property (nonatomic, strong) id <FeedbackFooterViewDelegate> delegate;

@property (nonatomic, weak) IBOutlet UIButton *sendFeedbackButton;

- (IBAction)feedbackButtonTouched:(id)sender;
+ (CGFloat)height;

@end
