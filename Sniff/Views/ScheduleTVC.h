//
//  ScheduleTVC.h
//  Sniff
//
//  Created by Razvan Balint on 07/01/16.
//  Copyright © 2016 Razvan Balint. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleEvent.h"

@interface ScheduleTVC : UITableViewCell

@property (nonatomic, strong) ScheduleEvent *scheduleEvent;

@property (nonatomic, weak) IBOutlet UILabel *startHourLabel;
@property (nonatomic, weak) IBOutlet UILabel *endHourLabel;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

+ (CGFloat)height;

@end
