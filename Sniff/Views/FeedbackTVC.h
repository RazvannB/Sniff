//
//  FeedbackTVC.h
//  Sniff
//
//  Created by Razvan Balint on 27/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Feedback.h"

@interface FeedbackTVC : UITableViewCell

@property (nonatomic, strong) Feedback *feedback;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *commentView;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *commentHeightConstraint;
@property (nonatomic, strong) NSString *message;

+ (CGFloat)getCellHeightWithText:(NSString*)text;

@end
