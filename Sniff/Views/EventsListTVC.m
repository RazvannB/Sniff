//
//  EventsListTVC.m
//  Sniff
//
//  Created by Razvan Balint on 18/09/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "EventsListTVC.h"

@implementation EventsListTVC

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setEvent:(Event *)event {
    _event = event;
    
    self.titleLabel.text = event.project_name;
    self.organiserLabel.text = [NSString stringWithFormat:@"In %@ zile", event.DiffDate];
    self.eventType.text = event.categoryName;
}

+ (CGFloat)height {
    return 73;
}

@end
