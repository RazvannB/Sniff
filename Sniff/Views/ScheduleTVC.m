//
//  ScheduleTVC.m
//  Sniff
//
//  Created by Razvan Balint on 07/01/16.
//  Copyright © 2016 Razvan Balint. All rights reserved.
//

#import "ScheduleTVC.h"

@implementation ScheduleTVC

- (void)setScheduleEvent:(ScheduleEvent *)scheduleEvent {
    _scheduleEvent = scheduleEvent;
    
    self.startHourLabel.text = scheduleEvent.start_hour;
    self.endHourLabel.text = scheduleEvent.end_hour;
    self.titleLabel.text = scheduleEvent.desc;
}

+ (CGFloat)height {
    return 82.0;
}

@end
