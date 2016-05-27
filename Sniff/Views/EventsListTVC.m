//
//  EventsListTVC.m
//  Sniff
//
//  Created by Razvan Balint on 18/09/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import "EventsListTVC.h"
#import "UIImageView+WebCache.h"
#import "EventsController.h"

@implementation EventsListTVC

- (void)setEvent:(Event *)event {
    _event = event;
    
    self.titleLabel.text = event.project_name;
    self.orgName.text = event.org_name;
    
    NSArray *favouriteEventsIds = [[EventsController sharedInstance].favoriteEventsArray valueForKey:@"id"];
    BOOL currentEventIsFavourite = [favouriteEventsIds containsObject:event.id];
    self.favoriteButton.hidden = !currentEventIsFavourite;
    
    switch ([event.DiffDate intValue]) {
        case 1:
            self.organiserLabel.text = @"Va avea loc maine";
            break;
        case 0:
            self.organiserLabel.text = @"Are loc astazi";
            break;
        case -1:
            self.organiserLabel.text = @"A avut loc ieri";
            break;
        default:
            if ([event.DiffDate intValue] < 0) {
                self.organiserLabel.text = [NSString stringWithFormat:@"A avut loc acum %d zile", abs([event.DiffDate intValue])];
            } else {
                self.organiserLabel.text = [NSString stringWithFormat:@"Au mai ramas %d zile", [event.DiffDate intValue]];
            }
            break;
    }
    
    if ([event.categoryName isEqualToString:@"Educational"]) {
        [self setCategoryType:EventsListTVCCategoryType_Educational];
        
    } else if ([event.categoryName isEqualToString:@"Cariera"]) {
        [self setCategoryType:EventsListTVCCategoryType_Career];
        
    } else if ([event.categoryName isEqualToString:@"Social"]) {
        [self setCategoryType:EventsListTVCCategoryType_Social];
        
    } else if ([event.categoryName isEqualToString:@"Distractie"]) {
        [self setCategoryType:EventsListTVCCategoryType_Fun];
        
    } else if ([event.categoryName isEqualToString:@"Concurs"]) {
        [self setCategoryType:EventsListTVCCategoryType_Contest];
        
    } else if ([event.categoryName isEqualToString:@"Training"]) {
        [self setCategoryType:EventsListTVCCategoryType_Training];
    }
    
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:[self.event imageLinkResized]]
                      placeholderImage:[UIImage imageNamed:@"sniff_loading"]];
}

- (void)setCategoryType:(EventsListTVCCategoryType)categoryType {
    _categoryType = categoryType;
    
    switch (categoryType) {
        case EventsListTVCCategoryType_Educational:
            self.categoryImage.image = [UIImage imageNamed:@"educational_logo"];
            break;
            
        case EventsListTVCCategoryType_Career:
            self.categoryImage.image = [UIImage imageNamed:@"career_logo"];
            break;
            
        case EventsListTVCCategoryType_Social:
            self.categoryImage.image = [UIImage imageNamed:@"social_logo"];
            break;
            
        case EventsListTVCCategoryType_Fun:
            self.categoryImage.image = [UIImage imageNamed:@"fun_logo"];
            break;
            
        case EventsListTVCCategoryType_Contest:
            self.categoryImage.image = [UIImage imageNamed:@"contest_logo"];
            break;
            
        case EventsListTVCCategoryType_Training:
            self.categoryImage.image = [UIImage imageNamed:@"training_logo"];
            break;
            
        default:
            break;
    }
}

+ (CGFloat)height {
    return 230;
}

@end
