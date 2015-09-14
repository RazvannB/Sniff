//
//  FeedbackTableVC.h
//  Sniff
//
//  Created by Razvan Balint on 27/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedbackFooterView.h"
#import "CustomRatingSlider.h"
#import "Event.h"

@interface FeedbackTableVC : UITableViewController

@property (nonatomic, strong) Event *event;
@property (nonatomic, strong) NSArray *feedbackArray;
@property (nonatomic, strong) FeedbackFooterView *footerView;

- (id)initWithEvent:(Event *)event;

@end
