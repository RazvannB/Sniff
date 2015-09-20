//
//  FeedbackTVC.m
//  Sniff
//
//  Created by Razvan Balint on 27/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "FeedbackTVC.h"
#import "AuthenticationController.h"

@implementation FeedbackTVC

- (void)awakeFromNib {
    // Initialization code

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFeedback:(Feedback *)feedback {
    _feedback = feedback;
    
    self.nameLabel.text = feedback.name;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateFromString = [formatter dateFromString:feedback.date];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    self.dateLabel.text = [formatter stringFromDate:dateFromString];
    
    [self setMessage: feedback.message];
}

- (void)setMessage:(NSString *)message {
    self.commentHeightConstraint.constant = [message boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, CGFLOAT_MAX)
                                                                  options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                               attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir" size:15.0]}
                                                                  context:nil].size.height;
    [self layoutIfNeeded];
    self.commentView.text = message;
}

+ (CGFloat)getCellHeightWithText:(NSString*)text {
    if ([text class] != [NSNull class] && [text length]) {
        return [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, CGFLOAT_MAX)
                                  options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                               attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Avenir" size:15.0]}
                                  context:nil].size.height + 65;
    } else {
        return 55;
    }
}

@end
