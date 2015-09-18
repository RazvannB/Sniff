//
//  FeedbackTVC.h
//  Sniff
//
//  Created by Razvan Balint on 27/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomRatingSlider.h"

@interface FeedbackTVC : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet CustomRatingSlider *slider;
@property (nonatomic, weak) IBOutlet UITextView *commentView;

+ (CGFloat)height;

@end
