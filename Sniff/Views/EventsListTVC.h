//
//  EventsListTVC.h
//  Sniff
//
//  Created by Razvan Balint on 18/09/15.
//  Copyright (c) 2015 Razvan Balint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventsListTVC : UITableViewCell

@property (nonatomic, strong) Event *event;
@property (nonatomic, weak) IBOutlet UIImageView *imageview;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *organiserLabel;
@property (nonatomic, weak) IBOutlet UILabel *eventType;

+ (CGFloat)height;

@end
