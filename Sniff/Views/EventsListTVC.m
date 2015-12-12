//
//  EventsListTVC.m
//  Sniff
//
//  Created by Razvan Balint on 18/09/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "EventsListTVC.h"
#import "UIImageView+WebCache.h"

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
    if ([event.DiffDate intValue] == 0) {
        self.organiserLabel.text = @"Astazi";
    } else if ([event.DiffDate intValue] == -1) {
        self.organiserLabel.text = [NSString stringWithFormat:@"A mai ramas %@ zi", event.DiffDate];
    } else {
        self.organiserLabel.text = [NSString stringWithFormat:@"Au mai ramas %@ zile", event.DiffDate];
    }
    
    self.orgName.text = event.org_name;
    
    if ([event.categoryName isEqualToString:@"Educational"]) {
        [self setCategoryType:EventsListTVCCategoryType_Educational];
        self.categoryImage.image = [UIImage imageNamed:@"educational_logo"];
        
    } else if ([event.categoryName isEqualToString:@"Cariera"]) {
        [self setCategoryType:EventsListTVCCategoryType_Career];
        self.categoryImage.image = [UIImage imageNamed:@"career_logo"];
        
    } else if ([event.categoryName isEqualToString:@"Social"]) {
        [self setCategoryType:EventsListTVCCategoryType_Social];
        self.categoryImage.image = [UIImage imageNamed:@"social_logo"];
        
    } else if ([event.categoryName isEqualToString:@"Distractie"]) {
        [self setCategoryType:EventsListTVCCategoryType_Fun];
        self.categoryImage.image = [UIImage imageNamed:@"fun_logo"];
        
    } else if ([event.categoryName isEqualToString:@"Concurs"]) {
        [self setCategoryType:EventsListTVCCategoryType_Contest];
        self.categoryImage.image = [UIImage imageNamed:@"contest_logo"];
        
    } else if ([event.categoryName isEqualToString:@"Training"]) {
        [self setCategoryType:EventsListTVCCategoryType_Training];
        self.categoryImage.image = [UIImage imageNamed:@"training_logo"];
    }
    
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:[self.event imageLinkResized]]
                      placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
}

+ (CGFloat)height {
    return 225;
}

@end
