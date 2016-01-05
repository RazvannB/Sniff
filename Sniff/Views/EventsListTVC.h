//
//  EventsListTVC.h
//  Sniff
//
//  Created by Razvan Balint on 18/09/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

typedef enum {
    EventsListTVCCategoryType_Educational,
    EventsListTVCCategoryType_Career,
    EventsListTVCCategoryType_Social,
    EventsListTVCCategoryType_Fun,
    EventsListTVCCategoryType_Contest,
    EventsListTVCCategoryType_Training
}EventsListTVCCategoryType;

@interface EventsListTVC : UITableViewCell

@property (nonatomic, strong) Event *event;
@property (nonatomic, weak) IBOutlet UIImageView *imageview;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *organiserLabel;
@property (nonatomic, weak) IBOutlet UILabel *orgName;
@property (nonatomic, weak) IBOutlet UIImageView *categoryImage;
@property (nonatomic, weak) IBOutlet UIButton *favoriteButton;

@property (nonatomic) EventsListTVCCategoryType categoryType;

+ (CGFloat)height;

@end
