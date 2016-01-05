//
//  EventImageTVC.m
//  Sniff
//
//  Created by Razvan Balint on 11/08/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "EventImageTVC.h"
#import "UIImageView+WebCache.h"

@implementation EventImageTVC

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setEvent:(Event *)event {
    _event = event;
    
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:[self.event imageLink]]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
